---
title: "position-try-order, the position-try shorthand, position-visibility, and anchored container queries"
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

Beyond the fallback list itself: `position-try-order` chooses a fallback proactively (at first display, by available space, not only on overflow); the `position-try` shorthand bundles order plus fallbacks; `position-visibility` hides an element when it or its anchor overflows; and **anchored container queries** restyle descendants based on which fallback is active. The UA `::picker(select)` default uses `position-try-order: most-block-size` to open in the tallest available cell (`web--goldilocks-select-height--problem-and-default-sizing`).

## position-try-order

By default a fallback is applied only when the initial position overflows. `position-try-order` instead picks, at initial display, the fallback that maximizes a dimension:

- **`normal`** (default) — no reordering; use the initial position.
- **`most-width`** — the fallback giving the most available width.
- **`most-height`** — the most available height.
- **`most-block-size`** — the most block-axis space.
- **`most-inline-size`** — the most inline-axis space.

If no fallback offers more space than the initial position, the property has no effect.

## position-try shorthand

`position-try` combines `position-try-order` and `position-try-fallbacks`:

```css
.positioned-element {
  position-try: most-height --fallback-1, --fallback-2, flip-block;
}
```

## position-visibility

`position-visibility` hides the element under overflow conditions; a "strongly hidden" element behaves as if it and all descendants had `visibility: hidden`:

- **`always`** (default) — always shown.
- **`no-overflow`** — strongly hidden if it overflows its containing element/viewport.
- **`anchors-visible`** — strongly hidden if its anchor(s) are completely hidden (overflowed or covered); visible while any part of the anchor shows.

```css
.infobox {
  position: fixed;
  position-anchor: --my-anchor;
  position-area: top span-all;
  position-visibility: no-overflow;
}
```

## Anchored container queries (style on the active fallback)

To restyle descendants depending on which fallback is currently applied (rotate a tooltip arrow, flip a gradient), set `container-type: anchored` on the positioned element and query the active fallback:

```css
.tooltip {
  position: absolute;
  position-anchor: --myAnchor;
  position-area: top;
  position-try-fallbacks: flip-block;
  container-type: anchored;
}

@container anchored(fallback: flip-block) {
  /* descendant styles that apply only when flip-block is active */
}
```

Anchored container queries are the cleaner alternative to property-flipping for fallback-conditional styling, but their browser support lags (Safari does not support them as of mid-2026 — `web--mdn-css-anchor-positioning--browser-support`), which is why the goldilocks margin fix prefers `flip-*` property-flipping over an anchored container query.

Source: [Handling overflow: try fallbacks and conditional hiding](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_anchor_positioning/Try_options_hiding), MDN contributors, developer.mozilla.org; fetched 2026-06-29 via direct curl, content SHA-256 `313a128a`.
