---
title: "position-area and the 3×3 region grid"
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

`position-area` is the high-level shorthand for placing an anchor-positioned element: instead of writing per-side `anchor()` insets, you name a cell (or span of cells) of a 3×3 grid centered on the anchor, and the element is placed in that region. It is the property the UA `::picker(select)` default uses (`position-area: self-block-end span-self-inline-end`; see `web--goldilocks-select-height--problem-and-default-sizing`). `inset-area` is the former name for the same property.

## The 3×3 region grid

The anchor's edges divide the containing block into nine regions. Two keywords (a row band and a column band) pick the cell; the anchor occupies the center:

```
[block-start inline-start]  [block-start center]  [block-start inline-end]
[center      inline-start]  [center      center]  [center      inline-end]
[block-end   inline-start]  [center      center]  [block-end   inline-end]
```

```css
.infobox {
  position: fixed;
  position-anchor: --my-anchor;
  position-area: top center;     /* above the anchor, horizontally centered */
}
```

## Region keywords

- **Physical:** `top`, `bottom`, `left`, `right`, `center`.
- **Logical:** `start`, `end`, `block-start`, `block-end`, `inline-start`, `inline-end`, and the `self-*` forms (`self-block-end`, `self-inline-start`, …) which resolve against the positioned element's own writing mode.

A single value (e.g. `position-area: top`) implies `center` on the other axis. Physical and logical keywords must not be mixed in one `position-area`.

## Span keywords

By default a region keyword selects one cell on its axis. The `span-*` keywords widen the placement to cover more of the grid:

- `span-block-start` / `span-block-end` / `span-inline-start` / `span-inline-end` (and `span-left`/`span-right`/`span-top`/`span-bottom`, `span-self-*`) — span from the named edge across the center cell.
- `span-all` — span the entire axis (all three cells).

For example `position-area: self-block-end span-self-inline-end` (the UA picker default) places the element below the anchor, spanning from the anchor's inline-start edge to the inline-end edge of the containing block.

## Sizing from the cell

The chosen region is also the positioned element's **inset-modified containing block** — `max-block-size: stretch` then means "fill the cell" (anchor edge to viewport edge), which is how the picker is kept from overflowing. `position-area`, `anchor-size()`, and the `stretch`/`fit-content` intrinsic sizes thus work together: the area picks the cell, `anchor-size()` ties a dimension to the anchor, and `stretch`/`calc-size()` clamp within the cell.

Source: [CSS anchor positioning — position-area](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_anchor_positioning), MDN contributors, developer.mozilla.org; fetched 2026-06-29 via direct curl, content SHA-256 `313a128a`.
