# Product profiles

## Leapcast — DONE (reference build, 2026-09-25)

- **Where:** `~/product-demos/leapcast/` (moved out of the old `launch-video` worktree on 2026-09-25; not a git repo).
  - Final film: `renders/leapcast-launch.mp4` (56.1 s, 1080p30, −14 LUFS).
  - Contact sheet: `renders/leapcast-launch-contact-sheet.jpg`.
  - The templates that matter are also copied into this skill's `examples/leapcast/`.
- **Templates in `examples/leapcast/`:**
  - `BRIEF.md`, `frame.md` ("Leapcast Dark — Frame"), `STORYBOARD.md`, `sfx-cues.json` (the project's `.hyperframes/sfx-cues.json`);
  - `capture/extracted/brand-facts.md` and `asset-descriptions.md` (the format `workflows/capture.js` copies);
  - three frames in `compositions/frames/`: `05-room-lights-up.html` (camera world with `cam()`, knockout wordmark over the live room on the drop), `08-nothing-lost.html` (the ghost fly-back signature and vector pill rebuilds), `13-end-card.html` (centred lockup, price, held still).
- **Asset sources:**
  - the leapcast.ai capture (`capture/assets/`): `leapcast-wordmark-nobg.svg`, `ori-logo-full.svg`, `meeting-avatars-recording.png` (none of these is in the repo);
  - `apps/leapcast-public/public`: `hero/hero_img_{1..6}_dark.webp` (six retina screens: live room, team analytics, Intelligence, sessions with summary/decisions/actions, recordings, post-meeting), `hub/*.png` (copied as `hub-<name>.png`), `brand/ori-mark.svg`, `brand/og-dark.png`, `brand/og-light.png`.
- **Brand:**
  - Terracotta `#D73D13` for punches, `#C96442` for UI and the wordmark (the SVG ships with cream fills; recolor it), `#D97F60` tint.
  - Ori pink `#FC097F`, only on Ori.
  - Canvas `#0C0B0E` (theme `dark`).
  - Schibsted Grotesk for display, Inter for UI.
- **Music:** Mixkit "Deep Urban" (id 623), 124 BPM, drop at bar 8 = 15.48 s, bed −10.1 LUFS. The film is 29 bars.
- **Story that won:**
  - "One call, played twice": a happy call nobody wrote down ends and its action items blur away; "Same call. One difference."
  - Drop: the knockout wordmark over the live room.
  - Then: Ori in the room → post-call page → the lost items fly back with owners (the signature) → recordings search → Ori digests at 07:00/18:00 → Signals → "Nothing to install" → end card with the price.
- **Open with the user:** real names in the screenshots (Bikash Phukan, Sandip) are shown. The screenshots are already public on leapcast.ai.

## TrueLeap Digital ID — DONE (EN + FR, 2026-09-25)

- **Where:** `~/product-demos/digital-id/` (EN, `renders/digital-id-launch.mp4`) and `~/product-demos/digital-id-fr/` (FR, `renders/digital-id-launch-fr.mp4`) (the user asked for `/home/product-demos`, which needs root; not a git repo). Truth: `capture/extracted/brand-facts.md`, `asset-descriptions.md`, `.hyperframes/research.md`; design args `.hyperframes/args.design.json`.
- **Product:** "Secure digital identity for every student. Issue, manage, and verify digital IDs from one unified platform." (`/id` login). Part of the TrueLeap Digital Twin platform ("The sovereign OS for education networks"). Demo: `https://demo.digi2in.ai/` → Login menu → Digital ID (`/id`), Digital Twin (`/twin`), Parent Portal (`/enroll`).
- **Screens:** captured with `workflows/capture.js` (agent-browser, 9 roles + parents, read-only, 2×). About 270 shots in `.hyperframes/shots/<role>/`; 19 staged. Demo logins come from the user; keep them in `<scratch>/secrets/`, never in the project.
- **User decisions (2026-09-25):** name "TrueLeap Digital ID", URL `digi2in.ai`, CTA "Request Executive Briefing →", no price. Keep the DRC map, names and portraits (demo data), but **hide the national coat of arms** on the ID card. Audience: ministries and administrators (B2G).
- **Brand:** theme `light`, ground `#FBFAF7`. The one accent is the gradient `#4F46E5 → #7C3AED`. Green `#22C55E` means verified only; red `#EF4444` means pending only. Navy `#14185A → #080A2B` for a few statement frames. Film type is Inter. The app screenshots render in Liberation Sans (Geist is declared but never loads), so vector rebuilds of UI use Liberation Sans/Arial.
- **Demo defects to mask:**
  - "Kinshasaaa";
  - "Sernie Admin" and other test names;
  - the "Integrity compromised" badge on every record;
  - verification at about 0.04% (never show verified/unverified counts);
  - the "Digital Twin" sub-line under the admin logo.
- **Never claim:** QR or scan-to-verify (`/id/verify` is a 404), offline or edge AI, anything marked "coming soon", or the certifications.
- **Music:** Mixkit "Ramp It Up" (id 69), 120 BPM, trimmed −0.117 s so bar 0 is the first downbeat (`assets/music/ramp-it-up-cut.mp3`). Drop at bar 8 (16.0 s), lift at bar 16 (32.0 s), breath at bar 24 (48.0 s). The film is 28 bars = 56 s; `bed_lufs` −11.9.

## Orian — LATER (checked against the sources 2026-09-25)

- **What it is:** orian.ai, "Community Intelligence", a waitlist (the default hero is `hero.update` in `src/locales/en/home.json`: "Turning events, conversations, and knowledge into meaningful relationships, scalable impact, and compounding growth").
  - `og_general.png` and the footer tagline: "Where communities become intelligent ecosystems".
  - The copy is split by audience segment (`hero.<segment>`):
    - general: "Get Early Access To The Community Super App";
    - startups: "Your community already lives on Slack. Now make it actually work." ("Orian layers on top of Slack and Discord");
    - afterschool: "12 WhatsApp groups / Zero organization" ("Orian works alongside WhatsApp");
    - edtech_india: "8 WhatsApp groups / 3 Telegram channels / One exhausted admin", "Your batch OS. Not another edtech platform.", "Batch 2024 results. Batch 2025 prep. Batch 2026 enrollment. One community, every cycle."
  - Pick ONE segment with the user before writing BRIEF.md. Locales: en, es, fr, hi, id.
- **Ori:** Orian's AI (leapcomm's public hero: "The brain behind Orian"; orian.ai's beta benefits: "First to deploy Ori"). Leapcast's post-meeting page (`libs/leapcast-stream/meeting/EndMeetingNew.tsx`) promotes it: "The conversation doesn't have to end instantly." / "Join your team's space on Orian — threads, events and updates that keep momentum between meetings."
- **Sources to mine:**
  - `~/work/orian-waitlist` is the orian.ai site source.
    - Brand tokens are in `src/styles/theme.css` (light-first, `color-scheme: light`): magenta `#FF1F8F` (primary; the i-dot and the hourglass mark in `public/logo.svg`), navy `#081B4B`, midnight `#050816` (text), cloud `#F8F9FB` (bg), mist `#D9DEE8`, teal `#2DD4BF` (secondary).
    - Fonts (`src/styles/app.css`, Google Fonts): Hanken Grotesk (headings), Source Sans Pro (body), Google Sans Flex (card headers).
    - The `#0A0A0A`/`#737373`/`#F5F5F5` neutrals are hardcoded in the home-section mock components (`src/components/home/*-content.tsx`), not brand tokens.
    - `public/`: `logo.svg` (the Orian wordmark with the magenta hourglass), `bimi.svg`, `favicon.svg`. Og images: only `og_general.png` (1200×630, "Where communities become intelligent ecosystems") and `og_first_orbit.png` (1200×630, "Orian First Orbit") are Orian-branded. `og-image.png`, `og-image-new.png`, `og_startup.png`, `og_edtech.png` and `og_afterschool.png` are LeapSpace.ai (green frog mark): never use them.
  - `~/work/v2/apps/v2` is the RIA web app; its header brands as "Orian.ai". `public/logo.svg` is the Orian wordmark (identical to orian-waitlist's). `logo-white.svg`, `logo-black.svg` and `leapy.svg` are the LeapSpace frog: not Orian. The dev app is `https://ori-dev.orian.ai` (behind Google IAP).
  - `~/work/v2/apps/leapcast-public/public/brand/promo/`: `promo-orian-app.jpg` (1200×657, an Orian app promo shot) and `promo-orian-logo.png` (300×169).
  - `~/work/leapcomm` is Ori (live at `agentori.bot`), "The brain behind Orian" (its public hero). It is a light-first community super app: an inbox across Slack/WhatsApp/email, CRM, events, a content studio and the @Ori agent. Brand: signal pink `#FC097F` on paper `#FAF9F6` (`src/styles/globals.css`); marks in `public/brand/agentori-*`. Feature truth: `PRODUCT.md` Part 2 (code-verified).
  - Socials (for tone; unverified, from memory; confirm before quoting): linkedin.com/showcase/orianai, instagram @orian_orbit, substack/medium @orianorbit, slack orianorbit.
- **Gaps to close in step 1:**
  1. **The one message.** Ask the user, or take it from the chosen segment's hero or `og_general`.
  2. **Real product screens (blocking; ask first).** None exist in any repo. leapcomm's `dogfood-output/` screenshots are 1280 px wide with QA annotation boxes, so they are unusable. Ask the user (question tool): (a) which app the film shows: the RIA web app (`apps/v2`, dev `ori-dev.orian.ai`, behind Google IAP) or Ori (`~/work/leapcomm`, live at `agentori.bot`); (b) whether they'll supply ≥ 2560 px-wide screenshots, or approve seeding a demo community in dev with fictional names and capturing it at 2× DPR with `workflows/capture.js`. Never seed or write to any environment without that approval. Never mock the UI in HTML beyond the one moving element per shot.
  3. **Pricing and CTA:** orian.ai has no price list; it is a waitlist. The end card is wordmark + message + orian.ai + "Join the waitlist" (or "Get Early Access", the site's own wording). Allowed pricing claim: "Usage-based credits". The `$29/mo`, `$99/mo`, `$12,480` and `$77k raised` figures in `home.json` are mock UI values: never put them in brand-facts.md.
  4. **Palette:** magenta `#FF1F8F` IS Orian's single accent. Ori's `#FC097F` is visually the same pink, so in an Orian film don't treat Ori as a separate color; use `#FF1F8F` for both. Decide a light (cloud `#F8F9FB`, theme `light`) or dark (midnight `#050816`, theme `dark`) ground with the user.
  5. **Audience:** community and cohort operators (the segments above).
  6. **Exclude from brand-facts.md:** event dates ("Unveiling at SXSW 2026", now past), parent-company reach ("Serving millions of learners globally."), waitlist counts, and every mock figure in `home.json` (goals, raised, tier prices). They are illustrative or stale.
- **Story angles to pitch (seed ideas for `args.angles`; replace freely):**
  1. Statement-led on the chosen segment's own lines (e.g. general: "Community Intelligence", then the platform features).
  2. Product-led camera journey: through the community space, events, the inbox, and Ori following up on WhatsApp and Slack.
  3. Before/after: scattered groups, spreadsheets and lost chats (the segment's "12 WhatsApp groups / Zero organization"), then one Orian space where Ori follows up.
