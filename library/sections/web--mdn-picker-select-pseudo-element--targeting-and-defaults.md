---
title: "::picker(select): targeting the picker, popover behavior, and default anchor styles"
source_kind: web
source_url: https://developer.mozilla.org/en-US/docs/Web/CSS/::picker
source_content_sha256: 806408c930a761e9423fc3c09bfd15d69fc045872d088cd69421bd64b99d0806
source_authors: [MDN contributors]
source_date: 2026-04-17
ingested: 2026-06-29
ingested_by: scholar
topics: [web-frontend]
status: current
---

The `::picker()` CSS pseudo-element and its `select` argument, which targets the drop-down picker of a customizable `<select>`. `::picker(select)` matches all descendants of the `<select>` except the first-child `<button>`, grouped and rendered by the browser as the picker, so you can style/animate/position the picker as a single entity. It is only targetable once the originating element has `appearance: base-select`. The element and picker get an automatic invoker/popover relationship (Popover API) and an implicit anchor reference (CSS anchor positioning), so this page also records the browser **default** position and `position-try` fallback styles for the picker, which the goldilocks-select-height technique refines.

## Syntax and what it targets

```css
::picker(<ident>) {
  /* ... */
}
```

The `<ident>` names the element whose picker you target; the available value is **`select`** (the drop-down picker of customizable select elements).

`::picker()` targets the picker part of a form control: the pop-up that appears to make a selection when you press the control button. It is only available to target when the originating element **has a picker and has base appearance set via `appearance: base-select`**.

`::picker(select)` targets **all descendants of the customizable `<select>` except for the first `<button>` child**; the browser groups these descendants and renders them as the picker. The first `<button>` child is the control button that opens the picker. This lets you target all picker contents as a single entity (customize its border, animate it on show/hide, or reposition it).

## Picker popover behavior

The `<select>` and the picker have an **implicit invoker/popover relationship** assigned automatically (per the Popover API), which is what allows animating the picker between hidden and showing states.

## Picker anchor positioning and default styles

A side-effect of that relationship is an **implicit anchor reference**: the picker is automatically associated with the select via CSS anchor positioning, so no explicit `anchor-name` / `position-anchor` is needed. The browser default styles position the picker relative to the button (the anchor):

```css
inset: auto;
margin: 0;
min-inline-size: anchor-size(self-inline);
min-block-size: 1lh;
/* Go to the edge of the viewport, and add scrollbars if needed. */
max-block-size: stretch;
overflow: auto;
/* Below and span-right, by default. */
position-area: block-end span-inline-end;
```

The default styles also define `position-try` fallbacks that reposition the picker if it risks overflowing the viewport:

```css
position-try-order: most-block-size;
position-try-fallbacks:
  /* First try above and span-right, */
  /* then below but span-left, */
  /* then above and span-left. */
  block-start span-inline-end,
  block-end span-inline-start,
  block-start span-inline-start;
```

To remove the implicit anchor reference (un-anchor the picker from the `<select>`), set the picker's `position-anchor` to a non-existent anchor name such as `--not-an-anchor-name`.

## Basic usage

Opt both the select and its picker in, then style the picker:

```css
select,
::picker(select) {
  appearance: base-select;
}

::picker(select) {
  border: none;
}
```

This feature is "Limited availability" (not Baseline).

Source: [`::picker()`](https://developer.mozilla.org/en-US/docs/Web/CSS/::picker) §§ Syntax, Description, Picker popover behavior, Picker anchor positioning, Examples, MDN contributors, developer.mozilla.org, last modified 2026-04-17; fetched 2026-06-29 via direct curl, content SHA-256 `806408c9`.
