---
title: "position-try-fallbacks: flip-* tactics, position-area fallbacks, and @position-try"
source_kind: web-reference
source_url: https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_anchor_positioning/Try_options_hiding
source_content_sha256: 313a128acf3b66e31dcfaf61e7b5344987739ede890097cb0b35d9c8a9c0524d
source_author: MDN contributors
source_date: 2026-06-29
ingested: 2026-06-29
ingested_by: scholar
topics: [web-frontend]
status: current
---

`position-try-fallbacks` lists alternative placements the browser tries, in order, when an anchor-positioned element would otherwise overflow in its initial position. Each fallback is one of three forms: a predefined **try tactic** (`flip-block`, `flip-inline`, `flip-start`), a `position-area` value, or a named `@position-try` custom option. This is the property that lets a popover/picker reposition itself when it hits a viewport edge (the goldilocks essay's margin-on-flip fix uses it — `web--goldilocks-select-height--viewport-margin-and-flip-fallbacks`). The *normative* account of which properties a tactic flips is in `web--csswg-css-anchor-position-1--try-tactic-flip-semantics`; this section is the practical MDN view.

## Predefined try tactics (flip-*)

A `<try-tactic>` mirrors the element's placement across an axis:

- **`flip-block`** — flips across the block axis. An element placed `10px` above its anchor that overflows the top is re-placed `10px` below the anchor.
- **`flip-inline`** — flips across the inline axis (mirrors to the opposite horizontal side in horizontal writing modes).
- **`flip-start`** — flips diagonally, swapping the block and inline axes (the start/end corner mirror).

The "dark magic" of a tactic is that it does not only move the element — it also flips the **other axis-paired properties** that came with the placement, including margins and insets. So a `margin-block-end` set for the below-anchor case is treated as a `margin-block-start` once `flip-block` puts the element above the anchor — which is exactly why the goldilocks margin survives a flip.

## Combining tactics

Multiple tactics can be space-separated inside one comma-separated fallback entry; the browser composes them (applies both flips), useful when the element nears two edges at once:

```css
.infobox {
  position: fixed;
  position-anchor: --my-anchor;
  position-area: top left;
  position-try-fallbacks:
    flip-block,
    flip-inline,
    flip-block flip-inline;
}
```

## position-area values as fallbacks

A `position-area` value can be a fallback entry directly, listing the alternate cells to try:

```css
.infobox {
  position-try-fallbacks:
    top, top right, right,
    bottom right, bottom,
    bottom left, left;
}
```

Note: `position-area` values **cannot** be space-combined within one fallback entry (unlike the flip tactics).

## Custom @position-try options

For a fallback that changes more than placement, define a named option with `@position-try` and reference it:

```css
@position-try --custom-left {
  position-area: left;
  width: 100px;
  margin-right: 10px;
}

@position-try --custom-bottom-right {
  position-area: bottom right;
  margin: 10px 0 0 10px;
}

.infobox {
  position: fixed;
  position-anchor: --my-anchor;
  position-area: top;
  width: 200px;
  margin-bottom: 10px;
  position-try-fallbacks: --custom-left, --custom-bottom-right;
}
```

When a custom option becomes active its declarations override the element's; when a later scroll selects a different (or no) fallback, the prior option's values are unset. If two `@position-try` rules share a name, the last in document order wins. The descriptors permitted inside `@position-try` are restricted: inset properties, margin properties, sizing properties, self-alignment properties, `position-anchor`, and `position-area` (see the normative list in `web--csswg-css-anchor-position-1--position-try-order-and-descriptors`).

Source: [Handling overflow: try fallbacks and conditional hiding](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_anchor_positioning/Try_options_hiding), MDN contributors, developer.mozilla.org; fetched 2026-06-29 via direct curl, content SHA-256 `313a128a`.
