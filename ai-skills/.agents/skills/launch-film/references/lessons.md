# Lessons from the Leapcast film (2026-09-25)

Each of these cost at least one iteration. The workflow templates already apply them. Keep them in mind when you edit the templates or work inline.

## Rendering and composition contract

- **Inline `visibility: "visible"` leaks across the whole film.** The runtime hides frames outside their window with `visibility: hidden` on an ancestor. A child set to `visible` inline overrides that, so it shows over every other frame. The Leapcast F10 split-flap clock put a giant "07" over 0–38 s. Always write `"inherit"` (GSAP `autoAlpha` is fine). Check with `grep -n '"visible"' compositions/frames/*.html`. The single-frame preview **cannot** catch this; only the assembled render can.
- **Frames that aren't on screen still composite their grain layers** (Digital ID, 2026-09-25). Every frame had a static 3% SVG-noise grain (`mix-blend-mode: multiply`, or normal blend on the end card). In the assembled render, the grain of every hidden frame stacked over the one on screen, so the `#FBFAF7` paper came out about `#EEEEE9`. The single-frame harness showed the right colour. Diagnose by sampling a corner of the draft (`ffmpeg … -f rawvideo`) against the harness PNG, then bisect by rendering index copies that keep only some frames. Fix: no grain layers at all (`[id*="grain"], [class*="grain"] { display: none !important; }` in each frame), or keep any texture inside the timed ground clip and check the corner value in the assembled render.
- A frame file is exactly one `<template>`, and every `<style>` and `<script>` (including the GSAP CDN script) goes inside it. Style the root through `#root`, never a class. The full-bleed ground goes on its own `class="clip"` layer, never on `#root`.
- Give every GSAP-targeted or timed element an id prefixed with the frame id, or lint raises `studio_missing_editable_id`. The prefix starts with a digit, so about 300 `id_requires_css_escape` warnings are expected and harmless. Use `getElementById` or `[id="…"]` selectors, never `#01-…`.
- `duplicate_media_discovery_risk` (the same image cropped several times) and `composition_file_too_large` on index.html are harmless.
- A `check` info note about `canvas_overflow` for a frame's text after a push-slide exit is expected: the pushed frame sits off-canvas.
- Per-frame `check` does not see seams, stacking between frames, or leaks. Always review the assembled MP4 (the film-review and gate workflows do).
- Render is fast (about 25 s for 56 s at 1080p30 on 24 cores), so render drafts freely.

## Storyboard and packets (product-launch-video scripts)

- **Scene windows must be frame-local**, written as `(0.00–0.49 s) [15.48–15.97]` with the absolute time in brackets for SFX. Each frame builds its own paused timeline from 0. Absolute windows produce empty frames.
- The **`## Video direction` block and `cam()` notation are not copied into packets.** Restate `cam(S,cx,cy)` in every frame's Build notes, and extract the block to `.hyperframes/video-direction.md` for builders.
- **stage-assets** matches by basename and only searches `capture/assets`, `capture/assets/videos`, `capture/assets/svgs` and `capture/screenshots`. It splits `asset_candidates` on `;`, in the form `assets/<basename> — role; …`. Anything in subfolders such as `capture/assets/app/` must also be copied flat. Aim for "staged N/N".
- `gsap-effects` is not a rule id. Cite only ids that exist in `hyperframes-animation/rules/`.
- Keep registry components installed with `hyperframes add` out of `compositions/` (move them to `.hyperframes/registry-reference/`), or project lint picks them up.
- The preview harness must **copy** the frame into the preview project, not symlink it; with a symlink the bundler reports "Skipping sub-composition … file is empty".
- `hyperframes beats` needs a temporary index with `<audio id="bgm" data-timeline-role="music" class="clip" …>`, or it says "No music track found". Its JSON holds onsets only (`{time, strength}`): no BPM, downbeats or drop. Get those from `analyze-beatgrid.py` (SKILL §1, Music).
- The storyboard grid assumes bar 0 starts at t = 0. Trim the track to its first downbeat before running `beats`, and use the trimmed file everywhere; `make-audio --offset` would shift the bed away from the beat JSON the storyboard was timed on.
- frame.md and the storyboard disagree on motion (frame.md says glows breathe and the camera drifts slowly). State in video-direction that the storyboard wins: static glows (static tints on a light film), locked cameras, no zoom blurs.
- The storyboard falls out of date as fixes land (F5 headline 72 → 70 px, and so on). The frame HTML is the truth; sync STORYBOARD.md before any rebuild.

## Design workflow

- **Judge ties:** three pitches scored 112, 113 and 113. Sort by total, then by judge `winner_index` votes, and give synthesis **all** the pitches so grafts that cite "P0 F5" resolve.
- A **frame-spec** agent writing a bespoke frame.md (tokens, type ramp, components, @font-face block) beat the presets for a dark product UI. `design.js` takes `product.theme` (`dark` | `light`) and writes a light system (off-white ground, static tint washes, hairline + soft-shadow screenshots) for a light brand.
- Check that frame.md has both `canvas` and `bg`, then run `node --input-type=module -e "import {readFileSync} from 'node:fs'; import {parseColors, semanticColors} from '$SKILLS/product-launch-video/scripts/lib/tokens.mjs'; console.log(semanticColors(parseColors(readFileSync('frame.md','utf8'))))"` in the project. `canvas` must be the film's ground: `assemble-index.mjs` paints the ground from it. `accent` is picked by highest chroma, so it may land on an assistant color (Leapcast: Ori pink); that only affects captions, which are off.
- The critics found real blockers, including absolute times, missing cam() definitions, 0/11 staged assets and a missing handoff asset. Always run both critics (story/brand and build contract).
- Copy fixes that mattered:
  - The hook's second line needs tension ("Nobody wrote it down.").
  - No empty-ground pause (pure black on a dark film, blank off-white on a light one) longer than about 1 beat: it reads as a dead video on muted autoplay.
  - The drop line should sell the differentiator ("the room remembers"), not a commodity feature ("takes notes").
  - Ask of every claim: does the demo actually prove it?
