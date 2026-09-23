---
source_kind: source
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/patterns/src/keys/copySet.js
source_line_range: 1-110
ingested: 2026-06-21
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 428 chat-lane ingest. 110-line copySet.js from
  @endo/patterns/src/keys — the implementation of
  CopySet (cycle 427's "passable alternative to
  JavaScript Set"). Seventy-sixth AUTHORED conformant
  single-body section doc in post-refactor era. One-
  hundred-and-eighteen consecutive non-garden sources
  after the pivot (310-428). §one-hundred-and-eighteen-
  cycles-with-named-pivot-domain-stay.

  Single most structurally interesting move: §the-named-
  call-local-full-order-supplements-distributed-partial-
  order — line 40: `fullCompare = fullCompare ||
  makeFullOrderComparatorKit().antiComparator`. The
  comment elaborates (lines 36-37): "This fullOrder
  contains history dependent state. It is specific to
  this one call and does not survive it." Cycle 427
  named the keys-have-partial-order-not-total-order
  framing. Cycle 428 reveals the refinement: the
  PARTIAL order is the distributed-equality TRUTH across
  vats (different remotables are genuinely
  incomparable); but for LOCAL operations like sorting
  and duplicate detection, the file constructs a CALL-
  LOCAL TOTAL ORDER. Two orderings coexist for two
  purposes: partial for cross-vat semantic correctness,
  full for per-call algorithmic convenience. §the-named-
  partial-order-for-semantics-full-order-for-sort as
  tier-3 meta-pattern.

  §the-named-three-stage-validation-confirm-assert-
  coerce — three exported validators with escalating
  commitment:
  - confirmElements (line 69): structural — copyArray
    kind + sorted + no duplicates; rejector-based
  - assertElements (line 86): unconditional wrapper
    with Fail
  - coerceToElements (line 95): sort + assert + return
  Cycle 427's matches/mustMatch (predicate/assertion
  pair) and cycle 424's confirmCanBeValid/
  assertRestValid (predicate/assertion pair) now joined
  by confirm/assert/coerce (predicate/assertion/sort-
  and-assert TRIPLE). The cluster's validation
  vocabulary deepens. §the-named-three-stage-confirm-
  assert-coerce as tier-3 meta-pattern.

  §the-named-CopySet-as-makeTagged-with-sorted-elements
  — line 108: `makeTagged('copySet', coerceToElements
  (elementIter))`. CopySet IS a tagged-copy-structure
  carrying a sorted array of elements. The tag is the
  string 'copySet'. §the-named-tagged-copy-structure-
  as-passable-collection-shape as tier-3 meta-pattern.

  §the-named-tagged-structure-tag-matches-pass-style-
  name — cycle 424 noted 'copyRecord' as styleName for
  the pass-style helper. CopySet uses 'copySet' as the
  makeTagged tag. The tag names match across the layer
  boundary. §the-named-tag-string-uniform-across-pass-
  style-and-patterns as tier-3 meta-pattern.

  §the-named-makeTagged-as-marshal-primitive-for-
  tagged-copy-structures — line 4: makeTagged imported
  from @endo/marshal. The tagged-copy-structure
  primitive lives in marshal, used by patterns. §the-
  named-marshal-provides-tagged-structures-patterns-
  uses-them as tier-3 meta-pattern.

  §the-named-copySet-stored-in-reverse-rank-order —
  lines 76, 96: `compareAntiRank` is used for sorting.
  CopySet elements are stored in REVERSE RANK ORDER.
  Possibly for consistency with merge operations or
  efficient subset checking. §the-named-anti-rank-as-
  reverse-rank-sort-order as tier-3 meta-pattern.

  §the-named-sort-then-adjacent-equality-for-
  duplicate-detection — lines 42-50: sort by full
  compare, then iterate adjacent pairs checking
  `fullCompare(k0, k1) === 0`. Standard sort-and-
  scan duplicate detection. O(n log n) + O(n).
  §the-named-sorted-array-with-adjacent-comparison as
  tier-3 meta-pattern.

  §the-named-hideAndHardenFunction-as-stronger-than-
  harden — line 89: `hideAndHardenFunction(assertElements)`.
  Imported from @endo/errors. Not just harden — also
  HIDES the function (presumably less introspectable
  via `toString()` etc.). §the-named-hide-and-harden-
  as-additional-defense as tier-3 meta-pattern; the
  cluster's harden vocabulary extends with a stronger
  primitive.

  §the-named-rejector-or-Fail-as-error-channel-
  parameter — pattern across confirm/assert pairs:
  confirmElements takes `reject` (Rejector); assert
  Elements passes Fail. Sibling to cycle 424's
  conditional-reject-vs-unconditional-Fail framing.
  §the-named-error-channel-as-function-parameter as
  tier-3 meta-pattern.

  §the-named-triple-slash-SES-reference-as-environment-
  declaration — line 12: `/// <reference types="ses"/
  >`. TypeScript triple-slash directive declaring
  dependency on SES types. The file expects to run
  in a SES-locked-down environment. §the-named-triple-
  slash-environment-declaration as tier-3 meta-pattern.

  §the-named-TODO-acknowledging-language-feature-not-
  yet-tooled — line 39: "TODO Once all our tooling is
  ready for &&=, the following line should be
  rewritten using it." Acknowledges WAITING for
  tooling to catch up. Different from cycle 424's
  acknowledged-stale-error-message. §the-named-
  tooling-readiness-as-tech-debt-marker as tier-3
  meta-pattern.

  §the-named-rich-dependency-imports-for-validation-
  file — small file (110 lines) imports from FOUR
  external packages: marshal (six imports), harden,
  errors (two imports), and the types file. §the-
  named-validation-file-as-cross-package-dependency-
  hub as tier-3 meta-pattern.

  §the-named-template-types-with-Passable-and-Key-
  constraints — JSDoc templates: `@template {Passable}
  T` and `@template {Key} K`. The function signatures
  are GENERIC over Passable or Key. Direct use of
  cycle 427's hierarchy in type bindings. §the-named-
  passable-key-as-template-type-bound as tier-3 meta-
  pattern.

  §the-named-makeSetOfElements-as-final-constructor —
  line 107: `makeSetOfElements = elementIter =>
  makeTagged('copySet', coerceToElements(elementIter))`.
  ONE-LINE constructor: tag with 'copySet', coerce
  elements. §the-named-tagged-structure-constructor-
  as-tag-plus-coerce as tier-3 meta-pattern.

  §the-named-harden-on-each-export-uniform-in-this-
  file — lines 84, 89, 100, 109. EVERY exported
  function is hardened (or hideAndHardened). The
  pattern file follows harden discipline rigorously.
  §the-named-uniform-harden-per-export-in-patterns
  as tier-3 meta-pattern.

  §the-named-history-dependent-comparator-not-survive-
  call — line 36-37 comment: "This fullOrder contains
  history dependent state. It is specific to this one
  call and does not survive it." The full-order
  comparator BUILDS UP STATE as it encounters new
  remotables (assigning them positions). State is
  CALL-LOCAL. §the-named-stateful-comparator-with-call-
  scope as tier-3 meta-pattern.

  §the-named-seventy-six-conformant-cycles-and-
  counting.

  Closes ten citation arcs: cycle 427 (1, adjacent
  forward; MAJOR REFINEMENT — partial-order framing
  extended with call-local full-order; CopySet
  implementation reveals the two orderings coexist)
  + cycle 424 (5, three-stage validation extends
  cycle 424's predicate-vs-assertion pair into
  triple; pass-style-name matches tag string across
  layers) + cycle 423 (3, makeTagged as marshal
  primitive; CopySet is marshal-tagged with 'copySet'
  string) + cycle 425 (3, hideAndHardenFunction
  stronger-than-harden extends harden discipline
  vocabulary) + cycle 387 (3, branded-types via
  template-bound generic types) + cycle 326 (75) +
  cycle 322 (75, Fail-as-Rejector pattern) + cycle
  421 (3, three-tier API layering parallels three-
  stage validation) + cycle 364 (4, shapes growing
  with three-stage-validation) + cycle 318 (3,
  Endo idiom — Fail and template types). Pushes
  citation-arc-closures-in-pivot to SEVEN-HUNDRED-
  AND-FORTY-TWO (732 + 10 net new).
