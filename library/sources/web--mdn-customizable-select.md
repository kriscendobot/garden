---
source_kind: web
source_url: https://developer.mozilla.org/en-US/docs/Learn_web_development/Extensions/Forms/Customizable_select
source_content_sha256: 013b9f8cf029d2b06c209edfe5692bffc182e5751bc03e362b1edea36f01e997
source_authors: [MDN contributors]
source_date: 2026-04-06
retrieved: 2026-06-29
ingested: 2026-06-29
ingested_by: scholar
section_count: 5
status: current
notes: "MDN learning guide for customizable <select>. Fetched live via direct curl (source_fetched_via=direct); idempotency anchor is source_content_sha256 over the live response body, not a git SHA. The guide is the semantics/accessibility/parts-catalog complement to web--goldilocks-select-height (which is deliberately sizing-focused and builds its demos from popover + anchor-positioning primitives rather than the real customizable <select>). Companion reference-page sources ingested the same cycle: web--mdn-appearance-base-select, web--mdn-selectedcontent, web--mdn-picker-select-pseudo-element."
---

The MDN "Customizable select elements" guide: how to build a fully-styled native `<select>` (button, picker, arrow icon, selection checkmark, each `<option>`) using only HTML and CSS, as a progressive enhancement that falls back to a classic select in non-supporting browsers. Covers the opt-in (`appearance: base-select`), the markup additions (the first-child `<button><selectedcontent></selectedcontent></button>` and rich `<option>` content), the stylable parts and their pseudo-elements (`::picker(select)`, `::picker-icon`, `::checkmark`, `:open`, `:checked`, `<optgroup>`/`<legend>`), animating the picker via popover states, positioning it via anchor positioning, the accessibility guarantees the native control keeps that a `<div>`-based JS widget would have to re-implement, and the mid-2026 browser-support state (Limited availability / not Baseline; Chrome ships, Firefox and Safari implementing).

| Section | Topics | Status |
|---------|--------|--------|
| [Background and feature inventory](../sections/web--mdn-customizable-select--background-and-feature-inventory.md) | web-frontend | current |
| [Customizable select markup and opting in](../sections/web--mdn-customizable-select--markup-and-opt-in.md) | web-frontend | current |
| [Styling the parts](../sections/web--mdn-customizable-select--styling-the-parts.md) | web-frontend | current |
| [Animating and positioning the picker](../sections/web--mdn-customizable-select--popover-and-anchor-positioning.md) | web-frontend | current |
| [Accessibility guarantees and browser-support state](../sections/web--mdn-customizable-select--accessibility-and-browser-support.md) | web-frontend | current |
