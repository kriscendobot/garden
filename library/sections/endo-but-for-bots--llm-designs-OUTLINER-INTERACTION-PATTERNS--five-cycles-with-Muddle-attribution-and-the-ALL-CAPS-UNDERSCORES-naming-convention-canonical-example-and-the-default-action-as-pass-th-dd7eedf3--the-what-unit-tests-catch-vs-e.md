---
title: §the-What-Unit-Tests-Catch-vs-E2E-table as named testing-taxonomy-shape (first-explicit-observation)
section-slug: endo-but-for-bots--llm-designs-OUTLINER-INTERACTION-PATTERNS--five-cycles-with-Muddle-attribution-and-the-ALL-CAPS-UNDERSCORES-naming-convention-canonical-example-and-the-default-action-as-pass-through-and-three-vertical-zones-and-double-rAF-for-mobile
source-slug: endo-but-for-bots--llm-designs-OUTLINER-INTERACTION-PATTERNS
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/OUTLINER_INTERACTION_PATTERNS.md
authors: [Endo project (with attribution to Muddle project)]
status: (no explicit metadata table)
ingest-cycle: 285
ingest-date: 2026-06-10
lane: designs
scope: full
total-lines: 996
parent: endo-but-for-bots--llm-designs-OUTLINER-INTERACTION-PATTERNS--five-cycles-with-Muddle-attribution-and-the-ALL-CAPS-UNDERSCORES-naming-convention-canonical-example-and-the-default-action-as-pass-through-and-three-vertical-zones-and-double-rAF-for-mobile
---

| Concern | Unit Tests | E2E Tests |
|---------|------------|-----------|
| Decision logic (what action to take) | Yes | — |
| Edge cases in behavior functions | Yes | — |
| Focus actually moves to correct block | — | Yes |
| Cursor position after operations | — | Yes |
| Textarea auto-resize | — | Yes |
| Drag-to-select visual behavior | — | Yes |
| Block creation renders in DOM | — | Yes |
| Cross-browser keyboard handling | — | Yes |

**§the-explicit-taxonomy-of-what-each-test-tier-catches as named testing-discipline-document** (first-explicit-observation). The table explicitly says **"Decision logic" goes to unit + "Visual + state-effect" goes to E2E**. This is **§the-pure-functions-IS-where-the-unit-tests-go + §the-DOM-effects-IS-where-the-E2E-tests-go** as named two-tier testing strategy with a table-based assignment of concerns.
