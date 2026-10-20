export const meta = {
  name: 'launch-film-design',
  description: 'Design a launch film: frame.md, three story pitches, judge panel, storyboard synthesis with grafts, story + contract critics, fixer',
  phases: [
    { title: 'Pitch', detail: 'frame.md author + 3 story pitches in parallel' },
    { title: 'Judge', detail: '3 judges score the pitches' },
    { title: 'Synthesize', detail: 'write STORYBOARD.md from the winner + grafts' },
    { title: 'Critique', detail: 'story critic + contract critic' },
    { title: 'Fix', detail: 'apply findings, re-validate' },
  ],
}

// args = {
//   project, skills, browser, hf, scratch,              // abs paths; hf = pinned hyperframes version; agents write only in project or <scratch>/work/design/
//   product: { name, url, what, assistant, message, endcard, brand_rules, design_notes, theme },
//     what: one sentence on the product; assistant: e.g. 'Ori (pink #FC097F, only on Ori)' or '';
//     message: the one line; endcard: exact end-card contents; brand_rules: accent/palette rules;
//     design_notes: colors/fonts/surfaces for frame.md; theme: 'dark' | 'light' (default 'dark') = the film's ground
//   canvas: { width, height, fps },
//   music: { file, name, bpm, bar_s, beat_s, drop_bar, drop_s, total_bars, total_s, energy, beats_json },
//   screens: [project-relative image paths every pitch/spec agent must LOOK at],
//   angles: [{ key, brief }] x3,
// }
const A = args
for (const k of ['project', 'skills', 'browser', 'hf', 'scratch', 'product', 'canvas', 'music', 'screens', 'angles']) {
  if (!A || A[k] == null) throw new Error(`args.${k} is required`)
}
for (const k of ['name', 'url', 'what', 'message', 'endcard', 'brand_rules', 'design_notes']) {
  if (!A.product[k]) throw new Error(`args.product.${k} is required`)
}
const THEME = A.product.theme || 'dark'
if (THEME !== 'dark' && THEME !== 'light') throw new Error(`args.product.theme must be 'dark' or 'light', got ${THEME}`)
const P = A.project
const SK = A.skills
const PR = A.product
const M = A.music
const C = A.canvas
const HF = `npx -y hyperframes@${A.hf}`
const LIGHT = THEME === 'light'
// Theme vocabulary: a light film must never get dark-ground instructions (and vice versa).
const T = LIGHT
  ? { name: 'Light', ground: 'off-white (the brand paper color)', empty: 'blank off-white', field: 'tint-field (static accent wash 4–8%)', fields: 'static tints', accent: 'punch/soft/tint/wash', shot: '1px hairline, soft layered shadow', text: 'deep ink text on the light ground' }
  : { name: 'Dark', ground: 'near-black', empty: 'pure-black', field: 'glow-field (static bloom 8–14%)', fields: 'static glows', accent: 'punch/soft/tint/glow', shot: '1px hairline, top highlight, soft shadow', text: 'light text on the dark ground' }
const PORTRAIT = C.height > C.width
const keepOut = Math.round(C.height * (PORTRAIT ? 0.80 : 0.83))
const SAFE = PORTRAIT
  ? `nothing readable above y ${Math.round(C.height * 0.12)}, below y ${keepOut} or right of x ${Math.round(C.width * 0.88)} (phone UI overlays)`
  : `nothing readable below y ${keepOut}`
const PHONE = Math.round(C.width / 3)
const barList = [1, 2, 3, 4, 5, 6].map(n => (n * M.bar_s).toFixed(2)).join(' / ')

