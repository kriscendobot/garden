---
title: "The anchor() function: positioning relative to an anchor's edges"
source_kind: web-reference
source_url: https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_anchor_positioning
source_content_sha256: 313a128acf3b66e31dcfaf61e7b5344987739ede890097cb0b35d9c8a9c0524d
source_author: MDN contributors
source_date: 2026-06-29
ingested: 2026-06-29
ingested_by: scholar
topics: [web-frontend]
status: current
---

The `anchor()` function resolves to a length: the position of one edge (or the center, or a percentage point) of an anchor element, used as the value of an inset property (`top`, `bottom`, `left`, `right`, `inset-block-start`, …) on an anchor-positioned element. This is the low-level, per-side way to place an element against its anchor; the higher-level `position-area` (sibling section) is shorthand over the same idea.

## Syntax

```css
top: anchor(--anchor-name bottom);
left: anchor(--anchor-name right);
inset-block-start: anchor(--anchor-name end);
```

`anchor(<anchor-name>? <anchor-side> , <fallback>? )`:

- **`<anchor-name>`** (optional) — the dashed-ident of the anchor to resolve against. Omit it to use the element's **default anchor** (the one named by `position-anchor`).
- **`<anchor-side>`** — which edge/point of the anchor to resolve to.
- **`<fallback>`** (optional) — a length used if the anchor function would otherwise be invalid (no anchor, or the side is incompatible with the inset property's axis), e.g. `top: anchor(--a bottom, 10px)`.

## Anchor-side keywords

- **Physical sides:** `top`, `bottom`, `left`, `right`.
- **Logical sides:** `start`, `end`, `self-start`, `self-end` (resolved against the containing block's or the element's own writing mode respectively).
- **`center`** — the center of the anchor along the relevant axis.
- **`<percentage>`** — a point a given percentage along the anchor's side (0% = start, 100% = end).

An `anchor()` is only valid on an inset property whose axis matches the side requested; a `left`/`right` inset takes a horizontal side, a `top`/`bottom` inset a vertical side. A mismatch falls back to the `<fallback>` length (or makes the declaration invalid if none is given).

## Centering on the anchor

`anchor()` placement is commonly paired with a `translate` (or the `anchor-center` self-alignment value) to center the positioned element on an anchor edge:

```css
.tooltip {
  position: absolute;
  position-anchor: --my-button;
  top: anchor(bottom);          /* sit just below the button */
  left: anchor(center);         /* align to the button's horizontal center */
  translate: -50% 0;            /* then pull back half the tooltip's width */
}
```

Source: [CSS anchor positioning — anchor()](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_anchor_positioning), MDN contributors, developer.mozilla.org; fetched 2026-06-29 via direct curl, content SHA-256 `313a128a`.
