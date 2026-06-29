---
source_kind: web-essay
source_url: https://jakearchibald.com/2026/goldilocks-select-height/
source_content_sha256: a73ec7f270b8ba4d87005dabc68aa2442016d528806720ab7d80e61a71fc781a
source_author: Jake Archibald
source_date: 2026-06-29
retrieved: 2026-06-29
ingested: 2026-06-29
ingested_by: scholar
section_count: 4
status: current
notes: "Authored blog essay; fetched live and reachable via direct curl (source_fetched_via=direct), so no archive snapshot needed. The idempotency anchor is source_content_sha256 over the live response body, not a git SHA. The essay's nominal subject is customizable <select> picker height, but its reusable substance is the general CSS toolkit: calc-size() arithmetic on intrinsic sizes, @supports progressive enhancement, and anchor-positioning flip fallbacks."
---

Jake Archibald's essay on sizing the picker (drop-down) of a customizable (fully stylable) `<select>` to a "Goldilocks" — not too tall, not too short, not too small for a short list — height in CSS. The reusable core is a general CSS-sizing toolkit: `calc-size()` for arithmetic on intrinsic sizes (`fit-content`, `stretch`), `@supports` feature-query progressive enhancement with hand-rolled fallbacks (including `:has()`/`:nth-of-type()` structural detection), and CSS anchor positioning with `flip-*` `position-try-fallbacks`. Because customizable select is built on the popover + anchor-positioning primitives, the technique generalizes to sizing any popover/menu anchored to a control. Includes a browser-support matrix (Chrome has `calc-size()`; Firefox/Safari do not yet; Firefox lacks `max-block-size: stretch`).

| Section | Topics | Status |
|---------|--------|--------|
| [The Goldilocks problem and default ::picker(select) sizing](../sections/web--goldilocks-select-height--problem-and-default-sizing.md) | web-frontend | current |
| [Keeping the picker off the viewport edge: margin + flip-* fallbacks](../sections/web--goldilocks-select-height--viewport-margin-and-flip-fallbacks.md) | web-frontend | current |
| [Clamping min/max with calc-size() and intrinsic sizes](../sections/web--goldilocks-select-height--intrinsic-min-max-with-calc-size.md) | web-frontend | current |
| [The complete picker CSS and the browser-support matrix](../sections/web--goldilocks-select-height--final-css-and-browser-support.md) | web-frontend | current |
