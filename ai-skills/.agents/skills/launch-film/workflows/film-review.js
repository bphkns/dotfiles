export const meta = {
  name: 'launch-film-review',
  description: 'Whole-film review of a launch-film render (4 lenses), verified director synthesis into per-frame fix lists, then per-frame fix + verify loops',
  phases: [
    { title: 'Review', detail: 'seams, rhythm/music/SFX, art direction/legibility, story/copy — each on the real MP4' },
    { title: 'Synthesize', detail: 'dedupe, verify against stills, reject weak findings, assign per-frame fixes' },
    { title: 'Fix', detail: 'one fixer per affected frame, preview harness verification' },
    { title: 'Verify', detail: 'independent check that every assigned fix landed without regressions' },
  ],
}

// args = {
//   project, skills, browser, hf, scratch, harness,
//   render: 'renders/draft-v1.mp4',                     // project-relative
//   product: { name, url, what, brand_rules, endcard, continuity, theme },   // continuity: the film's handoffs/bookends to check at seams; theme: 'dark' | 'light' (default 'dark')
//   canvas: { width, height, fps, ground },
//   music: { name, bpm, beat_s, bar_s, beats_json, bed, bed_lufs },    // bed: project-relative bed file (= make-audio --out); bed_lufs: its integrated loudness
//   frames: [{ id, n, duration, starts_at, transition_in }],
// }
const A = args
for (const k of ['project', 'skills', 'browser', 'hf', 'scratch', 'harness', 'render', 'product', 'canvas', 'music', 'frames']) {
  if (!A || A[k] == null) throw new Error(`args.${k} is required`)
}
if (!A.frames.length) throw new Error('args.frames is empty')
const THEME = A.product.theme || 'dark'
if (THEME !== 'dark' && THEME !== 'light') throw new Error(`args.product.theme must be 'dark' or 'light', got ${THEME}`)
const P = A.project
const C = A.canvas
const M = A.music
const MP4 = `${P}/${A.render}`
const FRAMES = A.frames
const PORTRAIT = C.height > C.width
const keepOut = Math.round(C.height * (PORTRAIT ? 0.80 : 0.83))
const SAFE = PORTRAIT
  ? `nothing readable above y ${Math.round(C.height * 0.12)}, below y ${keepOut} or right of x ${Math.round(C.width * 0.88)}`
  : `nothing readable below y ${keepOut}`
const PHONE = Math.round(C.width / 3)
const BED = Number.isFinite(M.bed_lufs) ? M.bed_lufs : null
const gainScale = BED === null ? 1 : Math.pow(10, (BED + 10) / 20)
const g = v => Math.min(4, v * gainScale).toFixed(2)
const SFX_FORMAT = `Each cue: { file: "assets/sfx/<name>.mp3" (project-relative, exact file name in ${P}/assets/sfx/; anything else is silently dropped), offset_s (frame-local), duration_s (≤ file length), volume (0–4) }. Starting volumes for the bundled SFX (bed ${BED === null ? 'loudness unknown, assumed ~−10' : BED} LUFS): pops/clicks/notifications/chimes ${g(1.2)}–${g(2.2)}, ping ~${g(2.5)}, whooshes ${g(0.3)}–${g(0.7)}, impacts ${g(0.6)}–${g(0.7)}.`
const THEME_LOOK = THEME === 'light'
  ? 'light theme: every frame keeps the same off-white ground; depth comes from hairlines and soft shadows; accent washes stay static and subtle'
  : 'dark theme: every frame keeps the same near-black ground; glows stay static'
const total = FRAMES[FRAMES.length - 1].starts_at + FRAMES[FRAMES.length - 1].duration
const TABLE = FRAMES.map(f => `F${f.n} ${f.id}: ${f.starts_at.toFixed(2)}–${(f.starts_at + f.duration).toFixed(2)} s (${f.duration} s), transition_in ${f.transition_in}`).join('\n')

