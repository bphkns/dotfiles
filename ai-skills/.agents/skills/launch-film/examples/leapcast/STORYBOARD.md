---
format: 1920x1080
duration: 56s
fps: 30
message: "Meetings that keep working after the call"
arc: "BAB told as a rewind — Hook (a happy call nobody wrote down) → Problem (the call ends, its value disappears) → Bridge (same call, one difference) → Reveal on the bar-8 drop → Features in call order: during (Ori) → leaving → after (decisions and owners) → library → follow-up → patterns → Friction removal → End card"
audience: "founders, team leads and community/program operators who run a lot of meetings and follow tech launches on X"
mode: autonomous
music: "deep house, confident and warm, 124 BPM"
bpm: 124
bar_seconds: 1.935
music_file: assets/music/deep-urban.mp3
captions: disabled
voiceover: none
---

# Leapcast — The Room Keeps Working

## Video direction

**The film.** One real call plays twice. Pass 1 (bars 0–5): a happy 7-person Leapcast call that nobody wrote down ends, the tiles go dark, and the call's real action items drift off and blur away. Bridge (bars 6–7): the last words fade, then "Same call. One difference." Pass 2 (bar 8 on): on the drop the room comes back through the knockout leapcast wordmark, and the feature frames follow the order of a call — during (Ori answers in the room), leaving (the post-call page), after (decisions, and the lost items caught with owners), the library, Ori's follow-up, the patterns — then friction removal and the end card. Signature: bar 16 (30.96 s), the panel pushes in and the two lines lost in Frame 3 fly back along their exit paths and land in their real rows, owner first.

**Palette (frame.md tokens, by role).** Ground `canvas` #0C0B0E on every frame. Surfaces `surface` / `card` / `raised` with `hairline` edges. Text ladder `text` / `text-muted` / `text-dim` (never #FFF). The ONE accent is terracotta: `terracotta` #D73D13 for punches (at most one headline word per frame, the eyebrow, underlines), `terracotta-soft` #C96442 for the wordmark and product-UI glows, `terracotta-tint` #D97F60 for small tinted text and highlight bands, `terracotta-glow` as the single bloom per frame. `ori-pink` / `ori-glow` / `ori-tint` appear only on Ori (Frames 6 and 10: the Ori mark, ori-chip, Ori caret, the Ori-frame bloom); never pink and terracotta blooms together. `success` / `record-red` only as the product's own live signals and the End button. Screenshot grounds: hero_img_1 is #0C0B0E; hero_img_3/4/5/6 page ground is #0E1011 (hero_img_3 panels #17191A). Patches that hide real UI always use the screenshot's own ground.

