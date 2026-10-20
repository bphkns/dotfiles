export const meta = {
  name: 'launch-film-capture',
  description: 'Capture real product screens from a logged-in demo (one agent-browser agent per role, 2x retina), the marketing site copy and brand, and a music bed; then write brand-facts.md, asset-descriptions.md and research.md and fact-check every claim',
  phases: [
    { title: 'Capture', detail: 'one agent per role + optional site + music' },
    { title: 'Synthesize', detail: 'brand-facts.md, asset-descriptions.md, research.md (messages + angles), flat asset copy' },
    { title: 'Verify', detail: 'claim checker edits the files to verified truth only; credential grep' },
  ],
}

// args = {
//   project, scratch, browser, hf,                 // abs paths; hf = pinned hyperframes version (music beat grid)
//   skills,                                        // optional: <scratch>/hyperframes-src/skills (music analysis via analyze-beatgrid.py)
//   reference,                                     // abs path whose capture/extracted/{brand-facts,asset-descriptions}.md show the FORMAT (e.g. <skill>/examples/leapcast)
//   product: { name, tagline, platform_context, demo_url, login_url, data_context, theme },
//     tagline: the product's own one-liner; platform_context: where it sits in a larger platform ('' if none);
//     data_context: what the demo data is (country, fictional org…); theme: 'dark' | 'light' (optional; the synthesis recommends one if unset)
//   roles: [{ key, task }],                        // one capture agent per role; key = [a-z0-9-]+; task may use the tokens
//                                                  // SESSION_NAME, {{password}}, {{login.<name>}}, {{login_url}}, {{demo_url}}
//   site: { key: 'site', task },                   // optional: the marketing site (no login); task = the routes and what to look for
//   music: { mood, avoid },                        // mood words; tracks/styles to avoid
//   logins: { <name>: 'user' | ['user', …] },      // credentials live ONLY in args; never written to project files
//   password,
//   password_probe,                                // distinctive substring of the password the verifier greps the project for (default: password)
//   secrets_file,                                  // optional: file under <scratch>/secrets/ holding the logins, for the verifier's re-checks
// }
const A = args
for (const k of ['project', 'scratch', 'browser', 'hf', 'reference', 'product', 'roles', 'music']) {
  if (!A || A[k] == null) throw new Error(`args.${k} is required`)
}
for (const k of ['name', 'tagline', 'demo_url']) {
  if (!A.product[k]) throw new Error(`args.product.${k} is required`)
}
if (A.product.theme && A.product.theme !== 'dark' && A.product.theme !== 'light') throw new Error(`args.product.theme must be 'dark' or 'light', got ${A.product.theme}`)
if (!Array.isArray(A.roles) || !A.roles.length) throw new Error('args.roles must be a non-empty array')
const SITE = A.site ? { key: A.site.key || 'site', task: A.site.task } : null
const SCOPES = SITE ? [...A.roles, SITE] : A.roles
const keys = SCOPES.map(r => r.key)
for (const r of SCOPES) {
  if (!r || typeof r.key !== 'string' || !/^[a-z0-9-]+$/.test(r.key)) throw new Error(`scope key must match [a-z0-9-]+, got ${r && r.key}`)
  if (!r.task) throw new Error(`scope ${r.key} has no task`)
}
if (new Set(keys).size !== keys.length) throw new Error(`scope keys must be unique: ${keys.join(', ')}`)

