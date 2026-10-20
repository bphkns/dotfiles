# Leapcast — brand and product facts (verified from the site capture and the app source)

## Identity

- Product: **Leapcast** (always lowercase in the wordmark, "Leapcast" in prose). A Trueleap Inc. product. Currently tagged "beta".
- AI assistant: **Ori** (pink hourglass mark). Ori answers questions during and after meetings, recalls past meetings, drafts summaries, action items, digests ("What lies ahead" at 07:00, "Your day" at 18:00) and can schedule meetings.
- Site tagline: "The intelligent collaboration & broadcast platform".
- Hero headline: "Turn every live conversation into lasting intelligence".
- Social card headline: "Meetings that keep working after the call".
- Section lines: "Important conversations happen every day. Most of their value disappears." · "Meet. Understand. Act." · "The meeting ends. The room keeps working." · "AI that moves work forward" · "Where conversations drive real outcomes." · "Build intelligent video into your platform."
- Positioning sentence: "Leapcast unifies meetings, spaces, live broadcasts, and AI to turn conversations into knowledge, action, and impact."
- Problem framing (site): Scattered conversations · Lost intelligence · Broken follow through · Invisible outcomes.
- The flow: **Meet → Understand → Act.**
- Core capabilities (site carousel): Engagement insights · Intelligent summaries · Decisions and action items · Searchable knowledge · Content and clips · Automated follow through.
- Session signals captured: Audio, Video, Chat, Polls, Files, Reactions. Outputs: Summaries, Action items, Clips, Reports, Analytics, Knowledge.
- Real product features (from the app): browser-based meetings (no install), persistent rooms, up to 25 participants, screen share, live captions (CC), live transcription, cloud recording, chat with reactions, polls, raise hand, notes, agenda, Ori tab inside the meeting, post-meeting summary + decisions + action items, transcripts library, recordings library, team analytics, Intelligence signals, meeting digests by email, Slack and WhatsApp delivery, MCP connector, React chat SDK for developers.
- Pricing (site): "One plan. Every feature. Pay for what you capture." Joining is always free. Hosting from **$5/month with 240 AI minutes included** (or $60/year). Extra minutes from $0.05/min, never expire. No long-term contracts, cancel anytime.
- Developer: `@leapcast/chat` React SDK, `createChatClient({ apiUrl: 'https://api.leapcast.ai', … })`.
- URL: leapcast.ai

## Colors (hex; from the site's tokens and the app screenshots)

- Terracotta / brand primary: **#D73D13** (site `--primary`, oklch 58.51% .1969 34.7). The app's wordmark and buttons render a slightly softer terracotta **#C96442** (`--sidebar-primary`) and a lighter tint **#D97F60**. Use #D73D13 for punches, #C96442 for UI buttons/avatars.
- Ori pink: **#FC097F**.
- Near-black canvas: **#0C0B0E** (meeting room ground), **#010209** (social card), app surface **#17191A**, card **#202124**, raised **#262624**.
- Off-white text on dark: **#F4F4F5** / **#C3C0B6** (muted). Cream (light theme only): **#FBF9F6**.
- Success green: **#3FA65A** (transcribing dot, "Open recording" buttons). Recording red: **#E5484D**.
- Chart oranges: #CB3900 · #D97F60.

## Type

- Display: **Schibsted Grotesk** (600–800, tight tracking). Body/UI: **Inter** (400–600). Both shipped in `assets/fonts/`.

## Look of the product

Dark, calm, low-chrome UI; rounded 12–16 px cards with 1 px hairline borders; terracotta as the only accent, pink only for Ori; orange charts; name pills on video tiles; a pill-shaped bottom control bar.
