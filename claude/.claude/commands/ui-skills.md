---
description: Apply opinionated constraints for building better interfaces with agents.
---

# UI Skills

When invoked, apply these opinionated constraints for building better interfaces.

## Stack

- Use Tailwind CSS defaults unless custom values already exist or are explicitly requested.
- Use `motion/react` when JavaScript animation is required.
- Use existing component primitives first; prefer accessible primitives for keyboard/focus behavior.
- Use the project `cn` utility for class logic when present.

## Interaction

- Use an `AlertDialog` for destructive or irreversible actions.
- Use structural skeletons for loading states.
- Never use `h-screen`; use `h-dvh`.
- Respect `safe-area-inset` for fixed elements.
- Show errors next to where the action happens.
- Never block paste in inputs.

## Animation

- Do not add animation unless explicitly requested.
- Animate only compositor props: `transform` and `opacity`.
- Do not animate layout properties.
- Respect `prefers-reduced-motion`.
- Keep interaction feedback under `200ms`.

## Typography

- Use `text-balance` for headings and `text-pretty` for body text.
- Use `tabular-nums` for data.
- Use `truncate` or `line-clamp` for dense UI.
- Do not modify tracking unless requested.

## Layout And Design

- Use a fixed `z-index` scale; avoid arbitrary `z-*`.
- Prefer `size-*` for square elements.
- Avoid gradients unless requested.
- Avoid purple or multicolor gradients.
- Limit accent color usage to one per view.
- Give empty states one clear next action.
