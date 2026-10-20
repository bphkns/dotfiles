#!/usr/bin/env node
// make-audio.mjs — build the music bed + audio_meta.json for a music-only cut.
//   node make-audio.mjs --project <dir> --total <s> --cues <cues.json>
//        [--music assets/music/track.mp3] [--out assets/music/bed.wav]
//        [--bgm-volume 0.75] [--fade-out <1 bar>] [--offset 0]
// cues.json: [{ "frame": <storyboard frame number>, "file": "assets/sfx/x.mp3",
//               "offset_s": 1.2 (frame-local, may be slightly negative for a pre-lap),
//               "duration_s": 0.6, "volume": 1.5 (0..4; the mixer allows +12 dB) }]
// assemble-index.mjs reads audio_meta.json: bgm on track 11, sfx on 20+ at frame start + offset.
import { existsSync, readFileSync, writeFileSync } from "node:fs";
import { spawnSync } from "node:child_process";
import { join, resolve } from "node:path";

const argv = process.argv.slice(2);
const flag = (n, d) => {
  const i = argv.indexOf(`--${n}`);
  return i === -1 ? d : argv[i + 1];
};
const die = (m) => {
  console.error(`✗ make-audio: ${m}`);
  process.exit(1);
};

const project = resolve(flag("project", "."));
const total = Number(flag("total"));
if (!Number.isFinite(total) || total <= 0) die("need --total <seconds>");
const music = flag("music");
if (!music) die("need --music <project-relative path>");
const out = flag("out", "assets/music/bed.m4a");
const offset = Number(flag("offset", "0"));
const fadeOut = Number(flag("fade-out", "2"));
const bgmVolume = Number(flag("bgm-volume", "0.75"));
const cuesPath = flag("cues");

const src = join(project, music);
if (!existsSync(src)) die(`music not found: ${src}`);
const fadeStart = Math.max(0, total - fadeOut);
const r = spawnSync(
  "ffmpeg",
  [
    "-y", "-v", "error", "-ss", String(offset), "-i", src, "-t", String(total),
    "-af", `afade=t=in:st=0:d=0.15,afade=t=out:st=${fadeStart.toFixed(3)}:d=${fadeOut}`,
    // AAC carries 1024 priming samples the renderer trims a second time (bed 23 ms early); WAV has none.
    ...(out.endsWith(".wav") ? ["-c:a", "pcm_s16le", "-ar", "44100"] : ["-c:a", "aac", "-b:a", "256k"]),
    join(project, out),
  ],
  { encoding: "utf8" },
);
if (r.status !== 0) die(`ffmpeg failed: ${r.stderr}`);

let sfx = [];
if (cuesPath) {
  const raw = JSON.parse(readFileSync(resolve(cuesPath), "utf8"));
  if (!Array.isArray(raw)) die("cues must be an array");
  sfx = raw
    .filter((c) => c && Number.isFinite(c.frame) && typeof c.file === "string")
    .filter((c) => {
      const ok = existsSync(join(project, c.file));
      if (!ok) console.error(`⚠ skipping missing sfx ${c.file}`);
      return ok;
    })
    .map((c) => ({
      frame: c.frame,
      file: c.file,
      offset_s: Number(c.offset_s ?? 0),
      duration_s: Number(c.duration_s ?? 1),
      volume: Math.min(4, Math.max(0, Number(c.volume ?? 1))),
    }));
}
writeFileSync(
  join(project, "audio_meta.json"),
  `${JSON.stringify({ bgm: { path: out, volume: bgmVolume }, bgm_pending: false, voices: [], sfx }, null, 2)}\n`,
);
console.log(`✓ bed ${out} (${total}s, fade-out from ${fadeStart.toFixed(2)}s) · ${sfx.length} sfx cue(s) → audio_meta.json`);
