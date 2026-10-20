#!/usr/bin/env node
// preview-frame.mjs — mount ONE frame sub-composition alone in a throwaway HyperFrames
// project (<project>/.hyperframes/preview/<frame_id>/) and run lint + check + snapshot on it,
// so a frame builder can see and validate its own frame before assembly.
//
//   node preview-frame.mjs --project <dir> --frame <frame_id> --duration <s>
//        [--at 0.3,1.2,...] [--samples 6] [--skip-check]
//        [--hf 0.8.73] [--ground #0c0b0e] [--width 1920] [--height 1080]
//
// Browser: uses $HYPERFRAMES_BROWSER_PATH when set (else the CLI's own resolution).
// Limits: the frame is alone, so seams, cross-frame stacking and visibility leaks
// (inline visibility:"visible") are invisible here — review the assembled render too.
import { existsSync, mkdirSync, rmSync, symlinkSync, writeFileSync, readdirSync, copyFileSync } from "node:fs";
import { spawnSync } from "node:child_process";
import { join, resolve } from "node:path";

const argv = process.argv.slice(2);
const flag = (name, dflt) => {
  const i = argv.indexOf(`--${name}`);
  return i === -1 ? dflt : argv[i + 1];
};
const has = (name) => argv.includes(`--${name}`);
const die = (m) => {
  console.error(`✗ preview-frame: ${m}`);
  process.exit(1);
};

const project = flag("project");
const frameId = flag("frame");
const duration = Number(flag("duration"));
if (!project || !frameId) die("need --project and --frame");
if (!Number.isFinite(duration) || duration <= 0) die("need --duration <seconds>");
const hfVersion = flag("hf", "0.8.73");
const ground = flag("ground", "#0c0b0e");
const width = Number(flag("width", "1920"));
const height = Number(flag("height", "1080"));

const projectDir = resolve(project);
const frameFile = join(projectDir, "compositions", "frames", `${frameId}.html`);
if (!existsSync(frameFile)) die(`no frame file at ${frameFile}`);

const env = { ...process.env, HYPERFRAMES_SKIP_SKILLS: "1" };

const dir = join(projectDir, ".hyperframes", "preview", frameId);
rmSync(dir, { recursive: true, force: true });
mkdirSync(join(dir, "compositions", "frames"), { recursive: true });
// Copy (not symlink) the frame: a symlinked sub-composition is skipped as "empty" by the bundler.
copyFileSync(frameFile, join(dir, "compositions", "frames", `${frameId}.html`));
for (const name of ["assets", "capture", "frame.md"]) {
  const src = join(projectDir, name);
  if (existsSync(src)) symlinkSync(src, join(dir, name));
}
if (existsSync(join(projectDir, "hyperframes.json"))) {
  copyFileSync(join(projectDir, "hyperframes.json"), join(dir, "hyperframes.json"));
}

writeFileSync(
  join(dir, "index.html"),
  `<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=${width}, height=${height}" />
    <script src="https://cdn.jsdelivr.net/npm/gsap@3.14.2/dist/gsap.min.js"></script>
    <style>
      * { margin: 0; padding: 0; box-sizing: border-box; }
      html, body { margin: 0; width: ${width}px; height: ${height}px; overflow: hidden; background: ${ground}; }
      #root { position: relative; width: 100%; height: 100%; overflow: hidden; background: ${ground}; }
      .scene { position: absolute; inset: 0; width: 100%; height: 100%; }
    </style>
  </head>
  <body>
    <div id="root" data-composition-id="main" data-start="0" data-duration="${duration}" data-width="${width}" data-height="${height}">
      <div id="el-${frameId}" class="scene" data-composition-id="${frameId}" data-composition-src="compositions/frames/${frameId}.html" data-start="0" data-duration="${duration}" data-track-index="1" data-width="${width}" data-height="${height}"></div>
    </div>
    <script>
      window.__timelines = window.__timelines || {};
      window.__timelines["main"] = gsap.timeline({ paused: true });
    </script>
  </body>
</html>
`,
);

const hf = (args, timeout = 240000) => {
  const r = spawnSync("npx", ["-y", `hyperframes@${hfVersion}`, ...args], { cwd: dir, env, encoding: "utf8", timeout });
  return { code: r.status, out: `${r.stdout ?? ""}${r.stderr ?? ""}` };
};
const trim = (s, n = 6000) => (s.length > n ? `${s.slice(0, n)}\n…[truncated ${s.length - n} chars]` : s);
const clean = (s) =>
  s
    .replace(/\u001b\[[0-9;]*m/g, "")
    .split("\n")
    .filter((l) => !/Using system Chrome|chrome-headless-shell|beginFrame is unavailable/.test(l))
    .join("\n");

console.log(`# preview ${frameId} (${duration}s) — ${dir}`);

const lint = hf(["lint", ".", "--verbose"]);
console.log(`\n## lint (exit ${lint.code})\n${trim(clean(lint.out))}`);

if (!has("skip-check")) {
  const check = hf(["check", ".", "--samples", flag("samples", "6"), "--caption-zone", "x0=0;y0=.84;x1=1;y1=1;severity=warning"], 300000);
  console.log(`\n## check (exit ${check.code})\n${trim(clean(check.out), 9000)}`);
}

const at =
  flag("at") ??
  [0.1, 0.2, 0.4, 0.6, 0.8, 0.97].map((f, i) => (i === 0 ? Math.min(0.25, duration * f) : duration * f).toFixed(2)).join(",");
const outDir = join(dir, "snapshots");
const snap = hf(["snapshot", ".", "--at", at, "--no-end", "-o", outDir, "--describe", "false"], 300000);
console.log(`\n## snapshot (exit ${snap.code}) at ${at}\n${trim(clean(snap.out), 2500)}`);
if (existsSync(outDir)) {
  const files = readdirSync(outDir).filter((f) => /\.(png|jpg)$/.test(f)).sort();
  console.log(`\n## images (Read these)\n${files.map((f) => `- ${join(outDir, f)}`).join("\n")}`);
}
