export const meta = {
  name: 'launch-film-gate',
  description: 'Regression gate on the latest launch-film draft vs the previous one + director re-score; fixes confirmed blockers/majors (and optional polish items) per frame with verification',
  phases: [
    { title: 'Gate', detail: 'regression hunter + director re-score on the assembled render' },
    { title: 'Fix', detail: 'per-frame fixes for confirmed blockers/majors and requested polish' },
    { title: 'Verify', detail: 'independent verifier per fixed frame' },
  ],
}

// args = {
//   project, browser, hf, scratch, harness,
//   current: 'renders/draft-v3.mp4', previous: 'renders/draft-v2.mp4',   // project-relative: the new draft and the draft the fixes were made against
//   product: { name, brand_rules, theme },                 // theme: 'dark' | 'light' (default 'dark')
//   canvas: { width, height, fps, ground },
//   music: { bpm, bed, bed_lufs },
//   frames: [{ id, n, duration, starts_at, transition_in }],
//   changes: 'what changed between previous and current (renders/CHANGES.txt)',
//   complaints: ['earlier review complaint 1', …],        // the director checks each on the current render
//   polish: [{ id, task }],                                // optional: minor fixes to apply regardless (id = frame id; skip the gate with skip_gate: true)
//   skip_gate: false,
// }
const A = args
for (const k of ['project', 'browser', 'hf', 'scratch', 'harness', 'current', 'product', 'canvas', 'music', 'frames']) {
  if (!A || A[k] == null) throw new Error(`args.${k} is required`)
}
const THEME = A.product.theme || 'dark'
if (THEME !== 'dark' && THEME !== 'light') throw new Error(`args.product.theme must be 'dark' or 'light', got ${THEME}`)
const P = A.project
const C = A.canvas
const CUR = `${P}/${A.current}`
const PREV = A.previous ? `${P}/${A.previous}` : null
const FRAMES = A.frames
const byId = Object.fromEntries(FRAMES.map(f => [f.id, f]))
const PORTRAIT = C.height > C.width
const keepOut = Math.round(C.height * (PORTRAIT ? 0.80 : 0.83))
const SAFE = PORTRAIT
  ? `nothing readable above y ${Math.round(C.height * 0.12)}, below y ${keepOut} or right of x ${Math.round(C.width * 0.88)}`
  : `nothing readable below y ${keepOut}`
const PHONE = Math.round(C.width / 3)
const BED = Number.isFinite(A.music.bed_lufs) ? A.music.bed_lufs : null
const gainScale = BED === null ? 1 : Math.pow(10, (BED + 10) / 20)
const g = v => Math.min(4, v * gainScale).toFixed(2)
const SFX_FORMAT = `Each cue: { file: "assets/sfx/<name>.mp3" (project-relative, exact file name in ${P}/assets/sfx/; anything else is silently dropped), offset_s (frame-local), duration_s (≤ file length), volume (0–4) }. Starting volumes for the bundled SFX (bed ${BED === null ? 'loudness unknown, assumed ~−10' : BED} LUFS): pops/clicks/notifications/chimes ${g(1.2)}–${g(2.2)}, ping ~${g(2.5)}, whooshes ${g(0.3)}–${g(0.7)}, impacts ${g(0.6)}–${g(0.7)}.`
const TABLE = FRAMES.map(f => `F${f.n} ${f.id}: ${f.starts_at.toFixed(2)}–${(f.starts_at + f.duration).toFixed(2)} s, transition_in ${f.transition_in}`).join('\n')

const BASE = `You are one worker on the ${A.product.name} launch film (HyperFrames HTML/GSAP → MP4). Do ALL the work yourself (Read, Bash, Write, Edit). Never spawn sub-agents; never use the Agent or Workflow tools. Final answer = structured data.
PROJECT = ${P}. ${C.width}×${C.height}, ${C.fps} fps, ${THEME} theme on a ${C.ground} ground, music-only (${A.music.bpm} BPM${BED === null ? '' : `, bed ${BED} LUFS`}). Spec: STORYBOARD.md (+ "## Video direction"), frame.md, capture/extracted/brand-facts.md. Brand rules: ${A.product.brand_rules}
Frames (absolute):
${TABLE}
Renders: current ${CUR}${PREV ? `; previous ${PREV}` : ''}. Inspect with ffmpeg (stills, tiled strips, scale=${PHONE}:-1 for phone); view images with Read. Never run hyperframes render. Scratch: ${A.scratch}/work/gate-<label>/. magick available; no python PIL.
${A.changes ? `Changes since the previous render: ${A.changes}` : ''}
Known failure class: per-frame checks mount each frame ALONE, so cross-frame leaks (an element visible outside its frame window — e.g. inline visibility:"visible"), stacking between frames and seam artifacts only show in the assembled render.`