const PREAMBLE = `You are one worker in a video-production workflow. Do the work yourself with your own tools (Read, Bash, Write, Edit). Never spawn sub-agents or use the Agent or Workflow tools. Your final text is machine-read data, not a chat message. Read images with the Read tool.

PROJECT (HyperFrames project root) = ${P}
SKILLS (HyperFrames skill library, read-only reference) = ${SK}

Product: ${PR.name} (${PR.url}) — ${PR.what}${PR.assistant ? ` Its AI assistant: ${PR.assistant}.` : ''} The one message: "${PR.message}". We are making a ~${M.total_s.toFixed(0)} s, ${C.width}x${C.height}, ${C.fps} fps, music-driven (NO voiceover, NO captions) product launch film in the style of the motion-graphics launch films posted on X by Linear, Raycast and Arc. Theme: ${THEME} (ground: ${T.ground}; ${T.text}). Real product screenshots and real brand marks only. Every factual claim must come from ${P}/capture/extracted/brand-facts.md. Brand rules: ${PR.brand_rules}

Music (locked): ${P}/${M.file} — ${M.name}, ${M.bpm} BPM, 4/4. Beat = ${M.beat_s} s, bar = ${M.bar_s} s. Bar n starts at n×${M.bar_s} s. Energy: ${M.energy}. The first big product reveal lands on the bar-${M.drop_bar} downbeat (${M.drop_s} s). Target length ${M.total_bars} bars = ${M.total_s} s (±1 bar). Frame durations are whole bars (${barList} s) and should VARY (1–4 bars) so the cut rate never settles into a metronome. Onset grid: ${P}/${M.beats_json}.

Any \`hyperframes\` command: \`HYPERFRAMES_BROWSER_PATH=${A.browser} ${HF} …\`. Never write outside PROJECT except under ${A.scratch}/work/design/.`

const PITCH_SCHEMA = {
  type: 'object',
  properties: {
    title: { type: 'string' },
    angle: { type: 'string' },
    summary: { type: 'string', description: '3-5 sentences: the idea and why it wins on X' },
    pitch_markdown: { type: 'string' },
  },
  required: ['title', 'angle', 'summary', 'pitch_markdown'],
}
const JUDGE_SCHEMA = {
  type: 'object',
  properties: {
    scores: {
      type: 'array',
      items: {
        type: 'object',
        properties: {
          pitch_index: { type: 'integer' }, hook: { type: 'number' }, clarity: { type: 'number' }, genre_fit: { type: 'number' },
          feasibility: { type: 'number' }, brand_truth: { type: 'number' }, total: { type: 'number' }, verdict: { type: 'string' },
        },
        required: ['pitch_index', 'hook', 'clarity', 'genre_fit', 'feasibility', 'brand_truth', 'total', 'verdict'],
      },
    },
    winner_index: { type: 'integer' },
    grafts: { type: 'array', items: { type: 'string' } },
    notes: { type: 'string' },
  },
  required: ['scores', 'winner_index', 'grafts', 'notes'],
}
const FINDINGS_SCHEMA = {
  type: 'object',
  properties: {
    findings: {
      type: 'array',
      items: {
        type: 'object',
        properties: { severity: { type: 'string', enum: ['blocker', 'major', 'minor'] }, frame: { type: 'string' }, issue: { type: 'string' }, fix: { type: 'string' } },
        required: ['severity', 'frame', 'issue', 'fix'],
      },
    },
    verdict: { type: 'string' },
  },
  required: ['findings', 'verdict'],
}

const LOOK = `LOOK at the real screens with the Read tool: ${A.screens.map(s => `${P}/${s}`).join(', ')}.`
const PITCH_READING = `Read, in order: ${P}/BRIEF.md; ${P}/capture/extracted/brand-facts.md; ${P}/capture/extracted/asset-descriptions.md; ${P}/capture/extracted/visible-text.txt; ${SK}/hyperframes-creative/references/story-spine.md; ${SK}/product-launch-video/references/story-design.md; ${SK}/hyperframes-animation/blueprints-index.md. Then ${LOOK}`

const PITCH_OUTPUT = `Write the pitch as markdown with EXACTLY these sections:
# <title>
## Logline (one sentence)
## Message (the one thing, in the brand's words)
## Arc and why this order
## Frames — table: # | Title | Role (Hook/Problem/Product_Intro/Key_Feature/Benefits/Proof/CTA/Brand_Outro) | Bars | Seconds | Starts at (s) | On-screen copy (EXACT words, ≤ 7 words per line, ≤ 2 lines) | What we see (which real asset, framing, what moves — concrete, name the motion) | Candidate blueprint id (from blueprints-index.md) | transition_in (cut / crossfade / push-slide) | SFX (names in ${P}/assets/sfx/)
Rules: 9–13 frames; whole bars that VARY; running total ${M.total_bars} bars ±1; first full-energy product reveal on bar ${M.drop_bar}; the end card is last and holds ≥ 3 bars; the on-screen copy is the whole script, so it must read as a film, not slide titles; plain confident copy, no jargon, no exclamation marks; every claim traceable to brand-facts.md; the hook's second line carries tension; no ${T.empty} hold longer than one beat; type-heavy frames cut (don't crossfade type over type).
## Music map — which bars carry which beats, where cuts land, where the drop hits
## The signature moment — the one shot people will screenshot (it must READ on a phone at ${PHONE} px wide)
## Why it wins on X (3 bullets)
## Risks and how the build avoids them (slideshow pacing, screensaver motion, illegible screenshots, demo data telling the wrong story, fake claims)`

