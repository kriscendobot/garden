---
title: "endo-but-for-bots — packages/compartment-mapper/designs/subpath-pattern-replacement.md — Node.js subpath pattern parity via shared-assertion-file"
source-slug: endo-but-for-bots--pkg-compartment-mapper-designs-subpath-pattern-replacement
url: https://github.com/endojs/endo-but-for-bots/blob/master/packages/compartment-mapper/designs/subpath-pattern-replacement.md
authors: [Endo project (collective)]
repo: endojs/endo-but-for-bots
path: packages/compartment-mapper/designs/subpath-pattern-replacement.md
total-lines: 271
ingest-cycle: 287
ingest-date: 2026-06-10
lane: designs
---

# `endo-but-for-bots/packages/compartment-mapper/designs/subpath-pattern-replacement.md`

A 271-line design specifying parity with Node.js subpath pattern replacement for `exports` and `imports` in `package.json`. **The first design from a per-package `packages/<name>/designs/` directory the library has ingested** — distinct from the prior endo-but-for-bots designs which were all under the top-level `designs/` directory.

## Key moves

- **§the-second-named-designs-tree-in-the-endo-but-for-bots-repository** — top-level `designs/` + per-package `packages/<name>/designs/`; the cluster has two named designs trees.
- **§the-`Objective`-section-as-named-design-doc-opening-name** — distinct from canonical `## Motivation` or `## What is the Problem Being Solved?`; §three-named-opening-section-conventions.
- **§the-`*`-IS-a-string-replacement-token-not-a-glob** — defensively bolded counter-claim; the-named-pejorative-of-mistaken-mental-model (§two-cycles-with-named-pejorative-of-mistaken-mental-model: 273 + 287).
- **§the-`*`-matches-across-`/`-separators** — explicit named deviation from glob semantics.
- **§the-seven-numbered-Rules-of-Node.js-subpath-semantics** — design enumerates the upstream spec it's matching; §the-implementation-must-honor-the-numbered-upstream-spec.
- **§the-Implementation-section-organized-by-source-file** — `(src/pattern-replacement.js)` named in subsection headings; §the-file-path-IS-the-section-anchor.
- **§the-O(1)-Map-vs-sorted-wildcard-array distinction** — exact entries in Map, wildcards in prefix-length-descending sorted array.
- **§the-prefix-length-descending-sort-IS-the-named-specificity-ordering** — realizes Rule 4 (longest matching prefix wins).
- **§the-null-target-IS-a-named-three-state-result-shape** — matched+replaced + matched+excluded + no-match.
- **§the-3-priority-resolution-order in moduleMapHook** — concrete > patterns > scope; fall-through-order-IS-the-named-resolution-policy.
- **§the-write-back-pattern-with-named-`__createdBy`-tag** — `__createdBy: 'link-pattern'`; three named purposes (caching + policy + archival).
- **§the-named-double-underscore-tag-as-provenance-marker** — internal-use marker field convention.
- **§the-`patterns: never`-type-level-enforcement** — TypeScript `never` as named compile-time-guarantee that the field cannot exist in the archived shape.
- **§the-Eschewed-Alternatives-section-with-two-named-rejected-shapes** — per-segment-via-prefix-tree (didn't match Node.js semantics) + array-fallback-values (would require I/O); §two-cycles-with-named-rejected-alternatives-shape (283 inline + 287 dedicated section).
- **§the-pure-string-operation-discipline** — no filesystem access; the named constraint that drives the eschewal of array-fallback-values.
- **§the-Parity-by-construction testing discipline** — shared assertion file (`_subpath-patterns-assertions.js`) IS the spec; both implementations meet there; parity by structural-invariant not by comparison.
- **§the-shared-assertion-file-IS-the-parity-mechanism** — the leading underscore IS the private-helper convention.
- **§the-`.node-condition.test.js`-double-extension-as-named-test-mode-marker** — file extension IS the test-mode discriminator.
- **§three-named-execution-modes-for-the-same-fixture** — plain Node + node-with-condition + scaffold-harness.
- **§the-scaffold-harness-exercises-seven-named-functions** — loadLocation + importLocation + makeArchive + parseArchive + writeArchive + loadArchive + importArchive.
- **§the-named-package-IS-the-named-test-case** — `patterns-lib` + `cond-patterns-lib` + `multi-star-lib` + `globstar-lib` + `app`; the package name documents the tested behavior.
- **§the-ten-row-Cases-Covered-table** — named test cases → named specifiers → expected resolutions.
- **§the-`#`-prefix-IS-the-named-internal-marker** — `imports` (with `#`-prefix) are package-private; `exports` (without prefix) are cross-package; §the-imports-IS-package-private + the-exports-IS-cross-package.
- **§the-import-patterns-NOT-propagated discipline** — `#`-prefix patterns are package-internal.
- **§the-no-metadata-table-shape reaffirmed** — §two-cycles-with-no-metadata-table-shape (285 + 287).

## Section files

- [§Node-parity-by-construction-with-shared-assertions + §`*`-IS-string-token-not-glob + §write-back-with-named-`__createdBy`-tag + 20 more first-explicit-observations](../sections/endo-but-for-bots--pkg-compartment-mapper-designs-subpath-pattern-replacement--node-parity-by-construction-with-shared-assertions-and-string-token-not-glob-and-write-back-with-named-tag.md) — full 271-line design in scope.

## Ingest scope

Cycle 287 (designs-lane after cycle 286 chat-lane @endo/zip/src/crc32.js). Full 271-line design in scope. **First-explicit-observations (twenty-three)**: the-second-named-designs-tree-in-the-endo-but-for-bots-repository + the-`Objective`-section-as-named-design-doc-section-name + the-`*`-IS-a-string-replacement-token-not-a-glob + the-named-counter-intuitive-semantic + the-seven-numbered-Rules-of-Node.js-subpath-semantics + the-Implementation-section-organized-by-source-file + the-O(1)-Map-vs-sorted-wildcard-array-distinction + the-prefix-length-descending-sort-IS-the-named-specificity-ordering + the-null-target-IS-a-named-three-state-result-shape + the-3-priority-resolution-order-in-moduleMapHook + the-write-back-pattern-with-named-`__createdBy`-tag + the-three-named-purposes-of-the-write-back + the-`patterns: never`-type-level-enforcement + the-Eschewed-Alternatives-section + the-pure-string-operation-discipline + the-Parity-by-construction-testing-discipline + the-shared-assertion-file-IS-the-parity-mechanism + the-`.node-condition.test.js`-double-extension-as-named-test-mode-marker + the-named-package-IS-the-named-test-case + the-fixture-package-IS-self-documenting + the-ten-row-Cases-Covered-table + the-`#`-prefix-IS-the-named-internal-marker + the-import-patterns-NOT-propagated-discipline.
