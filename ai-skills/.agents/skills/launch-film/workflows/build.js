export const meta = {
  name: 'launch-film-build',
  description: 'Build every launch-film frame: builder per frame with a self-preview loop, adversarial reviewer, fixer loop until pass',
  phases: [
    { title: 'Build', detail: 'one builder per frame writes compositions/frames/<id>.html and iterates with the preview harness' },
    { title: 'Review', detail: 'independent adversarial reviewer renders dense snapshots and scores the frame' },
    { title: 'Fix', detail: 'fixer applies review findings, re-verifies; up to 2 rounds' },
  ],
}

// args = {
//   project, skills, browser, hf, scratch,              // abs paths; hf = pinned version
//   harness,                                             // abs path to <project>/tools/preview-frame.mjs
//   product: { name, brand_rules, theme },               // theme: 'dark' | 'light' (default 'dark')
//   canvas: { width, height, ground },
//   music: { bed_lufs },                                 // integrated LUFS of the bed (SKILL §1); scales the SFX gain guidance
//   sfx_list: 'whoosh 0.57s · pop 0.72s · …',            // names + lengths of assets/sfx/*.mp3
//   frames: [{ id, n, duration, starts_at, transition_in, sfx, prev, next }],   // tools/frames-json.mjs
//   only: ['05-…'] (optional subset)
//   fast: false,                                         // optional: true = builder effort 'high', at most 1 fix round (about half the time)
//   max_rounds, build_effort, fix_effort                  // optional overrides (defaults: 2, 'xhigh', 'xhigh'; fast: 1, 'high', 'high')
// }
const A = args
const MAX_ROUNDS = A && A.max_rounds != null ? A.max_rounds : (A && A.fast ? 1 : 2)
const BUILD_EFFORT = (A && A.build_effort) || (A && A.fast ? 'high' : 'xhigh')
const FIX_EFFORT = (A && A.fix_effort) || (A && A.fast ? 'high' : 'xhigh')
for (const k of ['project', 'skills', 'browser', 'hf', 'scratch', 'harness', 'product', 'canvas', 'music', 'sfx_list', 'frames']) {
  if (!A || A[k] == null) throw new Error(`args.${k} is required`)
}
const THEME = A.product.theme || 'dark'
if (THEME !== 'dark' && THEME !== 'light') throw new Error(`args.product.theme must be 'dark' or 'light', got ${THEME}`)
const FIELDS = THEME === 'light' ? 'static tints' : 'static glows'
const P = A.project
const C = A.canvas
const PORTRAIT = C.height > C.width
const keepOut = Math.round(C.height * (PORTRAIT ? 0.80 : 0.83))
const SAFE = PORTRAIT
  ? `nothing readable above y ${Math.round(C.height * 0.12)}, below y ${keepOut} or right of x ${Math.round(C.width * 0.88)}`
  : `nothing readable below y ${keepOut}`
const PHONE = Math.round(C.width / 3)
// SFX gain guidance was tuned against a −10 LUFS bed; scale it by the measured bed loudness.
const BED = Number.isFinite(A.music.bed_lufs) ? A.music.bed_lufs : null
const gainScale = BED === null ? 1 : Math.pow(10, (BED + 10) / 20)
const g = v => Math.min(4, v * gainScale).toFixed(2)
const GAIN = `${BED === null ? 'Bed loudness unknown (music.bed_lufs unset), so these assume a bed near −10 LUFS' : `The bed measures ${BED} LUFS, so these are scaled ×${gainScale.toFixed(2)} from the −10 LUFS reference`}: pops/clicks/notifications/chimes ${g(1.2)}–${g(2.2)}, ping ~${g(2.5)}, whooshes ${g(0.3)}–${g(0.7)}, impacts ${g(0.6)}–${g(0.7)}, riser ${g(0.4)}`
const FRAMES = A.only ? A.frames.filter(f => A.only.includes(f.id)) : A.frames
const N = A.frames.length
const PREVIEW = `node ${A.harness} --project ${P} --frame <frame_id> --duration <seconds> --at <t1,t2,...> [--samples 8] --hf ${A.hf} --ground '${C.ground}' --width ${C.width} --height ${C.height}`