const BASE = `You are one worker in a video-production workflow for the ${A.product.name} launch film (HyperFrames HTML/GSAP → MP4). Do ALL the work yourself (Read, Bash, Write, Edit). Never spawn sub-agents; never use the Agent or Workflow tools. Final answer = structured data.

Context:
- PROJECT = ${P}. Film: ${total.toFixed(2)} s, ${C.width}×${C.height}, ${C.fps} fps, ${THEME} theme on a ${C.ground} ground, music-only (${M.name}, ${M.bpm} BPM: beat ${M.beat_s} s, bar ${M.bar_s} s; beat grid ${P}/${M.beats_json}), no voiceover, no captions. ${A.product.name} (${A.product.url}): ${A.product.what} Brand rules: ${A.product.brand_rules}
- Spec: ${P}/STORYBOARD.md ("## Video direction" + frame blocks), ${P}/frame.md, ${P}/capture/extracted/brand-facts.md, ${P}/BRIEF.md.
- Frames (absolute):
${TABLE}
- Frame files: ${P}/compositions/frames/<id>.html. SFX cues (frame-relative offsets, volumes 0–4) in ${P}/audio_meta.json; bed ${P}/${M.bed}.`

const TOOLS = `- The render: ${MP4}. Inspect with ffmpeg only (never run hyperframes render; never edit project files). Full-res still: ffmpeg -v error -ss 15.9 -i ${MP4} -frames:v 1 -y OUT.png ; strip around a cut: ffmpeg -v error -ss 7.5 -t 0.5 -i ${MP4} -vf "scale=480:-1,tile=5x3" -frames:v 1 -y OUT.png ; phone view: scale=${PHONE}:-1 ; audio: ebur128 / astats / band filters (highpass=f=2500 for clicks/notifications/chimes; highpass=f=400,lowpass=f=1000 for pops; lowpass=f=150 for impacts) compared against the same window of the bed file — wideband RMS hides short high-frequency cues. View images with Read. Scratch: ${A.scratch}/work/review-<lens>/ (mkdir -p). magick available; no python PIL.`

const FINDINGS = {
  type: 'object',
  properties: {
    lens: { type: 'string' },
    overall_score: { type: 'number' },
    strengths: { type: 'array', items: { type: 'string' } },
    findings: {
      type: 'array',
      items: {
        type: 'object',
        properties: {
          frames: { type: 'array', items: { type: 'number' } },
          at_s: { type: 'number' },
          severity: { type: 'string', enum: ['blocker', 'major', 'minor', 'nit'] },
          issue: { type: 'string' }, evidence: { type: 'string' }, fix: { type: 'string' },
          owner: { type: 'string', enum: ['frame', 'orchestrator'] },
        },
        required: ['frames', 'at_s', 'severity', 'issue', 'evidence', 'fix', 'owner'],
      },
    },
  },
  required: ['lens', 'overall_score', 'strengths', 'findings'],
}