phase('Pitch')

const frameSpecPromise = agent(`${PREAMBLE}

TASK: write ${P}/frame.md — a bespoke "${PR.name} ${T.name} — Frame" frame-scale design system for this film. It is the single visual truth every frame builder reads.

Read first: ${SK}/hyperframes-creative/references/design-spec.md; ${SK}/hyperframes-creative/frame-presets/blue-professional/FRAME.md and ${SK}/hyperframes-creative/frame-presets/code-editorial/FRAME.md (structure and detail level only — do NOT copy their look); ${SK}/hyperframes-creative/references/house-style.md; ${SK}/hyperframes-creative/references/typography.md; ${SK}/hyperframes-creative/references/video-composition.md; ${P}/capture/extracted/brand-facts.md; ${P}/BRIEF.md. Then ${LOOK}

Design notes from the orchestrator (authoritative): ${PR.design_notes}

Write YAML frontmatter + markdown body:
- frontmatter keys: version, name, description, unit, principle, colors, radii, typography, spacing, components, fonts.
- colors MUST include both \`canvas\` and \`bg\` (same ${T.ground} ground), plus surface/card/raised/hairline, a text ladder (text/text-muted/text-dim, ${T.text}; never pure #FFF/#000), the accent family (${T.accent}), the assistant colors if any, and live-signal colors. Exactly one accent family.
- typography: a full ramp by role (display, h1, h2, statement, eyebrow, body, label, stat-num tabular, mono-ish URL/price chrome, ui-text) in cqw with px, using only the shipped fonts in ${P}/assets/fonts/ (list them with project-root-relative paths and variable weight ranges) + a ready-to-paste @font-face block.
- spacing incl. the safe zone (${SAFE}) and a hero-anchor-y.
- components: ground, ${T.field}, screenshot-frame (18px radius, ${T.shot}; never upscale past 1.15× source px), ui-card, pills/chips the product uses, assistant chip/bubble if any, action-row, stat, eyebrow-rule, cta-button, wordmark-lockup, hairline-rule, url-chip.
- body: Overview; The Frame; Composition rules; Color roles; Type; Screenshot treatment (crop/zoom limits for the real screens you looked at, never stretch, never browser chrome); Motion character (calm, decisive, power3/expo eases, no bounce, entrances 0.5–0.9 s, ${T.fields.toUpperCase()}, no camera drift, holds ≥ 1 beat); Do/Don't; phone legibility (proof text ≥ ~40 px at ${C.width} wide, so it reads at ${PHONE} px).
Return a 5-line summary incl. any brand decision you had to make.`, { label: 'frame-spec', phase: 'Pitch', effort: 'high' })

const pitches = await parallel(A.angles.map(a => () =>
  agent(`${PREAMBLE}

TASK: write ONE complete story pitch from a specific angle. It competes with two others in front of a judge panel; the winner becomes the storyboard.

${a.brief}

${PITCH_READING}

${PITCH_OUTPUT}

Be specific and cinematic: name the real screenshot per frame (file names from asset-descriptions.md) and how it is cropped/pushed. Think like a great editor with THIS footage: masks, parallax between screenshot and rebuilt overlay, a live-typing assistant answer, an item checking itself off, the wordmark assembling. Prefer stillness to bad motion. No fake numbers, logos or testimonials.`, { label: `pitch:${a.key}`, phase: 'Pitch', schema: PITCH_SCHEMA, effort: 'high' })))

const valid = pitches.map((p, i) => (p ? { ...p, index: i, angle_key: A.angles[i].key } : null)).filter(p => p && p.pitch_markdown)
if (!valid.length) throw new Error('no pitches')
log(`pitches: ${valid.map(p => p.title).join(' | ')}`)

