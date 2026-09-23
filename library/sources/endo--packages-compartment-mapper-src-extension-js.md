---
source_kind: source
source_repo: endojs/endo
source_path: packages/compartment-mapper/src/extension.js
source_line_range: 1-23
ingested: 2026-06-18
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 372 chat-lane ingest paired to cycle 371 designs-lane
  @endo/compartment-mapper README. 22-line utility for
  parsing the file extension from a URL location string.
  Twentieth AUTHORED conformant single-body section doc in
  post-refactor era. Sixty-two consecutive non-garden sources
  after the pivot (310-372). §sixty-two-cycles-with-named-
  pivot-domain-stay.

  Single most structurally interesting move: §the-named-
  exported-for-tests-as-honest-acknowledgment — line 6
  carries `* Exported for tests.` as a JSDoc comment line.
  The export is named with TWO reasons (production use AND
  test access); the comment makes the test-access reason
  explicit so a future reader knows why the function is
  exported even when its production use is internal. §the-
  named-export-justification-comment as tier-3 meta-pattern,
  sibling to cycle 359's §the-named-honest-placeholder-not-
  hidden-gap and cycle 357's §the-named-for-expedience-as-
  honest-acknowledgment-with-named-recovery-path. Another
  shape of in-source-honest-incompleteness-or-acknowledgment.

  §The-named-pure-utility-needs-no-powers — the file imports
  NOTHING. It is pure string operations: `lastIndexOf`,
  `slice`. The cycle 371 README named §the-named-caller-
  supplies-IO-powers-not-package-imports-fs; cycle 372 source
  shows the simplest realization: don't need IO at all when
  the work is pure string parsing. §the-named-zero-dependency-
  utility as tier-3 meta-pattern, sibling to cycle 364's
  §the-named-substrate-non-use-in-substrate-benchmarking.
  The compartment-mapper avoids `path.extname` (Node's path
  module) and URL parsing libraries; uses pure character-
  position arithmetic instead.

  §The-named-empty-string-return-not-null-or-undefined — when
  the location has no slash (line 14) or no dot in the
  basename (line 19), the function returns `''` rather than
  null or undefined. §the-named-empty-string-as-no-extension-
  marker as tier-3 meta-pattern; the type stays consistently
  `string` so callers don't need a null-check before string
  ops on the result.

  §The-named-two-named-cases-with-explicit-returns — the
  function handles two failure cases (no slash; no dot) with
  named early returns. Each case has its own return statement
  rather than falling through to a common path. §the-named-
  early-return-per-case as tier-3 meta-pattern.

  §The-named-JSDoc-module-header — line 1: `/** @module
  Extracts the extension from a URL pathname. */`. The
  module's purpose is named in the first line. §the-named-
  module-purpose-in-first-line as tier-3 meta-pattern.

  §The-named-twenty-two-line-utility-from-substantive-package
  — compartment-mapper is a substantial package (~30 source
  files, thousands of lines of design surface, 773-line
  README); extension.js is 22 lines. The package decomposes
  into small focused files. Pairs with cycle 370's §the-
  named-twenty-three-line-utility-from-thousands-of-lines-of-
  daemon. The two adjacent cycles show the same shape:
  substantial package, tiny constituent utility.

  Closes seven citation arcs: cycle 371 (1, adjacent forward
  pair compartment-mapper README → extension.js source; the
  pure-utility realization of the caller-supplies-IO-powers
  discipline) + cycle 370 (1, twenty-three-line-utility-from-
  thousands-of-lines-of-daemon sibling shape; the discipline
  of tiny focused utilities in substantial packages) + cycle
  364 (1, substrate-non-use sibling; both extension.js and
  benchmark.js use only native string/numeric ops to avoid
  importing higher-level substrates) + cycle 359 (1, honest-
  placeholder-not-hidden-gap; cycle 372's exported-for-tests
  is a related shape of in-source acknowledgment) + cycle
  357 (1, for-expedience-as-honest-acknowledgment sibling
  shape) + cycle 326 (45, pure-naming-as-discipline) + cycle
  322 (46, @endo/errors not used; utility is small enough
  not to need error decoration). Pushes citation-arc-
  closures-in-pivot to TWO-HUNDRED-SEVENTY-SIX (269 + 7 net
  new).
---

22-line utility for parsing the file extension from a URL location string in @endo/compartment-mapper. Chat-lane after cycle 371 designs-lane compartment-mapper README. §the-named-exported-for-tests-as-honest-acknowledgment (single most structurally interesting move — line 6 `* Exported for tests.` JSDoc comment names the two-reason export). §the-named-export-justification-comment (tier-3 meta-pattern; sibling to cycle 359 honest-placeholder and cycle 357 honest-acknowledgment shapes). §the-named-pure-utility-needs-no-powers (zero imports; pure string ops; simplest realization of cycle 371's caller-supplies-IO-powers discipline). §the-named-zero-dependency-utility (sibling to cycle 364 substrate-non-use). §the-named-empty-string-return-not-null-or-undefined (consistent string type). §the-named-two-named-cases-with-explicit-returns. §the-named-JSDoc-module-header. §the-named-twenty-two-line-utility-from-substantive-package (sibling to cycle 370 daemon utility shape). Seven citation arcs closed.
