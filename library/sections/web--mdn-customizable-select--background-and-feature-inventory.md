---
title: "Background and feature inventory of customizable select elements"
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

Why customizable `<select>` exists and the full inventory of the HTML and CSS features that comprise it. Traditionally a `<select>`'s internals (drop-down picker, arrow icon) are styled at the operating-system level and cannot be targeted with CSS; the only prior option short of a custom JavaScript library was `appearance: none`, which strips OS styling but leaves the picker un-stylable. Customizable `<select>` makes the whole control (button, picker, icon, checkmark, each `<option>`) stylable with HTML and CSS alone, while remaining a **progressive enhancement**: in non-supporting browsers it falls back to a classic native `<select>` that still works. This section is the orientation map for the sibling sections (markup-and-opt-in, styling-the-parts, popover-and-anchor-positioning, accessibility-and-browser-support).

## Background: why this feature exists

Traditionally it has been difficult to customize the look and feel of `<select>` elements because they contain internals that are styled at the operating-system level, which cannot be targeted using CSS. This includes the drop-down picker, arrow icon, and so on.

Previously, the best available option (aside from using a custom JavaScript library) was to set an `appearance` value of `none` on the `<select>` element to strip away some of the OS-level styling, and then use CSS to customize the bits that can be styled (the "Advanced form styling" technique).

Customizable `<select>` elements provide a solution: they allow building fully-customized selects using only HTML and CSS in supporting browsers, including the `<select>` and drop-down picker layout, color scheme, icons, font, transitions, positioning, and markers indicating the selected option. Crucially, they provide a **progressive enhancement** on top of existing functionality, falling back to "classic" selects in non-supporting browsers.

This material covers "single dropdown" selects (display a single option at a time, allow a single selection). "Listbox" selects (display multiple options at once, allow single or multiple selection) are a separate guide ("Customizable select listboxes").

## What features comprise a customizable select?

A customizable `<select>` is built from these HTML and CSS features:

- **Plain `<select>`, `<option>`, and `<optgroup>` elements.** They work the same as in classic selects, except they accept additional permitted content types.
- **A `<button>` element as the first child of `<select>`** (not previously allowed in classic selects). When included, it replaces the default rendering of the closed `<select>`. This is the **select button** (the button you press to open the picker). The select button is **inert by default**, so any interactive children inside it are still treated as a single button for interaction purposes (child links/buttons are not focusable or clickable).
- **The `<selectedcontent>` element**, optionally included inside the first-child `<button>`, to display the currently selected value inside the closed `<select>`. It contains a clone of the selected `<option>`'s content (created with `cloneNode()` under the hood).
- **The `::picker(select)` pseudo-element**, targeting the entire contents of the picker: everything inside `<select>` except the first-child `<button>`.
- **The `appearance: base-select` value**, which opts the `<select>` element and the `::picker(select)` pseudo-element into the browser-defined default styles and behavior for customizable select.
- **The `:open` pseudo-class**, targeting the select button when the picker is open.
- **The `::picker-icon` pseudo-element**, targeting the icon inside the select button (the arrow that points down when the select is closed).
- **The `:checked` pseudo-class**, targeting the currently-selected `<option>` element.
- **The `::checkmark` pseudo-element**, targeting the checkmark placed inside the currently-selected `<option>` to indicate selection.

In addition, the `<select>` element and its drop-down picker have an **implicit anchor reference**: the picker is automatically associated with the `<select>` via CSS anchor positioning. The browser default styles position the picker relative to the button (the anchor) and define some `position-try` fallbacks that reposition the picker if it risks overflowing the viewport (see the popover-and-anchor-positioning sibling).

You can check browser support for customizable `<select>` by viewing the browser-compatibility tables on the reference pages for related features such as `<selectedcontent>`, `::picker(select)`, and `::checkmark`.

Source: [Customizable select elements](https://developer.mozilla.org/en-US/docs/Learn_web_development/Extensions/Forms/Customizable_select) §§ Background, What features comprise a customizable select?, MDN contributors, developer.mozilla.org, last modified 2026-04-06; fetched 2026-06-29 via direct curl, content SHA-256 `013b9f8c`.
