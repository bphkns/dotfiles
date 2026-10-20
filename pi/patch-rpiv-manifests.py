#!/usr/bin/env python3
"""Work around upstream rpiv packages declaring Pi's host-provided typebox as a dependency."""

import json
from pathlib import Path

packages = Path.home() / ".pi/agent/npm/node_modules/@juicesharp"
for name in ("rpiv-ask-user-question", "rpiv-config"):
    manifest = packages / name / "package.json"
    if not manifest.exists():
        continue
    data = json.loads(manifest.read_text())
    if "typebox" not in data.get("dependencies", {}):
        continue
    del data["dependencies"]["typebox"]
    data.setdefault("peerDependencies", {})["typebox"] = "*"
    manifest.write_text(json.dumps(data, indent="\t", ensure_ascii=False) + "\n")
    print(f"Patched {manifest}")
