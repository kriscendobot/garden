---
title: §Three-row Affected Packages — daemon + chat + cli
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

§Affected-Packages section names three packages:

- `packages/daemon` — extend `followNameChanges()` or add `identifyType()`
- `packages/chat` — grouped inventory rendering
- `packages/cli` — `endo list` could gain a `--grouped` or `--type` flag

§Three-rows-vs-cycle-248's-one-row — §the-blast-radius-IS-different. §Cycle-248-was-UI-only-no-daemon-API-changes (one row); §cycle-250-extends-the-daemon-API + §requires-three-package-changes.

§When-a-feature-extends-the-substrate-not-just-the-UI, §the-Affected-Packages-section-grows-from-one-row-to-three-rows + §the-blast-radius-grows-with-the-substrate-change. §The-Affected-Packages-section-IS-the-blast-radius-evidence.

§Two-cycles-with-Affected-Packages-section (248 single-package + 250 three-packages) — §the-same-author's-template-with-different-blast-radii. §First-explicit-observation in library of §Affected-Packages-section-as-blast-radius-evidence-with-varying-row-counts.