const P = A.project
const PR = A.product
const SH = `${P}/.hyperframes/shots`
const LOGINS = A.logins || {}
const PROBE = A.password_probe || A.password || ''
const loginValues = Object.values(LOGINS).flatMap(v => (Array.isArray(v) ? v : [v])).filter(v => typeof v === 'string' && v)
const q = s => `'${String(s).replace(/'/g, `'\\''`)}'`

// Expand {{password}}, {{login.<name>}}, {{login_url}}, {{demo_url}} in a role task. Unknown tokens fail fast.
const expand = text => text.replace(/\{\{([a-z_.0-9-]+)\}\}/gi, (_, tok) => {
  if (tok === 'password') {
    if (!A.password) throw new Error('a task uses {{password}} but args.password is unset')
    return A.password
  }
  if (tok === 'login_url') {
    if (!PR.login_url) throw new Error('a task uses {{login_url}} but args.product.login_url is unset')
    return PR.login_url
  }
  if (tok === 'demo_url') return PR.demo_url
  if (tok.startsWith('login.')) {
    const v = LOGINS[tok.slice(6)]
    if (v == null) throw new Error(`a task uses {{${tok}}} but args.logins.${tok.slice(6)} is unset`)
    return Array.isArray(v) ? v.join(', ') : v
  }
  throw new Error(`unknown token {{${tok}}} in a task`)
})

const ABOUT = `**${PR.name}**: "${PR.tagline}"${PR.platform_context ? ` ${PR.platform_context}` : ''} The demo is ${PR.demo_url}.${PR.data_context ? ` ${PR.data_context}` : ''}`
const SOLO = 'Do ALL the work yourself with Bash/Read/Write. Never spawn sub-agents; never use the Agent or Workflow tools. Final answer = structured data.'

const base = (key, session) => `You are one worker preparing a launch film for ${ABOUT}
${SOLO}

BROWSER: use the agent-browser CLI. Use ONLY your own session: put --session ${session} on EVERY command (or export AGENT_BROWSER_SESSION=${session}). First command: agent-browser --session ${session} set viewport 1600 1000 2 (retina: screenshots come out 3200x2000). Then open pages. Core loop: open → snapshot -i → click/fill @refs → re-snapshot. Waiting: data loads async (grey skeleton blocks) — after each navigation wait 2500–4000 ms and re-check; never keep a screenshot with skeletons, spinners, toasts, error banners, open tooltips you didn't intend, or the mouse hovering something by accident. Close your session at the end (agent-browser --session ${session} close).
To LOOK at a screenshot, make a small preview first: magick <png> -resize 1000x ${A.scratch}/work/capture/prev-${key}-<name>.jpg and Read the preview (never Read 3200-px originals). Scratch dir: ${A.scratch}/work/capture/.

CREDENTIALS: any login in your scope is for signing in only. Never write a password or login name into any file, report or answer; logged_in_as = the role name (e.g. "super admin"), not the account.

SAFETY — the demo is shared and may be wired to real messaging. READ-ONLY:
- Never submit anything that creates, edits, approves, rejects, verifies, merges, deletes, imports, uploads, exports, issues, revokes or prints. Never change users, roles, permissions, settings, profile or password.
- Never send communications, notifications, broadcasts, WhatsApp/SMS/email, invites or OTPs.
- You MAY: navigate, open detail pages, open tabs, expand rows, open dialogs/drawers/forms and type into them WITHOUT submitting (then Cancel/Escape), type into search and filter boxes, switch chart ranges, switch language (restore English after), toggle theme or font size (restore after), open the AI assistant and ask it 1–2 read-only questions about the data.
- If a click might mutate something, don't.

SCREENSHOTS (the film uses them full-bleed and pushes in to 1.15x, so quality matters):
- Save viewport shots as PNG to ${SH}/${key}/id-${key}-NN-slug.png (NN = 01, 02…, slug = short kebab). Basenames must be globally unique — keep the id-${key}- prefix.
- Also save element crops of standout components (a card, a QR code, a KPI row, a chart, a status panel, a table with rich data, a map) with agent-browser --session ${session} screenshot <css-selector> path → id-${key}-NN-crop-slug.png. Use get box / eval to find a good selector.
- Phone shots, when your scope asks for them: agent-browser --session ${session} set viewport 390 844 3 (1170x2532 PNGs), named id-${key}-NN-mobile-slug.png.
- Capture "in progress" states the film can animate: a search typed with results filtering, a dropdown/filter open, a dialog or drawer open, a status badge, a tab switch.
- Aim for 10–18 excellent shots (quality over quantity). Hide nothing by editing the DOM, EXCEPT you may scroll the page so the best content fills the viewport.
- For each shot note: what is where (regions in output px), key visible text verbatim (headings, numbers, labels, badges), and data concerns: anything that looks like real personal data, zeros/empty states, errors, placeholder text, odd numbers that tell the wrong story (e.g. falling trends, 0 verified), untranslated keys.

