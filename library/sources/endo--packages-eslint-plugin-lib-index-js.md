---
source_kind: source
source_repo: endojs/endo
source_path: packages/eslint-plugin/lib/index.js
source_line_range: 1-21
ingested: 2026-06-15
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 360 chat-lane ingest paired to cycle 359 designs-lane
  @endo/eslint-plugin README. 20-line entry point using
  requireIndex to enumerate `lib/rules/` and `lib/configs/`.
  Eighth AUTHORED conformant single-body section doc in post-
  refactor era. Fifty consecutive non-garden sources after the
  pivot (310-360). §fifty-cycles-with-named-pivot-domain-stay.
  FOURTEENTH instance of complementary lens after the pivot in
  the broader pattern, but in the specific sense it is a
  fresh-source paired-cycle chat-lane (not a re-ingest).

  Single most structurally interesting move: §the-named-
  requireindex-delegating-to-filesystem — 2 LINES of business
  logic expose the entire package surface area by enumerating
  the contents of two directories. §the-named-filesystem-as-
  source-of-truth-not-documentation as tier-3 meta-pattern.

  This cycle reveals an INVERTED §the-named-design-vs-
  implementation-arc-from-README-to-source compared to cycle
  358's instance. In cycle 357→358 (zip), the README was
  abstract and the source made it concrete. In cycle 359→360
  (eslint-plugin), the README UNDERCOUNTS what the source
  exposes: the README names FIVE configs (recommended +
  imports + style + strict + internal); `lib/configs/` actually
  contains EIGHT (those five plus daemon + ses + recommended-
  requiring-type-checking). The README's "Supported Rules"
  section says literally `* Fill in provided rules here`;
  `lib/rules/` actually contains SIX (assert-fail-as-throw +
  harden-exports + no-assign-to-exported-let-var-or-function
  + no-multi-name-local-export + no-polymorphic-call +
  restrict-comparison-operands). §the-named-readme-undercounts-
  the-implementation as tier-3 meta-pattern, complementing
  cycle 358's §the-named-readme-abstracts-the-implementation.

  §The-named-two-shapes-of-design-vs-implementation-arc-from-
  README-to-source as new tier-3 framing: ABSTRACTING
  (cycle 357→358 zip) vs UNDERCOUNTING (cycle 359→360
  eslint-plugin). Both are forms of the README not being the
  source of truth, but they differ in directionality.

  §The-named-honest-placeholder-in-README-as-license-to-
  under-document — cycle 359's `* Fill in provided rules here`
  is the EXPLICIT acknowledgment that documentation lags
  implementation; the lint plugin's six functional rules are
  shipped without README entries because the placeholder
  states the gap exists. The placeholder is not just honest
  about incompleteness; it pre-authorizes under-documentation.

  §The-named-Agoric-specific-plugin-comment — `lib/index.js`
  line 2 carries `@module Agoric-specific plugin` and line 3
  `@author Agoric`, an UPSTREAM HISTORICAL ATTRIBUTION that
  predates the `@endo/eslint-plugin` rename. §the-named-
  attribution-fossil-from-pre-rename as tier-3 meta-pattern;
  the package was originally Agoric-specific and was
  generalized to Endo without sweeping the JSDoc preamble.

  Closes six citation arcs: cycle 359 (1, adjacent forward
  pair README → source) + cycle 358 (1, the cycle that named
  the design-vs-implementation-arc-from-README-to-source for
  zip; the second known instance now establishes the meta-
  pattern) + cycle 326 (34, pure-naming-as-discipline sibling)
  + cycle 345 (15, lockdown + Hardened JS naming) + cycle 188
  (173, Endo policy doc references) + cycle 320 (46, earlier
  eslint trace). Pushes citation-arc-closures-in-pivot to
  ONE-HUNDRED-NINETY-ONE (185 + 6 net new).
---

20-line `lib/index.js` for @endo/eslint-plugin uses requireIndex to enumerate `lib/rules/` and `lib/configs/`. Chat-lane after cycle 359 designs-lane README. §the-named-requireindex-delegating-to-filesystem (2 lines of business logic). §the-named-filesystem-as-source-of-truth-not-documentation. §the-named-readme-undercounts-the-implementation (README names 5 configs, source has 8; README says 0 rules, source has 6). §the-named-two-shapes-of-design-vs-implementation-arc-from-README-to-source as new framing: ABSTRACTING (cycle 358) vs UNDERCOUNTING (cycle 360). §the-named-honest-placeholder-in-README-as-license-to-under-document. §the-named-Agoric-specific-plugin-comment (attribution fossil from pre-rename). Six citation arcs closed.
