---
title: Synthesis target
section-slug: endo-but-for-bots--pkg-compartment-mapper-designs-subpath-pattern-replacement--node-parity-by-construction-with-shared-assertions-and-string-token-not-glob-and-write-back-with-named-tag
source-slug: endo-but-for-bots--pkg-compartment-mapper-designs-subpath-pattern-replacement
url: https://github.com/endojs/endo-but-for-bots/blob/master/packages/compartment-mapper/designs/subpath-pattern-replacement.md
authors: [Endo project (collective)]
status: (no explicit metadata table)
ingest-cycle: 287
ingest-date: 2026-06-10
lane: designs
scope: full
total-lines: 271
parent: endo-but-for-bots--pkg-compartment-mapper-designs-subpath-pattern-replacement--node-parity-by-construction-with-shared-assertions-and-string-token-not-glob-and-write-back-with-named-tag
---

Slot machine library `@game/replay/designs/subpath-pattern-replacement.md` (located under `packages/replay/designs/` not `designs/`): Objective section (specify parity with a named upstream contract); Node.js Semantics with seven numbered Rules; Implementation section organized by source file (`src/pattern-replacement.js` + `src/infer-exports.js` + `src/link.js`); O(1) Map for exact + sorted array for wildcards; prefix-length-descending sort for specificity; null-target three-state result shape; 3-priority resolution order (concrete > patterns > scope); write-back with `__createdBy: 'link-pattern'` provenance tag serving three named purposes (caching + policy + archival); `patterns: never` type-level enforcement at archive time; Eschewed Alternatives section with two named rejected approaches; pure-string-operation discipline (no filesystem access); Parity-by-construction testing with shared assertion file (`_subpath-patterns-assertions.js`); three named test files for three execution modes (plain Node + node-with-condition + scaffold-harness); named-fixture packages where the name documents the behavior; ten-row Cases-Covered table; `#`-prefix as named internal marker.