const ENV = `Frame work: preview harness node ${A.harness} --project ${P} --frame <frame_id> --duration <s> --at <t1,…> --hf ${A.hf} --ground '${C.ground}' --width ${C.width} --height ${C.height} (mounts the frame alone; Read the PNGs; downscale to ${PHONE} px wide for legibility checks). HYPERFRAMES_BROWSER_PATH=${A.browser}. Rules: edit only your frame file; keep duration, handoffs and SFX-relevant timings; ids prefixed with the frame id; fromTo entrances; everything inside the <template>; safe zone: ${SAFE}; NEVER inline visibility "visible" (use "inherit"). Spec: .hyperframes/frame-packets/<frame_id>.md, frame.md, .hyperframes/video-direction.md.`

const FIND = {
  type: 'object',
  properties: {
    score: { type: 'number' },
    findings: {
      type: 'array',
      items: {
        type: 'object',
        properties: {
          frame_n: { type: 'number' }, at_s: { type: 'number' }, severity: { type: 'string', enum: ['blocker', 'major', 'minor'] },
          issue: { type: 'string' }, evidence: { type: 'string' }, fix: { type: 'string' },
        },
        required: ['frame_n', 'at_s', 'severity', 'issue', 'evidence', 'fix'],
      },
    },
    summary: { type: 'string' },
  },
  required: ['score', 'findings', 'summary'],
}
const CUE = {
  type: 'object',
  properties: {
    file: { type: 'string', description: 'project-relative path assets/sfx/<name>.mp3' }, offset_s: { type: 'number', description: 'frame-local seconds' },
    duration_s: { type: 'number' }, volume: { type: 'number' }, why: { type: 'string' },
  },
  required: ['file', 'offset_s', 'duration_s', 'volume', 'why'],
}
const FIX = {
  type: 'object',
  properties: {
    frame_id: { type: 'string' }, fixed: { type: 'array', items: { type: 'string' } }, skipped: { type: 'array', items: { type: 'string' } },
    lint_errors: { type: 'number' }, check_errors: { type: 'number' }, timing_changed: { type: 'boolean' },
    sfx_cues: { type: 'array', items: CUE, description: "the frame's full frame-local cue list; retimed when timing_changed is true" },
    notes: { type: 'string' },
  },
  required: ['frame_id', 'fixed', 'skipped', 'lint_errors', 'check_errors', 'timing_changed', 'sfx_cues', 'notes'],
}
const VER = { type: 'object', properties: { score: { type: 'number' }, landed: { type: 'boolean' }, regressions: { type: 'array', items: { type: 'string' } }, open_items: { type: 'array', items: { type: 'string' } }, summary: { type: 'string' } }, required: ['score', 'landed', 'regressions', 'open_items', 'summary'] }