const PREAMBLE = `You are one worker in a video-production workflow for the ${A.product.name} launch film (HyperFrames: HTML + CSS + GSAP → MP4; ${THEME} theme on a ${C.ground} ground). Do ALL the work yourself with your own tools (Read, Bash, Write, Edit). Never spawn sub-agents; never use the Agent or Workflow tools. Your final answer is machine-read structured data.

Environment:
- PROJECT = ${P}. Asset paths in HTML are project-root relative (assets/…, never ../).
- SKILLS = ${A.skills}
- Preview harness: ${PREVIEW}
  It mounts your frame ALONE at t=0 in .hyperframes/preview/<frame_id>/ and runs the pinned CLI lint --verbose, check and snapshot at the frame-local --at times; prints findings + PNG paths + contact-sheet.jpg. View PNGs with Read.
- export HYPERFRAMES_BROWSER_PATH=${A.browser} for any direct hyperframes command; only npx -y hyperframes@${A.hf}; never run render.
- magick and ffmpeg/ffprobe are available (no python PIL). Scratch: ${A.scratch}/work/<frame_id>/.
- Do not touch STORYBOARD.md, frame.md, BRIEF.md, index.html, capture/, other frames, .hyperframes/frame-packets/. No git state changes. Prefer CSS cropping of real assets; if a derived image is unavoidable write assets/derived/<frame_id>-<name>.png.

Source of truth, in order: (1) your packet's frame block (Scene lines, music_cue, Build notes, copy, handoffs), (2) .hyperframes/video-direction.md (storyboard wins over frame.md: ${FIELDS}, no drift, no zoom blurs, no count-ups), (3) frame.md, (4) capture/extracted/brand-facts.md, (5) the role file.

Hard rules for every frame file:
- Exactly one bare <template>…</template>; root <div id="root" data-composition-id="<frame_id>" data-width="${C.width}" data-height="${C.height}" data-duration="<duration>"> styled ONLY via #root; every <style>/<script> (incl. the GSAP CDN script) inside the template.
- One gsap.timeline({ paused: true }) at window.__timelines["<frame_id>"], built synchronously. No repeat/yoyo, CSS transitions/animations, Date.now/Math.random or network.
- Full-bleed ground on its own class="clip" layer (data-start="0" data-duration="<duration>" data-track-index), never a background on #root.
- EVERY element GSAP targets or that is timed has an id prefixed "<frame_id>-"; prefix invented class names too. Select with getElementById / [id="…"] (ids start with a digit).
- fromTo entrances. No exit tweens (the root transition is the exit) except where your Scene lines describe an in-frame beat; the final frame may settle.
- NEVER set inline visibility "visible" (use "inherit"): the runtime hides inactive frames via an ancestor and "visible" leaks the element over the WHOLE film. The harness cannot show this.
- No CSS transform on elements you tween with x/y/scale (use fromTo, xPercent, or offsets).
- Every font has an @font-face inside the file (copy frame.md's block).
- Safe zone: ${SAFE}. Copy exactly as the packet states. ${A.product.brand_rules}
- No <audio>.`

const BUILD_SCHEMA = {
  type: 'object',
  properties: {
    frame_id: { type: 'string' },
    file: { type: 'string' },
    lint_errors: { type: 'number' },
    lint_warnings_remaining: { type: 'array', items: { type: 'string' } },
    check_errors: { type: 'number' },
    check_warnings_remaining: { type: 'array', items: { type: 'string' } },
    harness_passes: { type: 'number' },
    sfx_cues: {
      type: 'array',
      items: {
        type: 'object',
        properties: {
          file: { type: 'string', description: 'project-relative path assets/sfx/<name>.mp3' }, offset_s: { type: 'number', description: 'frame-local seconds' }, duration_s: { type: 'number' }, volume: { type: 'number' }, why: { type: 'string' },
        },
        required: ['file', 'offset_s', 'duration_s', 'volume', 'why'],
      },
    },
    deviations: { type: 'array', items: { type: 'string' } },
    handoff_state: { type: 'string' },
    self_score: { type: 'number' },
    notes: { type: 'string' },
  },
  required: ['frame_id', 'file', 'lint_errors', 'check_errors', 'harness_passes', 'sfx_cues', 'deviations', 'self_score', 'notes'],
}
const REVIEW_SCHEMA = {
  type: 'object',
  properties: {
    score: { type: 'number' },
    pass: { type: 'boolean' },
    findings: {
      type: 'array',
      items: {
        type: 'object',
        properties: {
          severity: { type: 'string', enum: ['blocker', 'major', 'minor', 'nit'] },
          at_s: { type: 'number' }, issue: { type: 'string' }, evidence: { type: 'string' }, fix: { type: 'string' },
        },
        required: ['severity', 'at_s', 'issue', 'evidence', 'fix'],
      },
    },
    sfx_ok: { type: 'boolean' },
    summary: { type: 'string' },
  },
  required: ['score', 'pass', 'findings', 'sfx_ok', 'summary'],
}
const passes = r => r && r.score >= 8 && !r.findings.some(f => f.severity === 'blocker' || f.severity === 'major')