const LENSES = [
  { key: 'seams', brief: `LENS: seams and continuity. Every frame boundary at 30 fps (every frame from cut−0.4 to cut+0.6): flash frames, black/blank frames, half-built pop-ins, elements jumping across the cut, double exposure during injected transitions (crossfades between type-heavy frames are a known failure — recommend hard cuts), lingering outgoing text, ground mismatch, headline+scrim vanishing in one frame. Verify the film's continuity devices hold: ${A.product.continuity || 'the handoffs named in STORYBOARD.md'}. Scan a 10 fps strip of the whole film for stutters, one-frame glitches and ANY element visible outside its own frame's window (leaks, e.g. from inline visibility:"visible").` },
  { key: 'rhythm', brief: `LENS: rhythm, music sync, pacing and SFX. Map measured visual events (cuts, headline landings, reveals) against the beat grid; flag misses > 1 frame where the spec says on-beat and strong accents the picture ignores (the drop must hit). Reading time: each line fully readable ≥ ~0.25 s/word + 0.4 s. Pacing: dead air, slideshow cadence, frozen holds, rushed frames, the energy arc vs the music. SFX: for each cue in audio_meta.json confirm it lands on its visual event and is AUDIBLE — measure in its band against the bed (≥ +5 dB lift for story cues); flag clutter and missing punctuation. The ending: music fade vs the held end card.` },
  { key: 'art', brief: `LENS: art direction, craft and legibility. A full-res still at the held state of every frame plus key reveals, and a ${PHONE}-px-wide version (X in-feed). Judge vs Linear/Raycast/Arc: composition balance (empty areas, lopsided layouts, holes where UI was masked), type (right fonts, consistent sizes/baselines/left edges, tracking, widows), one focal point per frame, legibility at ${PHONE} px of everything the story depends on, screenshot crispness, rebuilt overlays pixel-aligned (no patches/seams/double text), color discipline (${THEME_LOOK}), consistent grammar across frames, text clearance from panel edges (≥ 48 px). Name the 5 weakest moments with numeric fixes.` },
  { key: 'story', brief: `LENS: story, copy and product truth. 2 fps stills in order, sound off, as a first-time X viewer: when does the viewer first know what the product is and its name? Is the one message clear? Does the signature moment land? Is each feature beat understood in its time? Does the end card (${A.product.endcard}) land? Every on-screen word: exact copy vs STORYBOARD.md, typos, casing, claims vs brand-facts.md, invented UI text, demo numbers that tell the wrong story, real person names readable in screenshots (note them). Fixes stay inside existing frame durations and assets.` },
]

phase('Review')
const reviews = (await parallel(LENSES.map(l => () => agent(`${BASE}
${TOOLS}

${l.brief}

Be adversarial and specific: every finding needs evidence you looked at (path + what is visible/measured) and a concrete numeric fix. No padding with taste nits; nothing you didn't verify in the render. blocker = broken/wrong/embarrassing; major = most viewers would notice or it weakens the message; minor = polish. owner=frame for a frame-file edit, owner=orchestrator for audio mix / SFX cues / transitions / assembly.`, { label: `review:${l.key}`, phase: 'Review', schema: FINDINGS, effort: 'high' })))).filter(Boolean)
log(`reviews: ${reviews.map(r => `${r.lens} ${r.overall_score}/10 (${r.findings.length})`).join(' · ')}`)

const SYNTH = {
  type: 'object',
  properties: {
    summary: { type: 'string' },
    film_score_now: { type: 'number' },
    frame_fixes: {
      type: 'array',
      items: {
        type: 'object',
        properties: {
          n: { type: 'number' }, frame_id: { type: 'string' },
          fixes: {
            type: 'array',
            items: {
              type: 'object',
              properties: {
                severity: { type: 'string', enum: ['blocker', 'major', 'minor'] }, at_local_s: { type: 'number' },
                issue: { type: 'string' }, fix: { type: 'string' }, acceptance: { type: 'string' },
              },
              required: ['severity', 'at_local_s', 'issue', 'fix', 'acceptance'],
            },
          },
          constraints: { type: 'string' },
        },
        required: ['n', 'frame_id', 'fixes', 'constraints'],
      },
    },
    orchestrator_actions: { type: 'array', items: { type: 'object', properties: { action: { type: 'string' }, detail: { type: 'string' } }, required: ['action', 'detail'] } },
    rejected: { type: 'array', items: { type: 'object', properties: { issue: { type: 'string' }, reason: { type: 'string' } }, required: ['issue', 'reason'] } },
  },
  required: ['summary', 'film_score_now', 'frame_fixes', 'orchestrator_actions', 'rejected'],
}

