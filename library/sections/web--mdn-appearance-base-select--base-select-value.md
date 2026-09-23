---
title: "appearance: base-select — opting a select into customizable rendering"
source_kind: web
source_url: https://developer.mozilla.org/en-US/docs/Web/CSS/appearance
source_content_sha256: cc527ff3a69cde64c68cd61e55c9172f693cf22fd3f7e3f05403753df2e9768a
source_authors: [MDN contributors]
source_date: 2026-04-20
ingested: 2026-06-29
ingested_by: scholar
topics: [web-frontend]
status: current
---

The CSS `appearance` property and its `base-select` value, the opt-in that turns a native `<select>` into a customizable one. `appearance` controls whether a UI widget renders in its OS-native style; `none` strips native styling (but can make some widgets disappear while staying interactive), and the newer `base` value gives a widget a usable primitive appearance while enabling CSS customization. `base-select` is the `<select>`-specific form: it applies to the `<select>` element and the `::picker(select)` pseudo-element, makes the picker a top-layer popover positionable with anchor positioning, and stops the select from rendering OS-native drop-downs or sizing to the widest option. Critically, changing a widget's `appearance` does **not** change its functionality.

## appearance, none, and base

The `appearance` property displays elements in their OS-native style, or removes native styling with `none`. Setting `appearance: none`, or otherwise changing the appearance of UI widgets, **does not change the element's functionality**.

Most elements can be fully styled by CSS, but UI controls (widgets) are typically rendered by the browser using the OS's native styles, which differ across operating systems and browsers and expose limited CSS-styleable surface. `appearance: none` suppresses much of a widget's native appearance, yielding a primitive look that can be styled via CSS while maintaining functionality and native user interactions. A caveat: some widgets disappear completely under `appearance: none` (though the hidden controls stay interactive, for example clicking a `<label>` still toggles an `appearance: none` checkbox).

Because `none` can hide a widget, the **`base`** value was added: it ensures widgets keep a native, usable, interoperable primitive appearance while enabling a good degree of CSS customization. Unlike `none`, `base` does not make radio buttons or checkboxes disappear.

## The base-select value (customizable select)

The **`base-select`** value is relevant only to the `<select>` element and the `::picker(select)` pseudo-element. It enables styling `<select>` elements and the select picker (which contains the `<option>` elements). With `base-select` set:

- The picker is **rendered in the top layer, similar to a popover**.
- The picker can be **positioned relative to the select (or other elements) using CSS anchor positioning**.
- The `<select>` no longer renders outside the browser pane and does not trigger built-in mobile operating-system components.
- The `<select>` is **no longer sized based on the width of the widest `<option>`**.

(See the customizable-select guide source for the worked opt-in: `select, ::picker(select) { appearance: base-select; }` on both the select and its picker.)

Source: [appearance](https://developer.mozilla.org/en-US/docs/Web/CSS/appearance) §§ Description, Customizable select elements, MDN contributors, developer.mozilla.org, last modified 2026-04-20; fetched 2026-06-29 via direct curl, content SHA-256 `cc527ff3`.