const header = f => `Your frame: frame_id = ${f.id} (Frame ${f.n} of ${N}), duration = ${f.duration} s (fixed), starts_at = ${f.starts_at} s (absolute; Scene windows are frame-local, [brackets] absolute), transition_in = ${f.transition_in}. Previous: ${f.prev || 'none'}. Next: ${f.next || 'none (final frame)'}.
File: ${P}/compositions/frames/${f.id}.html · Packet: ${P}/.hyperframes/frame-packets/${f.id}.md
Storyboard SFX for this frame: ${f.sfx}. SFX library (assets/sfx/<name>.mp3): ${A.sfx_list}.`

const SFX_RULES = `SFX cues (you mount no audio; return cues): the storyboard names, on the exact frame-local times of the visual events in YOUR timeline. Each cue's file is the project-relative path "assets/sfx/<name>.mp3" (exact file name from the SFX library; anything else is silently dropped); offset_s is frame-local. The bundled SFX are quiet and need gain. ${GAIN}. Skip typing unless it's the only sound (it's buried at any level). Volume range 0–4. duration_s ≤ file length; a whoosh may pre-lap a cut (offset ≥ −0.6); a riser: find its peak (ffmpeg astats) and place the peak on the beat.`

const buildPrompt = f => `${PREAMBLE}

${header(f)}

TASK: build this frame to a top-tier launch-film standard, faithfully realizing every Scene line and music cue.
1. Read fully, in order: ${P}/.hyperframes/frame-packets/_role.md (ROLE OVERRIDES: you DO run the preview harness; you DO return SFX cues), your packet, ${P}/frame.md, ${P}/.hyperframes/video-direction.md, ${P}/capture/extracted/brand-facts.md, ${A.skills}/product-launch-video/references/cut-catalog.md. Registry references cited as .hyperframes/registry-reference/<id>.html: read for mechanics, re-implement inline. Missing rule recipes: ${A.skills}/hyperframes-animation/rules/<id>.md.
2. Look at every image you place; crop with magick to measure exact source-pixel coordinates of anything you patch, duplicate, highlight or align to. Correct packet coordinates that are off (list in deviations).
3. Write the frame file.
4. Verify with the harness: --at every cue time, 0.05, each Scene midpoint and ${(f.duration - 0.05).toFixed(2)}. Read the contact sheet and the key PNGs; also downscale key PNGs to ${PHONE} px wide (magick x.png -resize ${PHONE}x y.png) and Read them — proof text must read on a phone. Check fonts (not fallback), images load, positions, crispness, nothing clipped, safe zone (${SAFE}), reveals on cue, back half still gets reveals, held read at the end, overlays pixel-aligned with the real UI.
5. Iterate until lint 0 errors, check 0 errors, warnings fixed or listed, and it looks finished. At least 3 harness runs; the last on the final file. grep your file for '"visible"' — must be none.
6. ${SFX_RULES}
Return the structured result; honest self_score; every remaining warning and deviation.`