phase('Synthesize')
const synth = await agent(`${BASE}
${TOOLS}

TASK: you are the film's director. Four reviewers watched the render through different lenses (below). Produce the fix plan.
1. Dedupe/merge; resolve lens conflicts (storyboard + video-direction win unless a finding shows the spec itself hurts the film — then change it within the frame's fixed duration and existing assets).
2. VERIFY every blocker/major yourself against the render (extract the still/strip, look). Reject wrong, unverifiable, risky or taste-only findings (list with reasons).
3. Per affected frame: precise fixes (frame-local times = absolute − frame start), each with an acceptance test checkable on a still; carry cross-frame constraints explicitly (handoff numbers, bookends) so a fixer doesn't break a neighbour. Never change a frame's duration or start. Fewer, high-impact fixes over many nits.
4. Orchestrator actions, precisely: SFX cue add/remove/retime/volume by frame number + offset (volumes 0–4; bed ${BED === null ? '?' : BED} LUFS), bed volume, transition_in changes (hard cuts between type-heavy frames).
Score the film now (0–10).

REVIEWS:
${JSON.stringify(reviews, null, 1)}`, { label: 'synthesize', phase: 'Synthesize', schema: SYNTH, effort: 'xhigh' })
if (!synth) return { reviews, synth: null, fixes: [] }
log(`synthesis: film ${synth.film_score_now}/10; ${synth.frame_fixes.length} frames; ${synth.orchestrator_actions.length} orchestrator actions; ${synth.rejected.length} rejected`)

const byId = Object.fromEntries(FRAMES.map(f => [f.id, f]))
const ENV = `Frame work:
- Preview harness: node ${A.harness} --project ${P} --frame <frame_id> --duration <s> --at <t1,…> [--samples 8] --hf ${A.hf} --ground '${C.ground}' --width ${C.width} --height ${C.height}. It mounts the frame alone; view PNGs with Read. HYPERFRAMES_BROWSER_PATH=${A.browser} for any direct hyperframes command. Never run render.
- Rules: one bare <template>; #root with data-composition-id; style/script inside; one paused timeline at window.__timelines["<frame_id>"]; fromTo entrances; no exits except the final frame or a spec'd in-frame beat; ids prefixed "<frame_id>-"; no CSS transform on x/y/scale-tweened elements; @font-face for shipped fonts; project-root-relative paths; deterministic; no <audio>; safe zone: ${SAFE}; NEVER inline visibility "visible" (use "inherit" — "visible" leaks across the whole film and the harness can't show it).
- Edit only your frame file (and assets/derived/<frame_id>-* if unavoidable). Never change the frame's duration. Scratch: ${A.scratch}/work/<frame_id>/.
- Spec: ${P}/.hyperframes/frame-packets/<frame_id>.md, ${P}/frame.md, ${P}/.hyperframes/video-direction.md.`

const FIX = {
  type: 'object',
  properties: {
    frame_id: { type: 'string' }, applied: { type: 'array', items: { type: 'string' } }, not_applied: { type: 'array', items: { type: 'string' } },
    lint_errors: { type: 'number' }, check_errors: { type: 'number' },
    sfx_cues: { type: 'array', items: { type: 'object', properties: { file: { type: 'string', description: 'project-relative path assets/sfx/<name>.mp3' }, offset_s: { type: 'number', description: 'frame-local seconds' }, duration_s: { type: 'number' }, volume: { type: 'number' }, why: { type: 'string' } }, required: ['file', 'offset_s', 'duration_s', 'volume', 'why'] } },
    notes: { type: 'string' },
  },
  required: ['frame_id', 'applied', 'not_applied', 'lint_errors', 'check_errors', 'sfx_cues', 'notes'],
}
const VERIFY = {
  type: 'object',
  properties: {
    score: { type: 'number' }, all_fixes_landed: { type: 'boolean' }, regressions: { type: 'array', items: { type: 'string' } },
    open_items: { type: 'array', items: { type: 'object', properties: { severity: { type: 'string', enum: ['blocker', 'major', 'minor'] }, at_local_s: { type: 'number' }, issue: { type: 'string' }, fix: { type: 'string' } }, required: ['severity', 'at_local_s', 'issue', 'fix'] } },
    summary: { type: 'string' },
  },
  required: ['score', 'all_fixes_landed', 'regressions', 'open_items', 'summary'],
}

