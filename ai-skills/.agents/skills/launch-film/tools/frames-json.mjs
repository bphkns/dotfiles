#!/usr/bin/env node
// frames-json.mjs — parse STORYBOARD.md into the `args.frames` array the workflow templates take.
//   node frames-json.mjs STORYBOARD.md > .hyperframes/frames.json
// Output: [{ id, n, duration, starts_at, transition_in, sfx, prev, next }]
// Exits 1 when a frame lacks a valid src/duration/starts_at, or starts_at ≠ the running sum of durations.
import { readFileSync } from "node:fs";

const path = process.argv[2];
if (!path) {
  console.error("usage: frames-json.mjs STORYBOARD.md");
  process.exit(1);
}
const text = readFileSync(path, "utf8");
const blocks = text.split(/\n## Frame /).slice(1);
const field = (block, name) => {
  const m = block.match(new RegExp(`^- ${name}: (.+)$`, "m"));
  return m ? m[1].trim() : null;
};

let running = 0;
let bad = false;
const frames = blocks.map((block, i) => {
  const src = field(block, "src") ?? "";
  const id = src.replace(/^.*\//, "").replace(/\.html$/, "");
  const num = (name) => {
    const raw = field(block, name);
    return raw === null ? Number.NaN : Number(raw.replace(/s$/, ""));
  };
  const duration = num("duration");
  const startsAt = num("starts_at");
  if (!id || !Number.isFinite(duration) || duration <= 0 || !Number.isFinite(startsAt)) {
    console.error(`✗ frame ${i + 1}: missing/invalid src, duration or starts_at`);
    bad = true;
    const startsHere = running;
    if (Number.isFinite(duration) && duration > 0) running += duration;
    return { id, n: i + 1, duration: 0, starts_at: startsHere, transition_in: "cut", sfx: "none" };
  }
  if (Math.abs(startsAt - running) > 0.02) {
    console.error(`✗ frame ${i + 1} (${id}): starts_at ${startsAt} ≠ running sum ${running.toFixed(2)}`);
    bad = true;
  }
  running += duration;
  return { id, n: i + 1, duration, starts_at: startsAt, transition_in: field(block, "transition_in") ?? "cut", sfx: field(block, "sfx") ?? "none" };
});
frames.forEach((f, i) => {
  f.prev = i > 0 ? frames[i - 1].id : null;
  f.next = i < frames.length - 1 ? frames[i + 1].id : null;
});
console.error(`${frames.length} frames, total ${running.toFixed(2)} s`);
process.stdout.write(`${JSON.stringify(frames, null, 1)}\n`);
process.exit(bad ? 1 : 0);
