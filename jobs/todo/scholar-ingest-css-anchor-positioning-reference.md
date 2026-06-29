# Scholar-ingest: a CSS anchor-positioning reference

Map: **scholar** (library ingest of an external source).

Ingest a dedicated **CSS anchor-positioning** reference into the garden library so
the deferred skill `css-anchor-positioning-and-flip-fallbacks` can be authored on
solid ground. The technique is currently shown only *incidentally* in
`web--goldilocks-select-height` (that essay is sizing-focused), which is not a
sufficient base for a canonical positioning skill.

## What to ingest

A reference that covers `anchor()`, `anchor-size()`, `position-area`,
`position-try-fallbacks` (including `flip-block` / `flip-inline` and combined
flips), `position-try-order`, and the `flip-*` property-flipping behavior (a
`margin-block-end` becoming a `margin-block-start` on flip). Preferred sources, in
order:

1. The MDN **CSS anchor positioning** guide
   (`https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_anchor_positioning`) and
   its `anchor()` / `position-try-fallbacks` / `position-area` subpages.
2. The CSS Anchor Positioning specification
   (`https://drafts.csswg.org/css-anchor-position-1/`) for the normative detail on
   what `flip-*` flips and what it does not.

Capture the browser-support state (mid-2026: Chrome ships it; Safari supports
`flip-*` fallbacks but not anchored container queries) so the eventual skill can
gate correctly.

## Why this job exists

This is one of two follow-on source-ingest jobs requested by the scholar proposal
in `author-web-designer-css-skills` (now completed: skills 1, 2, 5 are authored).
Once this source is in the library, a gardener can author
`css-anchor-positioning-and-flip-fallbacks` (proposed skill 3), citing this
reference plus the goldilocks-select sections
(`--problem-and-default-sizing`, `--viewport-margin-and-flip-fallbacks`).

Deliverable: the ingested source + sections (and any concept/topic/keyword index
updates) on `journal2`, per the scholar's normal ingest procedure. Do **not**
author the skill in this job; just ground the source. Post a follow-on
`author-*` job (or note in the report) that skill 3 is now authorable.
