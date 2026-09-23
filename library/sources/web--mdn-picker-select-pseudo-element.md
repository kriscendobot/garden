---
source_kind: web
source_url: https://developer.mozilla.org/en-US/docs/Web/CSS/::picker
source_content_sha256: 806408c930a761e9423fc3c09bfd15d69fc045872d088cd69421bd64b99d0806
source_authors: [MDN contributors]
source_date: 2026-04-17
retrieved: 2026-06-29
ingested: 2026-06-29
ingested_by: scholar
section_count: 1
status: current
notes: "MDN reference for the ::picker() CSS pseudo-element (::picker(select)). Fetched live via direct curl; idempotency anchor is source_content_sha256. One section captures the syntax, what it targets, the implicit popover + anchor relationship, and the browser default position / position-try-fallback styles for the picker — the same defaults web--goldilocks-select-height refines for sizing."
---

The MDN reference for the `::picker()` CSS pseudo-element and its `select` argument, which targets the drop-down picker of a customizable `<select>` (all descendants except the first-child `<button>`). Captures that it is only targetable once `appearance: base-select` is set, the automatic invoker/popover relationship, the implicit anchor reference, and the browser **default** picker styles (`min-inline-size: anchor-size(self-inline)`, `max-block-size: stretch`, `position-area`, `position-try-order: most-block-size`, the `position-try-fallbacks` list) that the `[[css-intrinsic-sizing]]` goldilocks-select-height technique starts from and refines.

| Section | Topics | Status |
|---------|--------|--------|
| [::picker(select): targeting the picker, popover behavior, and default anchor styles](../sections/web--mdn-picker-select-pseudo-element--targeting-and-defaults.md) | web-frontend | current |