Also write a markdown report of everything to ${SH}/${key}/REPORT.md (same content as your structured answer, human-readable).`

const SITE_STEPS = key => `NO login. Work only in ${SH}/${key}/; a separate "hyperframes capture" may be writing ${P}/capture/ — do not touch ${P}/capture/.
1) Read every route in your scope fully (agent-browser --session <yours> read <url> or get text, scrolling for lazy sections), plus the footer and the language menu (list languages). Write ALL copy VERBATIM (headlines, sub-lines, feature names + descriptions, stats/numbers, claims, CTAs, pricing if any, product names and how each is described) to ${SH}/${key}/site-copy.md, grouped by route and section, with the exact source URL for each.
2) Screenshot the best hero/feature sections @2x (id-${key}-NN-slug.png), including any product mock or diagram.
3) Brand assets: find the logo(s) in the DOM (img src / inline svg); download SVG versions if they exist (curl) into ${SH}/${key}/brand/ — also /favicon.svg, /favicon.ico, the og image(s) and any reversed (white) or single-color logo variant. If a logo exists only inline, save the outerHTML to .svg. Verify each SVG renders (magick → png preview, Read it).
4) Palette + type: with agent-browser eval on the site${PR.login_url ? ` AND the app login page (${PR.login_url})` : ''}, read computed styles: primary button background (and gradient stops), link color, panel colors, text colors, page bg, card border colors, success/warning/danger badge colors, font-family of headings and body. Report exact hex values and where each came from.
Put the verbatim copy + palette + fonts + brand asset list in notes and in REPORT.md. shots = the site screenshots.`

const SHOT = {
  type: 'object',
  properties: {
    file: { type: 'string' }, url: { type: 'string' }, title: { type: 'string' },
    size: { type: 'string' },
    what_it_shows: { type: 'string' },
    visible_text: { type: 'string' },
    film_potential: { type: 'number' },
    animate_idea: { type: 'string' },
    data_concerns: { type: 'string' },
  },
  required: ['file', 'url', 'title', 'size', 'what_it_shows', 'visible_text', 'film_potential', 'animate_idea', 'data_concerns'],
}
const CAP = {
  type: 'object',
  properties: {
    key: { type: 'string' },
    logged_in_as: { type: 'string', description: 'role name only; never an account or password' },
    nav: { type: 'string' },
    shots: { type: 'array', items: SHOT },
    features: { type: 'array', items: { type: 'object', properties: { name: { type: 'string' }, evidence: { type: 'string' }, description: { type: 'string' } }, required: ['name', 'evidence', 'description'] } },
    flows: { type: 'array', items: { type: 'object', properties: { name: { type: 'string' }, steps: { type: 'string' } }, required: ['name', 'steps'] } },
    languages: { type: 'string' },
    theme: { type: 'string', description: 'the UI theme seen (light/dark/both) and its ground color' },
    notes: { type: 'string' },
  },
  required: ['key', 'logged_in_as', 'nav', 'shots', 'features', 'flows', 'languages', 'theme', 'notes'],
}
const MUSIC_SCHEMA = {
  type: 'object',
  properties: {
    file: { type: 'string', description: 'project-relative, trimmed so bar 0 = the first downbeat' }, name: { type: 'string' }, source_url: { type: 'string' }, license: { type: 'string' },
    duration_s: { type: 'number' }, bpm: { type: 'number' }, beat_s: { type: 'number' }, bar_s: { type: 'number' },
    first_downbeat_s: { type: 'number', description: 'in the original download (0 after the trim)' }, drop_s: { type: 'number' }, drop_bar: { type: 'number' },
    bed_lufs: { type: 'number' }, energy: { type: 'string' }, beats_json: { type: 'string' }, why: { type: 'string' },
    runners_up: { type: 'array', items: { type: 'object', properties: { name: { type: 'string' }, file: { type: 'string' }, bpm: { type: 'number' }, note: { type: 'string' } }, required: ['name', 'file', 'bpm', 'note'] } },
  },
  required: ['file', 'name', 'source_url', 'license', 'duration_s', 'bpm', 'beat_s', 'bar_s', 'first_downbeat_s', 'drop_s', 'drop_bar', 'bed_lufs', 'energy', 'beats_json', 'why', 'runners_up'],
}

phase('Capture')
const capJobs = SCOPES.map(r => () => {
  const session = `cap-${r.key}`
  const task = expand(r.task).replaceAll('SESSION_NAME', session)
  const scope = SITE && r.key === SITE.key ? `${task}\n\n${SITE_STEPS(r.key)}` : task
  return agent(`${base(r.key, session)}\n\nYOUR SCOPE (key "${r.key}"):\n${scope}`, { label: `capture:${r.key}`, phase: 'Capture', schema: CAP, effort: 'high' })
})

const ANALYZE = A.skills
  ? `BPM, downbeats and the drop: uv run --no-project --python 3.12 --with librosa --with numpy --with soundfile python ${A.skills}/music-to-video/scripts/analyze-beatgrid.py <file>.mp3 -o <file>.audiomap.json (first run downloads ~100 MB of wheels). Read tempo.bpm, grid.downbeats_sec and energy_phases (the drop = the first HIGH phase start, snapped to the nearest downbeat). Cross-check with the ebur128 envelope.`
  : 'BPM: 60 / median interval between strong onsets from the beats JSON (it has onsets {time, strength} only, no bpm or downbeats); downbeats: the strongest onset every 4 beats near the start; drop: the ebur128 jump.'
const musicJob = () => agent(`You are one worker preparing a ~55-second, music-only launch film for ${ABOUT}
Tone: ${A.music.mood}. ${SOLO}

