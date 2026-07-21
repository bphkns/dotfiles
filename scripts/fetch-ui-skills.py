#!/usr/bin/env python3
"""Fetch licensed ui.sh skills through the uidotsh MCP server.

The skill bodies are intentionally not committed to this public repository.
Set UIDOTSH_TOKEN and run this script on each machine instead.
"""

from __future__ import annotations

import argparse
import http.client
import json
import os
import re
import sys
import urllib.parse
from collections import deque
from json import JSONDecodeError
from pathlib import Path
from typing import Any

SKILL_DESCRIPTIONS = {
    "add-dark-mode": "Add dark mode with designer-quality colors, shadows, and surfaces.",
    "brand-kit": "Generate a visual identity and marketing-site mockup board from a product idea.",
    "canonicalize-tailwind": "Sort, normalize, deduplicate, and resolve conflicting Tailwind utilities.",
    "componentize": "Extract and organize existing UI into reusable components with thoughtful APIs.",
    "dark-mode-image": "Create dark-mode variants of raster images for dark UI contexts.",
    "design": "Design and build new UI with the complete ui.sh design guideline system.",
    "ideas": "Compare multiple UI options in-browser with the ui.sh picker.",
    "make-responsive": "Adapt existing UI across mobile, tablet, and desktop breakpoints.",
    "markup-from-image": "Convert screenshots, Figma exports, mockups, or wireframes into semantic markup.",
}
DEFAULT_SKILLS = tuple(SKILL_DESCRIPTIONS)
URI_PATTERN = re.compile(r"uidotsh://[A-Za-z0-9_./-]+")
FRONTMATTER_PATTERN = re.compile(r"\A---\n(?P<fields>.*?)\n---(?:\n|\Z)", re.DOTALL)
USER_AGENTS = ("uidotsh-sync/1.0", "curl/8.7.1")


class UidotshError(RuntimeError):
    """Raised when the uidotsh MCP server cannot return a skill."""


class UidotshClient:
    def __init__(self, token: str, agent: str) -> None:
        query = urllib.parse.urlencode({"agent": agent})
        self.path = f"/mcp?{query}"
        self.token = token
        self.session_id: str | None = None
        self.request_id = 0

    def _post(self, payload: dict[str, Any], user_agent_index: int = 0) -> str:
        headers = {
            "Authorization": f"Bearer {self.token}",
            "Content-Type": "application/json",
            "Accept": "application/json, text/event-stream",
            "User-Agent": USER_AGENTS[user_agent_index],
        }
        if self.session_id:
            headers["Mcp-Session-Id"] = self.session_id

        connection = http.client.HTTPSConnection("ui.sh", timeout=60)
        try:
            connection.request(
                "POST",
                self.path,
                body=json.dumps(payload).encode(),
                headers=headers,
            )
            response = connection.getresponse()
            content = response.read().decode()
            status = response.status
            if session_id := response.headers.get("Mcp-Session-Id"):
                self.session_id = session_id
        except OSError:
            error = sys.exc_info()[1]
            raise UidotshError(f"cannot reach uidotsh: {error}") from error
        finally:
            connection.close()

        if status == 403:
            if user_agent_index + 1 < len(USER_AGENTS):
                return self._post(payload, user_agent_index + 1)
        if status >= 400:
            raise UidotshError(f"uidotsh returned HTTP {status}")
        return content

    @staticmethod
    def _parse(raw: str) -> dict[str, Any] | None:
        if not raw.strip():
            return None

        try:
            parsed = json.loads(raw)
            if isinstance(parsed, dict):
                return parsed
        except JSONDecodeError:
            pass

        for chunk in re.split(r"\n\n", raw.strip()):
            lines = []
            for line in chunk.splitlines():
                lines.append(line[6:] if line.startswith("data: ") else line)
            try:
                parsed = json.loads("\n".join(lines))
            except JSONDecodeError:
                continue
            if isinstance(parsed, dict) and ("result" in parsed or "error" in parsed):
                return parsed

        return None

    def _request(self, method: str, params: dict[str, Any]) -> dict[str, Any]:
        self.request_id += 1
        raw = self._post(
            {
                "jsonrpc": "2.0",
                "id": self.request_id,
                "method": method,
                "params": params,
            }
        )
        response = self._parse(raw)
        if response is None:
            raise UidotshError(f"uidotsh returned no JSON-RPC response for {method}")
        if "error" in response:
            message = response["error"].get("message", "unknown MCP error")
            raise UidotshError(f"uidotsh {method} failed: {message}")
        return response

    def initialize(self) -> None:
        self.session_id = None
        response = self._request(
            "initialize",
            {
                "protocolVersion": "2025-06-18",
                "capabilities": {},
                "clientInfo": {"name": "uidotsh-sync", "version": "1.0"},
            },
        )
        server_name = response.get("result", {}).get("serverInfo", {}).get("name")
        if server_name != "uidotsh":
            raise UidotshError(f"unexpected MCP server: {server_name or 'unknown'}")
        self._post({"jsonrpc": "2.0", "method": "notifications/initialized"})

        tools = self._request("tools/list", {}).get("result", {}).get("tools", [])
        if not any(tool.get("name") == "uidotsh_fetch" for tool in tools):
            raise UidotshError("uidotsh_fetch is not available from the MCP server")

    def fetch(self, uri: str) -> str:
        for attempt in range(2):
            try:
                result = self._request(
                    "tools/call",
                    {
                        "name": "uidotsh_fetch",
                        "arguments": {"uri": uri},
                    },
                ).get("result", {})
            except UidotshError:
                if attempt == 0:
                    self.initialize()
                    continue
                raise

            content = "".join(
                block.get("text", "")
                for block in result.get("content", [])
                if block.get("type") == "text"
            )
            if result.get("isError"):
                raise UidotshError(f"uidotsh could not fetch {uri}: {content.strip()}")
            if not content:
                raise UidotshError(f"uidotsh returned empty content for {uri}")
            return content

        raise UidotshError(f"uidotsh retries exhausted for {uri}")


