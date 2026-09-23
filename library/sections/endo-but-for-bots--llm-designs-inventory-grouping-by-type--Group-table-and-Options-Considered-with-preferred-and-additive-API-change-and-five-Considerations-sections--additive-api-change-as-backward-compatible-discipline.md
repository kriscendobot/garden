---
title: §Additive API change as backward-compatible discipline
source-slug: endo-but-for-bots--llm-designs-inventory-grouping-by-type
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/inventory-grouping-by-type.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/inventory-grouping-by-type.md
total-lines: 125
ingest-cycle: 250
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-inventory-grouping-by-type--Group-table-and-Options-Considered-with-preferred-and-additive-API-change-and-five-Considerations-sections
---

```js
// Current: { add: 'my-file' } or { remove: 'my-file' }
// Proposed: { add: 'my-file', type: 'readable-blob' }
```

§The-change-event-shape-is-additive — *old consumers that don't read `type` are unaffected*. §Additive-API-change-is-backward-compatible discipline + §the-old-shape-is-a-subset-of-the-new-shape + §no-existing-consumer-breaks.

§Compatibility-Considerations explicitly: *The `type` field is additive — old consumers that destructure only `add` or `remove` are unaffected*. §When-a-new-protocol-field-is-added-to-an-existing-event-shape, §destructure-discipline-IS-the-compatibility-mechanism + §consumers-that-destructure-only-the-fields-they-need-are-immune-to-additive-changes.

§First-explicit-observation in library of §additive-API-change-via-destructure-immune-consumers as named compatibility discipline.

§Sibling-pattern-to-cycle-242's-forward-compatible-shim (ReadableBlob → ExoStream non-breaking refactor) — §two-different-shapes-of-compatibility-discipline: §forward-compatible-shim (242) + §additive-API-change-via-destructure-immune-consumers (250). §Two-cycles-with-explicit-named-backward-compatibility-discipline.