phase('Judge')
const pack = valid.map(p => `\n\n=====================\n# PITCH ${p.index} (${p.angle_key}) — ${p.title}\n=====================\n${p.pitch_markdown}`).join('\n')
const LENSES = [
  { key: 'creative-director', lens: 'You are a creative director who has cut viral launch films for Linear, Raycast and Arc. Judge hook strength (first 2 bars), rhythm against the track, memorability of the signature moment (at phone size), restraint, and whether it feels like a film rather than a slide deck.' },
  { key: 'product-marketer', lens: `You are ${PR.name}'s head of product marketing. Judge message discipline (one idea), clarity of each feature beat and its benefit, truthfulness against brand-facts.md, plain copy a first-time viewer understands, and whether the CTA/price lands.` },
  { key: 'motion-engineer', lens: `You are the motion designer who must BUILD this in HyperFrames (HTML/CSS/GSAP, seek-safe, one paused timeline per frame, real screenshots, no footage, no cursors). Judge feasibility, blueprint fit, legibility of screenshots at ${C.width}×${C.height} and at ${PHONE} px wide, and the two failure modes: slideshow (front-load then freeze) and screensaver (everything floating). Read ${SK}/hyperframes-animation/blueprints-index.md and ${SK}/product-launch-video/references/motion-language.md first.` },
]
const judges = (await parallel(LENSES.map(l => () => agent(`${PREAMBLE}

${l.lens}

Read ${P}/BRIEF.md and ${P}/capture/extracted/brand-facts.md, then judge these ${valid.length} pitches. Score each 1–10 on hook, clarity, genre_fit, feasibility, brand_truth; total = sum. Name the winner (pitch_index) and 3–6 concrete grafts (frames, moves or copy lines from the other pitches worth merging into the winner; cite them as "Pitch <index> F<n>"). Be decisive; quote copy.
${pack}`, { label: `judge:${l.key}`, phase: 'Judge', schema: JUDGE_SCHEMA, effort: 'high' }).then(r => (r ? { ...r, lens: l.key } : null))))).filter(Boolean)

const totals = {}
const votes = {}
for (const j of judges) {
  for (const s of j.scores || []) totals[s.pitch_index] = (totals[s.pitch_index] || 0) + s.total
  votes[j.winner_index] = (votes[j.winner_index] || 0) + 1
}
// tie-break by judge votes (Leapcast tied 113/113); ignore scores for pitch indexes that don't exist
const ranked = Object.entries(totals)
  .filter(([i]) => valid.some(p => p.index === Number(i)))
  .sort((a, b) => (b[1] - a[1]) || ((votes[b[0]] || 0) - (votes[a[0]] || 0)))
if (!ranked.length) log(`judges returned no usable scores; falling back to pitch ${valid[0].index}`)
const winnerIndex = ranked.length ? Number(ranked[0][0]) : valid[0].index
const winner = valid.find(p => p.index === winnerIndex) || valid[0]
const grafts = judges.flatMap(j => j.grafts || [])
log(`winner: pitch ${winner.index} (${winner.title}); totals ${JSON.stringify(totals)} votes ${JSON.stringify(votes)}`)
const frameSpec = await frameSpecPromise

