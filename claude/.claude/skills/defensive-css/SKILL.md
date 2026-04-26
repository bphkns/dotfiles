---
name: defensive-css
description: Defensive CSS best practices from defensivecss.dev for resilient UI styles. Use proactively whenever writing or reviewing CSS/Tailwind for layout, overflow, flexbox, grid, images, responsive behavior, or cross-device interaction. Triggers on: css, tailwind, flex, grid, overflow, wrapping, truncation, min-width, min-height, object-fit, sticky, scrollbar, hover, media query.
metadata:
  author: ahmad-shadeed
  source: https://defensivecss.dev/
  version: "1.0.0"
---

# Defensive CSS

Use this skill as a default guardrail for CSS implementation and CSS review.

## Goal

Write CSS that keeps working when content, locale, viewport, or input mode changes.

## Required Workflow

1. Start from unknown content assumptions (long text, short labels, broken images, dynamic counts).
2. Apply baseline defensive rules before polishing visuals.
3. Add layout-specific protections (flex/grid/scroll/sticky/media).
4. Stress test with hostile inputs and small viewports.
5. In the final response, include a short "Defensive checks" list with applied rules (or N/A).

## Baseline Defensive Rules

```css
img {
  max-width: 100%;
  height: auto;
  object-fit: cover;
}

h1,
h2,
h3,
h4,
h5,
h6,
p,
a {
  overflow-wrap: break-word;
}
```

## CSS Decision Checklist

### Content and text

- Long single token risk -> `overflow-wrap: break-word`.
- Single-line critical layout text -> use truncation only when acceptable.

```css
.truncate-one-line {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
```

- Text near actions/icons -> reserve spacing (`margin-inline-end` / `padding-inline-end`).

### Sizing

- Unknown content height -> prefer `min-height` over fixed `height`.
- Localized button labels -> prefer `min-width` over fixed `width`.

### Flexbox

- Unknown number of children -> use `flex-wrap: wrap`.
- Wrapping rows -> prefer `gap` over `justify-content: space-between`.
- Long content inside flex item -> apply `min-width: 0`.
- Column flex with nested scroll -> apply `min-height: 0`.
- Default stretch causes distortion -> use `align-items` or `align-self` explicitly.

### Grid

- Fixed columns (e.g., `250px 1fr`) -> gate with media query.
- Grid item overflow due to child min-content -> apply `min-width: 0` on grid item.
- Sticky element in grid -> `align-self: start` before `position: sticky`.
- `minmax()` responsive cards -> prefer `auto-fill` if you do not want lone items to over-expand.

### Images and backgrounds

- Mixed image ratios -> enforce `object-fit: cover`.
- Text over image -> add image fallback background color.
- Large section backgrounds -> set `background-repeat: no-repeat`.

### Scrolling and overflow

- Only show scrollbars when needed -> use `overflow: auto` / `overflow-y: auto`.
- Prevent scroll chaining in modal/panel -> `overscroll-behavior-y: contain`.
- Prevent layout shift on scrollbar appearance -> `scrollbar-gutter: stable`.

### Interaction and device conditions

- Hover styles should not leak to touch -> wrap hover styles:

```css
@media (hover: hover) and (pointer: fine) {
  .interactive:hover {
    /* hover styles */
  }
}
```

- iOS Safari input zoom guard -> keep interactive text inputs at `font-size: 16px` minimum.
- Height-sensitive layouts -> add vertical media queries (`min-height` / `max-height`) where needed.

### Variables and browser-specific selectors

- CSS variable value from JS or dynamic source -> always provide fallback in `var()`.

```css
.message {
  max-width: calc(100% - var(--actions-width, 70px));
}
```

- Do not group vendor-specific selectors in one comma-separated rule.

## Stress Test Matrix (Minimum)

Test each changed component with:

1. Very long text + unbroken token.
2. Very short localized label (e.g., 1-2 characters).
3. Missing image / wrong image ratio.
4. Very small viewport width (`320px`).
5. Short viewport height (`<= 700px`).
6. Touch environment (no hover) + desktop pointer.

## Required Final Response Add-on

For CSS implementation/review tasks, always end with:

```text
Defensive checks:
- <applied check 1>
- <applied check 2>
- <N/A: reason>
```

## Source

- https://defensivecss.dev/
- https://defensivecss.dev/tips/