TASK: pick the music bed. Source: Mixkit free stock music (Mixkit License: free for commercial use, no attribution). Tracks download from https://assets.mixkit.co/music/<id>/<id>.mp3 and pages are https://mixkit.co/free-stock-music/... (browse with curl or agent-browser --session music …; close it after).
Requirements: 118–128 BPM, steady 4/4, a clear quiet-ish intro that BUILDS and a real DROP/lift around 12–18 s into the track, full energy after the drop, ≥ 60 s long (we need ~56 s + fade), modern production. Avoid: ${A.music.avoid || 'nothing specific'}.
Method:
1. Shortlist 6–10 candidates by name/tags/description, download them to ${A.scratch}/work/music/.
2. For each: ffprobe duration; loudness envelope with ffmpeg ebur128 (ffmpeg -nostats -i f -af ebur128 -f null - 2>&1 | grep 'M:' → momentary loudness per 0.1 s) to find the build and the drop (a jump of ≥ 4–6 LU sustained). Onset grid with HyperFrames: make a temp project dir ${A.scratch}/work/music/probe-<id>/ containing a copy of the mp3 and an index.html like <!doctype html><html><body><div id="root" data-composition-id="root" data-width="1920" data-height="1080" data-start="0" data-duration="60"><audio id="bgm" data-timeline-role="music" class="clip" src="<file>.mp3" data-start="0" data-duration="60" data-track-index="11"></audio></div></body></html>, then (cd there) HYPERFRAMES_BROWSER_PATH=${A.browser} npx -y hyperframes@${A.hf} beats . and read beats/<file>.mp3.json. ${ANALYZE}
3. Pick the best one. Prefer a drop that lands on a bar line at 12–18 s so the product reveal can hit it. Compute beat_s = 60/bpm, bar_s = 4 × beat_s, first_downbeat_s, drop_s (snapped to the nearest downbeat).
4. The film's grid assumes bar 0 starts at t = 0. If first_downbeat_s > 0.03, trim: ffmpeg -ss <first_downbeat_s> -i <track>.mp3 -c:a libmp3lame -q:a 2 ${P}/assets/music/<slug>-cut.mp3 (mkdir -p), else copy it as ${P}/assets/music/<slug>.mp3. Re-run beats on the file you keep (probe dir as above) and copy its JSON to ${P}/beats/assets/music/<that file name>.json. All times you report (drop_s, energy) are in the kept file; drop_bar = drop_s / bar_s (a whole number; say if not).
5. bed_lufs: ffmpeg -nostats -t 56 -i <kept file> -af ebur128 -f null - 2>&1 | grep -E '^\\s+I:' (integrated LUFS of the first 56 s).
6. Copy the top 2 runners-up to ${P}/assets/music/alt/.
Describe the energy curve second by second in words (energy field), e.g. "0–6 s sparse pads, 6–15 s build with risers, 15.2 s drop, …, 52 s outro".`, { label: 'music', phase: 'Capture', schema: MUSIC_SCHEMA, effort: 'high' })

const all = await parallel([...capJobs, musicJob])
SCOPES.forEach((r, i) => { if (!all[i]) log(`capture:${r.key} returned nothing`) })
const caps = SCOPES.map((r, i) => (all[i] ? { ...all[i], key: r.key } : null)).filter(Boolean)
const music = all[SCOPES.length]
log(`captured ${caps.reduce((n, c) => n + c.shots.length, 0)} shots across ${caps.length}/${SCOPES.length} scopes; music: ${music ? `${music.name} ${music.bpm} BPM drop ${music.drop_s}s, ${music.bed_lufs} LUFS` : 'FAILED'}`)
if (!caps.length) return { caps, music, syn: null, ver: null }

phase('Synthesize')
const SYN = {
  type: 'object',
  properties: {
    message_candidates: { type: 'array', items: { type: 'string' } },
    recommended_message: { type: 'string' },
    angles: { type: 'array', items: { type: 'object', properties: { key: { type: 'string' }, brief: { type: 'string' } }, required: ['key', 'brief'] } },
    hero_screens: { type: 'array', items: { type: 'string' } },
    theme: { type: 'string', enum: ['dark', 'light'] },
    palette: { type: 'string' },
    fonts: { type: 'string' },
    endcard: { type: 'string' },
    data_warnings: { type: 'array', items: { type: 'string' } },
    open_questions: { type: 'array', items: { type: 'string' } },
    summary: { type: 'string' },
  },
  required: ['message_candidates', 'recommended_message', 'angles', 'hero_screens', 'theme', 'palette', 'fonts', 'endcard', 'data_warnings', 'open_questions', 'summary'],
}
const siteCopy = SITE ? `${SH}/${SITE.key}/site-copy.md` : null
const syn = await agent(`You are the lead researcher for a launch film for ${ABOUT}
The film: HyperFrames, ~55 s, music-only, on-screen type is the whole script; quality bar = Linear/Raycast/Arc launch films on X. ${SOLO}