phase('Synthesize')
const synthesis = await agent(`${PREAMBLE}

TASK: write ${P}/STORYBOARD.md — story AND visual design in one pass. Frame builders build ONLY from their per-frame packet of this file, so every frame must be a complete, self-sufficient, buildable spec.

INPUTS
- Winning pitch (PITCH ${winner.index}; build from it):
${winner.pitch_markdown}
- Other pitches, for resolving grafts that cite them (0-based):
${valid.filter(p => p.index !== winner.index).map(p => `\n----- PITCH ${p.index} (${p.angle_key}) — ${p.title} -----\n${p.pitch_markdown}`).join('\n')}
- Judge totals ${JSON.stringify(totals)}, votes ${JSON.stringify(votes)}.
- Grafts (use those that strengthen the film; resolve conflicts, keep it coherent):
${grafts.map(g => `  - ${g}`).join('\n')}
- Judge notes: ${judges.map(j => `${j.lens}: ${j.notes}`).join(' | ') || 'none (no judge returned)'}
- frame.md is written (${frameSpec}). Use its color/type/component roles by NAME.

READ BEFORE WRITING: ${SK}/hyperframes/references/storyboard-format.md (follow exactly); ${SK}/product-launch-video/references/story-design.md; ${SK}/product-launch-video/references/visual-design.md; ${SK}/product-launch-video/references/motion-language.md; ${SK}/product-launch-video/references/cut-catalog.md; ${SK}/hyperframes-animation/blueprints-index.md and EVERY blueprint you instantiate; ${SK}/hyperframes-animation/rules-index.md (cite only ids that exist as files in rules/; "gsap-effects" is NOT a rule); ${SK}/product-launch-video/scripts/lib/transitions.json (allowed transition_in); brand-facts.md; asset-descriptions.md; BRIEF.md. For any named look run \`${HF} catalog --query "<look>" --json\`; if a registry block fits, name it as \`.hyperframes/registry-reference/<id>.html (read for mechanics only)\`.

FILE SHAPE (strict):
1. YAML frontmatter: format ${C.width}x${C.height} · duration · fps ${C.fps} · message · arc · audience · mode: autonomous · music (mood words + BPM) · bpm ${M.bpm} · bar_seconds ${M.bar_s} · music_file ${M.file} · captions: disabled · voiceover: none.
2. \`## Video direction\` ONCE: the film; palette roles; type roles (headline line-masked rise definition); the camera notation \`cam(S, cx, cy)\` (S = output px per source px; (cx,cy) = source point at frame centre; mapping formula; source sizes; sharpness budget S ≤ 1.0 held, ≤ 1.15 for a beat); FRAME-LOCAL TIME rule; the reveal model paced to the music with a bars/time/frame/reveals table; held/breather allocation; motion grammar (storyboard overrides frame.md: ${T.fields}, no drift, no zoom blurs); negative list (slideshow, screensaver, bounce, count-ups, demo figures that tell the wrong story, browser chrome, cursors, readable copy outside the safe zone: ${SAFE}); screenshot treatment (which element gets rebuilt where); continuity devices (handoffs).
3. One \`## Frame N — Title\` per frame, bullets in this order: scene · duration (e.g. 3.87s) · bars · starts_at · transition_in · status: outline · src: compositions/frames/NN-<slug>.html · type · beat · persuasion · blueprint: <id> (Reproduce|Adapt) or compose · focal · roles · asset_candidates · rules · sfx · copy (EXACT on-screen text, lines " / ") · music_cue · handoff_out/handoff_in where an element continues across a cut (every field numeric).
   - asset_candidates format: \`assets/<basename> — role/description; assets/<basename> — …\` separated by ";" (stage-assets copies capture/assets/<basename> → assets/). No fonts in this list.
   - Then the narrative paragraph, then "Build notes:" that RESTATE (packets do not carry Video direction): the frame-local timing rule with this frame's offset, the cam() definition + source size if the frame uses cam(), the line-masked rise definition, exact colors/sizes of anything rebuilt.
   - Then time-coded Scene lines covering the WHOLE duration in FRAME-LOCAL seconds with absolute seconds in brackets: \`Scene 1 (0.00–0.97 s) [15.48–16.45]: …\` — what is on screen, what moves (named motion + ease + duration), the layout inline, exact positions. Reveals spread across the frame on named beats; never front-loaded; each frame ends on a held read; readable content inside the safe zone (${SAFE}).
4. Copy: ≤ 7 words/line, ≤ 2 copy lines on screen; claims only from brand-facts.md; proof text sized to read at ${PHONE} px wide (≥ ~40 px at ${C.width} for anything the story depends on — rebuild small UI as enlarged vector overlays rather than zooming screenshots past 1.15×). End card: ${PR.endcard}; holds ≥ 3 bars, dead still at the end while the music fades.

HARD CONSTRAINTS: total ${M.total_bars} bars ±1; the drop reveal on bar ${M.drop_bar} (${M.drop_s} s); frame lengths vary; hard cuts between type-heavy frames; ${PR.brand_rules}

SELF-VERIFY in Bash until clean: (a) durations sum to the target and every starts_at = running sum; (b) every blueprint id has a file in ${SK}/hyperframes-animation/blueprints/; (c) every rules id has a file in ${SK}/hyperframes-animation/rules/; (d) every asset_candidates basename exists under ${P}/capture/assets/ or ${P}/assets/; (e) every sfx exists in ${P}/assets/sfx/; (f) src paths unique and ordered; (g) \`cd ${P} && node ${SK}/product-launch-video/scripts/frame-packets.mjs --project ${P} --storyboard ${P}/STORYBOARD.md\` exits 0; (h) \`cd ${P} && node ${SK}/product-launch-video/scripts/stage-assets.mjs --storyboard ./STORYBOARD.md --hyperframes .\` stages N/N with no anomalies.
Return: the frame list (number, title, bars, start, blueprint), the total, and every judgement call you made.`, { label: 'synthesize-storyboard', phase: 'Synthesize', effort: 'xhigh' })
log(`storyboard: ${String(synthesis).slice(0, 300)}`)

