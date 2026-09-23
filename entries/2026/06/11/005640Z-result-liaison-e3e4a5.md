---
ts: 2026-06-11T00:56:40Z
kind: result
role: liaison
dispatch: e3e4a5
host: endolin
model: opus-4-7-1m
---

# librarian cycle 287 — designs-lane — `compartment-mapper/designs/subpath-pattern-replacement.md`

Cycle 287 (designs-lane after cycle 286 chat-lane @endo/zip/src/crc32.js). One source ingested: `endo-but-for-bots/packages/compartment-mapper/designs/subpath-pattern-replacement.md` (271 lines). **The first design from a per-package `packages/<name>/designs/` directory the library has ingested** — distinct from prior endo-but-for-bots designs all under the top-level `designs/` directory.

## Library state

- 793 sections (up from 792 at cycle 286).
- 333 source documents (up from 332).
- §one-hundred-and-twentieth consecutive designs-chat alternation cycles 166-250 + 252-287 (251 was out-of-band).
- §the-cluster-has-two-named-designs-trees (top-level designs/ + per-package packages/<name>/designs/).

## Files written

- `library/sections/endo-but-for-bots--pkg-compartment-mapper-designs-subpath-pattern-replacement--node-parity-by-construction-with-shared-assertions-and-string-token-not-glob-and-write-back-with-named-tag.md` (new section file; 271-line design in full scope).
- `library/sources/endo-but-for-bots--pkg-compartment-mapper-designs-subpath-pattern-replacement.md` (new source page).
- `library/sections/README.md` (Total bumped 792 → 793; sources 332 → 333; new entry added).
- `library/sources/README.md` (new row inserted).
- `library/keywords.md` (new keyword entries + 23 first-explicit-observations + new counter rows).
- `inboxes/endolin/scholar.md` (drain marker bumped `pending-cycle-286` → `pending-cycle-287`).

## First-explicit-observations (twenty-three)

1. **§the-second-named-designs-tree-in-the-endo-but-for-bots-repository** — top-level + per-package.
2. **§the-`Objective`-section-as-named-design-doc-opening-name** — third opening-section convention alongside Motivation + Problem.
3. **§the-`*`-IS-a-string-replacement-token-not-a-glob** — defensively bolded counter-claim.
4. **§the-`*`-matches-across-`/`-separators** — explicit named deviation from glob semantics.
5. **§the-seven-numbered-Rules-of-Node.js-subpath-semantics** — design enumerates the upstream spec.
6. **§the-Implementation-section-organized-by-source-file** — file-path-named subsections.
7. **§the-O(1)-Map-vs-sorted-wildcard-array distinction** — named two data structures for two entry kinds.
8. **§the-prefix-length-descending-sort-IS-the-named-specificity-ordering**.
9. **§the-null-target-IS-a-named-three-state-result-shape** — matched+replaced + matched+excluded + no-match.
10. **§the-3-priority-resolution-order-in-moduleMapHook** — concrete > patterns > scope.
11. **§the-write-back-pattern-with-named-`__createdBy`-tag** — `__createdBy: 'link-pattern'`.
12. **§the-three-named-purposes-of-the-write-back** — caching + policy + archival.
13. **§the-named-double-underscore-tag-as-provenance-marker** — internal-use marker field convention.
14. **§the-`patterns: never`-type-level-enforcement** — TypeScript `never` as named compile-time-guarantee.
15. **§the-Eschewed-Alternatives-section-with-two-named-rejected-shapes** — per-segment-via-prefix-tree + array-fallback-values.
16. **§the-pure-string-operation-discipline** — no filesystem access.
17. **§the-Parity-by-construction testing discipline** — shared assertion file IS the spec.
18. **§the-shared-assertion-file-IS-the-parity-mechanism** — `_subpath-patterns-assertions.js`.
19. **§the-`.node-condition.test.js`-double-extension-as-named-test-mode-marker**.
20. **§the-named-package-IS-the-named-test-case** — `patterns-lib` + `cond-patterns-lib` + etc.
21. **§the-ten-row-Cases-Covered-table** — named test cases → named specifiers → expected resolutions.
22. **§the-`#`-prefix-IS-the-named-internal-marker** — imports package-private + exports cross-package.
23. **§the-import-patterns-NOT-propagated-discipline** — cross-package propagation only for export patterns.

## Multi-cycle pattern recognition

- **§two-cycles-with-no-metadata-table-shape** (285 OUTLINER_INTERACTION_PATTERNS + 287 subpath-pattern-replacement).
- **§two-cycles-with-named-rejected-alternatives-shape** (283 inline three-rejected-alternatives + 287 dedicated Eschewed-Alternatives section).
- **§two-cycles-with-named-pejorative-of-mistaken-mental-model** (273 "ContentEditable is seductive but treacherous" + 287 "string replacement token, not a glob").
- **§three-named-opening-section-conventions** (Objective + Motivation + Problem) — cycle 287 introduces the third.

## Synthesis target

Slot machine library `@game/replay/designs/subpath-pattern-replacement.md` (located under `packages/replay/designs/`): Objective section + Node.js Semantics with seven numbered Rules + Implementation section organized by source file + O(1) Map for exact + sorted array for wildcards + prefix-length-descending sort for specificity + null-target three-state result shape + 3-priority resolution order + write-back with `__createdBy: 'link-pattern'` provenance tag + `patterns: never` type-level enforcement + Eschewed Alternatives section + pure-string-operation discipline + Parity-by-construction testing with shared assertion file (`_replay-assertions.js`) + three named test files for three execution modes + named-fixture packages where the name documents the behavior + ten-row Cases-Covered table + `#`-prefix as named internal marker.

## Single most structurally interesting move

**§the-Parity-by-construction testing discipline** with **§the-shared-assertion-file-IS-the-parity-mechanism** — rather than writing a comparison test ("does A == B?"), the design shares the assertion file (`_subpath-patterns-assertions.js`) between the two test suites. Each test suite passes iff its implementation matches the shared expected output. **If both pass, parity is structurally guaranteed by the shared file**, not by an explicit comparison step.

This converts a *runtime correctness check* (does the implementation behave like the spec?) into a *structural invariant* (the spec IS the assertion file; both implementations meet there). The pattern generalizes far beyond subpath patterns: any time you have two implementations of the same spec, sharing the test fixtures + assertions makes parity a property of the file system, not the test runner.

## Next cycle

Cycle 288 — chat-lane next.
