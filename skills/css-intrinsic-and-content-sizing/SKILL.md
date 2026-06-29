---
created: 2026-06-29
updated: 2026-06-29
author: gardener
---

# Skill: css-intrinsic-and-content-sizing

Size an element from its **content** or from its **available space**, and use
`calc-size()` to do arithmetic on those intrinsic sizes so a box is clamped
between a content-driven minimum and a fixed maximum. This is the "Goldilocks"
size: neither a fixed pixel box nor unbounded growth, but as large as the
content wants until a cap takes over.

The technique is transcribed from Jake Archibald's essay on sizing a customizable
`<select>` picker
(`https://jakearchibald.com/2026/goldilocks-select-height/`), captured in the
garden library under `web--goldilocks-select-height--intrinsic-min-max-with-calc-size`
and `--problem-and-default-sizing` (concept `css-intrinsic-sizing`).

A [web-designer](../../roles/web-designer/AGENT.md) reaches for this when a
design needs an element to be "just the right size"; a
[web-builder](../../roles/web-builder/AGENT.md) implements it. The `@supports`
gating around the modern half lives in its own skill,
[supports-feature-query-progressive-enhancement](../supports-feature-query-progressive-enhancement/SKILL.md);
this skill is the sizing primitive, that skill is how you ship it safely.

## When to use

- Any element that should be **just the right size** for its content but capped:
  a menu, popover, picker, autocomplete list, side panel, an auto-growing region.
- You are reaching for a fixed `height`/`max-height` in pixels and the content
  height should really win until it exceeds a sensible cap.
- You want a floor that is "the content height, but no more than `N`" so a short
  list is not boxed in empty space while a long list is still bounded.

If the cap is the only constraint and you do not care about the content-driven
floor, a plain `max-block-size` is enough and you do not need `calc-size()`.

## The intrinsic-size keywords

CSS sizing properties (`block-size`/`inline-size`, `min-*`, `max-*`, and their
physical `height`/`width` aliases) accept **intrinsic** size keywords, not just
lengths and percentages:

- **`fit-content`** — the content's natural size, shrink-wrapped: as small as the
  content allows, but no larger than the available space.
- **`min-content`** — the smallest the content can be without overflowing (the
  longest unbreakable word, the tallest single line).
- **`max-content`** — the size the content wants if given unlimited room (no
  wrapping).
- **`stretch`** — the full available space in that axis (the containing block's
  content area, or the anchor-positioning cell for a popover). This is the
  "available space" counterpart to the content-driven keywords above.

Prefer logical properties (`block-size`, `min-block-size`, `max-block-size`,
`inline-size`) over the physical `height`/`width` so the technique follows the
writing mode. The Goldilocks problem is almost always a **block-axis** (vertical,
in horizontal writing modes) one.

## The problem: min() and max() reject intrinsic sizes

The natural expression of "the content height, but never taller than 12em" is
`min(fit-content, 12em)`. That does **not** work: the `min()` / `max()` /
`clamp()` math functions do not accept intrinsic keywords like `fit-content` or
`stretch` as operands. A bare `min-block-size: 12em` floor stops the box
collapsing, but then forces a too-tall box around content that only needs a
little. Arithmetic on an intrinsic size is the missing piece.

## calc-size(): arithmetic on an intrinsic size

`calc-size(<intrinsic>, <calc>)` unlocks it. The first argument names the
intrinsic size; the second is a calculation in which the `size` keyword stands
for that intrinsic size:

```css
.picker {
  /* floor: the content height, but never demand more than 12em as a minimum */
  min-block-size: calc-size(fit-content, min(size, 12em));
}
```

Read it as: resolve `fit-content`, bind it to `size`, then compute
`min(size, 12em)`. For a two-option list `size` is small, so the minimum is the
small content height; for a long list `size` exceeds 12em, so the minimum caps at
12em. The floor never over-reserves space.

The maximum works the same way, this time over `stretch` so the available-space
size can participate in a `min()`:

```css
.picker {
  --max-size: 30em;
  --viewport-margin: 1em;
  /* ceiling: the available space, but never taller than 30em */
  max-block-size: calc-size(stretch, min(size, var(--max-size)));
  margin-block-end: var(--viewport-margin);
}
```