- Watch for **demo data that tells the wrong story**: "Engagement falling −86%", "1 participant" right after a 7-person call, stats rows with zeros. Patch or hide them.

## Craft

- **Phone legibility** is the most common miss. X shows the film about a third of its width (640 px for 1920). Proof text (pills, labels, the key payoff line, the CTA) needs roughly 40 px or more at output size. The templates derive both numbers from `canvas.width`. Rebuild small UI as vector overlays at 1.4–2.2× instead of zooming the screenshot past 1.15× (it goes soft).
- **The signature moment** (lost items flying back) didn't read the first time: the ghosts appeared already at their target. The fix: resolve the element at its origin, fly it on power3.inOut, keep it soft until the last half, and scale from 1.6 to 1 while it flies.
- **Crossfades between type-heavy frames double-expose headlines.** Use hard cuts between frames that both carry type, and keep crossfades for image-to-type or image-to-image. Push-slides stayed clean.
- An end card set in the top-left like og-dark.png looked lopsided. A centred lockup looked better.
- A masked-out card leaves a visible hole. Put something in its slot, such as the payoff label.
- Headlines need at least 48 px of clearance from panel edges. A headline plus its scrim that disappears in one frame at a cut reads as a pop; exit them on the last 8th.

## Audio

- The Mixkit bed was mastered hot (−10 LUFS). The bundled SFX are quiet: −26 to −37 dB mean, and `click.mp3` is the same file as `click-soft.mp3`. At volumes 0.3–0.4 they were **inaudible**.
- The mixer keeps each track's `data-volume` and allows up to **4.0 (+12 dB)**. What worked against the −10 LUFS bed: bed at 0.75; pops, clicks and notifications at 1.3–2.2; ping at 2.5; whooshes at 0.3–0.7; impacts at 0.65–0.7; typing removed (buried at any level). The templates scale these by `args.music.bed_lufs`, so measure it (SKILL §1).
- **Make the bed a WAV** (`--out assets/music/<name>-bed.wav`; `make-audio.mjs` writes PCM for `.wav`). An AAC (`.m4a`) bed carries 1024 priming samples that the renderer trims a second time, so the music played 23.2 ms early and every cut trailed its kick (Referrals draft-v2). Check: cross-correlate the render against the trimmed track; the lag must be 0.
- A cue's `file` must be the project-relative `assets/sfx/<name>.mp3`. `make-audio.mjs` drops any other form with only a warning.
- **Measure audibility per band, not wideband RMS**:
  - clicks, notifications and chimes: above 2.5 kHz (`hf`);
  - pops: 400–1000 Hz (`mid`);
  - impacts: below 150 Hz (`low`);
  - whooshes and risers: full band (`wide`).
  - `tools/cue-lift.py` prints all four columns against the bed.
- The render's master sits about 5–6 dB below the bed file. Master afterwards with `tools/master-audio.sh`: +3 dB gain and `alimiter` at 0.80, giving −14 LUFS, −1.3 dBTP and 8.6 LU LRA. **Don't use two-pass `loudnorm`**: it drops into dynamic mode (LRA 3.2) and flattens the drop. The limiter needs `latency=1` (now in the script); without it the look-ahead puts the audio 2 ms late. After mastering, cross-correlate the final MP4 against the trimmed track: lag 0. AAC re-encoding can push true peak up by 0.3 dB, so if TP lands above −1, lower `limit` and raise `gain` together (Referrals: 3.6 dB / 0.72 gave −13.9 LUFS, −1.6 dBTP).
- **Very hot SFX turn the whole mix down.** On Digital ID, pushing pings to 4.0 made the renderer normalise the mix by peak (the render-bed offset went from −5 dB to −12 dB), so the SFX gained almost nothing relative to the bed and the film came out at −21.7 LUFS. Keep SFX at 2.0 or below, and swap a cue that won't cut through for one that does (pop cut through by +12–17 dB mid where ping and chime were buried under a dense bed). Re-check the render-bed offset line of `cue-lift.py` after every mix change.
- **A quiet pre-drop intro reads as silence on phones.** Master with a +3 dB lift before the drop: `volume=volume='if(lt(t,<drop−0.05>),1.4125,1)':eval=frame` before the gain and limiter, then set the gain so the integrated loudness lands at −14 LUFS (Digital ID: +3.4 dB, giving −14.1 LUFS and −1.8 dBFS).
- zsh reads `$5:l…` as a modifier. Always brace variables (`${5}`), or run the script with bash.

## Workflow mechanics

- A workflow killed by a session end keeps no results. Relaunch it, or resume with `scriptPath` and `resumeFromRunId` (unchanged prompts replay from cache).
- `rm -f $W/*.jpg` is blocked by the safety check. Use `"${W:?}"/…` or literal paths.
- A 13-frame build uses about 36 agents and a whole-film review about 29. Ultracode-sized, but the fix loops are what produce the quality.
