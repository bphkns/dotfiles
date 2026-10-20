#!/usr/bin/env bash
# master-audio.sh — master a rendered film's audio for social autoplay without touching the video.
#   master-audio.sh <in.mp4> <out.mp4> [gain_db=3.0] [limit=0.80]
# Linear gain + look-ahead limiter (4x oversampled, latency-compensated: without latency=1 the audio lands 2 ms late) → ~−14 LUFS, ≤ −1 dBTP, dynamics kept.
# Don't use two-pass loudnorm here: with a hot bed it falls back to dynamic mode (LRA → ~3)
# and flattens the drop. Re-run with a different gain if the printed I is off target.
set -euo pipefail
in="${1:?in.mp4}"
out="${2:?out.mp4}"
gain="${3:-3.0}"
limit="${4:-0.80}"
ffmpeg -v error -i "${in}" -c:v copy \
  -af "aresample=192000,volume=${gain}dB,alimiter=limit=${limit}:attack=2:release=60:level=false:latency=1,aresample=48000" \
  -c:a aac -b:a 256k -movflags +faststart -y "${out}"
ffmpeg -hide_banner -nostats -i "${out}" -af ebur128=peak=true -f null - 2>&1 | grep -E '^\s+(I|LRA|Peak):'
ffprobe -v error -show_entries format=duration,size -of compact "${out}"