let gates = []
let items = []
if (!A.skip_gate) {
  phase('Gate')
  gates = (await parallel([
    () => agent(`${BASE}

TASK (regression hunter): ${PREV ? `compare current vs previous across the WHOLE timeline — side-by-side tiles every 0.25 s; zoom into every difference and classify it as intended (a frame meant to change) or a regression/new defect` : 'scan the whole render every 0.25 s'}: leaks outside a frame's window, stacking over another frame, missing elements, broken layout, flicker, flash frames at seams, transition artifacts, clipped text, wrong fonts. Also scan every seam at 30 fps (cut−0.3 to cut+0.4) and run a per-frame luma check for flash frames. Report only regressions/new defects with evidence and a concrete frame-local fix. blocker = clearly broken; major = a viewer would notice.`, { label: 'gate:regressions', phase: 'Gate', schema: FIND, effort: 'high' }),
    () => agent(`${BASE}

TASK (director re-score): ${A.complaints && A.complaints.length ? `verify each earlier complaint on the current render: ${A.complaints.map((c, i) => `(${i + 1}) ${c}`).join('; ')}. ` : ''}Then watch the current render whole as a first-time X viewer (2 fps stills in order + ${PHONE}-px phone views) and list remaining blocker/major issues most viewers would notice (audio: measure in-band against the bed, not wideband; the ${THEME} ground stays consistent across frames). Score 0–10 vs a top-tier launch film. Only real, verified problems.`, { label: 'gate:director', phase: 'Gate', schema: FIND, effort: 'high' }),
  ])).filter(Boolean)
  const serious = gates.flatMap(g => g.findings).filter(f => f.severity !== 'minor')
  log(`gate: ${gates.map(g => g.score).join(' / ')}; ${serious.length} blocker/major; ${gates.flatMap(g => g.findings).length - serious.length} minor (not auto-fixed — pass them as args.polish if worth it)`)
  const byN = {}
  for (const f of serious) (byN[f.frame_n] = byN[f.frame_n] || []).push(f)
  items = Object.entries(byN).map(([n, fs]) => {
    const fr = FRAMES.find(x => x.n === Number(n))
    return fr ? { id: fr.id, task: `Confirmed gate issues (confirm each yourself in the current render first; skip any that is not real and say why):\n${JSON.stringify(fs, null, 1)}` } : null
  }).filter(Boolean)
}
for (const p of A.polish || []) {
  if (!byId[p.id]) {
    log(`polish: unknown frame id ${p.id}, skipped`)
    continue
  }
  const existing = items.find(i => i.id === p.id)
  if (existing) existing.task += `\n\nAlso apply this polish:\n${p.task}`
  else items.push({ id: p.id, task: p.task })
}
if (!items.length) return { gates, fixes: [] }

const fixPrompt = (it, extra) => {
  const f = byId[it.id]
  return `${BASE}
${ENV}

TASK: frame ${it.id} (Frame ${f.n}, duration ${f.duration} s, starts at ${f.starts_at} s; frame-local t = absolute − ${f.starts_at}). Read the frame file fully, your packet and frame.md; look at the current render at the relevant times. Change as little as possible.
${it.task}
${extra || ''}
Iterate with the harness (dense --at around the affected window) until lint/check 0 errors and the fix is visibly done at full size and at ${PHONE} px wide. Reason from the code about cross-frame leaks (the harness can't show them).
SFX: return the frame's full current cue list as sfx_cues (frame-local; current cues are the ${P}/audio_meta.json sfx entries with frame ${f.n}). If you moved any visual event a cue sits on, set timing_changed: true and retime those cues. ${SFX_FORMAT}`
}
const verifyPrompt = (it, fx) => {
  const f = byId[it.id]
  return `${BASE}
${ENV}

TASK: independent verifier for ${it.id} (Frame ${f.n}, ${f.duration} s). Do NOT edit. Requested:
${it.task}
Fixer report: ${JSON.stringify(fx)}
Harness densely across the whole frame (every 0.25 s; every 0.05 s in the affected window); compare with the current render at absolute = local + ${f.starts_at}. Confirm the fix (incl. ${PHONE}-px check) and that nothing else changed/regressed (grep for inline "visible", lint/check errors, alignment, timings, overlaps). landed = done with no regressions.`
}

phase('Fix')
const fixes = await pipeline(items,
  it => agent(fixPrompt(it), { label: `fix:${it.id}`, phase: 'Fix', schema: FIX, effort: 'xhigh' }),
  async (fx, it) => {
    let v = await agent(verifyPrompt(it, fx), { label: `verify:${it.id}`, phase: 'Verify', schema: VER, effort: 'high' })
    if (v && (!v.landed || v.regressions.length)) {
      log(`${it.id}: ${v.score}/10 landed=${v.landed} → retry`)
      const fx2 = await agent(fixPrompt(it, `\nA verifier reviewed your first pass. Fix all of this:\n${JSON.stringify({ regressions: v.regressions, open_items: v.open_items, summary: v.summary }, null, 1)}`), { label: `fix2:${it.id}`, phase: 'Fix', schema: FIX, effort: 'xhigh' })
      v = await agent(verifyPrompt(it, fx2 || fx), { label: `verify2:${it.id}`, phase: 'Verify', schema: VER, effort: 'high' })
      fx = fx2 || fx
    }
    log(`${it.id}: ${v ? v.score : '?'}/10 landed=${v ? v.landed : '?'}`)
    return { id: it.id, fix: fx, verify: v }
  })
return { gates, fixes: fixes.filter(Boolean) }