const fixPrompt = (ff, extra) => {
  const f = byId[ff.frame_id]
  return `${BASE}
${ENV}

TASK: apply the director's fixes to ${ff.frame_id} (Frame ${ff.n}, duration ${f.duration} s, starts at ${f.starts_at} s). Read your packet, the frame file in full and frame.md first. Apply every fix; skip one only if impossible or it breaks a constraint (say why). Keep everything else as is.
FIXES:
${JSON.stringify(ff.fixes, null, 1)}
CROSS-FRAME CONSTRAINTS (binding): ${ff.constraints}
${extra || ''}
Verify with the harness at every fix's at_local_s and the frame's cue times; Read the PNGs (and ${PHONE}-px versions for legibility fixes); confirm each acceptance test. Iterate until lint/check 0 errors. Return the full current SFX cue list for this frame (frame-local; current cues are the audio_meta.json sfx entries with frame ${ff.n}); retime any cue whose visual event moved. ${SFX_FORMAT}`
}
const verifyPrompt = (ff, fx) => {
  const f = byId[ff.frame_id]
  return `${BASE}
${ENV}

TASK: independent verifier (do NOT edit). A fixer applied these fixes to ${ff.frame_id} (Frame ${ff.n}, ${f.duration} s):
${JSON.stringify(ff.fixes, null, 1)}
Constraints: ${ff.constraints}
Fixer report: ${JSON.stringify(fx)}
Run the harness densely (every 0.25 s + each fix's at_local_s ± 0.1); Read the PNGs; compare with the render at the same times (absolute = local + ${f.starts_at}). Check each acceptance test, look for regressions, grep for inline "visible". Score 0–10; all_fixes_landed = every blocker/major verified.`
}

phase('Fix')
for (const ff of synth.frame_fixes) if (!byId[ff.frame_id]) log(`dropped fixes for unknown frame_id ${ff.frame_id}`)
const fixes = await pipeline(
  synth.frame_fixes.filter(ff => byId[ff.frame_id] && ff.fixes.length),
  ff => agent(fixPrompt(ff), { label: `fix:${ff.frame_id}`, phase: 'Fix', schema: FIX, effort: 'xhigh' }),
  async (fx, ff) => {
    let cur = fx
    let ver = await agent(verifyPrompt(ff, cur), { label: `verify:${ff.frame_id}`, phase: 'Verify', schema: VERIFY, effort: 'high' })
    const bad = v => !v || !v.all_fixes_landed || v.regressions.length > 0 || v.score < 8 || v.open_items.some(i => i.severity !== 'minor')
    if (ver && bad(ver)) {
      log(`${ff.frame_id}: ${ver.score}/10 landed=${ver.all_fixes_landed} → retry`)
      const again = await agent(fixPrompt(ff, `\nA verifier checked your first pass; fix all of it:\n${JSON.stringify({ regressions: ver.regressions, open_items: ver.open_items, summary: ver.summary }, null, 1)}\n`), { label: `fix2:${ff.frame_id}`, phase: 'Fix', schema: FIX, effort: 'xhigh' })
      if (again) cur = again
      ver = await agent(verifyPrompt(ff, cur), { label: `verify2:${ff.frame_id}`, phase: 'Verify', schema: VERIFY, effort: 'high' })
    }
    log(`${ff.frame_id}: ${ver ? ver.score : '?'}/10 landed=${ver ? ver.all_fixes_landed : '?'}`)
    return { frame_id: ff.frame_id, n: ff.n, fix: cur, verify: ver }
  },
)
return { reviews, synth, fixes: fixes.filter(Boolean) }