INPUTS:
- Capture reports (JSON below) and ${SH}/*/REPORT.md${siteCopy ? `, ${siteCopy}` : ''}, screenshots in ${SH}/*/ (to LOOK, make previews: magick <png> -resize 1000x ${A.scratch}/work/capture/syn-<name>.jpg, then Read; never Read 3200-px originals).
- The HyperFrames site capture at ${P}/capture/ (extracted/tokens.json, visible-text.txt, design-styles.json, screenshots/, assets/) if present.
- Reference outputs from a previous film to copy the FORMAT (not the content): ${A.reference}/capture/extracted/brand-facts.md and ${A.reference}/capture/extracted/asset-descriptions.md.
- Music: ${JSON.stringify(music)}
- Capture reports: ${JSON.stringify(caps)}

WRITE:
1. ${P}/capture/extracted/brand-facts.md — verified truth only, every line with its source (URL or screenshot file): identity (product names and how they relate), one-line descriptions verbatim, the audience, the roles and permissions as captured, features (each with evidence), languages, accessibility, any AI assistant, numbers shown in the demo (mark them "demo data, do not claim"), pricing (say so if there is none), CTAs, palette (exact hex with source; name ONE primary accent and its gradient partner if any, plus neutrals and semantic colors), fonts (family + where used; if the brand family has no variable woff2 in ${P}/assets/fonts/, download one from Google Fonts / fontsource into ${P}/assets/fonts/ and note the @font-face), the look of the product (UI theme and ground color, cards, radii, shadows, icon style), and an AVOID list (claims we can't prove, data concerns found by the capture agents, real-looking personal data). Never write a password or login name.
2. ${P}/capture/extracted/asset-descriptions.md — choose the 14–22 best assets for a film (hero screens, crops, phone shots, logos, og image). For each: path (assets/<basename>), pixel size (identify), what is where (regions), visible text verbatim, best use in a film (push-in target, crop regions, which element could be rebuilt as a vector overlay to animate), and warnings. Also list the brand marks with their colors and which background they work on.
3. Copy every chosen asset FLAT into ${P}/capture/assets/ (keep basenames; create the dir if missing) and ALSO into ${P}/capture/assets/app/ (screens) or ${P}/capture/assets/brand/ (logos/og). The pipeline's stage-assets only finds files flat in capture/assets.
4. ${P}/.hyperframes/research.md — the story material: the problem the product solves (from site copy), the strongest proof moments visible in the demo (which screen proves what), 5–8 candidate one-line messages (≤ 8 words, benefit-led, from site copy where possible), 3 distinct story angles (statement-led / product-led camera journey / before-after, adapted to this product; each angle = a paragraph naming the screens it would use and the drop moment), a proposed end card (logo lockup, message, public URL, and price — or the site's own CTA when there is no public price), and open questions for the product owner.
theme: the film's ground. ${PR.theme ? `The orchestrator chose ${PR.theme}; return it, and put any mismatch with the product UI in open_questions.` : 'Pick dark or light to match the product UI and brand.'}
Rules: claims ONLY from the site copy or what the demo visibly does. No invented stats, customers, logos or testimonials. Flag demo numbers — they are demo data, not claims.`, { label: 'synthesize', phase: 'Synthesize', schema: SYN, effort: 'xhigh' })

phase('Verify')
const VER = {
  type: 'object',
  properties: {
    removed: { type: 'array', items: { type: 'string' } },
    corrected: { type: 'array', items: { type: 'string' } },
    missing_assets: { type: 'array', items: { type: 'string' } },
    staged_flat: { type: 'number' },
    credential_hits: { type: 'number', description: 'credential strings found (and removed) in project files' },
    summary: { type: 'string' },
  },
  required: ['removed', 'corrected', 'missing_assets', 'staged_flat', 'credential_hits', 'summary'],
}
const secretStrings = [PROBE, ...loginValues].filter(Boolean)
const ver = await agent(`You are an adversarial fact-checker for a product launch film. ${SOLO}
Check ${P}/capture/extracted/brand-facts.md, ${P}/capture/extracted/asset-descriptions.md and ${P}/.hyperframes/research.md line by line against the sources: ${siteCopy ? `${siteCopy}, ` : ''}${SH}/*/REPORT.md, the screenshots in ${SH}/ (preview with magick -resize 1000x into ${A.scratch}/work/capture/ver-*.jpg and Read), and — for anything still doubtful — the live site with agent-browser --session verify (read-only; close it after${A.secrets_file ? `; logins are in ${A.secrets_file} if you need the app — never copy them into any project file` : '; do not log in to the app'}).
- Every claim must be verbatim or visibly demonstrated. Remove or correct anything that isn't; move demo figures to the "demo data, do not claim" list.
- Every asset listed must exist flat in ${P}/capture/assets/ with the stated pixel size (identify). Copy missing ones from ${SH}/ if possible; list the rest as missing.
- Hex colors: re-derive the primary accent from the screenshots (magick <png> -crop … -format '%[hex:u.p{0,0}]' info:) and the computed styles; correct if wrong.
- Credentials: ${secretStrings.length ? `for s in ${secretStrings.map(q).join(' ')}; do grep -rnF -- "$s" ${P} --include='*.md' --include='*.json' --include='*.html' --include='*.txt'; done — replace every hit with "<redacted>" and count them in credential_hits.` : 'no credential strings were passed; set credential_hits to 0.'}
Edit the files in place.`, { label: 'verify:facts', phase: 'Verify', schema: VER, effort: 'high' })

return { caps, music, syn, ver }
