---
source_kind: web
source_url: https://developer.mozilla.org/en-US/docs/Web/CSS/appearance
source_content_sha256: cc527ff3a69cde64c68cd61e55c9172f693cf22fd3f7e3f05403753df2e9768a
source_authors: [MDN contributors]
source_date: 2026-04-20
retrieved: 2026-06-29
ingested: 2026-06-29
ingested_by: scholar
section_count: 1
status: current
notes: "MDN reference for the CSS appearance property, ingested for its base / base-select material (the customizable-select opt-in). Fetched live via direct curl; idempotency anchor is source_content_sha256. One section captures the none-vs-base framing and the base-select value; the property's full legacy non-standard-value catalog is intentionally not transcribed (stale-mirror avoidance)."
---

The MDN reference for the CSS `appearance` property, ingested for the half relevant to customizable `<select>`: the `none` vs `base` framing (native styling removal vs a usable primitive native appearance) and the `base-select` value that opts a `<select>` and its `::picker(select)` into customizable rendering. Records that changing `appearance` does not change a widget's functionality, and that `base-select` makes the picker a top-layer popover positionable via anchor positioning and stops the select being sized to the widest option. The property's broader legacy `-moz-`/`-webkit-` non-standard value catalog is out of scope for this ingest.

| Section | Topics | Status |
|---------|--------|--------|
| [appearance: base-select — opting a select into customizable rendering](../sections/web--mdn-appearance-base-select--base-select-value.md) | web-frontend | current |