---

110-line copySet.js from @endo/patterns/src/keys — the implementation of CopySet (cycle 427's "passable alternative to JavaScript Set"). Chat-lane after cycle 427 designs-lane patterns/README.md. **Single most structurally interesting move**: §the-named-call-local-full-order-supplements-distributed-partial-order — *line 40 + lines 36-37 comment: "This fullOrder contains history dependent state. It is specific to this one call and does not survive it." Cycle 427 named keys-have-partial-order-not-total-order. Cycle 428 reveals the refinement: the PARTIAL order is the distributed-equality TRUTH across vats; for LOCAL operations like sorting and duplicate detection, a CALL-LOCAL TOTAL ORDER is constructed. Two orderings coexist for two purposes.* §the-named-partial-order-for-semantics-full-order-for-sort as tier-3 meta-pattern. §the-named-three-stage-validation-confirm-assert-coerce (extends cycle 427's matches/mustMatch and cycle 424's confirmCanBeValid/assertRestValid PAIR into a TRIPLE: predicate / assertion / sort-and-assert); §the-named-three-stage-confirm-assert-coerce. §the-named-CopySet-as-makeTagged-with-sorted-elements; §the-named-tagged-copy-structure-as-passable-collection-shape. §the-named-tagged-structure-tag-matches-pass-style-name ('copySet' matches across pass-style + patterns); §the-named-tag-string-uniform-across-pass-style-and-patterns. §the-named-makeTagged-as-marshal-primitive-for-tagged-copy-structures; §the-named-marshal-provides-tagged-structures-patterns-uses-them. §the-named-copySet-stored-in-reverse-rank-order; §the-named-anti-rank-as-reverse-rank-sort-order. §the-named-sort-then-adjacent-equality-for-duplicate-detection; §the-named-sorted-array-with-adjacent-comparison. §the-named-hideAndHardenFunction-as-stronger-than-harden (cluster's harden vocabulary extends); §the-named-hide-and-harden-as-additional-defense. §the-named-rejector-or-Fail-as-error-channel-parameter (sibling to cycle 424's conditional-reject-vs-unconditional-Fail); §the-named-error-channel-as-function-parameter. §the-named-triple-slash-SES-reference-as-environment-declaration. §the-named-TODO-acknowledging-language-feature-not-yet-tooled (tooling-readiness vs cycle 424's stale-error-message); §the-named-tooling-readiness-as-tech-debt-marker. §the-named-rich-dependency-imports-for-validation-file (110-line file imports from four external packages); §the-named-validation-file-as-cross-package-dependency-hub. §the-named-template-types-with-Passable-and-Key-constraints (cycle 427's hierarchy used in type bounds); §the-named-passable-key-as-template-type-bound. §the-named-makeSetOfElements-as-final-constructor; §the-named-tagged-structure-constructor-as-tag-plus-coerce. §the-named-harden-on-each-export-uniform-in-this-file; §the-named-uniform-harden-per-export-in-patterns. §the-named-history-dependent-comparator-not-survive-call; §the-named-stateful-comparator-with-call-scope. §the-named-seventy-six-conformant-cycles-and-counting. Ten citation arcs closed; pushes citation-arc-closures-in-pivot to SEVEN-HUNDRED-AND-FORTY-TWO.
