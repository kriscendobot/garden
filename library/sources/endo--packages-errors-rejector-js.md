---
source_kind: source-file
source_repo: endojs/endo
source_path: packages/errors/rejector.js
source_line_range: 1-23
file_commit: abe6124fa3aca1405059c83c04cebb4ae2f30fca
file_commit_date: 2025-09-16
file_commit_author: Mark S. Miller
ingested: 2026-06-15
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 340 chat-lane ingest. 23-line types-only file (JSDoc
  + one lint-disabled import; no runtime exports). Adjacent
  forward pair with cycle 339 designs-lane @endo/errors
  README. Tenth INSTANCE of one-cycle README↔source pattern
  (cycle 339 → 340 same-package); §the-named-streak-resumes-
  with-tenth-instance.

  Single most structurally interesting move: §the-named-
  canonical-typedef-as-the-pattern-anchor — the entire file
  is ONE import + ONE typedef + ONE worked-idiom (in JSDoc)
  + ONE pointer to test file; zero runtime exports; pure
  type-level + pure documentation. The file IS the pattern.
  §the-named-canonical-source-of-a-distributed-pattern — the
  Rejector trio pattern has been observed in 13+ prior pivot
  cycles (102 + 134 + 138 + 140 + 142 + 148 + 150 + 211 +
  322 + 325 + 332 + 337 + 339); cycle 340 reveals the
  canonical typedef. §the-named-pattern-citation-network-
  anchored-at-canonical-source.

  Other key first-explicit-observations: §the-named-types-
  only-file (JSDoc + lint-disabled import; no runtime
  exports); §the-named-Rejector-IS-false-OR-Fail (sum-type
  discriminator: false | typeof Fail); §the-named-binary-
  choice-silent-vs-throwing (silent-reject used by is*
  predicates; throwing-reject used by assert* assertions);
  §the-named-discriminator-type-as-mode-switch (one function
  body serves two modes via discriminator parameter); §the-
  named-cond-OR-reject-AND-reject-template-literal (three-
  part short-circuit idiom: `cond || reject && reject\`...\``);
  §the-named-three-step-evaluation-shown-in-JSDoc (prose
  enumerates three cases: cond truthy / reject false /
  reject Fail); §the-named-three-case-enumeration-tracks-
  binary-tree; §the-named-template-literal-tag-as-error-
  constructor (Fail invoked as template literal tag);
  §two-shapes-of-error-construction-syntax (cycle 87
  null.null + cycle 340 Fail`...`); §the-named-test-file-as-
  canonical-examples (JSDoc points to rejector.test.js for
  illustration); §two-cycles-with-named-tests-as-examples-
  discipline (333 + 340); §the-named-import-for-typedef-
  only-with-named-lint-disable (line 1 eslint-disable for
  no-unused-vars); §three-cycles-with-named-named-lint-
  disable-with-canonical-rationale (211 + 338 + 340); §the-
  named-intra-package-import-as-canonical-coupling (relative-
  path import marks intra-package coupling vs cross-package
  @endo/X/foo.js); §three-cycles-with-named-intra-package-
  relative-import (322 + 332 + 340).

  Closes nine citation arcs (canonical-source closure of the
  Rejector trio): cycle 339 = 1 cycle (adjacent forward pair)
  + cycle 102 = 238 cycles (Rejector trio FIRST observation;
  canonical anchor closure) + cycle 87 = 253 cycles (ties
  cycle 339's 252-cycle arc as second-longest pivot arc
  after the 261-cycle record) + cycle 134 = 206 cycles +
  cycle 138 = 202 cycles + cycle 142 = 198 cycles + cycle
  148 = 192 cycles + cycle 150 = 190 cycles + cycle 211 =
  129 cycles. Pushes citation-arc-closures-in-pivot to
  SEVENTY-FIVE (68 + 7 net new). §three-cycles-with-named-
  substrate-package-introduction (337 + 339 + 340).
---

> Abstract: 23-line **types-only file** for the @endo/errors
> Rejector trio. ONE import (lint-disabled because used only
> in JSDoc) + ONE typedef + ONE worked-idiom + ONE pointer
> to test file. Zero runtime exports. **The file IS the
> pattern**.
>
> **Single most structurally interesting move**: §the-named-
> canonical-typedef-as-the-pattern-anchor — the canonical
> definition of the Rejector trio pattern observed across
> 13+ prior pivot cycles lives in this 23-line file. §the-
> named-canonical-source-of-a-distributed-pattern; §the-
> named-pattern-citation-network-anchored-at-canonical-
> source.
>
> §the-named-types-only-file — JSDoc + lint-disabled import;
> no runtime exports.
>
> §the-named-Rejector-IS-false-OR-Fail (sum-type discriminator)
> + §the-named-binary-choice-silent-vs-throwing + §the-named-
> discriminator-type-as-mode-switch.
>
> §the-named-cond-OR-reject-AND-reject-template-literal
> (three-part short-circuit idiom shown in JSDoc) + §the-
> named-three-step-evaluation-shown-in-JSDoc + §the-named-
> three-case-enumeration-tracks-binary-tree.
>
> §the-named-template-literal-tag-as-error-constructor
> (Fail`...`); §two-shapes-of-error-construction-syntax
> (cycle 87 null.null + cycle 340 Fail`...`).
>
> §the-named-test-file-as-canonical-examples — JSDoc points
> to rejector.test.js for illustration; §two-cycles-with-
> named-tests-as-examples-discipline (333 + 340).
>
> §the-named-import-for-typedef-only-with-named-lint-disable;
> §three-cycles-with-named-named-lint-disable-with-canonical-
> rationale (211 + 338 + 340).
>
> §the-named-intra-package-import-as-canonical-coupling;
> §three-cycles-with-named-intra-package-relative-import
> (322 + 332 + 340).
>
> Closes nine citation arcs including the 238-cycle arc back
> to cycle 102's first Rejector observation (CANONICAL-
> source closure) and the 253-cycle arc to cycle 87 (ties
> cycle 339's 252-cycle arc as second-longest pivot arc).
> §three-cycles-with-named-substrate-package-introduction
> (337 + 339 + 340).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [canonical-typedef-as-the-pattern-anchor-of-the-distributed-Rejector-trio](../sections/endo--packages-errors-rejector-js--canonical-typedef-as-the-pattern-anchor-of-the-distributed-Rejector-trio.md) | hardened-javascript, types-only-file, canonical-typedef, Rejector-trio, distributed-pattern-anchor | current (cycle 340, chat-lane) |

23-line file. One section. The single section is dense with first-explicit-observations because the file's STRUCTURAL SIGNIFICANCE (canonical anchor for a 13+ cycle citation network) is far greater than its line count would suggest.

## Provenance

- Fetched 2026-06-15 from `endojs/endo@HEAD` (commit `abe6124fa3aca1405059c83c04cebb4ae2f30fca`) via the local clone.
- Last substantive touch 2025-09-16 by Mark S. Miller.
- Apache-2.0 license per package LICENSE file.
- **Thirty-first consecutive non-garden source after the pivot** (cycles 310-340).
- **Tenth INSTANCE of one-cycle README↔source pattern** (cycle 339 → 340 same-package). §the-named-streak-resumes-with-tenth-instance — streak count is 1.
- **Canonical-source closure of the Rejector trio pattern** — cycle 102's first explicit observation is closed at 238 cycles.
- Cycle 340 closes **nine citation arcs** across the Rejector trio's observation cluster.
- §the-named-substrate-package-introduction-closes-many-arcs discipline applies for the THIRD TIME (cycle 337 + 339 + 340). §three-cycles-with-named-substrate-package-introduction.