phase('Critique')
const critics = (await parallel([
  () => agent(`${PREAMBLE}

You are the story + brand critic. Read ${P}/STORYBOARD.md, BRIEF.md, brand-facts.md and frame.md, and LOOK at the screenshots the storyboard names. Find everything that makes this weaker than the best launch films on X: a soft hook; a dead ${T.empty} pause longer than one beat; copy that is jargon, long or generic; the drop line selling a commodity feature; a feature beat with no benefit or a claim its demo doesn't prove; a claim not in brand-facts.md; demo figures that tell the wrong story (falling metrics, "1 participant", zeros); anything that won't read at ${PHONE} px wide (compute the px size of every proof element at its camera scale); front-load-then-freeze; motion for its own sake; the end card missing any of: ${PR.endcard}; rhythm ignoring the bar grid or a 2-bar metronome; brand-rule violations; anything that breaks the ${THEME} theme (${T.ground} ground, ${T.text}). Per finding: frame, issue, concrete fix (rewrite copy yourself). Severity blocker/major/minor. Verdict in one sentence.`, { label: 'critic:story', phase: 'Critique', schema: FINDINGS_SCHEMA, effort: 'high' }),
  () => agent(`${PREAMBLE}

You are the build-contract critic. The storyboard is split into per-frame packets for parallel builders who read ONLY their packet, frame.md and .hyperframes/video-direction.md. Check ${P}/STORYBOARD.md against ${SK}/hyperframes/references/storyboard-format.md, ${SK}/product-launch-video/references/visual-design.md, ${SK}/hyperframes/references/frame-worker-core.md, ${SK}/product-launch-video/sub-agents/frame-worker.md, rules-index.md and transitions.json. Verify in Bash: ids/files exist (blueprints, rules, sfx, asset basenames); transition_in allowed; src unique/ordered; whole bars summing to target; starts_at consistent; Scene windows FRAME-LOCAL (absolute only in brackets), covering each frame with no gaps/overlaps; cam() defined in the Build notes of every frame that uses it; handoff pairs match numerically; asset_candidates in "assets/<basename> — role;" form; any asset a handoff or Build note needs is listed; registry references point at .hyperframes/registry-reference/<id>.html. Run frame-packets.mjs and stage-assets.mjs (commands as in the storyboard self-verify) and report errors verbatim as blockers; staging must be N/N. Flag any Scene line a builder can't implement unambiguously. Concrete fix per finding. Verdict in one sentence.`, { label: 'critic:contract', phase: 'Critique', schema: FINDINGS_SCHEMA, effort: 'high' }),
])).filter(Boolean)
const findings = critics.flatMap(c => c.findings)
log(`critique: ${findings.length} findings (${findings.filter(f => f.severity === 'blocker').length} blockers)`)

phase('Fix')
const fix = await agent(`${PREAMBLE}

TASK: apply the critics' findings to ${P}/STORYBOARD.md in place, keeping the file shape. Re-read storyboard-format.md and visual-design.md first. Apply every blocker and major; minors when they clearly help without changing total length or the bar grid. Conflicts: prefer shorter, plainer, more truthful. You may copy capture/assets files into assets/ if staging needs it.

FINDINGS:
${findings.map(f => `- [${f.severity}] ${f.frame}: ${f.issue} → FIX: ${f.fix}`).join('\n')}

Re-run the storyboard self-verify (a)–(h) until clean. Return per finding applied/skipped + why, the final frame list (number, title, bars, start, blueprint, copy) and the total.`, { label: 'apply-fixes', phase: 'Fix', effort: 'high' })

return {
  pitches: valid.map(p => ({ index: p.index, angle: p.angle_key, title: p.title, summary: p.summary })),
  totals, votes, winnerIndex: winner.index, winnerTitle: winner.title, grafts, frameSpec, synthesis, findings, fix,
}
