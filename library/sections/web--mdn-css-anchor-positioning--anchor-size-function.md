---
title: "The anchor-size() function: sizing relative to an anchor's dimensions"
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

The `anchor-size()` function resolves to a length equal to one dimension of an anchor element, used as the value of a sizing or inset property on an anchor-positioned element. It is what lets a popover/picker be "always at least as wide as its button" — the UA default `::picker(select)` uses `min-inline-size: anchor-size(self-inline)` for exactly this (see `web--goldilocks-select-height--problem-and-default-sizing`).

## Syntax

```css
width:  anchor-size(--my-anchor width);
height: anchor-size(--my-anchor height);
min-inline-size: anchor-size(inline);       /* default anchor, logical axis */
```

`anchor-size(<anchor-name>? <anchor-size>? , <fallback>? )`:

- **`<anchor-name>`** (optional) — the anchor to measure; omit to use the **default anchor** from `position-anchor`.
- **`<anchor-size>`** — which dimension to read.
- **`<fallback>`** (optional) — a length used if the function is otherwise invalid.

## Dimension keywords

- **Physical:** `width`, `height`.
- **Logical:** `inline`, `block` (respect the writing mode).
- **Self variants:** `self-inline`, `self-block` (and the physical `self-*` forms) — measure against the positioned element's own writing mode rather than the containing block's.

`anchor-size()` is valid in sizing properties (`width`, `height`, `min-*`, `max-*`, `inline-size`, `block-size`) and may also be used inside `calc()` to derive a size from the anchor (e.g. `width: calc(anchor-size(width) + 2rem)`).

## Sizing a popover to its anchor

```css
.popover {
  position: absolute;
  position-anchor: --button;
  min-inline-size: anchor-size(self-inline);  /* never narrower than the button */
  max-block-size: stretch;                     /* never taller than the cell */
}
```

`anchor-size()` composes with the intrinsic-size + `calc-size()` clamping toolkit (`web--goldilocks-select-height--intrinsic-min-max-with-calc-size`): the anchor's dimension sets a floor or ceiling while `calc-size()` arithmetic on `fit-content` / `stretch` clamps the rest.

Source: [CSS anchor positioning — anchor-size()](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_anchor_positioning), MDN contributors, developer.mozilla.org; fetched 2026-06-29 via direct curl, content SHA-256 `313a128a`.