**Type (frame.md roles).** Claims = Schibsted Grotesk: `display` 180/800 (Frame 4 slam), `h2` 104/700 (most headlines), `statement` 90/600 (long lines, end-card headline); a 72/600 `text-muted` support line sits on the same baseline beside the headline in Frames 1 and 12; `stat-num` style at 242px for the Frame 10 clock. Everything that belongs to the product (chips, pills, typed queries, Ori's answer, owner lines) = Inter at the screenshot's own size, or at a stated enlargement when a frame rebuilds it for legibility. Sentence case. Headlines reveal with a line-masked rise (each line in an overflow:hidden box; fromTo yPercent 100→0, opacity 0→1 over the first 40%, power3.out 0.6 s). In-place headline swaps use the cut-catalog waterfall cut. No typewriter headlines — typing is reserved for product UI. Copy ≤ 7 words per line, ≤ 2 copy lines on screen at once, nothing readable below y = 896; the eyebrow, the clock, the end-card URL and price rows and verbatim product text are exempt from the 2-line and 7-word limits. Every frame's Build notes restate the rise, since packets do not carry this block.

**Camera notation (restated in every frame that uses it).** `cam(S, cx, cy)`: S = output px per source px of the named screenshot; (cx, cy) = the source-px point at frame centre (960, 540). A source point (x, y) lands at (960 + (x − cx)·S, 540 + (y − cy)·S). Full-bleed cover of hero_img_1 = cam(0.656, 1510, 823). Sharpness budget: S ≤ 1.0 for held reads, ≤ 1.15 for a beat. Rebuilt overlays live inside the same scaled world wrapper, positioned in source px, so they track every move. Uniform scale only, no stretch, no browser chrome, no cursor. Source sizes: hero_img_1 3020×1646, hero_img_3 3024×1650, hero_img_4 3024×1650, hero_img_5 3024×1646, hero_img_6 3016×1646.

**Frame-local time.** Every frame builds its own paused timeline from 0. Scene windows and cues in each frame block are frame-local seconds (t = video time − starts_at), with the absolute video time in [brackets] for the orchestrator's SFX. The table below is absolute.

**Reveal model — paced to the music (no voiceover, no captions).** 124 BPM: beat 0.484 s, bar 1.935 s, 8th 0.242 s. Every frame boundary is a bar downbeat. Inside a frame the first headline lands on a downbeat or the next strong beat and every further piece lands on a named beat or 8th of the onset grid (beats/assets/music/deep-urban.mp3.json). Nothing is dumped at t=0; the back half of every frame still receives a reveal; each frame ends on a held read. Frame lengths vary (1, 2, 3 and 4 bars) so the cut rate never settles into a 2-bar metronome.

| Bars | Time (s) | Frame | Reveals land on |
|---|---|---|---|
| 0–1 | 0.00–3.87 | 1 Thumbs up | opens sharp; zoom-out stops on bar 1 (1.94); "Great call." beat 3 (0.97); "Nobody wrote it down." bar 1 (1.94); bar 1 held |
| 2–3 | 3.87–7.74 | 2 Hits End | End pressed on the cut (3.87); pull-back 4.36→5.33; tiles dark on 8ths 4.60→6.05; headline bar 3 (5.81) |
| 4–5 | 7.74–11.61 | 3 Value disappears | line 1 7.99; ghosts 8.23 / 8.72; line 2 bar 5 (9.68); dissolve 10.41→11.61, gone on the bar-6 hit |
| 6–7 | 11.61–15.48 | 4 Same call | "Most of their value" fades 11.61→12.10 over faint outlines; "Same" 12.58, "call." 12.82; "One difference." 14.28; cleared on the 15.25 pickup |
| 8–9 | 15.48–19.35 | 5 Room lights up | DROP 15.48 knockout held a full beat; rush-through 16.45→16.94; push lands bar 9 (17.42); pills at 2.2× 17.42 / 17.91 / 18.39; headline 17.42; dock 18.87 |
| 10–12 | 19.35–25.16 | 6 Ori in the room | tab + line 1 19.84; ask 20.33; send + line 2 20.81; answer streams bar 11 21.29→22.99; highlight bar 12 (23.23); held to 25.16 |
| 13 | 25.16–27.09 | 7 You left | push + line 1 on the cut (25.16); line 2 25.64; highlight 26.13; link press 26.62 |
| 14–17 | 27.09–34.83 | 8 Nothing lost | hard cut; eyebrow 27.34; scroll 28.07→29.52; headline bar 15 (29.03); "1." 29.52; SIGNATURE bar 16 (30.96): push 30.96→31.40, B lands 31.46 + "Who owns it.", A lands 31.94; "And by when." 33.39 (0.96) |
| 18–19 | 34.83–38.70 | 9 Every recording | cards on 16ths 35.09→35.69; line 2 + typing bar 19 (36.77); result 37.26 (0.96); Play press 38.21 |
| 20–21 | 38.70–42.57 | 10 Ori follows up | card 1 39.20; words 39.68 / 40.17; clock flip + card 2 bar 21 (40.64); "On WhatsApp." 41.13 (0.97); full line 41.62 |
| 22–23 | 42.57–46.44 | 11 See the pattern | bars 42.83; cards B–D 43.80 / 44.04 / 44.28; card E + line 2 bar 23 (44.51); "5 need attention" underline 45.01 (0.96) |
| 24–25 | 46.44–50.31 | 12 Nothing to install | line 1 on the cut; pill row 46.93; line 2 bar 25 (48.38) |
| 26–28 | 50.31–56.12 | 13 End card | wordmark wipe 50.31 (0.85); beta 51.05; headline bar 27 (52.25); leapcast.ai 52.75 (0.90); price 53.23; still from 53.47 |

Total 29 bars = 56.12 s; first full-energy product reveal on the bar-8 downbeat, 15.48 s; the end card holds 3 bars.

**Held / breather allocation.** F1 bar 1 (the still, happy call); F4 11.61–12.58 (the last words fade to a near-empty breath) and its title hold; F6 23.23–25.16 (Ori's answer held long enough to read); F8 bar 17 (33.39–34.83); F12 (calm bookend); F13 53.47–56.12 dead still while the music fades.

**Motion grammar.** Entrances power3.out / expo.out; camera legs power3.inOut / power2.inOut; in-frame beats that remove something power2.in. No bounce, back, elastic or overshoot; the only spring is a critically damped press-release. Every camera move has a target, lands and locks; after landing only element motion. Holds ≥ 1 beat. The only aliveness allowed in a hold is a real product signal (a caret blinking). This storyboard overrides frame.md's motion notes where they differ: glow-fields are static once in (no 4-bar breathing), there is no slow camera drift, and there are no zoom blurs between frames (F7→F8 is a hard cut motivated by the link press).

**Negative list.** Slideshow (front-loaded then frozen); screensaver (idle drift, breathing cards or glows, back-half slow pans/pushes, parallax wobble); bounce; bokeh, particles, CSS-keyframe grain, glitch, shimmer on copy; purple/blue "AI" gradients or gradient text; pink on anything that is not Ori; red/green used decoratively; any number that counts or steps (no count-ups, no ticking timer; the Recording pill reads 0:22 throughout); demo figures that tell the wrong story (the −86% Engagement-rate card, the "Peak 15" participation subtitle, the stats row of hero_img_4 — all stay hidden); skeleton or placeholder bars; ticking action items off as done; hub-center / hub-knowledge / hub-followthrough images; the right half of hero_img_6 (Orian promo); hero_img_3's KPI strip; sidebar account footers; Slack or WhatsApp logos (words only); browser chrome; cursors; readable copy or focal UI below y = 896 (screenshot imagery may bleed into that band).

**Screenshot treatment.** Real screens only, cropped to one region per shot and ≥ 40% of the canvas when focal: full-bleed (Frames 2, 5, 6), a floating 18px-radius hairline panel on a glow-field (Frames 1, 8, 12), a feathered crop on canvas (Frames 7, 9, 11). Where something must move or be read inside a screenshot, only that element is rebuilt on top (patch the real pixels with the screenshot's ground, animate the rebuild at the measured position and scale, or at a stated enlargement for legibility); everything else stays the real image. Rebuilds: End button as a clipped duplicate of its real pixels + tile blackouts (F2); the Notes / Transcribing / Recording capture pills as vector copies pixel-matched to meeting-avatars-recording.png (F5, F6, F12); tab indicator + Ori thread (F6); link press + highlight (F7); action rows, owner lines (F8); the filter field as an enlarged duplicate + typed text, card lift, Play press (F9); plot and card masks + the enlarged "5 need attention" label (F11).

**Continuity devices.** (1) Tile outlines hand off F2→F3→F4. (2) The room world hands off F5→F6. (3) The ghost lines: Frame 3 hard-codes their rest and vanish points; Frame 8 starts each at its Frame 3 vanish point and flies it to its real row — both frames state the same numbers. (4) Frames 1 and 12 share one framing of the room card and one glow-field (bookend). (5) Ori's highlighted "proceed to the design meeting" (F6) seeds the "design" query (F9).

**Claims.** Every line traces to capture/extracted/brand-facts.md: the problem and brand lines (section lines, social-card headline); "the room remembers" (Ori recalls past meetings); Ori in the meeting (Ori tab; answers during meetings); notes, live transcription, cloud recording; summaries, decisions, action items; recordings and transcripts library, searchable knowledge; digests "What lies ahead" 07:00 and "Your day" 18:00 by email, Slack and WhatsApp, whose section labels ("Today", "Yours to do") and to-do line format ("owner: title") come from the repo's apps/leapcast-public-api/src/lib/email/ori-digest-email.ts; engagement insights and Intelligence signals; browser-based with no install; joining is always free; from $5/month with 240 AI minutes included. The one composite: F5, F6 and F12 place vector copies of the real Notes/Transcribing/Recording pills from meeting-avatars-recording.png on hero_img_1's top bar. The names in hero_img_4 (Bikash Phukan, Sandip Bordoloi) already appear in leapcast.ai's own published screenshot.

**Audio.** Music assets/music/deep-urban.mp3 from 0.00 at full level, fading out 54.18→56.12. SFX named per frame; ticks and clicks sit −10 to −12 dB under the groove; impacts at 0 dB on 15.48 and 50.31; the riser's tail peaks exactly at 15.48.

## Frame 1 — Thumbs up

- scene: Tight and sharp on Carlos's thumbs-up in the real Leapcast call, then one decelerating zoom-out to the whole 7-person room
- duration: 3.87s
- bars: 2 (bars 0–1)
- starts_at: 0.00
- transition_in: cut
- status: outline
- src: compositions/frames/01-thumbs-up.html
- type: hook
- beat: warmth with an ironic edge
- persuasion: Pain validation by setup — show the good moment, then the crack in it
- blueprint: zoom-out-workspace-reveal (Adapt)
- focal: assets/hero_img_1_dark.webp — the live room, ending as an 18px hairline card; opening edge falloff per .hyperframes/registry-reference/vignette.html (read for mechanics only)
- roles: hero_img_1_dark.webp = cutout (the room card, focal) · vignette = supporting overlay (fades out) · terracotta glow-field = background
- asset_candidates: assets/hero_img_1_dark.webp — the live 7-person Leapcast room (3020×1646)
- rules: viewport-change
- sfx: whoosh
- copy: Great call. / Nobody wrote it down.
- music_cue: quiet intro (onsets ≈0.2). The zoom-out runs 0.00→1.94 and stops on the bar-1 downbeat; line 1 on beat 3 (0.97); line 2 on bar 1 (1.94); bar 1 is a held read.

The hook is a human gesture, not a status dot: a real person giving a thumbs-up in a real Leapcast room, then the whole warm call — and the crack in it: nobody wrote it down. The tension lands at 1.94 s, so Frame 2's hang-up reads as the consequence. Adapt: keep the blueprint's single, decelerating zoom-out from a close-up detail to the containing whole (one outward move, camera locked after the lock); the detail is Carlos's tile, the whole is the entire call floating as a card; the frame opens sharp and the zoom-out alone is the motion. Build notes: frame starts at 0.00, so frame-local and video time are the same. cam(S,cx,cy): S = output px per source px of hero_img_1 (3020×1646); the source point (cx,cy) sits at output (960,540); source (x,y) → (960+(x−cx)·S, 540+(y−cy)·S); world = one wrapper transformed translate+uniform scale, overlays positioned in source px inside it. The screenshot is one world layer with a 34-source-px corner radius (18px at the final scale) and a 1px hairline edge (frame.md `screenshot-frame`). Line-masked rise = each text line in an overflow:hidden box; fromTo yPercent 100→0, opacity 0→1 over the first 40%, power3.out 0.6 s. The glow-field is static once in (no breathing).

Scene 1 (0.00–0.97 s): Open sharp at cam(1.15, 1060, 1170): Carlos's tile (source 777–1487 × 796–1434 → output x 635–1451, y 110–839) fills the centre with his raised thumb at (869, 670); Priya's and Hiroshi's tiles are cut by the frame edges; the vignette at 0.8 darkens the edges. No blur, no focus pull. The single zoom-out starts at 0.00 towards cam(0.53, 1509, 626) on expo.out and lasts to 1.94; the vignette fades 0.8→0 over 0.00–1.20. Full-bleed detail widening to a card; 3 layers (canvas, world, vignette).

Scene 2 (0.97–1.94 s): The room card is already settling (its top edge is below y 186 by 0.97). "Great call." rises line-masked top-left: Schibsted 700 104px (h2), text, left x 160, baseline y 170 (≈492px wide). The zoom-out decelerates to a full stop exactly on 1.94: final card x 160–1761, y 208–1081 (bottom edge flush with the frame; the control bar bleeds into the keep-out band as imagery), the thumbs-up at (680, 888). A static terracotta glow-field (8–10%) sits behind the card's upper-right (1500, 320). Layout: one headline row above a 1601px product card — an editorial top/bottom split, the card ≈ 67% of the canvas.

Scene 3 (1.94–3.87 s): On bar 1 the support line "Nobody wrote it down." rises on the same baseline to the right of line 1: Schibsted 600 72px, text-muted, starting x 692 (40px after "Great call.", ends ≈ x 1440). Then nothing moves — camera locked, no drift, no breathing. The still, happy call is the held read until the cut on 3.87.

## Frame 2 — Someone hits End

- scene: Macro on the real red End button; it is pressed on the cut and the camera pulls back as all seven tiles go dark on eighth notes
- duration: 3.87s
- bars: 2 (bars 2–3)
- starts_at: 3.87
- transition_in: cut
- status: outline
- src: compositions/frames/02-hits-end.html
- type: pain_point
- beat: small dread
- persuasion: Negative contrast — the moment the value starts to leak
- blueprint: camera-journey (Adapt)
- focal: assets/hero_img_1_dark.webp — the control bar and End button, then the whole room at cover
- roles: hero_img_1_dark.webp = cutout (focal world) · End button duplicate (clipped real pixels) = supporting overlay · tile blackout rects = supporting overlays
- asset_candidates: assets/hero_img_1_dark.webp — the live 7-person room, control bar and End button (3020×1646)
- rules: coordinate-target-zoom, press-release-spring
- sfx: click, click-soft
- copy: Then everyone hangs up.
- music_cue: bar-2 downbeat = cut + End press 0.00 [3.87]; pull-back from beat 2 0.49 [4.36]; blackouts on 8ths 0.73 [4.60], 0.97 [4.84], 1.22 [5.09], 1.46 [5.33], 1.70 [5.57], 1.94 [5.81], 2.18 [6.05]; headline on the bar-3 downbeat 1.94 [5.81]; hold from 2.43 [6.30].
- handoff_out: tile-outlines — seven rounded rects (radius 18px, 1px stroke rgba(244,244,245,0.16), fill #0C0B0E) at T1 Amara x −6 y 89 w 340 h 412 · T2 Mei x 360 y 89 w 338 h 412 · T3 Rituraj x 725 y 89 w 339 h 412 · T4 Sofia x 1091 y 89 w 339 h 412 · T5 Priya x −10 y 522 w 462 h 416 · T6 Carlos x 479 y 522 w 466 h 416 · T7 Hiroshi x 969 y 522 w 463 h 416; scale 1; opacity 1; motion none (static at the cut)

Adapt: keep camera-journey sub-shape A — the camera dives onto an actionable element, the action fires, the camera travels to where the consequence renders as element motion, then rests. The action is the End press (no cursor: the button presses on the beat) and the consequence is every tile going dark. Build notes: Timing: Scene windows and cues are frame-local seconds (t = video time − 3.87); [brackets] give absolute video seconds for the orchestrator's SFX only. cam(S,cx,cy): S = output px per source px of hero_img_1 (3020×1646); the source point (cx,cy) sits at output (960,540); source (x,y) → (960+(x−cx)·S, 540+(y−cy)·S); world = one wrapper transformed translate+uniform scale, overlays positioned in source px inside it. The pressable End pill is a clipped duplicate of hero_img_1 itself at source 2137–2299 × 1516–1595 (the real pixels, same world position, clipped to the pill's ≈16-source-px radius) scaled about its centre for the press — never redraw its icons. Blackouts are world-space rounded rects (radius 28 source px, fill #0C0B0E, 1.5-source-px stroke rgba(244,244,245,0.16)) on the tile rects (source): T1 38–555 × 136–764 · T2 596–1111 × 136–764 · T3 1152–1669 × 136–764 · T4 1710–2227 × 136–764 · T5 31–736 × 796–1430 · T6 777–1487 × 796–1430 · T7 1523–2229 × 796–1430; each is a plain 0.07 s linear opacity snap 0→1 on its 8th (no recipe needed). The screenshot keeps Frame 1's 34-source-px corner radius. Line-masked rise = each text line in an overflow:hidden box; fromTo yPercent 100→0, opacity 0→1 over the first 40%, power3.out 0.6 s.

Scene 1 (0.00–0.49 s) [3.87–4.36]: Hard cut to the macro at cam(1.15, 2150, 1312): the real control bar across the lower third, the End pill at x 945–1131, y 775–865 (right of centre), Hiroshi's face upper centre (658, 333), the chat composer upper right; the screenshot's rounded bottom edge at y 924 with canvas below. On the cut the End pill duplicate presses: scale 1.0→0.94 in 0.12 s (linear), then a critically damped release to 1.0 by 0.49 [4.36] with a one-shot record-red ring (35%→0). Macro close-up; 3 layers (canvas, world, pill duplicate).

Scene 2 (0.49–1.94 s) [4.36–5.81]: The camera pulls back to cover, cam(0.656, 1510, 823), one tween 0.49–1.46 [4.36–5.33] on power4.out (fast start, settled by 1.46 [5.33]) — and the consequence renders while it travels: tiles black out one per 8th in reading order, T1 0.73 [4.60], T2 0.97 [4.84], T3 1.22 [5.09], T4 1.46 [5.33], T5 1.70 [5.57], T6 (Carlos) 1.94 [5.81], T7 2.18 [6.05]. Each blackout snaps 0→1 in 0.07 s, leaving only its hairline outline; a soft click on each.

Scene 3 (1.94–3.87 s) [5.81–7.74]: On the bar-3 downbeat "Then everyone hangs up." rises line-masked, centred on the hero anchor: Schibsted 700 104px (h2), text, x 356–1564, row centred on y 454 — over dark tiles only. 1.94–2.43 [5.81–6.30] the chat thread dims: a #0C0B0E overlay at 85% over the panel body (source 2252–2988 × 205–1250). From 2.43 [6.30] the frame holds still: dark tile outlines, dimmed chat, the idle top bar and control bar, the headline.

## Frame 3 — Value disappears

- scene: On near-black, the site's problem line lands while two real action items float up out of the dead tiles as faint texture and blur away with the letters of "disappears."
- duration: 3.87s
- bars: 2 (bars 4–5)
- starts_at: 7.74
- transition_in: crossfade 0.4s
- status: outline
- src: compositions/frames/03-value-disappears.html
- type: pain_point
- beat: loss
- persuasion: Pain agitation — the brand's own problem line, acted out literally
- blueprint: kinetic-type-beats (Adapt)
- focal: the headline (type-only frame over the handed-off tile outlines)
- roles: headline = focal type · ghost lines = supporting texture (rebuilt text, verbatim from hero_img_4's Action items) · tile outlines = background
- rules: depth-of-field-blur
- sfx: whoosh-cinematic
- copy: Important conversations happen every day. / Most of their value disappears.
- music_cue: cut on bar 4 0.00 [7.74] (the first jump in onset strength); line 1 0.25 [7.99]; ghost A 0.49 [8.23], ghost B 0.98 [8.72]; line 2 on the bar-5 downbeat 1.94 [9.68]; dissolve 2.67–3.87 [10.41–11.61], finished exactly on the bar-6 hit (11.61, strength 0.65).
- handoff_in: tile-outlines — seven rounded rects (radius 18px, 1px stroke rgba(244,244,245,0.16), fill #0C0B0E) at T1 x −6 y 89 w 340 h 412 · T2 x 360 y 89 w 338 h 412 · T3 x 725 y 89 w 339 h 412 · T4 x 1091 y 89 w 339 h 412 · T5 x −10 y 522 w 462 h 416 · T6 x 479 y 522 w 466 h 416 · T7 x 969 y 522 w 463 h 416; scale 1; opacity 1; motion none at 0.00 [7.74], then the outline layer fades to opacity 0.5 (≈8% effective stroke) over 0.00–0.98 [7.74–8.72]

The problem, in the site's words, with proof you can see: the call's real action items rise out of the dead tiles and dissolve. Adapt: keep the Problem variant of kinetic-type-beats — pain statements landing alone on a bare canvas, the final pain line resolving with a letter-level dissolve; add two small rebuilt ghost lines as the visual evidence. Build notes: Timing: Scene windows and cues are frame-local seconds (t = video time − 7.74); [brackets] give absolute video seconds for the orchestrator's SFX only. Fonts come from frame.md's @font-face files in assets/fonts. Ghost lines (Frame 8 uses the same numbers): A "Find time tonight to go through the information", B "Send the filled form/information to Sandip" — Inter 500 30px, line-height 38px, #F4F4F5 at 45%, no background, so they read as texture under the headline; anchor = text left edge x / vertical centre y. Ghost A rest (1000, 236); vanish point (1060, 156). Ghost B rest (900, 712); vanish point (980, 652). The ghost and glyph blurs follow the depth-of-field-blur recipe (filter blur on the element, deterministic). Line-masked rise = each text line in an overflow:hidden box; fromTo yPercent 100→0, opacity 0→1 over the first 40%, power3.out 0.6 s; the bar-5 swap is the waterfall cut per cut-catalog.md. The dissolve is the frame's content beat, not an exit transition; the frame ends with "Most of their value" still on screen (Frame 4 picks it up).

Scene 1 (0.00–0.98 s) [7.74–8.72]: The 0.4 s crossfade from Frame 2 keeps the seven outlines exactly in place while everything else dissolves to canvas; the outlines fade to 50% over 0.00–0.98 [7.74–8.72]. At 0.25 [7.99] line 1 rises centred in two rows — "Important conversations" / "happen every day." — Schibsted 600 90px (statement), text, centred on x 960, row centres y 407 and 502. At 0.49 [8.23] ghost A rises out of the Sofia/Rituraj outlines: from (1000, 266) to rest (1000, 236), opacity 0→0.45, 0.6 s power3.out. Centred type block; 3 layers (outlines, ghosts, headline).

Scene 2 (0.98–1.94 s) [8.72–9.68]: At 0.98 [8.72] ghost B rises the same way from (900, 742) to rest (900, 712), inside the Carlos/Hiroshi outlines. Hold.

Scene 3 (1.94–2.67 s) [9.68–10.41]: Bar 5: waterfall cut — line 1 leaves upward word by word as line 2 "Most of their value disappears." cascades into one row centred on y 454 (Schibsted 700 90px, text, ≈1300 wide, x 310–1610). Both ghosts hold at 45%.

Scene 4 (2.67–3.87 s) [10.41–11.61]: The loss. Ghost A drifts 2.67–3.87 [10.41–11.61] to its vanish point (+60, −80 → (1060, 156)), blur 0→14px, opacity 0.45→0, power2.in; ghost B drifts 2.91–3.87 [10.65–11.61] to (980, 652) (+80, −60), same blur and fade. From 2.67 [10.41] the letters of "disappears." blur out one by one left→right: 11 glyphs (d-i-s-a-p-p-e-a-r-s-.) staggered 0.085 s, each blur 0→10px, opacity 1→0, y −6px over 0.35 s power2.in — the last glyph is gone at 3.87 [11.61]. At the cut only "Most of their value" remains on near-black over faint outlines. No camera anywhere.

## Frame 4 — Same call

- scene: The last words of the problem fade over the faint outlines, a one-beat breath, then "Same call. / One difference." lands word by word on the build and clears on the pickup
- duration: 3.87s
- bars: 2 (bars 6–7)
- starts_at: 11.61
- transition_in: cut
- status: outline
- src: compositions/frames/04-same-call.html
- type: product_intro
- beat: held breath → anticipation
- persuasion: Curiosity gap — the rewind promise
- blueprint: titlecard-reveal (Adapt)
- focal: the two-line title
- roles: title = focal type · Frame 3 remnant ("Most of their value" + faint tile outlines) = background · canvas = background
- rules: kinetic-beat-slam
- sfx: riser
- copy: Same call. / One difference.
- music_cue: the bar-6 hit 0.00 [11.61] is the cut; "Most of their value" fades 0.00–0.49 [11.61–12.10]; "Same" 0.97 [12.58] (beat 3), "call." 1.21 [12.82] (0.47); "One" 2.67 [14.28] (0.47), "difference." 2.79 [14.40]; cleared on the pickup 3.64 [15.25] (0.63); 3.64–3.87 [15.25–15.48] empty; riser 1.46–3.87 [13.07–15.48].

The hinge of the film: the held breath before the drop — short enough that the screen is never dead. Adapt: the titlecard-reveal Product_Intro card chain — card 1 is Frame 3's fading remnant and a one-beat breath, card 2 is the two-line title built word by word and held still, and the chain ends on an instant hard cut to empty black instead of a logo card (the logo arrives in Frame 5 on the drop). Build notes: Timing: Scene windows and cues are frame-local seconds (t = video time − 11.61); [brackets] give absolute video seconds for the orchestrator's SFX only. Fonts come from frame.md's @font-face files in assets/fonts. Remnant = Frame 3's end state rebuilt exactly: the seven tile outlines (Frame 3 handoff_in rects: radius 18px, 1px stroke rgba(244,244,245,0.16) at layer opacity 0.5 ≈ 8% effective) and "Most of their value" set as Frame 3's line 2 (Schibsted 700 90px, text, the full line "Most of their value disappears." laid out centred on x 960, row centre y 454, x 310–1610, with "disappears." at opacity 0 so the remaining words keep their x). Deliberate held breath: exempt from hero-by-0.5 s; the remnant fade and the 3.64 [15.25] clear are in-frame storytelling beats (the clear is a gsap set of opacity 0), not exits.

Scene 1 (0.00–0.97 s) [11.61–12.58]: On the cut the remnant is exactly where Frame 3 left it. "Most of their value" fades 1→0 0.00–0.49 [11.61–12.10] (power2.in); the outlines stay at 8%. Then one beat of near-empty canvas — no grain, no glow.

Scene 2 (0.97–2.67 s) [12.58–14.28]: "Same" slams in on 0.97 [12.58] and "call." on 1.21 [12.82] — Schibsted 800 180px (display), text, tracking −0.04em; row 1 centred on x 960, row centre y 369 (≈859 wide, x 530–1389). Each word: scale 1.06→1.0 + opacity 0→1 in 0.22 s, power3.out — percussive, on the shared beat array, no overshoot. The outlines stay faint behind.

Scene 3 (2.67–3.64 s) [14.28–15.25]: Row 2 "One difference." lands (row centre y 539, ≈1278 wide, x 321–1599): "One" on 2.67 [14.28], "difference." on 2.79 [14.40], same slam; "difference." in terracotta #D73D13, the frame's one punch. Both rows hold still.

Scene 4 (3.64–3.87 s) [15.25–15.48]: On the pickup both rows and the outlines hard-cut off (gsap set opacity 0, no fade) — one 8th of empty black before the drop.

## Frame 5 — The room lights up

- scene: DROP: the returning 7-person room seen through the knockout leapcast wordmark holds a beat, rushes past the lens, then the room's capture pills spring in large, one per beat, and dock in the top bar
- duration: 3.87s
- bars: 2 (bars 8–9)
- starts_at: 15.48
- transition_in: cut
- status: outline
- src: compositions/frames/05-room-lights-up.html
- type: product_intro
- beat: release and awe
- persuasion: Reveal on the peak — the brand is the answer to "one difference"
- blueprint: logo-assemble-lockup (Adapt)
- focal: assets/leapcast-wordmark-nobg.svg as a knockout mask over assets/hero_img_1_dark.webp — mask mechanism per .hyperframes/registry-reference/svg-mask-reveal.html (read for mechanics only; no sweep: the mask is fully open at 0.00)
- roles: hero_img_1_dark.webp = cutout (the room; focal from 1.46) · leapcast-wordmark-nobg.svg = mask 0.00–1.46, then the small signature · meeting-avatars-recording.png = supporting (pixel reference for the vector pills; only its Notes notebook icon is cropped)
- asset_candidates: assets/hero_img_1_dark.webp — the live 7-person room (3020×1646); assets/leapcast-wordmark-nobg.svg — wordmark, knockout mask and top-bar signature; assets/meeting-avatars-recording.png — Notes/Transcribing/Recording pills, pixel reference + Notes icon crop
- rules: multi-phase-camera, nudge-curve
- sfx: impact-bass-1, whoosh-short, pop
- copy: This time, the room remembers.
- music_cue: DROP 0.00 [15.48] (0.80) knockout + impact, the wordmark held a full beat pair; rush-through 0.97–1.46 [16.45–16.94] (0.74 → 0.84); push lands on the bar-9 downbeat 1.94 [17.42]; Notes pill + headline 1.94 [17.42] (0.75); Transcribing 2.43 [17.91] (0.79); Recording 2.91 [18.39] (0.71); dock 3.39 [18.87]; static from 3.82 [19.30].
- handoff_out: room-world — hero_img_1 at cam(1.0, 2040, 540) (image at output x −1080..1940, y 0..1646), static at the cut; vector pills at 1× Notes · On x 1148–1333, ● Transcribing x 1356–1541, ● Recording · 0:22 x 1564–1785, all y 21–68, scale 1, opacity 1, static, over the #0C0B0E patch (source 2210–2875 × 14–75); signature wordmark (9 paths, fill #C96442) at x 96, y 24, width 200, opacity 1, static. The headline and its scrim end at the cut.

The first full-energy reveal, on the drop: the leapcast letters are windows onto the same seven faces, held long enough to read the name, then the camera flies through them into the call — which now remembers. The capture pills are the proof, so they arrive big enough to read on a phone and only then go home to the top bar. Adapt: keep the CTA push-through signature (a fast camera push through the mark's negative space) resolving on a small lockup; the push lands in the live room instead of CTA letters, and the lockup is the small wordmark signature docked in the app's top bar. Build notes: Timing: Scene windows and cues are frame-local seconds (t = video time − 15.48); [brackets] give absolute video seconds for the orchestrator's SFX only. cam(S,cx,cy): S = output px per source px of hero_img_1 (3020×1646); the source point (cx,cy) sits at output (960,540); source (x,y) → (960+(x−cx)·S, 540+(y−cy)·S); world = one wrapper transformed translate+uniform scale, overlays positioned in source px inside it. Use multi-phase-camera phases only; omit its micro-drift. Mask = paths 1–8 of the SVG (the letters; path 9 is "beta"), viewBox region x 2.64–133.2, y 7.2–44.9 drawn into the box x 210–1710, y 237.5–670.5 (11.49 px per unit); outside the letters = canvas. Push-through origin (986, 594) = the centre of the "c"'s bottom arm (inside the letterform); scale 20 opens the whole frame. Capture pills = vector rebuilds pixel-matched to meeting-avatars-recording.png (never its crops, except the Notes notebook icon, ≈1300–1335 × 30–70, scaled with its pill). At 1× (hero_img_1 source px, = output px at cam(1.0)): full-radius pills 47 tall; Notes · On and ● Transcribing 185 wide, fill #202124, label Inter 600 ≈21px #F4F4F5, dot #4FC560 ≈8px (Notes = icon, "Notes", dot, "On"); ● Recording · 0:22 221 wide, fill #1F1414, 1px border #5C2D29, dot and label in the pill's red ≈#D25A4F, digits tabular-nums, reading 0:22 throughout (no tick). 1× top-bar slots (source): Notes 2228–2413, Transcribing 2436–2621, Recording 2644–2865, y 21–68; a #0C0B0E patch (source 2210–2875 × 14–75) hides the real "Notes · Off" from 1.46 [16.94]; the real "7" pill stays. Stack slots at 2.2× (screen px, over the chat panel, no faces): pills 103 tall, label ≈46px, right-aligned at x 1824 — Notes x 1417–1824, y 250–353 · Transcribing x 1417–1824, y 377–480 · Recording x 1338–1824, y 504–607. Line-masked rise = each text line in an overflow:hidden box; fromTo yPercent 100→0, opacity 0→1 over the first 40%, power3.out 0.6 s.

Scene 1 (0.00–0.97 s) [15.48–16.45]: Hard cut on the drop. On canvas the leapcast letters are windows onto the live room: behind the mask hero_img_1 sits at cam(0.5, 1510, 940) (image x 205–1715, y 70–893 — both face rows inside the letter band, the chat thread in "ast"). A 2px terracotta-soft stroke traces the letter edges. The mask pushes gently 1.00→1.05 about (986, 594) 0.00–0.97 [15.48–16.45], power2.out — the name holds a full beat pair so it registers. This is the film's screenshot frame: the brand made of the people in the call. Centred hero; 3 layers.

Scene 2 (0.97–1.46 s) [16.45–16.94]: Rush-through: the mask scales 1.05→20 about (986, 594) on power3.in (accelerating) while the room behind eases from cam(0.5, 1510, 940) to cover cam(0.656, 1510, 823) on power2.inOut — two speeds, real depth; the letter stroke fades out 0.97–1.12 [16.45–16.60]. At 1.46 [16.94] the mask is removed: the room is full-bleed.

Scene 3 (1.46–1.94 s) [16.94–17.42]: The camera carries on without a stop into a push to the top right: cover → cam(1.0, 2040, 540) 1.46–1.94 [16.94–17.42], power3.out, landing on bar 9 and locking. The pill patch covers the real "Notes · Off" from 1.46 [16.94]. The signature wordmark fades up in the app's empty top bar (x 96, y 24, 200px wide) and a canvas scrim fades in 1.70–1.94 [17.18–17.42]: a #0C0B0E feather over x 0–1560, y 0–250 at ≤85%, fading to 0 by y 300.

Scene 4 (1.94–2.91 s) [17.42–18.39]: Bar 9: the Notes · On pill springs into stack slot 1 at 2.2× (scale 0.85→1 + opacity 0→1 about its right edge, 0.4 s power3.out, no overshoot); on the same downbeat the headline "This time, the room remembers." rises top-left over the scrim — Schibsted 600 90px (statement), text, x 96, row centre y 184 (glyphs ≈ y 140–225: above Rituraj's and Sofia's faces, crossing only hair and the scrim-dimmed tab row). On 2.43 [17.91] ● Transcribing springs into slot 2 the same way. A pop on each pill.

Scene 5 (2.91–3.87 s) [18.39–19.35]: On 2.91 [18.39] ● Recording · 0:22 springs into slot 3; pop. The three big pills read for a beat. On 3.39 [18.87] all three dock in one power3.inOut move 3.39–3.82 [18.87–19.30] (nudge-curve slow-fast-slow) from their stack slots at 2.2× to their top-bar slots at 1× over the patch. Static from 3.82 [19.30] to the cut, camera locked.

## Frame 6 — Ori in the room

- scene: The camera settles on the meeting's side panel; the tab slides to Ori, "What did we decide?" is asked and Ori streams back the call's real decision, which holds long enough to read
- duration: 5.81s
- bars: 3 (bars 10–12)
- starts_at: 19.35
- transition_in: cut
- status: outline
- src: compositions/frames/06-ori-in-the-room.html
- type: feature_showcase
- beat: curiosity → relief
- persuasion: Show-don't-tell proof — one ask, one real answer, the same call
- blueprint: prompt-type-submit-generate (Adapt)
- focal: assets/hero_img_1_dark.webp side panel with a rebuilt Ori thread — tab slide per .hyperframes/registry-reference/tabs-slide-indicator.html and answer streaming per .hyperframes/registry-reference/streaming-text.html (read for mechanics only)
- roles: hero_img_1_dark.webp = cutout (panel focal; tiles dimmed to background) · ori-mark.svg = supporting (tab, Thinking row, ori-chip) · rebuilt thread = supporting overlay · leapcast-wordmark-nobg.svg = the handed-off signature · meeting-avatars-recording.png = supporting (pixel reference for the handed-off vector pills + Notes icon crop)
- asset_candidates: assets/hero_img_1_dark.webp — the live room and its side panel (3020×1646); assets/ori-mark.svg — Ori mark for the tab, Thinking row and ori-chip; assets/leapcast-wordmark-nobg.svg — the handed-off top-bar signature; assets/meeting-avatars-recording.png — pixel reference for the handed-off pills + Notes icon crop
- rules: discrete-text-sequence, context-sensitive-cursor
- sfx: click-soft, typing, pop
- copy: Ori is in the room. / Ask while you talk.
- music_cue: the camera continues from the downbeat 0.00 [19.35]; tab slide + line 1 on beat 2 0.49 [19.84]; ask types from 0.98 [20.33] (0.74); send + line 2 on 1.46 [20.81] (0.89); one-beat Thinking; answer streams from the bar-11 downbeat 1.94–3.64 [21.29–22.99]; highlight on the bar-12 downbeat 3.88 [23.23] (0.74); held to the cut 5.81 [25.16].
- handoff_in: room-world — hero_img_1 at cam(1.0, 2040, 540) (image at output x −1080..1940, y 0..1646), static at 0.00 [19.35]; vector pills at 1× Notes · On x 1148–1333, ● Transcribing x 1356–1541, ● Recording · 0:22 x 1564–1785, all y 21–68, scale 1, opacity 1, static, over the #0C0B0E patch (source 2210–2875 × 14–75); signature wordmark (9 paths, fill #C96442) at x 96, y 24, width 200, opacity 1, static. No headline or scrim at the start.

Ori is in the room while the call is still going: ask what was decided and the answer is the call's own decision — the same line that appears on the post-call page in Frame 8, so the ask, the answer and the page are one call. The answer gets the frame's back half to itself, and its key phrase is highlighted so the meaning lands without reading every word. Adapt: keep the full generate loop (ask types into a real product surface → submit → status theatre → streamed answer → hold), with the camera making one move and then locking; the ask types into a user bubble at the top of the thread (the real composer sits below the keep-out line). Build notes: Timing: Scene windows and cues are frame-local seconds (t = video time − 19.35); [brackets] give absolute video seconds for the orchestrator's SFX only. cam(S,cx,cy): S = output px per source px of hero_img_1 (3020×1646); the source point (cx,cy) sits at output (960,540); source (x,y) → (960+(x−cx)·S, 540+(y−cy)·S); world = one wrapper transformed translate+uniform scale, overlays positioned in source px inside it; the rebuilt tab row, thread and pills are positioned in hero_img_1 source px inside the scaled world. Handed-off pills (identical to Frame 5's end state): vector rebuilds pixel-matched to meeting-avatars-recording.png — full-radius, 47 source px tall; Notes · On (source 2228–2413; fill #202124; notebook icon cropped from the PNG ≈1300–1335 × 30–70, "Notes", #4FC560 dot, "On"), ● Transcribing (2436–2621; fill #202124; #4FC560 dot), ● Recording · 0:22 (2644–2865; fill #1F1414, 1px border #5C2D29, dot and label ≈#D25A4F, tabular-nums, no tick); labels Inter 600 ≈21 source px, #F4F4F5 unless red; all y 21–68, over a #0C0B0E patch (source 2210–2875 × 14–75) that hides the real "Notes · Off". Patches (#0C0B0E, source): tab row 2258–2720 × 140–204 (rebuilt labels "Chat", "People 7", "Agenda", [ori-mark] "Ori" in Inter 500 at the screenshot's size); thread body 2262–2980 × 205–1245. The ori-glow bloom is static once risen. Line-masked rise = each text line in an overflow:hidden box; fromTo yPercent 100→0, opacity 0→1 over the first 40%, power3.out 0.6 s.

Scene 1 (0.00–0.49 s) [19.35–19.84]: The Frame 5 world continues with no visible cut: camera cam(1.0, 2040, 540) → cam(1.1, 2145, 560) 0.00–0.74 [19.35–20.09], power3.inOut — the panel (source 2252–2988) comes to rest at output x 1078–1887 and the pills leave through the top edge with the move. A #0C0B0E overlay over the tile region (source x < 2242) fades 0→65% 0.00–0.74 [19.35–20.09] so the tiles fall to 35% (background role). An ori-glow bloom (≤12%) rises behind the panel's upper half (centre 1480, 380). The signature stays at (96, 24).

Scene 2 (0.49–0.98 s) [19.84–20.33]: Beat 2: in the rebuilt tab row (output x 1084–1593, y 78–148) the raised active pill slides from "Chat" (source 2271–2352) to "Ori" (2615–2700) in 0.3 s, power3.inOut; Chat → text-dim, Ori → text; the tab's pink mark glows once (pink bloom 0→40%→10% over 0.5 s); click-soft. Line 1 "Ori is in the room." rises at left: Schibsted 700 104px, text, x 96, row centre y 390 (≈838 wide). 0.74–0.98 [20.09–20.33] the chat thread wipes upward out of the panel (the thread patch reveals bottom→top).

Scene 3 (0.98–1.94 s) [20.33–21.29]: The ask. A right-aligned user bubble (raised #262624, 16-source-px radius, 1px hairline) opens at source 2666–2960 × 250–312 (output x 1533–1857, y 199–267) and "What did we decide?" types into it character by character — Inter 500, 26 source px — with a caret, 0.98–1.46 [20.33–20.81]; typing sfx. On 1.46 [20.81] it sends (bubble press 0.97→1.0, pop) and a Thinking row appears under it at source (2275, 350) → output (1103, 309): ori-mark 22 source px + "Thinking…" in text-dim; the mark pulses once (1→1.15→1 over one beat). On the same 1.46 [20.81] line 2 "Ask while you talk." rises under line 1 (x 96, row centre y 506, ≈903 wide), so both headline lines are read before the answer starts.

Scene 4 (1.94–3.88 s) [21.29–23.23]: Bar 11: the Thinking row is replaced (hard swap) by Ori's answer as ori-bubble specifies — the ori-chip header (pink mark + "Ori", output y 293–337) and directly under it, with no section label, the call's real decision streaming word by word with a 2px ori-pink caret: "The team agreed to leave the current meeting and proceed to the design meeting." — Inter 400 26 source px (≈29px), wrapped in two rows so row 2 starts at "proceed": "The team agreed to leave the current meeting and" (output y 357–395) / "proceed to the design meeting." (y 399–437), x 1103–1857, streaming 1.94–3.64 [21.29–22.99]. The caret blinks while the answer settles.

Scene 5 (3.88–5.81 s) [23.23–25.16]: Bar 12: a terracotta-tint band (rgba(217,127,96,0.24), 4px radius) sweeps left→right behind "proceed to the design meeting" (row 2, x 1098–≈1545, y 397–439) in 0.35 s and rests; the caret stops. Then hold, camera locked, to the cut — nearly two seconds to read the answer. The highlighted phrase seeds Frame 9's "design".

## Frame 7 — You left the meeting

- scene: One bar on the real post-call page: the camera pushes onto its Meeting details card as the brand line lands, the card's promise is highlighted and its details link is pressed
- duration: 1.93s
- bars: 1 (bar 13)
- starts_at: 25.16
- transition_in: cut
- status: outline
- src: compositions/frames/07-you-left.html
- type: benefit_highlight
- beat: calm confidence
- persuasion: Feature-to-benefit translation — the product's own promise on its own screen
- blueprint: device-surface-showcase (Adapt)
- focal: assets/hero_img_6_dark.webp (left half only) — sentence sweep per .hyperframes/registry-reference/inline-highlight.html (read for mechanics only)
- roles: hero_img_6_dark.webp = cutout (the surface, a feathered crop on canvas) · headline = focal type · terracotta glow-field = background
- asset_candidates: assets/hero_img_6_dark.webp — the real "You left the meeting" post-call page (left half only, 3016×1646)
- rules: coordinate-target-zoom, css-marker-patterns, press-release-spring
- sfx: chime, click-soft
- copy: The meeting ends. / The room keeps working.
- music_cue: cut on the bar-13 downbeat 0.00 [25.16] = push start + line 1; line 2 + dot ring 0.48 [25.64] (0.79); highlight 0.97 [26.13] (0.72); link press 1.46 [26.62] (0.83); held to the cut 1.93 [27.09].

The moment you leave, in the brand's own words, on the product's own page: the page already says the notes, transcript and recording are on their way. One bar, no idle beat: the push starts on the cut. Adapt: keep the surface held as the hero with one push-in onto its target region and a tap on its own control (floating-window + static-tour mechanics); the screen advance after the tap happens across the cut — Frame 8 is the details page. Build notes: Timing: Scene windows and cues are frame-local seconds (t = video time − 25.16); [brackets] give absolute video seconds for the orchestrator's SFX only. cam(S,cx,cy): S = output px per source px of hero_img_6 (3016×1646); the source point (cx,cy) sits at output (960,540); source (x,y) → (960+(x−cx)·S, 540+(y−cy)·S); world = one wrapper transformed translate+uniform scale, overlays positioned in source px inside it. Show only source x 0–1560, y 0–1220 (80-source-px feather on the right edge, 60 on the bottom) — the divider, the Orian promo on the right and the footer never appear; the page ground #0E1011 sits on canvas. A #0E1011 patch (source ≈620–1000 × 455–500) hides the "Instant meeting · 1 participant" subtitle from the cut; the title, buttons and stars stay real. The glow-field is static. Line-masked rise = each text line in an overflow:hidden box; fromTo yPercent 100→0, opacity 0→1 over the first 40%, power3.out 0.6 s.

Scene 1 (0.00–0.48 s) [25.16–25.64]: Hard cut to cam(0.83, 809, 832): the page's own centred column — small leapcast wordmark, "You left the meeting", Rejoin / Write a review, the stars, the Meeting details card, Chat With Ori — and the push starts at once: cam(0.83, 809, 832) → cam(1.15, 1075, 756) 0.00–0.48 [25.16–25.64], power3.inOut, landing and locking on beat 2; the card travels to the lower left and grows to x 96–1211, y 540–839. Everything above it (source y < 735: wordmark, title, buttons, stars) and below it (source y > 1040: Chat With Ori, the redirect line) fades 1→0 0.00–0.24 [25.16–25.40] (power2.in) as masked layers, clearing the top before the headline reads. On 0.00 [25.16] line 1 "The meeting ends." rises at x 96, row centre y 190 — Schibsted 700 104px, text (≈885 wide). A static terracotta glow-field (8%) behind the card. Layout: a left-aligned editorial stack, headline over the product card.

Scene 2 (0.48–0.97 s) [25.64–26.13]: Beat 2: line 2 "The room keeps working." rises under it (x 96, row centre y 306, ≈1220 wide; "working." in terracotta #D73D13). Chime. The card's orange status dot (output (148, 599)) sends one terracotta-soft ring (scale 1→2.4, opacity 0.6→0, 0.45 s).

Scene 3 (0.97–1.46 s) [26.13–26.62]: A terracotta-glow highlight (rgba(215,61,19,0.22)) sweeps left→right behind the card's real sentence "Notes, transcript and recording land on the details page once this meeting wraps up." — row 1 (x 142–1157, y 654–683) 0.97–1.24 [26.13–26.40], row 2 (x 142–277, y 698–726) 1.24–1.36 [26.40–26.52].

Scene 4 (1.46–1.93 s) [26.62–27.09]: On 1.46 [26.62] the real "Go to meeting details →" link (x 142–463, y 763–793) presses (scale 0.96 → 1.0, critically damped) and brightens to terracotta-tint; click-soft. Held to the cut — the next frame is the details page.

## Frame 8 — Nothing lost

- scene: The real post-call page scrolls from the charts to Decisions; on the phrase change the panel pushes in and the two lines lost in Frame 3 fly back and land in Action items with their owners
- duration: 7.74s
- bars: 4 (bars 14–17)
- starts_at: 27.09
- transition_in: cut
- status: outline
- src: compositions/frames/08-nothing-lost.html
- type: feature_showcase
- beat: relief → control (the signature)
- persuasion: Callback proof — the same items, first lost, then caught with an owner and a deadline
- blueprint: transcript-scroll-artifact-reveal (Adapt)
- focal: assets/hero_img_4_dark.webp right column (charts → Action items) as a floating panel — ghost landing per .hyperframes/registry-reference/soft-blur-in.html and sweeps per .hyperframes/registry-reference/inline-highlight.html (read for mechanics only)
- roles: hero_img_4_dark.webp = cutout (panel, focal) · ghost lines = supporting (rebuilt text) · headline column = focal type · terracotta glow-field = background
- asset_candidates: assets/hero_img_4_dark.webp — the real post-call details page: Summary, Decisions, Action items (3024×1650)
- rules: 3d-page-scroll, css-marker-patterns, discrete-text-sequence
- sfx: whoosh-short, pop, typing
- copy: After the call / What was decided. / Who owns it. / And by when.
- music_cue: hard cut on bar 14 0.00 [27.09]; eyebrow + rule 0.25–0.98 [27.34–28.07]; scroll 0.98–2.43 [28.07–29.52] with summary sweeps on 1.22 [28.31] / 1.46 [28.55] / 1.71 [28.80] / 1.95 [29.04]; headline on the bar-15 downbeat 1.94 [29.03]; "1." on 2.43 [29.52] (0.88); SIGNATURE on the bar-16 phrase change 3.87 [30.96]: panel push 3.87–4.31 [30.96–31.40], ghost B lands 4.37 [31.46] (0.81) with "Who owns it.", ghost A lands 4.85 [31.94] (0.73), owners type after each; "And by when." + "tonight" on 6.30 [33.39] (0.96); hold to 7.74 [34.83].

The signature. The details page reads what was decided; then, on the 8-bar phrase change, the panel pushes in and the two action items that dissolved in Frame 3 fly back from where they vanished and snap into their real rows — the one with a named owner first — and their owners type in. The headline answers along with the product: what was decided, who owns it, and by when. Nothing is ticked off: Leapcast captures and assigns, it does not do the work. Adapt: keep the vertical traversal of one long generated surface as evidence (element scroll, one move) → one focal pivot → the payoff held with the frame locked; the pivot is the push plus the ghost lines landing, the payoff is the owned action rows. Build notes: Timing: Scene windows and cues are frame-local seconds (t = video time − 27.09); [brackets] give absolute video seconds for the orchestrator's SFX only. The panel is a window at output x 752–1879, y 96–896 (18px radius, 1px hairline, `shade` shadow, ground #0E1011) onto hero_img_4 (3024×1650). Mapping, phase A: source (x, y) → (752 + (x − 1498)·0.92, 96 + (y − Y0)·0.92), Y0 = 480 at entry (below the stats row, source 340–470, which never shows) → 742 at rest. Phase B (the push, 3.87–4.31 [30.96–31.40], power3.inOut): S 0.92 → 1.15 and Y0 742 → 954 on one eased progress, the left edge (source x 1498 at output x 752) fixed; at rest source (x, y) → (752 + (x − 1498)·1.15, 96 + (y − 954)·1.15), with the image's bottom edge (source 1650) on the panel's bottom edge. Use 3d-page-scroll's scroll mechanic only; no tilt (rotateX/Y 0, no perspective). Patches (#0E1011, source px): the Participation subtitle "Peak 15 · avg 11.5 participants" 1518–1885 × 576–606 (a 15-person figure in a 7-person story) for the whole frame; and until their landings row 1 1518–2143 × 1440–1475, owner 1 1518–1760 × 1482–1508, row 2 1518–2080 × 1531–1565, owner 2 1518–1705 × 1573–1600. Ghost lines (same numbers as Frame 3): A "Find time tonight to go through the information", B "Send the filled form/information to Sandip", Inter 500 30px (Frame 3's size), #F4F4F5; anchor = text left edge x / vertical centre y. A starts at (1060, 156), B at (980, 652) — their Frame 3 vanish points. Targets after the push: row 1 left 780, centre y 675; row 2 left 780, centre y 778; landed scale 1.11 (≈33px, the real row text at S 1.15); owner lines land ≈24px (owner 1 y 703–733, owner 2 y 808–839). Headline rows: Schibsted 700 104px, text, x 96, row centres y 420 and 526; the eyebrow and two headline rows are exempt from the 2-line limit. The glow-field is static. Line-masked rise = each text line in an overflow:hidden box; fromTo yPercent 100→0, opacity 0→1 over the first 40%, power3.out 0.6 s; headline swaps are the waterfall cut per cut-catalog.md.

Scene 1 (0.00–0.98 s) [27.09–28.07]: Hard cut (the link press in Frame 7 motivates it): the floating panel is already on the right at Y0 = 480 — the Participation and Engagement charts (Participation subtitle patched) with the Summary heading below them; a static terracotta glow-field (10%) behind its upper right. On 0.25 [27.34] the eyebrow "AFTER THE CALL" (frame.md eyebrow, terracotta, x 96, y 300) rises and its 40×3 rule draws on beneath it 0.25–0.74 [27.34–27.83]. Nothing else moves. Layout: asymmetric 35/65 — type column left, product panel right, 3 depth layers.

Scene 2 (0.98–2.43 s) [28.07–29.52]: The shot's one traversal: an element scroll Y0 480 → 742 on power3.inOut, landing 2.43 [29.52]. As the Summary paragraph rides up, a terracotta-glow band (14%) sweeps each of its four lines on 1.22 [28.31], 1.46 [28.55], 1.71 [28.80], 1.95 [29.04] (world space, riding the scroll), fading out by 2.43 [29.52]. On 1.94 [29.03] (bar 15) "What was decided." rises in the left column as two rows — "What was" / "decided.".

Scene 3 (2.43–3.87 s) [29.52–30.96]: Landed and locked: Summary (y 246–457), Decisions (heading y 534; the line y 587–614), the Action items heading (y 690) over empty patches. On 2.43 [29.52] the decision's "1." (x 774–793, y 589–611) pops (scale 1.35→1, power3.out) and flashes terracotta-tint for 0.6 s, and a terracotta-glow band sweeps behind the decision line (x 813–1808) 2.43–2.81 [29.52–29.90], resting at 10%. Hold.

Scene 4 (3.87–5.34 s) [30.96–32.43]: SIGNATURE on the phrase change. The panel pushes in 3.87–4.31 [30.96–31.40] (phase B) about the Action items block, then locks: Decisions line now y 466–500, Action items heading ≈ y 595, the empty row slots below; whoosh-short. Ghost B appears at (980, 652) at blur 14px, opacity 0 and flies 3.88–4.37 [30.97–31.46] on expo.out to row 2 (780, 778) — blur 14→0, opacity 0→1, scale 1→1.11 — the reverse direction of its Frame 3 drift (its target is the pushed position). On landing 4.37 [31.46] a terracotta-soft glow band (30%→0 over 0.5 s) blooms behind the row with a pop, the rebuilt text hands over to the real screenshot text (patch removed within 0.1 s), the owner line "Bikash Phukan" types in under it 4.37–4.71 [31.46–31.80] (Inter 400 ≈24px, text-muted), then hands over to the real pixels; on the same 4.37 [31.46] the headline waterfall-cuts to "Who" / "owns it.". Ghost A flies 4.37–4.85 [31.46–31.94] from (1060, 156) to row 1 (780, 675) the same way; lands on 4.85 [31.94] with flash and pop; its real owner line "Unassigned · tonight" types 4.85–5.34 [31.94–32.43].

Scene 5 (5.34–7.74 s) [32.43–34.83]: Hold, camera locked. On 6.30 [33.39] the headline waterfall-cuts to "And" / "by when." and the word "tonight" in owner line 1 (x 957–1047, y 706–731) glows terracotta-tint while a 2px terracotta underline draws left→right beneath it (y 735, 0.3 s). Held still to the cut.

## Frame 9 — Every recording

- scene: The real Recordings library assembles card by card; an enlarged copy of its real filter types "design" and the library narrows to the design reviews, one Play press
- duration: 3.87s
- bars: 2 (bars 18–19)
- starts_at: 34.83
- transition_in: push-slide LEFT
- status: outline
- src: compositions/frames/09-every-recording.html
- type: feature_showcase
- beat: ease
- persuasion: Friction reduction — find any meeting in one query
- blueprint: prompt-type-submit-generate (Adapt)
- focal: assets/hero_img_5_dark.webp — the recordings grid under its real "Filter by meeting" field
- roles: hero_img_5_dark.webp = cutout (focal, feathered crop on canvas; its field also supplies the enlarged duplicate) · headline = focal type · terracotta glow-field = background (behind the lifted card only)
- asset_candidates: assets/hero_img_5_dark.webp — the real Recordings library with its "Filter by meeting" field (3024×1646)
- rules: discrete-text-sequence, press-release-spring
- sfx: typing, click-soft
- copy: Every recording. / One search away.
- music_cue: cut on bar 18 0.00 [34.83] with line 1; cards on 16ths 0.26 [35.09] → 0.86 [35.69]; line 2 + focus + typing on the bar-19 downbeat 1.94 [36.77]; the result on 2.43 [37.26] (0.96, the strongest hit so far); Play press on 3.38 [38.21] (0.63).

Every call lands in one library, and one search finds it. The query is "design" — it echoes the decision Ori highlighted in Frame 6 ("proceed to the design meeting"), and the matching cards' real Play buttons are inside the screenshot (the "Daily standup" card's are not). Adapt: sub-shape C, search skin — the surface establishes first (the cards assemble), then a short query types into the product's input and the machine answers with an instant result surface, confirmed by one press; camera locked throughout. Build notes: Timing: Scene windows and cues are frame-local seconds (t = video time − 34.83); [brackets] give absolute video seconds for the orchestrator's SFX only. cam(S,cx,cy): S = output px per source px of hero_img_5 (3024×1646); the source point (cx,cy) sits at output (960,540); source (x,y) → (960+(x−cx)·S, 540+(y−cy)·S); world = one wrapper transformed translate+uniform scale, overlays positioned in source px inside it. World hero_img_5 at cam(0.735, 1720, 737). A #0E1011 patch hides the real page title and subtitle (source 530–1300 × 140–270 → output x 85–651, y 101–197). Filter field: patch the real field (source 2352–2990 × 192–262 → output x 1425–1893, y 140–192) with page ground and lay an enlarged duplicate of those real pixels at 1.6× (output x 1144–1893, y 124–208, right edge pinned at x 1893 — above the grid/list toggle at y ≈229–273); its placeholder "Filter by meeting" is patched with the field's own fill before typing, and the typed text is live Inter 500 ≈37px, text. Card masks = clip rects on each card's own source rect: c1 544–1338 × 410–1136, c2 1370–2164 × 410–1136, c3 2198–2990 × 410–1136, r2c1 544–1338 × 1172–1616, r2c2 1370–2164 × 1172–1616, r2c3 2198–2990 × 1172–1616; before a reveal the slot shows page ground #0E1011. The row-2 poster titles ("Daily standup", "Instant meeting") are accepted bleed imagery in the keep-out band; they dim with the result. Line-masked rise = each text line in an overflow:hidden box; fromTo yPercent 100→0, opacity 0→1 over the first 40%, power3.out 0.6 s; the bar-19 swap is the waterfall cut per cut-catalog.md.

Scene 1 (0.00–0.26 s) [34.83–35.09]: Push-slide in from the right. The page header is present: the enlarged filter field with its placeholder, "10 RECORDINGS" (y 245–256), the grid/list toggle; the card slots are empty. "Every recording." rises top-left over the patched title zone: Schibsted 700 104px, text, x 96, row centre y 150 (≈797 wide). Layout: a header rail over a full-width grid.

Scene 2 (0.26–1.94 s) [35.09–36.77]: The six real cards reveal on 16th notes — 0.26 [35.09], 0.38 [35.21], 0.50 [35.33], 0.62 [35.45], 0.74 [35.57], 0.86 [35.69] — top-left to bottom-right, each opening bottom→top through its own clip with a 12px rise (0.45 s, power3.out): Women in AI USA online event · Weekly product design review · Daily Design Review (row 1, output y 300–833) · Daily standup · Instant meeting · Instant meeting (row 2 posters from y 860, imagery bleeding into the keep-out band). The full library holds to 1.94 [36.77].

Scene 3 (1.94–2.43 s) [36.77–37.26]: Bar 19: the headline waterfall-cuts to "One search away." (Schibsted 700 104px, x 96, ≈860 wide). The enlarged field focuses (border → hairline-strong plus a 1px terracotta-tint ring, 0.2 s), its placeholder clears and "design" types character by character 1.97–2.39 [36.80–37.22] with a caret; typing sfx.

Scene 4 (2.43–3.87 s) [37.26–38.70]: On 2.43 [37.26] the result: the four non-matching cards dim to 25% (a #0E1011 overlay at 75%, 0.3 s) — Women in AI USA online event, Daily standup, both Instant meetings; "Daily Design Review" stays lit; "Weekly product design review" lifts — a duplicate crop of its card (source 1370–2164 × 410–1136) layered on top scales 1.0→1.03 about its centre with a terracotta glow-field behind and a `shade` shadow. On 3.38 [38.21] its orange "Play recording" button (output x 731–932, y 752–808) presses: scale 0.94, then critically damped back to 1.0 with a soft terracotta glow; click-soft. Held to the cut.

## Frame 10 — Ori follows up

- scene: Ori's pink mark stays pinned beside a big clock; the clock flips 07:00 → 18:00 as the two digest cards, filled with the digest's real sections, stack in, and the channel word cycles email → Slack → WhatsApp
- duration: 3.87s
- bars: 2 (bars 20–21)
- starts_at: 38.70
- transition_in: cut
- status: outline
- src: compositions/frames/10-ori-follows-up.html
- type: benefit_highlight
- beat: peace of mind
- persuasion: Future pacing — tomorrow morning and this evening, handled
- blueprint: fixed-anchor-cycle (Adapt)
- focal: assets/ori-mark.svg pinned with the 242px clock — flip per .hyperframes/registry-reference/split-flap-board.html and card stack per .hyperframes/registry-reference/notification-stack.html (read for mechanics only)
- roles: ori-mark.svg = the anchor (focal, never moves) · clock digits = focal type · digest cards = supporting (rebuilt in frame.md card style with the digest email's real section labels) · ori-glow bloom = background
- asset_candidates: assets/ori-mark.svg — Ori's pink mark (the anchor and the card headers)
- rules: discrete-text-sequence
- sfx: notification, click-soft
- copy: Then Ori follows up. / By email. / In Slack. / On WhatsApp. / By email, Slack and WhatsApp.
- music_cue: cut on bar 20 0.00 [38.70] with line 1; card 1 on beat 2 0.50 [39.20]; channel words on 0.98 [39.68] and 1.47 [40.17]; clock flip + card 2 on the bar-21 downbeat 1.94 [40.64]; "On WhatsApp." on 2.43 [41.13] (0.97, the strongest hit); the full line on 2.92 [41.62]; hold.

After the call, Ori keeps going: a morning digest and an evening digest, delivered where the team already is. Adapt: sub-shape A (adjacent-region cycle) — the anchor is Ori's pink mark, which enters with the frame and never moves; what cycles is the clock (one flip) and the channel word (hard-cut chip swaps), resolving into the completed line as the lockup; no camera. Build notes: Timing: Scene windows and cues are frame-local seconds (t = video time − 38.70); [brackets] give absolute video seconds for the orchestrator's SFX only. Canvas frame, output px. The digest cards are rebuilt with real content only — titles, section labels and the to-do line format come from the repo's apps/leapcast-public-api/src/lib/email/ori-digest-email.ts: card #202124, 14px radius, 1px hairline, 384×232; header row [ori-mark 24px] "Ori" (Inter 600 22px, text) with the time right-aligned (Inter 500 22px, text-dim); title Inter 600 30px, text; section label (frame.md label style, text-dim); one content line Inter 500 22px, text-muted. Card 1: 07:00 · "What lies ahead" · section "Today" · "Weekly product design review". Card 2: 18:00 · "Your day" · section "Yours to do" · "Bikash Phukan: Send the filled form/information to Sandip" (wraps to two rows). No skeleton bars. The clock, the channel slot and the card text are exempt from the 2-line and 7-word limits. The ori-glow bloom is static. Line-masked rise = each text line in an overflow:hidden box; fromTo yPercent 100→0, opacity 0→1 over the first 40%, power3.out 0.6 s.

Scene 1 (0.00–0.50 s) [38.70–39.20]: Crossfade in. The anchor is on screen from the first frame and never moves: ori-mark.svg (pink, 170px tall, x 96–265, y 200–370) and beside it the clock "07:00" — Schibsted 800 242px, tabular-nums, −0.035em, text, left x 300, baseline y 372 (≈631 wide). A static ori-glow bloom (≤12%) behind the mark (centre 260, 290). Line 1 "Then Ori follows up." rises: Schibsted 700 104px, text, x 96, row centre y 520 (≈959 wide). Layout: anchor + copy stack on the left 70%, card stack on the right.

Scene 2 (0.50–1.94 s) [39.20–40.64]: Beat 2: digest card 1 (07:00, "What lies ahead", Today) slides into the top stack slot x 1440–1824, y 214–446 (from +60px, 0.5 s, power3.out); notification sfx. The channel slot under line 1 (Schibsted 600 90px, text-muted, x 96, row centre y 640) hard-cuts "By email." on 0.98 [39.68] and "In Slack." on 1.47 [40.17] (click-soft each).

Scene 3 (1.94–2.92 s) [40.64–41.62]: Bar 21: the clock split-flaps 07:00 → 18:00 (only "0→1" and "7→8" flap; ":00" holds; 0.35 s) while digest card 2 (18:00, "Your day", Yours to do) lands in the top slot y 214–446 and card 1 steps down to y 462–694 and dims to 70%; notification sfx. On 2.43 [41.13] the slot hard-cuts "On WhatsApp.".

Scene 4 (2.92–3.87 s) [41.62–42.57]: The slot resolves to the full line "By email, Slack and WhatsApp." (x 96–1370) — the lockup completes and everything holds; the mark has never moved. Words only, no Slack or WhatsApp logos.

## Frame 11 — See the pattern

- scene: The real Intelligence page: the orange engagement bars grow from the baseline, four signal cards populate on eighths, and an enlarged "5 need attention" is underlined
- duration: 3.87s
- bars: 2 (bars 22–23)
- starts_at: 42.57
- transition_in: push-slide LEFT
- status: outline
- src: compositions/frames/11-see-the-pattern.html
- type: feature_showcase
- beat: clarity
- persuasion: Show-don't-tell proof — the patterns across meetings, read off the real screen
- blueprint: grid-card-assemble (Adapt)
- focal: assets/hero_img_3_dark.webp — the Signals panel and the Trends charts
- roles: hero_img_3_dark.webp = cutout (focal, feathered crop on canvas) · rebuilt "5 need attention" label = supporting overlay · headline = focal type
- asset_candidates: assets/hero_img_3_dark.webp — the real Intelligence page: Signals + Trends (3024×1650)
- rules: stat-bars-and-fills, css-marker-patterns
- sfx: whoosh-short, ping
- copy: Spot the patterns. / And what needs attention.
- music_cue: cut on bar 22 0.00 [42.57] with line 1; bars grow from 0.26 [42.83]; signal cards on 8ths 1.23 [43.80] / 1.47 [44.04] / 1.71 [44.28] / 1.94 [44.51]; line 2 on the bar-23 downbeat 1.94 [44.51]; "5 need attention" underline on 2.44 [45.01] (0.96); held still from 2.74 [45.31].

Engagement insights and Intelligence signals, shown as the product shows them — patterns across meetings, not people being watched. Adapt: the live-populate variant — the board is the real page; its plots fill and its signal cards populate on the beat, then one status beat ("5 need attention") lands as the post-assembly live flip; camera locked (no tilt, no push). Build notes: Timing: Scene windows and cues are frame-local seconds (t = video time − 42.57); [brackets] give absolute video seconds for the orchestrator's SFX only. cam(S,cx,cy): S = output px per source px of hero_img_3 (3024×1650); the source point (cx,cy) sits at output (960,540); source (x,y) → (960+(x−cx)·S, 540+(y−cy)·S); world = one wrapper transformed translate+uniform scale, overlays positioned in source px inside it. World hero_img_3 at cam(0.75, 1767, 729), clipped to source y ≥ 350 (20-source-px feather) so the KPI strip never shows; the sidebar is off-frame left. Signal-card content patches (#17191A, source): A 578–1032, B 1066–1520, C 1555–2009, D 2045–2499, E 2533–2987, all × 470–660; card A (Engagement rate falling) stays patched for the whole frame so its figure never shows. "5 need attention": patch the real label (source 2785–2962 × 405–436, #17191A) and set a vector copy at 2× — Inter 600 32px, terracotta-tint, right-aligned at output x 1853, centred on the Signals title row (y 309), ≈256 wide. Plot clips: Engagement bars source 652–1654 × 905–1153 (output x 124–875, y 672–858); Unique attendance 1860–2900 × 905–1153 (x 1030–1810). Line-masked rise = each text line in an overflow:hidden box; fromTo yPercent 100→0, opacity 0→1 over the first 40%, power3.out 0.6 s; the bar-23 swap is the waterfall cut per cut-catalog.md.

Scene 1 (0.00–0.26 s) [42.57–42.83]: Push-slide in. The Signals panel (output x 43–1877, y 270–509) with its "Signals" title and the enlarged "5 need attention" label but empty card slots; the Trends panel below (from y 548) with titles, axes and gridlines but empty plots. Line 1 "Spot the patterns." rises top-left: Schibsted 700 104px, text, x 96, row centre y 160 (≈890 wide). Layout: a header rail over two stacked data panels; the product fills ≈80% of the canvas.

Scene 2 (0.26–1.23 s) [42.83–43.80]: The screenshot's own orange Engagement bars and dashed running average grow up from the baseline — a clip wipe bottom→top of the Engagement plot 0.26–1.13 [42.83–43.70] (power3.out) with the Unique attendance plot 0.12 s behind. No number counts.

Scene 3 (1.23–1.94 s) [43.80–44.51]: Signal cards B–D populate left→right on 8ths — 1.23 [43.80] Agenda timing variance, 1.47 [44.04] Uneven talk time, 1.71 [44.28] Late arrivals — each opening left→right through its mask (0.4 s, power3.out). Their figures stay as UI texture, never enlarged. Slot A stays empty.

Scene 4 (1.94–3.87 s) [44.51–46.44]: Bar 23: card E (Connection issues) opens the same way on 1.94 [44.51] while the headline waterfall-cuts to "And what needs attention." (x 96, ≈1265 wide). On 2.44 [45.01] the enlarged "5 need attention" label gets a 2px terracotta underline drawn left→right (x 1597–1853, y 330, 0.3 s) and one soft terracotta glow pass behind it; ping. The camera never moves; held still to the cut.

## Frame 12 — Nothing to install

- scene: Back in the same room, framed exactly as in Frame 1 but now capturing — a large row of the live capture pills sits on the card's top-right corner; two calm lines remove the last friction
- duration: 3.87s
- bars: 2 (bars 24–25)
- starts_at: 46.44
- transition_in: cut
- status: outline
- src: compositions/frames/12-nothing-to-install.html
- type: benefit_highlight
- beat: ease
- persuasion: Risk reversal — nothing to install, free to join
- blueprint: titlecard-reveal (Adapt)
- focal: assets/hero_img_1_dark.webp as the Frame 1 room card, with Frame 5's capture pills rebuilt as a 1.6× vector row on its top-right corner
- roles: hero_img_1_dark.webp = cutout (the room card) · meeting-avatars-recording.png = supporting (pixel reference for the vector pills + Notes icon crop) · headline row = focal type · terracotta glow-field = background
- asset_candidates: assets/hero_img_1_dark.webp — the room card in Frame 1's framing (3020×1646); assets/meeting-avatars-recording.png — pixel reference for the vector pills + Notes icon crop
- rules: none
- sfx: pop
- copy: Nothing to install. / Joining is always free.
- music_cue: cut on bar 24 0.00 [46.44] with line 1; pill row on beat 2 0.49 [46.93]; line 2 on the bar-25 downbeat 1.94 [48.38]; held still to 3.87 [50.31].

The bookend: the film returns to the room it opened on, same framing and same glow, but the room is now capturing — and the pills are big enough to see it. It makes the offer feel low-risk right before the price. Adapt: the Benefits two-line value title — one restrained move per line (the line-masked rise) and a still hold, set on the product card instead of a bare field. Build notes: Timing: Scene windows and cues are frame-local seconds (t = video time − 46.44); [brackets] give absolute video seconds for the orchestrator's SFX only. cam(S,cx,cy): S = output px per source px of hero_img_1 (3020×1646); the source point (cx,cy) sits at output (960,540); source (x,y) → (960+(x−cx)·S, 540+(y−cy)·S); world = one wrapper transformed translate+uniform scale, overlays positioned in source px inside it. hero_img_1 at cam(0.53, 1509, 626) (card x 160–1761, y 208–1081, 34-source-px radius, 1px hairline). A #0C0B0E patch (world, source 2210–2990 × 14–75) hides the card's own top-bar pills. Pill row = vector rebuilds pixel-matched to meeting-avatars-recording.png at 1.6× their 1× size (screen px): full-radius pills 75 tall, labels Inter 600 ≈34px; Notes · On 296 wide and ● Transcribing 296 wide, fill #202124, #F4F4F5 labels, #4FC560 dots (Notes = the notebook icon cropped from the PNG ≈1300–1335 × 30–70, "Notes", dot, "On"); ● Recording · 0:22 354 wide, fill #1F1414, 1px border #5C2D29, dot and label ≈#D25A4F, tabular-nums; gaps 37; the row right-aligned at x 1741, y 204–279 (x 721–1741, straddling the card's top bar, below line 2's descenders). Pill spring = scale 0.9→1 + opacity 0→1 about the row's right edge, 0.35 s power3.out, no overshoot. Line-masked rise = each text line in an overflow:hidden box; fromTo yPercent 100→0, opacity 0→1 over the first 40%, power3.out 0.6 s.

Scene 1 (0.00–1.94 s) [46.44–48.38]: Cut back to the room exactly as Frame 1 left it — the card at x 160–1761, y 208–1081, faces lit — and a static terracotta glow-field at (1500, 320), 8–10%, identical to Frame 1. On the cut, line 1 "Nothing to install." rises top-left: Schibsted 700 104px, text, x 160, baseline y 170 (≈839 wide). On 0.49 [46.93] the capture-pill row springs in on the card's top-right corner as one unit; pop. Camera locked; nothing else moves.

Scene 2 (1.94–3.87 s) [48.38–50.31]: Bar 25: the support line "Joining is always free." rises on the same baseline from x 1039 — Schibsted 600 72px, text-muted, with "free." in terracotta #D73D13 (≈718 wide, ends x 1757). Held still to the cut — the calm before the price.

## Frame 13 — End card

- scene: The terracotta leapcast wordmark wipes on along its italic slant, "beta" pops, then the promise, the URL and the price lock up and hold still
- duration: 5.81s
- bars: 3 (bars 26–28)
- starts_at: 50.31
- transition_in: cut
- status: outline
- src: compositions/frames/13-end-card.html
- type: cta
- beat: confidence → urgency to act
- persuasion: Risk reversal + clear offer — a real price anyone can check
- blueprint: logo-assemble-lockup (Adapt)
- focal: assets/leapcast-wordmark-nobg.svg inlined (the og-dark.png lockup) — lockup-and-still-hold scaffold per .hyperframes/registry-reference/logo-brand-close.html (read for mechanics only), with the slanted wipe below instead of its letter cascade
- roles: leapcast-wordmark-nobg.svg = focal mark · headline + URL row = focal type · price row = supporting type · og-dark.png = layout reference only (never rendered) · terracotta glow-field = background
- asset_candidates: assets/leapcast-wordmark-nobg.svg — the leapcast wordmark with "beta" (inlined, 9 paths); assets/og-dark.png — social-card lockup, layout reference only (never rendered)
- rules: spring-pop-entrance, stat-bars-and-fills
- sfx: impact-bass-2, chime
- copy: Meetings that keep working after the call / leapcast.ai / From $5/month · 240 AI minutes included
- music_cue: bar 26 0.00 [50.31] (0.85) wipe + impact; "beta" on 0.74 [51.05]; headline on the bar-27 downbeat 1.94 [52.25]; "leapcast.ai" on 2.44 [52.75] (0.90); price on 2.92 [53.23] (0.72); dead still from 3.16 [53.47]; music fades 3.87–5.81 [54.18–56.12].

The promise, the brand and a price anyone can check — with the URL as the biggest thing after the headline. Adapt: the Brand_Outro / CTA lockup — the mark comes to exist (a slanted wipe instead of a parts build), the badge pops onto the lockup, the tagline, URL and price follow, then a long dead-static hold; og-dark.png is the layout reference only, never shown. Build notes: Timing: Scene windows and cues are frame-local seconds (t = video time − 50.31); [brackets] give absolute video seconds for the orchestrator's SFX only. Canvas frame. Wordmark = the SVG inlined (9 paths: 1–8 "leapcast", 9 "beta"), every fill #C96442 (frame.md wordmark-lockup), rendered 760px wide (4.343 px per viewBox unit) with its box at x 128, y 119: letters y 150–314; "beta" x 714–862, y 242–294. The italic lean is ≈9.6° (horizontal offset = 0.168 × height). The wipe is a clip-path polygon reveal (the stat-bars-and-fills fill mechanic, clip-path variant) whose leading edge is slanted to the italic — the top edge leads the bottom by 28px — sweeping left→right across the letters' box. The URL and price rows are exempt from the 2-line limit. The glow-field is static once bloomed. Line-masked rise = each text line in an overflow:hidden box; fromTo yPercent 100→0, opacity 0→1 over the first 40%, power3.out 0.6 s. This is the final frame: it holds to the last frame with no exit.

Scene 1 (0.00–1.94 s) [50.31–52.25]: Bar 26, impact-bass-2: the letters wipe on left→right through the slanted clip 0.00–0.74 [50.31–51.05] on expo.out. On 0.74 [51.05] "beta" pops onto the lockup (scale 0.85→1 + opacity, 0.35 s, power3.out, no overshoot). A terracotta glow-field (10–12%) blooms behind the wordmark (centre 480, 240) 0.00–0.99 [50.31–51.30], then holds static. Layout like og-dark.png: lockup top-left.

Scene 2 (1.94–3.16 s) [52.25–53.47]: Bar 27, chime: the headline rises line-masked in two rows — "Meetings that keep working" / "after the call" — Schibsted 600 90px (statement), text, x 128, baselines y 500 and 596 (row 1 ≈1140 wide), row 2 0.08 s after row 1. On 2.44 [52.75] "leapcast.ai" rises (12px rise + opacity, 0.5 s power3.out): Schibsted 600 64px, text, x 128, baseline y 700. On 2.92 [53.23] the price row rises the same way: "From $5/month · 240 AI minutes included" — Inter 500 34px, tabular-nums, text-muted, separators text-dim, x 128, baseline y 760.

Scene 3 (3.16–5.81 s) [53.47–56.12]: Everything is set and completely still — no drift, no breathing, no glow pulse — while the music fades out 3.87–5.81 [54.18–56.12]. Final frame: it holds to the last frame with no exit.
