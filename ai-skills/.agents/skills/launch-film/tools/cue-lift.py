#!/usr/bin/env python3
"""cue-lift.py — how far each SFX cue lifts the mix above the music bed, per frequency band.

  python3 cue-lift.py --project <dir> --render renders/draft-vN.mp4 [--frames .hyperframes/frames.json]

Reads audio_meta.json (bed path + sfx cues keyed by frame number) and frame starts from
frames.json (tools/frames-json.mjs). For every cue it compares render vs bed RMS in short
windows after the cue, minus the render-vs-bed offset measured in cue-free windows.
Bands: hf = highpass 2.5 kHz (clicks, notifications, chimes, ping), mid = 400–1000 Hz (pops),
low = lowpass 150 Hz (impacts), wide = full band (whooshes, risers).
Rule of thumb: a story cue should lift its band ≥ +5 dB.
"""
import argparse, array, json, math, os, statistics, subprocess, sys

ap = argparse.ArgumentParser()
ap.add_argument("--project", required=True)
ap.add_argument("--render", required=True)
ap.add_argument("--frames", default=".hyperframes/frames.json")
a = ap.parse_args()
P = os.path.abspath(a.project)
meta = json.load(open(os.path.join(P, "audio_meta.json")))
frames = json.load(open(os.path.join(P, a.frames)))
start = {f["n"]: f["starts_at"] for f in frames}
bed = os.path.join(P, meta["bgm"]["path"])
render = os.path.join(P, a.render)
SR = 16000
BANDS = {"wide": None, "low": "lowpass=f=150", "mid": "highpass=f=400,lowpass=f=1000",
         "hf": "highpass=f=2500,highpass=f=2500"}


def decode(src, filt):
    cmd = ["ffmpeg", "-v", "error", "-i", src, "-vn"]
    if filt:
        cmd += ["-af", filt]
    cmd += ["-ac", "1", "-ar", str(SR), "-f", "s16le", "-"]
    buf = array.array("h")
    buf.frombytes(subprocess.run(cmd, check=True, capture_output=True).stdout)
    return buf


def rms(x, t0, t1):
    i0, i1 = int(t0 * SR), min(int(t1 * SR), len(x))
    if i1 <= i0:
        return -120.0
    return 10 * math.log10(sum(v * v for v in x[i0:i1]) / (i1 - i0) + 1e-9)


# A frame-1 pre-lap cue has a negative offset; clamp so the window never wraps to the buffer end.
cues = [(max(0.0, start[c["frame"]] + c["offset_s"]), c) for c in meta["sfx"] if c["frame"] in start]
busy = [(max(0, t - 0.3), t + c["duration_s"] + 0.3) for t, c in cues]
total = frames[-1]["starts_at"] + frames[-1]["duration"]
free = [(t, t + 0.8) for t in [x * 0.5 for x in range(int(total * 2) - 2)]
        if all(t + 0.8 < b0 or t > b1 for b0, b1 in busy)][:12]

res = {}
for band, filt in BANDS.items():
    R, B = decode(render, filt), decode(bed, filt)
    off = statistics.median([rms(R, s, e) - rms(B, s, e) for s, e in free]) if free else 0.0
    res[band] = [max(rms(R, t + k * 0.02, t + k * 0.02 + 0.1) - rms(B, t + k * 0.02, t + k * 0.02 + 0.1) for k in range(8)) - off
                 for t, _ in cues]
    print(f"{band}: render-bed offset {off:+.2f} dB over {len(free)} cue-free windows", file=sys.stderr)

print(f"{'frame':>5} {'t':>6}  {'file':22} {'vol':>5}  " + " ".join(f"{b:>6}" for b in BANDS))
for i, (t, c) in enumerate(cues):
    print(f"F{c['frame']:<4} {t:6.2f}  {os.path.basename(c['file']):22} {c['volume']:5.2f}  "
          + " ".join(f"{res[b][i]:+6.1f}" for b in BANDS))