Combined, the box is clamped between a content-aware floor and a fixed ceiling
while still honoring its intrinsic content height in between. That is the
Goldilocks result.

## Browser support and the gate

As of mid-2026 `calc-size()` is **Chrome-only** (Firefox and Safari have open
tickets), and `max-block-size: stretch` is unsupported in Firefox. So the
`calc-size()` arithmetic must be gated behind an `@supports` feature query with a
hand-rolled fallback for engines without it. That gating and the structural
short-list fallback (`:has()` + `:nth-of-type()`) are a separate, reusable
discipline: see
[supports-feature-query-progressive-enhancement](../supports-feature-query-progressive-enhancement/SKILL.md).
The complete, gated CSS for the picker case is in the library section
`web--goldilocks-select-height--final-css-and-browser-support`.

## Procedure

1. **Name the axis and the two bounds.** Decide the content-driven floor (what
   "too small" means) and the fixed ceiling (what "too big" means), as CSS
   custom properties (`--min-size`, `--max-size`) so they are tunable and
   reviewable.
2. **Pick the intrinsic keyword per bound.** A content-driven floor uses
   `fit-content`; an available-space ceiling uses `stretch`. A pure
   shrink-to-fit needs only `fit-content` with no calc.
3. **Write the modern path** with `calc-size(<intrinsic>, min(size, <cap>))` for
   each bound that mixes an intrinsic size with a length.
4. **Gate it** behind `@supports` and supply a fallback (a fixed bound, plus an
   optional structural short-list detector) per
   [supports-feature-query-progressive-enhancement](../supports-feature-query-progressive-enhancement/SKILL.md).
5. **Verify** across a `calc-size()` engine (Chrome) and a non-`calc-size()`
   engine (Firefox/Safari) per the checklist below.

## Verification

- In a `calc-size()` engine: a short list shrink-wraps (no empty padding below the
  options) and a long list caps at `--max-size` rather than overflowing.
- In a non-`calc-size()` engine: the fallback path still produces a usable box
  (the short list is not boxed in, the long list does not run off-screen).
- Resize the viewport: the ceiling respects the available space (the box does not
  push past the viewport edge once `stretch`/percentage and the margin are in
  play).
- Confirm logical properties behave under at least one non-default writing mode if
  the surface supports right-to-left or vertical text.

## Limitations (call these out in the design)

- **`calc-size()` is not yet universal.** Treat the modern path as the
  enhancement and always ship a fallback; do not assume `calc-size()` or
  `max-block-size: stretch` is present.
- **`min()`/`max()`/`clamp()` still reject intrinsic keywords.** `calc-size()` is
  the only way to mix an intrinsic size into the arithmetic; you cannot inline
  `fit-content` into a `min()`.
- **This is a sizing primitive, not a positioning one.** Keeping a popover off the
  viewport edge, flipping it above its anchor, and anchoring it to a control are
  positioning concerns; this skill only sizes the box. The positioning half is
  the subject of a future `css-anchor-positioning-and-flip-fallbacks` skill (a
  source ingest is pending before it can be authored).

## Output

The deliverable is the gated sizing CSS (the `calc-size()` modern path plus its
`@supports` fallback) landed on the target element, with `--min-size` /
`--max-size` (and any `--viewport-margin`) named as custom properties, plus a
design note recording the two bounds, the intrinsic keyword chosen per bound, and
the browser-support caveat.

## Notes from the field

(Append; terse and dated.)

- _2026-06-29_: initial write (job `author-web-designer-css-skills`, scholar
  proposal off `web--goldilocks-select-height`). Grounded in the Jake Archibald
  essay's `calc-size(fit-content, min(size, 12em))` floor and
  `calc-size(stretch, min(size, 30em))` ceiling. The essay's nominal subject is a
  customizable-`<select>` picker, but the sizing core generalizes to any
  content-or-space-sized box. Honest scope: the seed proposal guessed
  `field-sizing`; the source does not use it, so this skill does not cover it.