const reviewPrompt = (f, round, history, build) => `${PREAMBLE}

${header(f)}

TASK: independent, adversarial reviewer (demanding motion-design director + HyperFrames contract checker). Do NOT edit the frame. A frame passes only if it would not embarrass a top-tier launch film.
${history.length ? `Re-review round ${round}. Earlier findings (verify each is fixed, then do a FULL fresh review):\n${JSON.stringify(history[history.length - 1].findings, null, 1)}\n` : ''}
Builder's claims (verify, don't trust): ${JSON.stringify(build ? { deviations: build.deviations, sfx_cues: build.sfx_cues, lint_warnings_remaining: build.lint_warnings_remaining, check_warnings_remaining: build.check_warnings_remaining, handoff_state: build.handoff_state, notes: build.notes } : null)}
1. Read your packet, frame.md, .hyperframes/video-direction.md, brand-facts.md, then the frame file in full. grep it for inline visibility "visible" (blocker if present).
2. Run the harness with --at every 0.25 s from 0.05 to ${(f.duration - 0.05).toFixed(2)} plus every cue and cue−0.1/cue+0.3 around key reveals, --samples 10. Read the contact sheet and every PNG that matters; also check key moments at ${PHONE} px wide.
3. Judge: fidelity (every Scene phase, each reveal within ±0.05 s, copy verbatim, handoff numbers exact); contract (lint/check, ids, #root, template transport, no exits, no transform conflicts, @font-face, determinism); craft (hierarchy, spacing, alignment, type quality, crisp screenshots ≤ stated S, overlays pixel-aligned, phone legibility, eases, no jank/front-loading/drift/count-ups, held end); brand (${A.product.brand_rules}; safe zone: ${SAFE}; no invented claims; negative list); SFX cues on their events.
4. Score 0–10; pass = ≥ 8 and no blocker/major. blocker = broken/empty/wrong copy/contract break; major = a visible flaw viewers notice; minor = polish; nit = taste. Evidence (PNG path + measurement) and a numeric fix per finding.`

const fixPrompt = (f, review, build) => `${PREAMBLE}

${header(f)}

TASK: the reviewer scored this frame ${review.score}/10 (bar: ≥ 8, no blocker/major). Fix every blocker and major, minors when safe. Edit in place (read the file fully first; re-read packet, frame.md, video-direction.md). If a finding contradicts the packet, the packet wins — note it in deviations.
Findings:
${JSON.stringify(review.findings, null, 1)}
Summary: ${review.summary}
Previous report: ${JSON.stringify(build ? { deviations: build.deviations, sfx_cues: build.sfx_cues, notes: build.notes } : null)}
Verify with the harness at every finding's at_s and every cue time; Read the PNGs. Iterate until lint/check 0 errors and every finding is resolved. ${SFX_RULES} Return the full current sfx_cues.`

async function reviewAndFix(build, f) {
  let cur = build
  let rev = null
  const history = []
  for (let round = 0; round <= MAX_ROUNDS; round++) {
    rev = await agent(reviewPrompt(f, round, history, cur), { label: `review:${f.id}#${round}`, phase: 'Review', schema: REVIEW_SCHEMA, effort: 'high' })
    if (!rev) break
    history.push(rev)
    log(`${f.id} review #${round}: ${rev.score}/10 ${passes(rev) ? 'PASS' : 'fail'}`)
    if (passes(rev) || round === MAX_ROUNDS) break
    const fixed = await agent(fixPrompt(f, rev, cur), { label: `fix:${f.id}#${round + 1}`, phase: 'Fix', schema: BUILD_SCHEMA, effort: FIX_EFFORT })
    if (fixed) cur = fixed
  }
  return {
    frame_id: f.id, n: f.n, passed: passes(rev), final_score: rev ? rev.score : null, review_rounds: history.length,
    remaining_findings: rev ? rev.findings : [], sfx_cues: cur ? cur.sfx_cues : [], deviations: cur ? cur.deviations : [],
    handoff_state: cur ? cur.handoff_state : null, notes: cur ? cur.notes : null,
  }
}

const results = await pipeline(
  FRAMES,
  f => agent(buildPrompt(f), { label: `build:${f.id}`, phase: 'Build', schema: BUILD_SCHEMA, effort: BUILD_EFFORT }),
  (build, f) => {
    if (!build) {
      log(`${f.id}: builder returned nothing`)
      return { frame_id: f.id, n: f.n, passed: false, final_score: null, review_rounds: 0, remaining_findings: [], sfx_cues: [], deviations: [], handoff_state: null, notes: 'builder failed' }
    }
    log(`${f.id} built: self ${build.self_score}/10, lint ${build.lint_errors}e, check ${build.check_errors}e`)
    return reviewAndFix(build, f)
  },
)
const ok = results.filter(Boolean)
log(`passed ${ok.filter(r => r.passed).length}/${FRAMES.length}`)
return { results: ok }
