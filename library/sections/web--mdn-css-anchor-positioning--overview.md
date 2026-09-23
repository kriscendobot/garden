---
title: "CSS anchor positioning: anchor elements, anchor-name, and position-anchor"
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

The fundamentals of CSS anchor positioning: an **anchor element** is tied to one or more **anchor-positioned elements**, which are then sized and placed relative to the anchor. This section captures the association mechanism — `anchor-name` on the anchor, `position-anchor` (or the implicit/default anchor) on the positioned element, the `anchor-scope` property, and the requirement that the positioned element be `position: absolute` or `position: fixed`. The actual positioning is then expressed with the `anchor()` / `anchor-size()` functions and the `position-area` property (sibling sections).

## The two roles

- An **anchor element** is any element designated as a reference point by giving it a dashed-ident name via the `anchor-name` property (`anchor-name: --my-anchor`). An element can expose more than one name.
- An **anchor-positioned element** is an absolutely- or fixed-positioned element that references an anchor and positions/sizes itself relative to it. It must be `position: absolute` or `position: fixed`; without that, the anchor functions have nothing to position.

## Binding the positioned element to an anchor

| Property | Purpose |
|----------|---------|
| `anchor-name` | Declares one or more dashed-ident names on the anchor element (e.g. `anchor-name: --button`). |
| `position-anchor` | Binds an anchor-positioned element to a named anchor (e.g. `position-anchor: --button`), establishing that anchor as the element's **default anchor**. |
| `anchor-scope` | Limits the scope in which a given `anchor-name` is visible, so the same name can be reused in different subtrees without collisions. |

A positioned element with a `position-anchor` has a **default anchor**; the `anchor()` and `anchor-size()` functions may then omit the anchor name and operate against that default. The HTML `anchor` attribute (`anchor="--name"` paired with an `id`) is an alternative, markup-level way to associate an element with its anchor.

## Minimal example

```css
/* Anchor element */
.anchor {
  anchor-name: --my-anchor;
}

/* Anchor-positioned element */
.infobox {
  position: fixed;
  position-anchor: --my-anchor;
  /* placement via anchor() / position-area in sibling sections */
}
```

The popover API pairs naturally with anchor positioning: a `popover` is the top-layer element, and anchor positioning is how it is placed next to its invoker. This is the same primitive pair the customizable-`<select>` picker is built from (see `web--goldilocks-select-height--problem-and-default-sizing`).

Source: [CSS anchor positioning](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_anchor_positioning), MDN contributors, developer.mozilla.org; fetched 2026-06-29 via direct curl, content SHA-256 `313a128a`.
