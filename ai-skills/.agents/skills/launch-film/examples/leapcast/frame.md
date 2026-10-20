---
version: 1
name: "Leapcast Dark — Frame"
description: >
  Bespoke frame-scale design system for the Leapcast launch film (1920×1080, 30 fps, music-driven,
  no VO, no captions). The unit is the frame. Atoms are the real product's: a warm near-black
  ground (#0C0B0E), the app's graphite surfaces (#17191A / #202124 / #262624) lifted by 1px
  hairlines, terracotta as the ONLY accent (#D73D13 punch, #C96442 UI, #D97F60 tint), Ori pink
  (#FC097F) reserved for Ori alone, success green / record red only as live-state signals.
  Schibsted Grotesk 700–800 tight-tracked display over Inter UI/body. Real screenshots sit in an
  18px hairline frame over a soft terracotta bloom. Motion is calm and decisive: long-tail
  power3/expo eases, no bounce, cuts on bar downbeats.
unit: the frame — 1920×1080 (16:9) only; authored in cqw/cqh against a `container-type:size` ground
principle: atoms are sacred · composition is free · every claim comes from brand-facts.md · the real product is the hero

colors:
  # — grounds & surfaces (from the app: meeting room ground + graphite UI steps) —
  canvas: "#0C0B0E"            # the near-black ground; identical to bg
  bg: "#0C0B0E"                # alias of canvas (tools read either key)
  surface: "#17191A"           # app shell / side panels
  card: "#202124"              # video tiles, cards, Ori panel body
  raised: "#262624"            # chips, bubbles, control-bar buttons, hover
  hairline: "rgba(244,244,245,0.10)"         # the 1px border on every surface
  hairline-strong: "rgba(244,244,245,0.16)"  # checkbox strokes, screenshot frame edge on bright shots
  highlight: "rgba(244,244,245,0.06)"        # 1px inner top highlight on raised surfaces
  shade: "rgba(6,5,8,0.55)"                  # shadow / scrim color (tinted, never #000)
  # — text ladder (warm off-whites; never #FFF) —
  text: "#F4F4F5"
  text-muted: "#C3C0B6"
  text-dim: "rgba(244,244,245,0.55)"
  # — the one accent: terracotta —
  terracotta: "#D73D13"        # punches: eyebrow, rule, CTA, focal word, stat accent
  terracotta-soft: "#C96442"   # product UI: wordmark, UI buttons, avatars, checked boxes
  terracotta-tint: "#D97F60"   # small terracotta text, chart tint, secondary glow core
  terracotta-glow: "rgba(215,61,19,0.14)"    # radial bloom behind heroes
  # — Ori (only for Ori) —
  ori-pink: "#FC097F"
  ori-glow: "rgba(252,9,127,0.14)"
  ori-tint: "rgba(252,9,127,0.10)"           # ori-chip fill
  # — live-state signals (only as signals) —
  success: "#3FA65A"           # transcribing dot, recording available, "Open recording"
  record-red: "#E5484D"        # REC dot / recording timer only

radii:
  screenshot: "18px"
  card-lg: "16px"
  card: "12px"
  tile: "14px"                 # video tile (matches hero_img_1)
  control-bar: "20px"          # the product's control bar is a softly-rounded bar, not a full capsule
  chip: "8px"
  checkbox: "5px"
  rule: "2px"
  pill: "9999px"
  circle: "50%"

typography:
  # — display ramp: Schibsted Grotesk (tight, heavy, sentence case) —
  display:   { fontFamily: "Schibsted Grotesk", cqw: 9.4, px: 180, weight: 800, lineHeight: 0.94, tracking: "-0.04em", color: "text", note: "1–3 word slams only (e.g. 'Meet.')" }
  h1:        { fontFamily: "Schibsted Grotesk", cqw: 7.0, px: 134, weight: 800, lineHeight: 0.98, tracking: "-0.03em", color: "text" }
  h2:        { fontFamily: "Schibsted Grotesk", cqw: 5.4, px: 104, weight: 700, lineHeight: 1.0, tracking: "-0.028em", color: "text" }
  statement: { fontFamily: "Schibsted Grotesk", cqw: 4.7, px: 90, weight: 600, lineHeight: 1.06, tracking: "-0.022em", color: "text", note: "one full sentence; second clause may drop to text-muted" }
  stat-num:  { fontFamily: "Schibsted Grotesk", cqw: 8.4, px: 161, weight: 800, lineHeight: 0.9, tracking: "-0.035em", numeric: "tabular-nums", color: "text", note: "unit/currency sign at 0.5× size, weight 700, text-muted" }
  # — reading + chrome ramp: Inter —
  eyebrow:   { fontFamily: "Inter", cqw: 1.35, px: 26, weight: 600, lineHeight: 1.0, tracking: "0.12em", upper: true, color: "terracotta" }
  body:      { fontFamily: "Inter", cqw: 1.75, px: 34, weight: 400, opticalWeight: 380, lineHeight: 1.42, tracking: "0", color: "text-muted" }
  label:     { fontFamily: "Inter", cqw: 1.3, px: 25, weight: 500, lineHeight: 1.2, tracking: "0.01em", color: "text-muted" }
  mono:      { fontFamily: "Inter", cqw: 1.45, px: 28, weight: 500, lineHeight: 1.0, tracking: "0.02em", numeric: "tabular-nums", features: "'tnum' 1, 'zero' 1", color: "text", note: "URL + pricing chrome; no mono face ships — Inter tabular stands in" }
  ui-text:   { fontFamily: "Inter", cqw: 1.35, px: 26, weight: 500, lineHeight: 1.3, tracking: "-0.005em", color: "text", note: "rebuilt UI bits; when laid over a screenshot, match the screenshot's own text size at its current zoom instead" }
  ori-text:  { fontFamily: "Inter", cqw: 1.5, px: 29, weight: 400, lineHeight: 1.4, color: "text", note: "Ori's typed answer inside ori-bubble" }

spacing:
  pad-x: "5cqw"                 # 96px left/right safe edge for copy
  pad-top: "4.2cqw"             # 80px
  keep-out-top: "83cqh"         # y = 896px — no load-bearing copy/UI below this line
  hero-anchor-y: "42cqh"        # y ≈ 454px — optical center for a centered hero
  gap-xs: "0.6cqw"              # 12px
  gap-sm: "1.25cqw"             # 24px
  gap-md: "2.1cqw"              # 40px
  gap-lg: "4.2cqw"              # 80px
  measure: "72cqw"              # max width of any headline block
  eyebrow-rule: "40px × 3px"
  hairline: "1px"

components:
  ground:
    backgroundColor: "{colors.canvas}"
    border: "none"
    rounded: "0"
    typography: "n/a"
    description: "Full-bleed #0C0B0E on every frame, with `container-type:size`. Never a linear gradient (bands under H.264). Depth comes only from glow-field, screenshots and hairline surfaces. Optional 3–4% film grain allowed; no vignette darker than {colors.shade}."
  glow-field:
    backgroundColor: "radial-gradient(ellipse 60% 55% at <focal x/y>, {colors.terracotta-glow} 0%, rgba(215,61,19,0.06) 45%, transparent 72%)"
    border: "none"
    rounded: "0"
    typography: "n/a"
    description: "A soft terracotta bloom at 8–14% peak alpha, placed behind the hero (headline, screenshot or wordmark), never centered by habit. Breathes ±6% scale / ±2% alpha over 4 bars (7.74 s). On Ori frames swap to {colors.ori-glow} — never both hues in one bloom."
  screenshot-frame:
    backgroundColor: "{colors.card} (letterbox fill, rarely visible)"
    border: "1px solid {colors.hairline} + inset 0 1px 0 {colors.highlight} (top edge highlight)"
    rounded: "{radii.screenshot}"
    shadow: "0 40px 60px -20px {colors.shade}, 0 0 0 1px rgba(6,5,8,0.4) — optional; drop it when the shot is full-bleed"
    typography: "n/a"
    description: "How a real product screenshot sits: `<img>` with object-fit:cover inside an overflow:hidden 18px-rounded box, uniform scale only, on a glow-field. As a background layer: full-bleed, no radius, dimmed 30–50% (brightness .55–.7 plus a {colors.canvas} scrim at 30–45%)."
  ui-card:
    backgroundColor: "{colors.card}"
    border: "1px solid {colors.hairline}"
    rounded: "{radii.card-lg} (large) / {radii.card} (small)"
    shadow: "inset 0 1px 0 {colors.highlight}"
    typography: "{typography.ui-text} title + {typography.label} meta"
    description: "The app's card: graphite fill, 1px hairline, 12–16px radius, padding 28–40px. Used for rebuilt single elements (a summary card, a decision) that must match the screenshots exactly."
  name-pill:
    backgroundColor: "rgba(12,11,14,0.72)"
    border: "none"
    rounded: "{radii.chip}"
    typography: "Inter 500, 0.95cqw (18px) in-shot / 1.2cqw (23px) when rebuilt at hero scale, {colors.text}"
    description: "The video-tile name tag, bottom-left of a tile with a 14px inset, 6×12px padding; optional muted-mic glyph in {colors.record-red} at 70% before the name. A terracotta 8px dot marks the active speaker (as in hub-center)."
  control-bar:
    backgroundColor: "{colors.surface}"
    border: "1px solid {colors.hairline}"
    rounded: "{radii.control-bar}"
    typography: "icon-only; buttons {colors.raised} 12px-radius squares 56–64px, 12px gaps"
    description: "The dark meeting control bar, bottom-center of the room. Active state = {colors.terracotta-soft} fill; record = {colors.record-red} fill; the separate End button = {colors.record-red}. Shown from the screenshot; rebuild only a single button that must animate (e.g. record pressing)."
  ori-chip:
    backgroundColor: "{colors.ori-tint}"
    border: "1px solid rgba(252,9,127,0.28)"
    rounded: "{radii.pill}"
    typography: "Inter 600, 1.35cqw (26px), {colors.text}"
    description: "Ori's identity tag: the real `capture/assets/brand/ori-mark.svg` (pink hourglass, 1.1em tall) + the word 'Ori', padding 10×20px. The only place pink fills a shape. Marks Ori's panel, bubble or answer; never decorates non-Ori content."
  ori-bubble:
    backgroundColor: "{colors.card}"
    border: "1px solid {colors.hairline}"
    rounded: "{radii.card-lg}"
    shadow: "0 30px 50px -20px {colors.shade}; an {colors.ori-glow} radial bloom sits behind it"
    typography: "{typography.ori-text}; header row = ori-chip; section heads in {typography.label} uppercase 0.1em {colors.text-dim}"
    description: "Ori's answer surface, modelled on hub-center's panel. Text types on (≈40 chars/s) with a 2px {colors.ori-pink} caret; a 'Thinking…' line in {colors.text-dim} may precede it. Width 30–40cqw. No left-edge accent stripe."
  action-row:
    backgroundColor: "transparent (inside ori-bubble or ui-card)"
    border: "checkbox 22–26px, 1.5px solid {colors.hairline-strong}, {radii.checkbox}"
    rounded: "{radii.checkbox}"
    typography: "{typography.ui-text} task in {colors.text} + ' — @owner' / owner line in {colors.text-muted}"
    description: "Checkbox + task + owner, 18px gap, rows 14–18px apart. Checking = box fills {colors.terracotta-soft} with a {colors.text} check drawn on (stroke-dashoffset), task stays full-opacity (not struck through). Check on a beat."
  stat:
    backgroundColor: "transparent"
    border: "optional 1px {colors.hairline} vertical divider between stats (as in hero_img_4)"
    rounded: "0"
    typography: "{typography.stat-num} + {typography.label} beneath, 12px gap"
    description: "Number + label. Only numbers in brand-facts.md ($5/month, 240 AI minutes, $0.05/min, up to 25 participants, $60/year, 07:00, 18:00). The number may be {colors.terracotta} when it is the frame's single punch; otherwise {colors.text}. Counts up with tabular-nums."
  eyebrow-rule:
    backgroundColor: "{colors.terracotta}"
    border: "none"
    rounded: "{radii.rule}"
    typography: "{typography.eyebrow} above, rule 40×3px sitting 16px below the eyebrow's baseline"
    description: "The section marker: uppercase terracotta eyebrow + a 40×3 terracotta rule that draws on scaleX 0→1 from the left. One per frame, at most."
  cta-button:
    backgroundColor: "{colors.terracotta}"
    border: "none"
    rounded: "{radii.pill}"
    shadow: "0 18px 40px -12px rgba(215,61,19,0.45)"
    typography: "Inter 600, 1.55cqw (30px), {colors.text} (warm white, never #FFF), padding 22×44px"
    description: "The one solid terracotta element — end card only. Label is the URL 'leapcast.ai' or a brand-facts line."
  wordmark-lockup:
    backgroundColor: "none"
    border: "none"
    rounded: "0"
    typography: "'beta' = Schibsted Grotesk 600, 0.34× wordmark cap-height, {colors.terracotta-soft}, baseline-aligned to the wordmark's foot, 0.12em gap"
    description: "The real `capture/assets/brand/leapcast-wordmark-nobg.svg` INLINED with every path fill set to {colors.terracotta-soft} (#C96442) — the source file ships cream #FBF9F6 fills; the terracotta recolor matches og-dark.png and the app. Never redraw, stretch, skew or re-typeset the italic blocky letters. Height 7–10cqw on the end card, 3–4cqw as a signature. `logo_white.png` only if a monochrome mark is ever needed."
  hairline-rule:
    backgroundColor: "{colors.hairline}"
    border: "none"
    rounded: "0"
    typography: "n/a"
    description: "1px rule (1.5px at full-bleed widths so it survives compression) separating zones; draws on scaleX from its anchor edge. Terracotta version only as the eyebrow-rule."
  url-chip:
    backgroundColor: "{colors.raised}"
    border: "1px solid {colors.hairline}"
    rounded: "{radii.chip} (kbd) / {radii.pill} (url)"
    typography: "{typography.mono}"
    description: "The URL 'leapcast.ai' and pricing chrome ('From $5/month · 240 AI minutes included'), padding 12×24px; the separator ' · ' in {colors.text-dim}. kbd variant: square-ish 8px-radius keycap with a 2px bottom inset shade, for a single key only."

fonts:
  - family: "Inter"
    file: "assets/fonts/InterVariable.woff2"
    weight: "100 900"
    style: normal
    format: woff2 (variable)
    role: "body, labels, eyebrows, UI, URL/pricing chrome (tabular-nums)"
  - family: "Inter"
    file: "assets/fonts/InterVariable-Italic.woff2"
    weight: "100 900"
    style: italic
    format: woff2 (variable)
    role: "reserved; not used in the default ramp"
  - family: "Schibsted Grotesk"
    file: "assets/fonts/SchibstedGrotesk-latin.woff2"
    weight: "400 900"
    style: normal
    format: woff2 (variable, latin subset)
    role: "all display: display, h1, h2, statement, stat-num, 'beta' tag"
---

# Leapcast Dark — Frame

## Overview

Leapcast Dark is the product's own dark room turned into a film. The real app lives on a warm
near-black ground with graphite panels, 1px hairlines and one terracotta accent; this system keeps
those atoms exactly and scales them to the frame. The register is the premium X launch film
(Linear / Raycast / Arc): big tight headlines on near-black, the real product shown large and
moving, a single warm light source, and a calm, decisive rhythm locked to a 124 BPM deep-house bed.

Three voices, in fixed roles:

- **Schibsted Grotesk 700–800**, tight (−0.03em), sentence case, is the voice of every claim and
  every number. Heavy, close-set, slightly condensed-feeling — it reads as confident, not loud.
- **Inter** is the product's voice: body, labels, eyebrows, and every rebuilt UI element, so
  overlays sit invisibly on the real screenshots (which are set in Inter).
- **The real screenshots** are the third voice and the hero. Type introduces; the product proves.

**Key characteristics at frame scale:**

- Warm near-black `{colors.canvas}` ground on every frame; graphite surfaces step up
  `surface → card → raised`, each edged by a 1px `{colors.hairline}`.
- **Terracotta is the only accent.** `#D73D13` for punches, `#C96442` for product UI and the
  wordmark, `#D97F60` for small tinted text. Ori pink appears only where Ori is.
- A **terracotta bloom** (`glow-field`) is the single light source; screenshots float on it in an
  18px hairline frame.
- One headline, one screenshot focal, one accent per frame. Silence is a feature.

## The Frame

### Frame Craft Bar

- **Squint** — one element dominates: a Schibsted headline, a hero screenshot, or the wordmark —
  at 3–6× the next element.
- **One light** — exactly one glow-field per frame (terracotta, or pink on an Ori frame).
- **One accent** — one terracotta punch per frame (a word, a rule, a stat, or the CTA), plus the
  terracotta that is already inside the real screenshot.
- **Reference** — aim at a Linear/Raycast launch film; failure looks like a SaaS explainer slide
  (centered title + bullet cards + purple gradient).

### Geometry

- **Canvas:** 1920×1080, 16:9, 30 fps. Author display in `cqw` (`px ÷ 1920 × 100`), vertical
  positions in `cqh`. Every frame ground sets `container-type: size`; never use `vw`.
- **Copy safe edge:** `pad-x` 5cqw (96px) left/right; `pad-top` 4.2cqw (80px).
- **Keep-out (load-bearing):** plan all copy, stats, chips and focal UI into the **top 83%**
  (y ≤ 896px, `83cqh`). The bottom 17% stays clear of anything the viewer must read — it keeps
  the bottom edge consistent frame to frame and clear of the X player's scrubber. Backgrounds,
  glow and full-bleed screenshot bleed are exempt and may run to the edge.
- **Centered hero anchor:** a centered headline or wordmark sits on `hero-anchor-y` ≈ 42cqh
  (y ≈ 454px), not the geometric center.
- **Measure:** no headline block wider than 72cqw.
- Radii stay px (18 / 16 / 14 / 12 / 8); hairlines stay 1px (1.5px at full width).

## Composition Rules

- **Anchor to edges, not the middle.** Headline left at `pad-x` with the screenshot pushing in from
  the right, or screenshot full-bleed with a headline pinned top-left. Center only the hook slam and
  the end card.
- **Layer every produced frame:** ground → glow-field → screenshot (or dimmed background shot) →
  rebuilt moving element (ori-bubble, action-row, stat) → type → one foreground accent
  (eyebrow-rule, url-chip, hairline). Six roles is typical; the hook and end card may run on three.
- **The product is the hero.** A screenshot, when present, is 55–100% of the frame width. Type
  never covers a face, a name pill, or the part of the UI the frame is about.
- **One idea per frame, one line per beat.** A headline is ≤ 8 words. A frame holds at most one
  headline + one support line + one eyebrow.
- **Rebuild only the moving part.** Show the real screenshot; overlay a single rebuilt element
  (Ori typing an answer, an action item checking itself, a stat counting up, a record button
  pressing) at the measured position and matched scale.
- **Cuts and hits live on the grid.** Frame boundaries on bar downbeats (n × 1.935 s); the main
  entrance of each frame lands on beat 1; secondary elements on beats 2–4 or on 8th-notes
  (0.242 s). The first big product reveal lands on the bar-8 downbeat (15.48 s).
- **Copy comes from brand-facts.md only.** frame.md is style; the words and numbers come from the
  storyboard, which quotes brand-facts. Screenshot demo data (e.g. "14 meetings this week") is
  texture, never restated as a claim in type.

## Color

| Role | Token | Use |
| --- | --- | --- |
| Ground | `canvas` / `bg` #0C0B0E | every frame, full-bleed |
| Surfaces | `surface` #17191A · `card` #202124 · `raised` #262624 | panels, tiles, bubbles, chips |
| Edges | `hairline` 10% · `hairline-strong` 16% · `highlight` 6% | all borders; top-edge highlight |
| Text | `text` #F4F4F5 · `text-muted` #C3C0B6 · `text-dim` 55% | headlines · body/labels · tertiary only |
| Accent | `terracotta` #D73D13 · `terracotta-soft` #C96442 · `terracotta-tint` #D97F60 | punch · product UI/wordmark · small tinted text |
| Light | `terracotta-glow` 14% · `ori-glow` 14% | the one bloom per frame |
| Ori | `ori-pink` #FC097F · `ori-tint` 10% | Ori mark, ori-chip, typing caret — nothing else |
| Signals | `success` #3FA65A · `record-red` #E5484D | live / transcribing / recording available · REC |

- **Terracotta is the ONLY accent.** Headlines are `text`; one word of a headline may turn
  `terracotta` as the frame's punch. Never set body copy in terracotta.
- **Ori pink ONLY for Ori** — the hourglass mark, the ori-chip, the caret in Ori's answer, and an
  Ori frame's bloom. Never pink on a headline that isn't about Ori; never pink and terracotta
  blooms together.
- **Green only for live signals** — the "● Transcribing" dot, "recording available", a live dot.
  **Red only for REC** and the product's own End button. Neither is ever decorative.
- **Never a purple/blue "AI" gradient**, never gradient text, never neon, never cyan. AI is
  expressed by Ori's pink mark and by the product working, not by a color wash.
- **No pure #000 or #FFF anywhere** — shadows use `shade` (tinted), text uses `#F4F4F5`.
- **Contrast:** `terracotta` on `canvas` is ≈4.2:1 — use it for text only at ≥ 24px / weight
  ≥ 600 (eyebrow, headline word). Below that, use `terracotta-tint` (≈6.7:1). `text-dim` is for
  non-essential tertiary text ≥ 24px only.
- **Accent presence:** terracotta must be visible, not a whisper — glow peaks at 8–14%, focal
  terracotta at full saturation.

## Type

- **Ramp by role** (frontmatter is normative): `display` 9.4cqw (1–3 word slams) → `h1` 7.0cqw →
  `h2` 5.4cqw → `statement` 4.7cqw (one sentence) → `stat-num` 8.4cqw; Inter `body` 1.75cqw,
  `ui-text`/`eyebrow` 1.35cqw, `label` 1.3cqw, `mono` 1.45cqw.
- **Fit to length:** ≤ 3 words → `display`; 4–6 → `h1`; 7–8 → `h2`; a full sentence →
  `statement`. Step down rather than exceed the 72cqw measure; break lines by sense, never
  leave a one-word widow.
- **In-feed floor:** headlines ≥ 90px, body ≥ 32px, labels ≥ 24px. Nothing load-bearing below
  1.25cqw (24px). Rebuilt UI laid over a screenshot matches the screenshot's own type size
  instead of the floor.
- **Sentence case** for all display (the product and site do this). Only the eyebrow is uppercase.
  Periods are allowed and encouraged on short declaratives ("Meet. Understand. Act.").
- **Display tracking** −0.028 to −0.04em (video compresses letter detail); Inter body at 0; eyebrow
  +0.12em. Headlines `text-wrap: balance`.
- **Numbers** always `font-variant-numeric: tabular-nums` (stat-num, mono, counters). Currency
  and unit signs at 0.5× size, weight 700, `text-muted`.
- **Optical compensation on dark:** light-on-dark reads heavier and tighter. Set Inter body at
  variable weight 380 (not 400) and add +0.05 line-height versus a light-ground value; display
  sizes are already tight — do not go tighter than −0.04em; add +0.01em on any display line set
  in `text-muted`.
- **Two sans, deliberately.** Schibsted Grotesk + Inter is the brand's real pairing (site and
  app), so it is kept. The separation is carried by weight (800 vs 400), size (≥ 3×) and role
  (claims vs product) — never set a headline in Inter or a label in Schibsted.

## Screenshot Treatment

Source shots are ~3020×1650 (retina 2×, aspect ≈1.83:1 — slightly wider than 16:9).

- **Uniform scale only.** `object-fit: cover` + `object-position`, or a wrapper transform with a
  single `scale`. Never set independent width/height; never stretch, skew or perspective-warp.
- **Sharpness budget:** keep ≥ 1 source px per output px. The tightest crop is therefore a
  ~1920×1080 source-px window (≈64% of the shot's width); a push-in may end at up to 1.15× past
  that for a beat. `hub-center.png` is only 1190×640: display it at ≤ 1.3× (≈1550px wide) and
  rebuild its Ori panel text live if it must be read large.
- **Never show browser chrome.** No tab bars, traffic lights or address bars. `hub-center.png`
  carries a faux window bar (top ~44px, dots + "Q4 Planning · leapcast.ai/q4-planning") — crop
  it out. The app shots have no chrome.
- **Framed (default):** 18px radius, 1px `hairline` border, 1px inner top `highlight`, optional
  `0 40px 60px -20px shade`, sitting on a glow-field whose core is offset toward the shot's
  upper-left or upper-right, never dead-center.
- **Background (dimmed):** full-bleed, no radius, 30–50% dimmed (brightness .55–.7 + a canvas scrim
  at 30–45%), optionally blurred ≤ 6px when type sits on it. Type over a dimmed shot still needs
  ≥ 4.5:1 locally — add a soft canvas radial behind the text block if it doesn't.
- **Crop recipes (source-px windows):**
  - `hero_img_1_dark.webp` (live room): tile grid x 20–2240, y 120–1440; control bar x 690–2320,
    y 1490–1620; side panel with the Ori tab x 2250–2990, y 130–1440 (Ori tab ≈ 2560–2700, 150–195).
  - `hero_img_4_dark.webp` (session): Session analytics column x 1500–2820, y 150–1650; stats row
    y 340–470; Summary y 890–1150; Decisions y 1200–1320; Action items y 1380–1650; sessions list
    x 620–1480.
  - `hub-center.png` (Ori in a meeting): tiles x 0–915, y 44–640; Ori panel x 930–1190, y 0–640.
- **Faces and names are real product imagery** — never cover a face with type or a chip; never
  crop a face in half at the frame edge unless the move is carrying it off.
- **Rebuilt overlays** (ori-bubble, action-row, a caption line) are positioned in the shot's
  coordinate space inside the same scaled wrapper, so they track every push-in exactly.

## Motion Character

Calm, decisive, expensive. Every move has a destination and arrives there with a long, soft tail.

- **Eases:** entrances `power3.out` or `expo.out`; camera and parallax `power2.inOut` /
  `sine.inOut`; exits `power2.in`. **No bounce, no elastic, no back/overshoot, no wiggle.**
- **Durations:** entrances 0.5–0.9 s; exits 0.35–0.5 s (faster than entrances); line-to-line
  stagger one 8th-note (0.242 s); word stagger 0.06–0.08 s.
- **Type reveals:** line-masked rise (y 100% → 0 inside an overflow:hidden line box) with opacity
  0 → 1 over the first 40%; a headline's punch word may resolve to terracotta one beat later.
  Never typewriter headlines; typing is reserved for Ori.
- **Camera:** slow. Push-ins 1.00 → 1.06–1.10 over a full 2–4 bars; parallax between shot and type
  at a 1 : 0.6 ratio; one move per shot, no reversal. Masked reveals (clip-path inset) open over
  0.7–0.9 s.
- **Rebuilt elements:** Ori types ≈ 40 chars/s with a pink caret; a checkbox fills in 0.25 s on a
  beat; stats count up over 0.8–1.2 s `power2.out` and land on a downbeat.
- **Ambient:** glow-field breathes over 4 bars; nothing loops faster than one bar.
- **Transitions:** hard cuts on downbeats are the default; a masked wipe or a shot-to-shot
  push is allowed where a frame hands the same screenshot across the cut. No spins, flips, zoom
  blurs or glitch.
- **A held read beats bad motion.** After an element settles, hold it ≥ 1 beat (0.484 s) before
  anything else moves; a headline stays readable for ≥ 1.5 × its reading time. Motion runs across
  the whole frame duration (slow camera drift), never front-loaded then frozen.

## Do

- Start every frame on `#0C0B0E` with one terracotta (or, for Ori, pink) bloom behind the focal.
- Show real screenshots big — framed in 18px hairline, or full-bleed and dimmed behind type.
- Set claims in Schibsted Grotesk 700–800 at −0.03em, sentence case, `#F4F4F5`; make one word
  terracotta when the line needs a punch.
- Use Inter for everything that touches the product (labels, chips, Ori's answer, action rows).
- Use the real marks: the inlined wordmark SVG recolored to `#C96442` + "beta"; `ori-mark.svg`
  whenever Ori is named or shown.
- Land cuts on bar downbeats and main entrances on beat 1; hold every settled read ≥ 1 beat.
- Keep every readable element above y = 896px.

## Don't

- No second accent: no blue, purple, teal or neon; no "AI" gradient; no gradient text.
- No pink outside Ori; no green outside live/recording-available signals; no red outside REC/End.
- No pure `#000` / `#FFF`; no full-screen linear gradients; no heavy black drop shadows.
- No browser chrome, cursors, stretched or perspective-warped screenshots, or upscaling past the
  sharpness budget.
- No fake UI where the real screenshot exists; no invented features, stats, logos or testimonials.
- No left-edge accent stripes on cards, no identical card grids, no bullet-list slides.
- No bounce, elastic, overshoot, spin or glitch; no typewriter headlines; no screensaver drift.
- Don't set headlines in Inter or labels in Schibsted; don't go below the in-feed type floor.

## Font Loading

Fonts ship as local files — do NOT link Google Fonts. Paths are project-root relative and must be
used exactly as written (never `../`). Paste this into every frame's `<head>` / `<template>`:

```html
<style>
  @font-face {
    font-family: "Inter";
    src: url("assets/fonts/InterVariable.woff2") format("woff2");
    font-weight: 100 900;
    font-style: normal;
    font-display: block;
  }
  @font-face {
    font-family: "Inter";
    src: url("assets/fonts/InterVariable-Italic.woff2") format("woff2");
    font-weight: 100 900;
    font-style: italic;
    font-display: block;
  }
  @font-face {
    font-family: "Schibsted Grotesk";
    src: url("assets/fonts/SchibstedGrotesk-latin.woff2") format("woff2");
    font-weight: 400 900;
    font-style: normal;
    font-display: block;
  }
</style>
```

Stacks: display `"Schibsted Grotesk", "Inter", sans-serif`; body/UI `"Inter", sans-serif`.

## CSS Tokens (ready to paste)

```css
:root {
  --canvas: #0C0B0E; --bg: #0C0B0E;
  --surface: #17191A; --card: #202124; --raised: #262624;
  --hairline: rgba(244,244,245,0.10); --hairline-strong: rgba(244,244,245,0.16);
  --highlight: rgba(244,244,245,0.06); --shade: rgba(6,5,8,0.55);
  --text: #F4F4F5; --text-muted: #C3C0B6; --text-dim: rgba(244,244,245,0.55);
  --terracotta: #D73D13; --terracotta-soft: #C96442; --terracotta-tint: #D97F60;
  --terracotta-glow: rgba(215,61,19,0.14);
  --ori-pink: #FC097F; --ori-glow: rgba(252,9,127,0.14); --ori-tint: rgba(252,9,127,0.10);
  --success: #3FA65A; --record-red: #E5484D;
  --font-display: "Schibsted Grotesk", "Inter", sans-serif;
  --font-ui: "Inter", sans-serif;
}
```

## Approved Real Entities

- Marks: `capture/assets/brand/leapcast-wordmark-nobg.svg` (inline + recolor), `logo_basic.png`,
  `logo_white.png`, `leapcast-mark.svg` / `leapcast-mark-1024.png` (bolt icon),
  `ori-mark.svg`, `ori-logo-full.svg`, the dashboard stroke icons.
- Screens: `capture/assets/app/hero_img_1…6_dark.webp`, `meeting-avatars-recording.png`,
  `hub-*.png`. People and names in them are product imagery, not endorsements.
- No customer logos, partner marks or testimonials exist in the source — never add any.

## Numerals & Claims (hard rule)

Every number and claim in type traces to `capture/extracted/brand-facts.md` (e.g. "From $5/month ·
240 AI minutes included", "up to 25 participants", "Joining is always free"). If the storyboard
names none, render no number.

## Pre-Render Self-Audit

- **Squint** — one focal dominates; one bloom; one terracotta punch.
- **Color** — ground #0C0B0E; terracotta the only accent; pink only on Ori; green/red only as
  signals; no #000/#FFF; no gradient text or AI gradient.
- **Type** — Schibsted display −0.03em sentence case; Inter UI/body; ≥ in-feed floor; tabular nums.
- **Screens** — real, uniform-scaled, ≥ 1 src px/output px, no chrome, 18px hairline frame or dimmed bg.
- **Keep-out** — nothing readable below y = 896px.
- **Motion** — power3/expo out, no bounce; cuts on downbeats; ≥ 1-beat holds; no front-load-then-freeze.
- **Claims** — every word and number in brand-facts.md.
