# Asset Descriptions — Leapcast (canonical inventory)

All paths are relative to the project root. Every asset here is a REAL Leapcast asset: captured from https://leapcast.ai, or copied from the Leapcast web app's own public folder (`apps/leapcast-public/public`). Nothing is mocked. Screens are dark-theme product screenshots at ~3020×1650 (retina), so they can be cropped/zoomed generously.

## Brand marks (`capture/assets/brand/`)

- `leapcast-wordmark-nobg.svg` — the "leapcast" wordmark (italic, blocky custom lettering) with transparent background. Fill is the brand terracotta. Use for logo lockups and the end card.
- `logo_white.png` — the wordmark in white on transparent (for dark grounds when a monochrome mark is wanted).
- `logo_basic.png` — the wordmark in terracotta on transparent.
- `leapcast-mark.svg` — the Leapcast icon: a terracotta lightning-bolt mark on a cream square (BIMI). Square, 64 viewBox.
- `leapcast-mark-1024.png` — the same lightning mark, 1024 px PNG.
- `og-dark.png` — 1200×630 social card: terracotta wordmark + "beta" tag, headline "Meetings that keep working after the call" in white on near-black `#010209`.
- `og-light.png` — the light variant of the same card.
- `ori-mark.svg` — Ori's brand mark: a pink (`#FC097F`) S-curved hourglass glyph. Ori is Leapcast's AI assistant. Use whenever Ori is on screen.
- `ori-logo-full.svg` — the full "Orian/Ori" logo lockup with the pink hourglass mark.
- `quick-video.svg`, `quick-calendar.svg`, `quick-broadcast.svg`, `quick-code.svg` — the dashboard's quick-action icons (start meeting, schedule, broadcast, developer). Simple stroke icons.
- `users-new.svg`, `settings-new.svg`, `search-new.svg`, `grid-new.svg`, `check-new.svg`, `calendar-empty-new.svg`, `send-horizontal.svg`, `ori-panel-mark.svg`, `ori-panel-send.svg`, `ori-panel-suggestion.svg`, `ori-panel-close.svg` — dashboard UI stroke icons (people, settings, search, grid, check, calendar, send, Ori panel chrome).

## Product screens (`capture/assets/app/`) — the hero evidence

