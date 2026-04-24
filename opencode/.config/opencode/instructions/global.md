- Be extremely concise, less reading overhead. Sacrifice grammar for the sake of concision.
- Make the plan extremely concise. Sacrifice grammar for the sake of concision.
- At the end of each plan, give me a list of unresolved questions to answer, if any.
- When you need to search docs, use `context7` tools.
- If you are unsure how to do something, use `gh_grep` to search code examples from GitHub.
- Use exa tools when required for searching

## Coding Rules

- strict types
- no type assertions
- no non-null assertions
- use early returns
- defensive programming by default
- keep functions direct and small
- prefer library defaults
- do not hand-roll features the chosen library already provides
- do not over-engineer
- do not add compatibility code unless there is a real migration need
- no global DB caching by default

---

1. General Coding Rules (Tailwind/HTML)
   Markup:

- Never apply text-_ / leading-_ to inline elements (<span>, <a>) -- only block elements
- Never add redundant display classes (block on <div>, inline on <span>)
- Never apply conflicting classes for the same property
- Always add role="list" to <ul>/<ol> unless list-style-\* is applied
  Tailwind:
- Always antialiased on root, isolate on main container
- Use gap-_ on parent, never mt-_/mb-_/mx-_ between flex/grid children
- Prefer size-{n} over h-{n} w-{n} when equal
- Use --spacing(...) for arbitrary spacing, never calc(var(--spacing)\*...)
- Use rem for font sizes, px for borders/outlines
- Use tabular-nums on changing numbers (counters, prices, stats)
- Never use named line-heights (tight, snug) -- only spacing scale (leading-6)
- Never use min-h-screen (deprecated) -- use min-h-dvh/svh/lvh
- Use bg-linear-_ not bg-gradient-_, shrink-_ not flex-shrink-_
- Use not-\* variants instead of setting base + conditionally overriding
- Set CSS variables with arbitrary property syntax, not inline styles
- Use @utility for reusable styles (works with all Tailwind variants)

---

2. Colors

- Never default to indigo as brand color
- Never default to gray-_ or slate-_ for neutrals -- prefer zinc-_ or neutral-_
- Never use solid colors for dividers -- use opacity-based (border-gray-950/10)

---

3. Typography

- Never text-xs for body text -- minimum text-sm at sm: breakpoint, text-base on mobile
- Never font-bold on headings -- use font-semibold or font-medium
- Never add leading-\* to headings -- use Tailwind defaults
- text-balance on headings, text-pretty on paragraphs
- tracking-tight on headings larger than text-xl
- Never uppercase on eyebrow text unless monospace font (then add tracking-wide)
- Constrain text width with max-w-[*ch] directly on the element
- Default font: Inter (loaded from rsms.me, not Google Fonts) with OpenType features cv02, cv03, cv04, cv11
  Heading groups (marketing sections):
- Never constrain the wrapper width -- constrain each text element individually
- max-w-[*ch] scales with font size: text-4xl → max-w-[35ch], text-6xl → max-w-[24ch], etc.
- Switch to left-aligned when subheadline exceeds ~120 chars

---

4. Buttons

- Less horizontal padding: px-3 py-2 not px-4 py-2
- App UIs: text-sm only, button height 28-38px, max 2 button sizes
- One primary button per page -- everything else is secondary
- Buttons with icons: asymmetric padding (icon side = vertical padding)
- Solid buttons need focus-visible:outline-\* with outline-offset-2
- Small buttons need 48x48px touch target via invisible overlay
- Dangerous actions use secondary style unless it's the page's primary action

---

5. Surfaces & Cards

- Don't default to white cards on gray backgrounds -- prefer content directly on white
- Hierarchy: whitespace > borders/dividers > wells (bg-gray-50) > cards
- Reserve cards for independently interactive or fundamentally different content
- Dividers: use opacity-based colors, reconfigure at each breakpoint
- Elevated elements (shadow) must be lighter than canvas, never darker

---

6. Shadows

- Never pair shadows with solid gray borders -- use ring-1 ring-black/5 or ring-black/10
- Elevated elements with shadows must be white/lightest neutral

---

7. Responsive Design

- Every layout must adapt mobile → desktop
- Body text, subheadings, form controls, icons should be LARGER on mobile, scale down at sm: (e.g., text-2xl/8 sm:text-xl/8)
- Exception: h1s stay same or get smaller on mobile
- Body text minimum text-base on mobile
- Use @container for component-level responsiveness, not media queries

---

8. Dark Mode

- Maintain same contrast ratios, don't just invert colors
- Cards only slightly lighter than page bg (e.g., dark:bg-gray-900 on dark:bg-gray-950)
- Remove all shadows in dark mode (dark:shadow-none)
- Hide decorative background images (dark:hidden)
- Single heading text color in dark mode (no mixing)
- Add dark:inset-ring dark:inset-ring-white/5 for card definition

---

9. Icons

