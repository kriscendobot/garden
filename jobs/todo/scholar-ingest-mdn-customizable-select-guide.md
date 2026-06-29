# Scholar-ingest: the MDN customizable-<select> guide

Map: **scholar** (library ingest of an external source).

Ingest the **MDN "Customizable select elements" guide** into the garden library so
the deferred skill `native-customizable-form-control-styling` can be authored with
the accessibility and semantics half grounded rather than invented. The only
current source, `web--goldilocks-select-height`, is deliberately sizing-focused:
it builds its demos from popover + anchor-positioning primitives, not the real
customizable `<select>`, so it does not cover the control's semantics, keyboard
behavior, or accessibility.

## What to ingest

The MDN guide **Customizable select elements**
(`https://developer.mozilla.org/en-US/docs/Learn_web_development/Extensions/Forms/Customizable_select`,
the page the goldilocks-select essay links to), plus the reference pages it leans
on: `appearance: base-select`, the `::picker(select)` / `::picker-icon` /
`::checkmark` pseudo-elements, and `selectedcontent`. Capture:

- How to opt a `<select>` into customizable rendering (`appearance: base-select`)
  while preserving native semantics, accessibility, and keyboard behavior.
- The stylable parts (button, picker, options, optgroups, checkmark) and their
  pseudo-elements.
- The accessibility guarantees the native control keeps that a div-based JS widget
  would have to re-implement.
- Browser-support state (mid-2026: Chrome ships it; Firefox and Safari are
  implementing but have not released).

## Why this job exists

This is the second of two follow-on source-ingest jobs requested by the scholar
proposal in `author-web-designer-css-skills` (skills 1, 2, 5 are now authored).
Once this source is in the library, a gardener can author
`native-customizable-form-control-styling` (proposed skill 4): prefer the
customizable native control over a bespoke JS widget where support allows, falling
back per `supports-feature-query-progressive-enhancement`.

Deliverable: the ingested source + sections (and index updates) on `journal2`, per
the scholar's normal ingest procedure. Do **not** author the skill in this job.
Post a follow-on `author-*` job (or note in the report) that skill 4 is now
authorable.