- `hero_img_1_dark.webp` (3020×1646) — **Live meeting room**: "Instant meeting · 8:14", 7 participants in a 4+3 video tile grid with real faces (Amara, Mei, Rituraj Pathak, Sofia, Priya, Carlos, Hiroshi), each tile with a name pill and muted-mic badge. Right side panel with tabs "Chat · People 7 · Agenda · Ori" (Ori tab has the pink hourglass), a chat thread with emoji reactions, and a message composer. Bottom control bar: mic, camera, share screen, CC captions, reactions, raise hand, record (red), layout grid, notes (orange, active), people (badge 7), effects, share, more, and a red "End" button. Top-right: "Notes · Off" and participant count.
- `hero_img_2_dark.webp` (3024×1650) — **Team analytics** (Home → Team Analytics tab): sidebar (Home, Calendar, My meetings, Ori, Intelligence, Library: Transcripts, Recordings; workspace "Rituraj Personal" with People & groups, Team settings, Billing). KPI row: "Meetings this week 14 (+11 vs prior week)", "Hours this week 12.1", "Recording coverage 18%", "Average participants 1". Charts: "Recordings over 30 days" (orange bars), "Where meeting time went" (horizontal bars: Daily standup, Product update…), "Meeting minutes per day" (orange area line), "When you meet" (bars by hour).
- `hero_img_3_dark.webp` (3024×1650) — **Intelligence** page: KPI strip "Meetings 45 · Meeting time 54h 14m · Unique attendees 4.1 · Engagement 19 · Agenda timing 19%". A "Signals" panel with five cards: "Engagement rate falling −86%", "Agenda timing variance 6 of 7 measured", "Uneven talk time 11 of 18 measured", "Late arrivals 2 of 42 measured", "Connection issues 20 of 39 measured", each with a one-line recommendation ("Open with a poll or a quick round-robin…"). Below: "Trends" charts — Engagement, Unique attendance, Chat activity, Talk balance (orange bars/lines with dashed running averages).
- `hero_img_4_dark.webp` (3024×1650) — **My meetings → Sessions**: a list of completed sessions ("Mon 17 Aug · 19:00 · 80 min · 18 participants · Completed", with chips Recording / Transcript / Summary). Right: "Session analytics — 1 decision · 4 action items", buttons "Open recording" / "Open transcript" (green), stats "80 Duration (min) · 15 Peak participants · 67 Engagement events", Participation and Engagement mini charts, then **Summary** paragraph ("During the call, Bikash Phukan agreed to send over filled information while Sandip Bordoloi requested…"), **Decisions** ("1. The team agreed to leave the current meeting and proceed to the design meeting."), **Action items** ("Find time tonight to go through the information — Unassigned · tonight", "Send the filled form/information to Sandip — Bikash Phukan", "Deploy the requested item…").
- `hero_img_5_dark.webp` (3024×1646) — **Recordings library**: "Recordings — Watch recordings from your recent meetings", "10 RECORDINGS", a grid of recording cards with dark navy poster tiles ("Women in AI USA online event · 17 AUG 2026 · 23:24", "Weekly product design review · 96:17", "Daily Design Review · 2:30", "Daily standup · 80:04", "Instant meeting…"), each with "REC" badge, host name, duration, "Available" chip, orange "Play recording" button and "Download".
- `hero_img_6_dark.webp` (3016×1646) — **Post-meeting page**: "You left the meeting — Instant meeting · 1 participant", orange "Rejoin" button, "Write a review", 5-star "Rate this meeting", a "Meeting details" card ("Notes, transcript and recording land on the details page once this meeting wraps up." → "Go to meeting details →"), and an orange "⚡ Chat With Ori" button. Right half: an Orian promo card ("The conversation doesn't have to end instantly. Join your team's space on Orian…") with WhatsApp and Slack tiles.
- `meeting-avatars-recording.png` (2192×1636) — **Live meeting, camera-off**: 7 tiles with terracotta initial avatars (JO, BO, PE, JA, AL, MA, RP), top bar shows "Notes · On", "● Transcribing" (green) and "● Recording · 0:21" (red), participant count 7. Control bar with the record button green/active. Good for the "recording + transcribing live" proof.
- `hub-center.png` (1190×640) — **Ori side panel next to a meeting** ("Q4 Planning · leapcast.ai/q4-planning"): 8 avatar tiles (Sarah Chen, Alex Rivera, Maya Patel, Jordan Kim…), and a right panel where Ori answers a prompt, "Created a design plan", then lists **ACTION ITEMS** ("Ship pricing page — @sarah", "Send recap deck to client", "Book design review — @maya") and asks "Would you like me to add tablet and phone breakpoints next?", with an "Add follow up…" composer. The best single image of Ori working inside a meeting.
- `hub-summaries.png` (260×640) — a tall narrow **summary card** from the site's feature carousel (Summary · 2 min read style).
- `hub-decisions.png` (1100×719) — **decisions / action-items card** (feature illustration from the site).
- `hub-knowledge.png` (1100×719) — **searchable knowledge / transcript search** illustration (a highlighted "launch date" in a transcript).
- `hub-content.png` (1100×719) — **content & clips** illustration (Highlight · 0:42, Recap clip, Report, Shareable).
- `hub-followthrough.png` (1100×719) — **automations** illustration (Follow-up email · Sent, Create tasks · Linear, Share recap · Slack).
- `hub-engagement.png` (540×1000) — tall **engagement insights** card (92% participation, 10h 27m talk time, 0.72 balance).

## Marketing site captures (`capture/assets/`, `capture/screenshots/`)

- `leapcast-live-meeting.webp`, `leapcast-team-analytics.webp`, `leapcast-analytics-overview.webp`, `leapcast-session-analytics.webp`, `leapcast-meeting-recordings.webp`, `leapcast-post-meeting.webp` — the same six product screens as served by leapcast.ai (duplicates of `app/hero_img_*_dark.webp`).
- `og-image.png` — the light social card.
- `capture/screenshots/scroll-000.png … scroll-082.png` — 1920×1080 screenshots down the leapcast.ai homepage (light cream theme, terracotta accents): hero "Turn every live conversation into lasting intelligence", the problem section, "Meet. Understand. Act.", the capabilities carousel, use-case tabs, the developer SDK block with `room.ts` code, pricing, and the "Ask Ori about Leapcast" FAQ.
- `capture/assets/svgs/*.svg` — site icons (unlabeled; prefer the named brand icons above).

## Fonts (`assets/fonts/`)

- `InterVariable.woff2`, `InterVariable-Italic.woff2` — Inter variable (body / UI). Official release from rsms.me.
- `SchibstedGrotesk-latin.woff2` — Schibsted Grotesk variable 400–900 (display headings), from Google Fonts. Leapcast's display face.

## Audio (`assets/sfx/`, `assets/music/`)

- `assets/sfx/*.mp3` — the HyperFrames bundled SFX library (whoosh, whoosh-short, whoosh-cinematic, impact-bass-1/2, riser, pop, click, click-soft, key-press, typing, chime, ping, notification, sparkle, glitch-1/2/3, error). Credits in `assets/sfx/CREDITS.md`.
- `assets/music/` — the chosen background track (Mixkit free license, no attribution required). See `BRIEF.md` → Assets.