- Never generate raw SVG -- import from Heroicons or project library
- Never wrap in decorative containers (colored circles/squares)
- Fixed sizes: 24px viewBox → size-6, 20px → size-5, 16px → size-4
- App UIs: only Heroicons Micro (16px, size-4)
- Use size-4 h-lh for vertical alignment with text
- Use fill-_/stroke-_, never text-\* with currentColor
- Always shrink-0 in flex containers

---

10. Form Controls

- Never shadow + solid gray border -- use ring-1 ring-black/10 shadow-\*
- max-w-xs for compact forms (login, signup)
- If font < 16px, add max-sm:text-base to prevent iOS zoom
- Never use conjoined input + button pattern
- Always name attribute, always label or aria-label
- Checkboxes, radios, toggles: pure CSS state management, never JS class toggling
- Includes exact markup patterns for checkboxes, radios, selects, and toggles with full Tailwind classes

---

11. Navigation

- Every app needs a mobile nav menu -- hide desktop nav with hidden lg:flex
- Never high-contrast/primary background for active nav items
- Never change font-weight between nav states
- Horizontal menus must never overflow -- use scroll
- Never icons in top header horizontal links

---

12. Layout Patterns
    Section layout: Two-element pattern -- outer for bg/vertical padding, inner for max-width/centering/horizontal padding
    Flexbox:

- Always min-w-0 on flex children that need to shrink below content size
- Always shrink-0 on elements that shouldn't shrink (icons, images, avatars)
  Border radius:
- Concentric radii on nested elements using CSS variables + calc()
- Use min() with viewport units for image radii

---

13. Component-Specific Rules
    Headers: Logo in <a href="/"> with aria-label="Homepage". Navbar buttons must feel secondary to hero CTA.
    Footers: Logo h-5 to h-7. font-normal for links. Social icons minimum text-gray-600.
    Landing pages: Consistent button styling, font treatment, container style, border radius, and column gap across the entire page. Never centered layout directly below left-aligned.
    Login pages: Never light gray backgrounds -- solid white or dark only.
    Pricing cards: Emphasize via button styling, not background color. Always align buttons across cards with flex flex-col justify-between. CSS grid rows for taller emphasized card.
    Testimonials: Hanging punctuation with pseudo-elements. Bottom-align avatars. No whitespace in <p> tags.
    Tables: No uppercase headings, whitespace-nowrap on <th>, no containers/cards around tables, only horizontal dividers, responsive two-div wrapper pattern.
    Feature lists: Use <dl>/<dt>/<dd>, not <ul>/<li>.
    Description lists: <dt> higher contrast + font-medium, <dd> regular weight + lower contrast.
    Team sections: Never landscape aspect for photos. Muted color for roles. Use <ul>/<li>.
    Dashboards: truncate on stat card titles. No icons in stat cards. Container queries for widgets.
    Logo clouds: Even distribution across rows. Match hero alignment.
    Badges: Asymmetric padding with icons (same as buttons).
    Pagination: Hide page numbers on mobile.
    Images: Never borders on photos -- use outline-1 -outline-offset-1 outline-black/5. alt="" when text is adjacent.
    Avatars: Stacked groups get 2px ring matching background. Use outline-black/5 border treatment.

---

14. Interactivity

- Never hover:\* on non-interactive elements
- Never transition-\* for hover color/background changes -- only for movement/transforms

---

15. Copywriting

- Consistent period usage within a page
- Always periods on standalone descriptive text (taglines, subtitles)
- Omit periods only on list items (e.g., feature bullets)
- Never use emojis anywhere

---

16. SVG

- Omit xmlns on inline SVGs
- Style with Tailwind (fill-_, stroke-_), not hardcoded attributes
- Never mix fill="currentColor" attributes with fill-\* classes

---

17. Prose Content

- Never use @tailwindcss/typography -- create custom .prose class with plain CSS + Tailwind variables
- Default text-base body, line-height at least 1.75x
- Width via max-w-[65ch] on the markup, never inside CSS
- text-pretty on article titles (not text-balance)

---

18. Font Recommendations
    Body/UI (sans-serif): Inter (default), DM Sans, Figtree, General Sans, Geist, Host Grotesk, Instrument Sans, Mona Sans, Satoshi
    Body (serif): Lora
    Headlines: DM Sans, Fixel Display, Geist, Inter, Mona Sans (wide), Satoshi, Instrument Serif
    Monospace: Geist Mono, IBM Plex Mono

---

19. Assets API (assets.ui.sh)
    A placeholder content CDN with:

- Marks (/marks/{id}.svg) -- generated logos with custom text, font, color
- Avatars (/avatars/{id}.webp) -- IDs 1-16, with size/grayscale params
- Logos (/logos/{id}.svg) -- 9 placeholder company logos (align, artifact, axiom, etc.)
- Screenshots (/screenshots/{id}.webp) -- realistic app UI screenshots with crop params
- Wallpapers (/wallpapers/{type}.webp) -- blend, haze, horizon, landscapes, silk variants with many color options
  Colors accept Tailwind names (red-500) resolved to oklch().

---
