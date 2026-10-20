---
name: launch-film
description: Make a highly produced, X/Twitter-style product launch film (music-driven motion graphics, real product screenshots, kinetic type, end card with price) with HyperFrames and multi-agent Workflows. Use when asked for a launch video, promo video, product film or SaaS launch reel for Leapcast, Orian or any product. Encodes the proven pipeline, reusable workflow templates, helper tools and hard-won gotchas from the Leapcast film (2026-09-25).
---

# Launch film (HyperFrames + Workflows)

**Output:** a 45–60 s MP4 at 1920×1080, 30 fps. It is music-only, with no voiceover or captions; the on-screen type is the whole script. It uses the product's real screens on the brand's own ground (dark or light), and ends on an end card with the wordmark, one-line message, URL and price (or the site's CTA when there is no public price).
**Quality bar:** the launch films Linear, Raycast and Arc post on X.
**Reference build:** Leapcast (dark). `examples/leapcast/` holds its BRIEF.md, frame.md, STORYBOARD.md, sfx-cues.json, `capture/extracted/` brand-facts and asset descriptions, and three frames: `05-room-lights-up.html` (camera world), `08-nothing-lost.html` (the ghost fly-back signature), `13-end-card.html`. `references/products.md` has the product profiles.
**Before starting, read:**
- `references/lessons.md`. Every item there cost an iteration last time.
- `references/products.md`, the product profile.

## Pipeline at a glance

| Step | Who | Output | Leapcast cost |
|---|---|---|---|
| 0 Setup | you | worktree, project, skills clone, chrome, pinned CLI | 15 min |
| 1 Truth + assets | you (+ `workflows/capture.js` for a logged-in demo) | BRIEF.md, capture/, brand-facts.md, asset-descriptions.md, fonts, music + beat grid, SFX | 45 min |
| 2 Design | `workflows/design.js` | frame.md, STORYBOARD.md, frame packets | 11 agents, 65 min, 1.1M tok |
| 3 Build | `workflows/build.js` | compositions/frames/NN-*.html + SFX cues | 36 agents, 60 min, 7.3M tok |
| 4 Assemble | you | sfx-cues.json, audio_meta.json, index.html, draft-v1.mp4 | 5 min |
| 5 Film review | `workflows/film-review.js` | per-frame fixes + mix plan | 29 agents, 67 min, 3.9M tok |
| 6 Gate / polish | `workflows/gate.js` | draft-vN, all blockers/majors gone | 2–10 agents, 10–40 min |
| 7 Master | you | renders/<name>-launch.mp4 at −14 LUFS | 2 min |

Each workflow is a template. Pass the project and product specifics through `args` (the schema is at the top of each file; `workflows/args.leapcast.json` is a filled example, `workflows/args.capture.example.json` the capture one). Every workflow takes `product.theme` (`dark` | `light`, default `dark`), and a light run gets light-ground instructions throughout. Run a workflow with `Workflow({ scriptPath: "<this skill>/workflows/<x>.js", args: {...} })`. Scripts can't read files, so everything they need goes in `args`.

## 0. Setup

1. Make a worktree under `.claude/worktrees/<name>` from `origin/main`. The project goes at `playground/<name>-launch/` (untracked; don't commit unless asked).
2. Pin the CLI: `npm view hyperframes version`, then use `npx -y hyperframes@<pin>` everywhere. The tools take `--hf <pin>`; Leapcast used 0.8.73.
3. Get the skill library at the pinned version, so its scripts (frame-packets, stage-assets, assemble-index, transitions) match the CLI:
   ```bash
   git ls-remote --tags https://github.com/heygen-com/hyperframes "refs/tags/v<pin>"   # one line = the tag exists (v0.8.73 does)
   git clone --depth 1 --branch v<pin> https://github.com/heygen-com/hyperframes <scratch>/hyperframes-src
   export SKILLS=<scratch>/hyperframes-src/skills
   ```
   If there is no tag: clone without `--branch`, run `grep '"version"' <scratch>/hyperframes-src/packages/cli/package.json`, and if it isn't `<pin>`, re-pin the CLI to that version. The clone lives in the session scratchpad, so a new session redoes this step and updates `args.skills`. The templates read the `product-launch-video`, `hyperframes`, `hyperframes-animation` and `hyperframes-creative` skills from there.
4. Scaffold from `~/product-demos/` (films live there, outside any repo or worktree): `HYPERFRAMES_SKIP_SKILLS=1 npx -y hyperframes@<pin> init <name>-launch --example blank --resolution landscape --skill product-launch-video --non-interactive`. `--skill` stamps `authoringSkill` into `hyperframes.json`; no manual edit is needed.
5. Browser:
   ```bash
   npx -y hyperframes@<pin> browser ensure   # downloads chrome-headless-shell to ~/.cache/hyperframes/chrome (kept across sessions) and prints its Path
   export HYPERFRAMES_BROWSER_PATH=<the Path ensure printed>   # or: find ~/.cache/hyperframes/chrome -type f -name chrome-headless-shell
   npx -y hyperframes@<pin> browser path     # must print that same path
   ```
   Without the env var the CLI may pick a puppeteer-cache or system chromium (`/usr/bin/chromium` on this machine), which lacks the fast capture path. The value is `args.browser`, and every agent prompt repeats it.
6. Copy `tools/` from this skill into the project's `tools/`.

## 1. Truth and assets (do this well; everything downstream depends on it)

- **BRIEF.md** frontmatter (example: `examples/leapcast/BRIEF.md`):
  - `workflow: product-launch-video`, `flow: automation`, `storyboard: no`
  - `message: "<the one line>"`, `destination: x-feed`, `aspect: 1920x1080`, `length: 55s`
  - `voice: none`, `style_preset: bespoke-<product>-<theme>`. The theme is the brand's own ground (`dark` or `light`) and is `args.product.theme` for every workflow.
  - Body sections: Intent, Assets, Customizations (no narration, beat-aware cuts, real screenshots with only the moving element rebuilt, end-card contents), Notes (claims only from brand-facts; accent rules; the avoid list).
- **Capture the site:** `npx -y hyperframes@<pin> capture <url>` writes capture/ (tokens, visible-text, scroll screenshots, assets, fonts).
- **Real product screens.** Use large retina screens (≈3000 px wide): they allow push-ins up to 1.15×. Two sources:
  - The product repo's public or marketing folders (for Leapcast: `apps/leapcast-public/public`). Put them in `capture/assets/app/` and `capture/assets/brand/`, **and also copy them flat into `capture/assets/`** because of the stage-assets search path (see lessons).
  - A logged-in demo, captured with agent-browser by `workflows/capture.js` (args: `workflows/args.capture.example.json`). One agent per role, read-only (it never submits or sends anything), at 2× (3200×2000, phone shots 1170×2532), saving `.hyperframes/shots/<key>/id-<key>-NN-slug.png`. A site agent takes the verbatim copy, palette and brand marks, and a music agent picks and trims a bed. The synthesis writes brand-facts.md, asset-descriptions.md and `.hyperframes/research.md` (message candidates, three angles, an end card) and copies the chosen assets flat into `capture/assets/`. A fact-checker then verifies every claim and greps the project for the credentials. Credentials go only in the args: keep the filled args file under `<scratch>/secrets/`, never in the project or this skill.
- **capture/extracted/brand-facts.md:** verified identity, copy lines, features, pricing, hex colors, fonts, "look of the product". Every claim must come from the site or the code. Agents may only claim what is in this file. Format: `examples/leapcast/capture/extracted/`.
- **capture/extracted/asset-descriptions.md:** every screen described in detail (what is where, visible text, pixel size). Pitch agents choose their shots from it.
- **Fonts:** variable woff2 files in `assets/fonts/`.
- **SFX:** `mkdir -p assets/sfx && cp $SKILLS/media-use/audio/assets/sfx/*.mp3 $SKILLS/media-use/audio/assets/sfx/CREDITS.md assets/sfx/` (19 Pixabay-licensed files; `click.mp3` is the same file as `click-soft.mp3`). List names and lengths for `args.sfx_list`:
  `for f in assets/sfx/*.mp3; do printf '%s %.2fs · ' $(basename $f .mp3) $(ffprobe -v error -show_entries format=duration -of csv=p=0 $f); done`
- **Music:**
  - Take a free-license track (Mixkit) with a clear build and drop, at 120–128 BPM for the X launch feel.
  - Analyse it: `uv run --no-project --python 3.12 --with librosa --with numpy --with soundfile python $SKILLS/music-to-video/scripts/analyze-beatgrid.py assets/music/<track>.mp3 -o .hyperframes/audiomap.json` (librosa isn't installed system-wide here; uv fetches it into a throwaway env, about 100 MB on the first run; use plain `python3` where `python3 -c 'import librosa'` works). Then:
    `python3 -c "import json;d=json.load(open('.hyperframes/audiomap.json'));print(d['tempo']['bpm'],d['grid']['downbeats_sec'][:4],[p['start'] for p in d['energy_phases'] if p['level']=='HIGH'][:4])"`
    The drop is the first HIGH phase start, snapped to the nearest downbeat. Cross-check with the Mixkit BPM and the loudness jump: on Deep Urban the analyser read 123 BPM (Mixkit: 124) and put its downbeats two beats off the grid the film used, but its first HIGH phase (16 s) matched the drop.
  - Fallback without uv: BPM from the Mixkit page, or 60 / median interval of the `hyperframes beats` onsets; the drop is the first bar where `ffmpeg -nostats -i <track> -af ebur128 -f null - 2>&1 | grep 'M:'` momentary loudness jumps ≥ 6 LU.
  - Trim so bar 0 is the first downbeat: `ffmpeg -ss <t0> -i assets/music/<track>.mp3 -c:a libmp3lame -q:a 2 assets/music/<name>-cut.mp3` (skip it when the first downbeat is already at ≈ 0, as with Deep Urban). Use that file everywhere (`music.file`, `beats`, make-audio without `--offset`) so the beat grid and the bed agree. The analyser's times are in the original file: subtract t0 from them.
  - Onset grid: `npx -y hyperframes@<pin> beats .` writes `beats/<audio path>.json`. It needs a temporary `index.html` holding `<audio id="bgm" data-timeline-role="music" class="clip" src=… data-start=0 data-duration=…>`; restore the blank index afterwards.
  - Loudness: `ffmpeg -nostats -t <total_s> -i assets/music/<file> -af ebur128 -f null - 2>&1 | grep -E '^\s+I:'` gives `music.bed_lufs` (Leapcast: −10.1). The templates scale their SFX gain guidance by it.
  - Plan in whole bars and fill `args.music`: `bpm`, `beat_s` = 60/bpm, `bar_s` = 240/bpm, `drop_bar`, `drop_s` = drop_bar × bar_s, `total_bars` (about 29 for 55 s at 124 BPM), `total_s` = total_bars × bar_s, `energy`, `beats_json`, `bed` (the make-audio `--out` path) and `bed_lufs`. Put the first big product reveal on the drop (Leapcast: bar 8, 15.48 s at 124 BPM).

## 2. Design → `workflows/design.js`

A frame-spec writer and 3 angle pitches, then 3 judges (creative director, product marketer, motion engineer), then storyboard synthesis (winner plus grafts from the other pitches), then 2 critics (story/brand and build contract), then a fixer. Its args need `scratch` (agents write only in the project and `<scratch>/work/design/`) and `product.theme`.

Afterwards, verify it yourself. **Don't trust the fixer.**
1. Durations add up to the planned bars, and every `starts_at` equals the sum of the durations before it.
2. Every Scene window is **frame-local**, with the absolute time in `[brackets]`.
3. `asset_candidates` uses `assets/<basename> — role; …`, with `;` separators.
4. Blueprint and rule ids exist. `cam(S,cx,cy)` is defined in every frame that uses it.
5. Registry components: for every `.hyperframes/registry-reference/<id>.html` the storyboard cites, run `npx -y hyperframes@<pin> add <id> --no-clipboard`, then `mkdir -p .hyperframes/registry-reference && mv compositions/<id>.html compositions/components/<id>.html .hyperframes/registry-reference/ 2>/dev/null` (blocks land in `compositions/`, components in `compositions/components/`). Confirm each cited file exists and nothing registry-installed remains under `compositions/`. Builders read them for mechanics only.
6. frame.md has both `canvas` and `bg`, and `canvas` is the film's ground (the tokens check is in lessons).
7. Extract `## Video direction` into `.hyperframes/video-direction.md`. Builders read it, because packets don't carry it.
8. `node $SKILLS/product-launch-video/scripts/frame-packets.mjs --project . --storyboard ./STORYBOARD.md` exits 0.
9. `node $SKILLS/product-launch-video/scripts/stage-assets.mjs --storyboard ./STORYBOARD.md --hyperframes .` reports **N/N staged**.
10. `node tools/frames-json.mjs STORYBOARD.md > .hyperframes/frames.json` exits 0 and produces the `args.frames` for steps 3, 5 and 6.

## 3. Build → `workflows/build.js`

For each frame (pipelined, no barrier):
1. A builder (xhigh) writes the frame and iterates with `tools/preview-frame.mjs` until lint and check show 0 errors and the snapshots look right.
2. An adversarial reviewer (high) takes dense snapshots every 0.25 s.
3. A fixer runs, then another review, for at most 2 rounds.

Pass = score ≥ 8 with no blocker or major finding. Each result carries the frame number `n` and its SFX cues in frame-local time (`file` = `assets/sfx/<name>.mp3`). Its args include `music` (for `bed_lufs`) and `sfx_list`.

**Fast mode** (`fast: true`) sets builders to effort `high` and allows at most 1 fix round.
- Digital ID: 14 frames in 44 min, 13 of 14 passing at 8.2–9.
- Leapcast, full mode: 60 min.

When the user wants speed, follow fast mode with `gate.js`, one pass (about 25 min), instead of the full `film-review.js` (29 agents, about 67 min). Then send the minors worth fixing through `gate.js` with `skip_gate: true` and a polish list.

## 4. Assemble and first render

1. Write `.hyperframes/sfx-cues.json` from the build result (use Write):
   `results.flatMap(r => r.sfx_cues.map(c => ({ frame: r.n, file: c.file, offset_s: c.offset_s, duration_s: c.duration_s, volume: c.volume })))`.
   Check that every `file` exists; make-audio only warns on missing ones and drops them.
2. Run the block from the project root:
   ```bash
   TOTAL=$(node -e 'const f=require("./.hyperframes/frames.json");const l=f.at(-1);console.log((l.starts_at+l.duration).toFixed(3))')
   node tools/make-audio.mjs --project . --music <args.music.file> --out <args.music.bed> --total $TOTAL --cues .hyperframes/sfx-cues.json --fade-out <args.music.bar_s> --bgm-volume 0.75
   # Leapcast: --music assets/music/deep-urban.mp3 --out assets/music/leapcast-bed.wav (TOTAL 56.120, --fade-out 1.935)
   node $SKILLS/product-launch-video/scripts/assemble-index.mjs --storyboard ./STORYBOARD.md --hyperframes .
   node $SKILLS/product-launch-video/scripts/transitions.mjs inject --storyboard ./STORYBOARD.md --hyperframes .
   node $SKILLS/product-launch-video/scripts/transitions.mjs verify --storyboard ./STORYBOARD.md --index ./index.html
   npx -y hyperframes@<pin> lint && npx -y hyperframes@<pin> check --samples 12
   npx -y hyperframes@<pin> render --skill=product-launch-video --quality looks --output renders/draft-v<N>.mp4   # ~25 s
   ```

- `args.music.bed` must equal the `--out` path: film-review reads it, and cue-lift reads it through `audio_meta.json`.
- `make-audio` and `assemble-index` rewrite `audio_meta.json` and `index.html`. **Re-run the whole block after any frame, cue or transition change.**
- Drafts: every render after any change is `renders/draft-v<N+1>.mp4`, where N is the highest existing draft; never overwrite one. Add one line per draft to `renders/CHANGES.txt` (what changed); it feeds gate `changes`.
- Look at the result yourself: `ffmpeg -i renders/draft-v<N>.mp4 -vf "fps=1,scale=480:-1,tile=6x10" -frames:v 1 sheet.jpg`, then Read it. Pull full-res stills of the weak moments.
- Check the SFX: `python3 tools/cue-lift.py --project . --render renders/draft-v<N>.mp4` (reads `audio_meta.json` and `.hyperframes/frames.json`; prints the lift per band: wide, low, mid, hf). A story cue should lift its band by ≥ +5 dB (see lessons).

## 5. Film review → `workflows/film-review.js`

Four lenses on the real MP4: seams, rhythm/music/SFX, art direction and phone legibility, story/copy/truth. Then a director synthesis verifies every blocker and major against stills, rejects weak findings, and writes per-frame fix lists plus orchestrator actions. Then a fixer and a verifier per frame, with one retry.

Then apply the result, in this order:
1. For each `fixes[]` entry, replace ALL cues with `frame == n` in `.hyperframes/sfx-cues.json` by `fix.sfx_cues` (frame-local; drop `why`).
2. Apply each `synth.orchestrator_actions` item by hand: SFX volume, offset, add and remove edits go to `.hyperframes/sfx-cues.json` by frame number; a bed volume goes to `--bgm-volume`; a `transition_in` change goes to STORYBOARD.md, then re-run `node tools/frames-json.mjs STORYBOARD.md > .hyperframes/frames.json`.
3. Re-run the whole §4 block into the next draft.

## 6. Gate → `workflows/gate.js` (always, after any fix round)

- `current` = the new draft; `previous` = the draft the fixes were made against; `changes` = the CHANGES.txt lines between them; `complaints` = the earlier review's blockers and majors.
- A regression hunter compares current with previous side by side every 0.25 s and at every seam at 30 fps.
- A director re-scores and checks each earlier complaint.

Per-frame checks mount each frame **alone**, so a leak across frame windows only shows up here (see lessons). Blockers and majors go back through a per-frame fix and verify.

- Each `fixes[].fix` returns `timing_changed` and the frame's full `sfx_cues`. When `timing_changed` is true, read that frame's new timeline and replace its cues in `.hyperframes/sfx-cues.json` by `fix.sfx_cues` (frame = the frame's `n` from `.hyperframes/frames.json`; drop `why`). Then re-run §4 into the next draft and gate again.
- For minors worth fixing (phone legibility, edges), run gate.js again with `skip_gate: true, polish: [{ id: '<frame_id>', task: '<exact fix + acceptance>' }]`. Unknown ids are logged and skipped.

## 7. Master and deliver

```bash
npx -y hyperframes@<pin> render --skill=product-launch-video --quality delivery --output renders/<name>-launch-master.mp4
tools/master-audio.sh renders/<name>-launch-master.mp4 renders/<name>-launch.mp4   # −14 LUFS, ≤ −1 dBTP, video copied
```

Deliver:
- the MP4 path, duration and loudness;
- a contact sheet (`renders/<name>-launch-contact-sheet.jpg`);
- the open questions: real names in screenshots, commit or not, 60 fps, a 9:16 cut.

`xdg-open` doesn't pick Chrome. To show the film, open it with `chromium file://…`.

## Variants: 9:16

- A portrait cut is a new project (`init --resolution portrait`): copy BRIEF.md, `capture/`, `assets/` (fonts, SFX, music) and `beats/` into it.
- Re-run design.js with `canvas: { width: 1080, height: 1920, fps: 30, ground }` and angles written for vertical, reusing the same music, bars and theme. Screens become crops (`cam()` S ≤ 1.15 still applies).
- The templates derive the portrait rules from the canvas: phone check at width/3 (360 px), and a safe zone with nothing readable in the top 12%, the bottom 20% or the right 12% (the Reels/Shorts/X overlays). Proof text stays ≥ 40 px at output size.
- Never reuse the 16:9 frames. They are laid out in absolute px at 1920×1080, and the CLI has no re-layout.

## Variants: another language

A language version is a copy of the finished project (`rsync` without `renders/draft-*` and `.hyperframes/preview`), kept separate from the original. Keep the original final as `renders/reference-<lang>.mp4`. Then one workflow does the rest. `examples/localize-french.digital-id.js` is the Digital ID French run: about 40 agents, 50 minutes, every frame passed.

1. **Capture and copy deck, in parallel:**
   - Capture agents re-shoot every screen the frames use with the app in the target language, at the same crop and pixel size. Name them like the originals so the frames need no path changes.
   - A copywriter agent writes `.hyperframes/copy-<lang>.md`, preferring the product's own translations (site, login page and app) over ours.
2. **Staging:** a step checks each new screen, then copies it over `assets/` and `capture/assets/`.
3. **Localize:** one localizer and one verifier per frame, with one retry. They change the copy, the rebuilt UI labels, the text fit and the masks, and keep timing and handoffs. The verifier lists any source-language text left on screen.
4. **Render and master** exactly as in step 7.

Things to know:
- Role names and other data may stay untranslated in the app; follow the app.
- Flip any language-demo beat (Digital ID FR goes FR → EN).
- The scratchpad can be wiped between sessions. Re-run step 0.3 (the skills clone) and 0.5 (`browser ensure`) before rendering.

## Orchestrator rules

- Scout inline, then fan out. One workflow per phase, and read each result before starting the next.
- Every agent prompt says: do the work yourself, no sub-agents, use the pinned CLI and the browser env var, and never set inline `visibility: visible`.
- Keep every draft (`draft-v1…vN`) so reviewers can diff.
- Never accept a per-frame "pass" as a whole-film pass. Always review the assembled render.
- Only claims from brand-facts.md. No invented stats, logos or testimonials. Hide demo figures that tell the wrong story.
- Never write credentials into the project, this skill or any report.