def uri_to_relative_path(uri: str, skill: str) -> Path | None:
    prefix = "uidotsh://"
    if not uri.startswith(prefix):
        return None

    segments = uri[len(prefix) :].split("/")
    if not segments or segments[0] != skill or any(segment in {"", ".."} for segment in segments):
        return None

    if len(segments) == 1:
        relative = Path("SKILL.md")
    else:
        relative = Path(*segments[1:])
        if relative.suffix == "":
            relative = relative.with_suffix(".md")

    return relative


def ensure_skill_metadata(skill: str, content: str) -> str:
    """Add Agent Skills frontmatter when uidotsh omits required fields."""
    required = {
        "name": skill,
        "description": SKILL_DESCRIPTIONS[skill],
    }
    match = FRONTMATTER_PATTERN.match(content)
    if match is None:
        fields = "\n".join(f"{key}: {value}" for key, value in required.items())
        return f"---\n{fields}\n---\n\n{content.lstrip()}"

    fields = match.group("fields").rstrip()
    additions = [
        f"{key}: {value}"
        for key, value in required.items()
        if re.search(rf"^{key}\s*:", fields, re.MULTILINE) is None
    ]
    if not additions:
        return content

    body = content[match.end() :].lstrip("\n")
    updated_fields = "\n".join((fields, *additions))
    return f"---\n{updated_fields}\n---\n\n{body}"


def write_atomic(root: Path, relative: Path, content: str) -> None:
    safe_root = root.resolve()
    path = (safe_root / relative).resolve()
    if not path.is_relative_to(safe_root):
        raise UidotshError(f"refusing to write outside {safe_root}")

    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_name(f".{path.name}.tmp")
    temporary.write_text(content)
    temporary.replace(path)


def fetch_skill(client: UidotshClient, skill: str, destination: Path) -> int:
    queue = deque([f"uidotsh://{skill}"])
    seen: set[str] = set()
    written = 0

    while queue:
        uri = queue.popleft()
        if uri in seen:
            continue
        seen.add(uri)

        content = client.fetch(uri)
        relative = uri_to_relative_path(uri, skill)
        if relative is None:
            continue
        if relative == Path("SKILL.md"):
            content = ensure_skill_metadata(skill, content)
        write_atomic(destination / skill, relative, content)
        written += 1

        for nested_uri in URI_PATTERN.findall(content):
            if nested_uri.startswith(f"uidotsh://{skill}") and nested_uri not in seen:
                queue.append(nested_uri)

    skill_file = destination / skill / "SKILL.md"
    if not skill_file.is_file() or skill_file.stat().st_size == 0:
        raise UidotshError(f"{skill} did not produce a readable SKILL.md")
    return written


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "skills",
        nargs="*",
        default=list(DEFAULT_SKILLS),
        help="ui.sh skill names to fetch (defaults to the configured UI skill set)",
    )
    parser.add_argument(
        "--destination",
        type=Path,
        default=Path.home() / ".agents/skills",
        help="skill root directory (default: ~/.agents/skills)",
    )
    parser.add_argument("--agent", default="claude", help="uidotsh MCP agent label")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    token = os.environ.get("UIDOTSH_TOKEN")
    if not token:
        print("fetch-ui-skills: UIDOTSH_TOKEN is not set", file=sys.stderr)
        return 2

    invalid = sorted(set(args.skills) - set(DEFAULT_SKILLS))
    if invalid:
        print(f"fetch-ui-skills: unsupported skills: {', '.join(invalid)}", file=sys.stderr)
        return 2

    client = UidotshClient(token, args.agent)
    try:
        client.initialize()
        for skill in args.skills:
            count = fetch_skill(client, skill, args.destination.expanduser())
            print(f"fetch-ui-skills: {skill}: {count} file(s)")
    except UidotshError as error:
        print(f"fetch-ui-skills: {error}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
