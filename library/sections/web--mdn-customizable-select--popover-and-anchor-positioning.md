---
title: "Animating and positioning the picker: popover states and anchor positioning"
source_kind: web
source_url: https://developer.mozilla.org/en-US/docs/Learn_web_development/Extensions/Forms/Customizable_select
source_content_sha256: 013b9f8cf029d2b06c209edfe5692bffc182e5751bc03e362b1edea36f01e997
source_authors: [MDN contributors]
source_date: 2026-04-06
ingested: 2026-06-29
ingested_by: scholar
topics: [web-frontend]
status: current
---

The customizable `<select>`'s button and picker are automatically given an invoker/popover relationship and an implicit anchor reference, so the picker is a popover rendered in the top layer and positioned by CSS anchor positioning without any explicit `anchor-name` / `position-anchor` wiring. This section covers the two consequences the guide demonstrates: animating the picker between hidden and showing popover states (with `transition`, `allow-discrete`, and `@starting-style`), and positioning the picker relative to its anchor with the `anchor()` function. These are the same primitives the goldilocks-select-height sizing technique builds on, so this section is the semantic bridge between the customizable-select control and the `[[css-intrinsic-sizing]]` picker-sizing material.

## Animating the picker using popover states

The select button and picker have an automatic invoker/popover relationship (per the Popover API). The `:open` pseudo-class represents the select in the open state. To fade the picker in and out:

Select the picker, set `opacity: 0`, and transition all properties with `allow-discrete` so discrete properties also animate:

```css
::picker(select) {
  opacity: 0;
  transition: all 0.4s allow-discrete;
}
```

The transition list includes `opacity` plus two **discrete** properties whose values the browser default styles set:

- **`display`** changes from `none` to `block` when the popover goes hidden → shown; animating it ensures other transitions are visible.
- **`overlay`** changes from `none` to `auto` when shown (promoting the picker to the top layer) and back when hidden; animating it defers removal from the top layer until the transition completes, keeping the exit transition visible.

The `allow-discrete` value is needed to enable discrete property animations.

Set the showing-state end value with `:open::picker(select)`:

```css
:open::picker(select) {
  opacity: 1;
}
```

Because the picker transitions while moving from `display: none` to a visible display, the transition's starting state must be specified in a `@starting-style` block:

```css
@starting-style {
  :open::picker(select) {
    opacity: 0;
  }
}
```

Together these make the picker smoothly fade in and out as the select opens and closes.

## Positioning the picker using anchor positioning

The select button and picker have an **implicit anchor reference**: the picker is automatically associated with the select button via CSS anchor positioning, so no explicit association with `anchor-name` / `position-anchor` is needed. The browser provides a default position you can customize. In the demo the picker is positioned relative to its anchor with the `anchor()` function inside `top` and `left`:

```css
::picker(select) {
  top: calc(anchor(bottom) + 1px);
  left: anchor(10%);
}
```

This puts the picker's top edge 1 pixel below the button's bottom edge, and its left edge 10% of the button's width across from the button's left edge.

To remove the implicit anchor reference (stop the picker being anchored to the `<select>`), set the picker's `position-anchor` to an anchor name that does not exist in the document, such as `--not-an-anchor-name`.

Source: [Customizable select elements](https://developer.mozilla.org/en-US/docs/Learn_web_development/Extensions/Forms/Customizable_select) §§ Animating the picker using popover states, Positioning the picker using anchor positioning, MDN contributors, developer.mozilla.org, last modified 2026-04-06; fetched 2026-06-29 via direct curl, content SHA-256 `013b9f8c`.
