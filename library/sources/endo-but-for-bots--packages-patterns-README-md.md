---
source_kind: source
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/patterns/README.md
source_line_range: 1-415
ingested: 2026-06-21
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 427 designs-lane ingest. 415-line README.md for
  @endo/patterns — the M namespace for pattern matching
  and interface guards. Closes the infrastructure
  triangle: marshal → pass-style → patterns → exo.
  Seventy-fifth AUTHORED conformant single-body section
  doc in post-refactor era. One-hundred-and-seventeen
  consecutive non-garden sources after the pivot (310-
  427). §one-hundred-and-seventeen-cycles-with-named-
  pivot-domain-stay.

  Single most structurally interesting move: §the-named-
  passable-key-pattern-three-tier-hierarchy — lines 372-
  391 articulate the cluster's central type hierarchy:
  Passable ⊃ Key ⊃ Pattern (with Pattern overlapping
  Key, not strictly subsuming):
  - PASSABLE (everything that can cross vat boundaries;
    from @endo/pass-style): Error, Promise, Key, and
    Pattern.
  - KEY (stable, comparable subset of Passable):
    Primitives + Remotable + CopyArray<Key> +
    CopyRecord<Key> + CopySet<Key> + CopyBag<Key> +
    CopyMap<Key, Passable>. NOT Error, NOT Promise.
  - PATTERN (describes a subset of Passables): Key
    (matches itself) plus Key-like-with-Matcher-leaves.
  §the-named-three-tier-passable-hierarchy-with-pattern-
  not-subsumed as tier-3 meta-pattern. The cluster's
  accumulated infrastructure framings now have a clean
  hierarchical placement: marshal classifies Passables;
  pass-style validates each Passable kind; patterns
  describes subsets of Passables.

  §the-named-keys-have-partial-order-not-total-order —
  lines 344-371. compareKeys returns -1, 0, 1, OR NaN.
  NaN means "incomparable." Different remotables have
  NO DEFINED ORDERING. CopySets use subset relationships
  (partial). Not all Keys can be ordered. §the-named-
  partial-order-on-keys-via-NaN-for-incomparable as
  tier-3 meta-pattern. Distributed comparison must
  accommodate the absence of a total order.

  §the-named-six-M-DSL-categories — the M namespace
  organizes into SIX explicit categories:
  1. PRIMITIVE matchers (M.number, M.string, M.bigint,
     M.symbol, M.nat, etc.)
  2. CONTAINER matchers (M.array, M.record, M.set,
     M.bag, M.map, M.arrayOf, M.recordOf, M.setOf)
  3. STRUCTURED matchers (M.splitArray, M.splitRecord,
     M.partial, M.split)
  4. LOGICAL operators (M.and, M.or, M.not, M.opt)
  5. COMPARISON matchers (M.eq, M.neq, M.lt, M.lte,
     M.gte, M.gt)
  6. SPECIAL matchers (M.remotable, M.error, M.promise,
     M.eref, M.kind, M.pattern, M.key, M.scalar)
  §the-named-M-DSL-organized-into-six-categories as
  tier-3 meta-pattern; full picture of the DSL the
  cluster has been referencing piecewise since cycle
  401.

  §the-named-copy-collections-as-passable-alternatives-
  to-builtin — lines 178-249. JavaScript's Set, Map are
  NOT Passable. CopySet, CopyBag, CopyMap exist BECAUSE
  the cluster requires Passable-only data. "JavaScript
  Sets aren't passable. CopySet is frozen, comparable
  via keyEQ, and can be efficiently serialized." §the-
  named-passable-only-data-discipline-forces-copy-
  collections as tier-3 meta-pattern.

  §the-named-eref-as-eventual-reference-matcher — line
  140: `M.eref(M.number())` — "Number or promise for
  number (eventual reference)." THE matcher for
  distributed-system call sites: the value can be
  either the value itself OR a promise for it.
  Connects to cycle 425's M.callWhen (await-then-
  validate). §the-named-value-or-promise-as-eventual-
  reference-shape as tier-3 meta-pattern.

  §the-named-matches-vs-mustMatch-predicate-vs-
  assertion — lines 149-176. matches returns boolean;
  mustMatch throws with descriptive error. Same shape
  as cycle 424's confirmCanBeValid/assertRestValid
  (predicate/assertion pair). §the-named-predicate-
  function-paired-with-assertion-function as tier-3
  meta-pattern; the cluster sees this discipline at
  pass-style level (cycle 424) and at patterns level
  (cycle 427).

  §the-named-labelled-error-via-mustMatch-third-arg —
  line 171-173: `mustMatch(-5, M.and(M.number(),
  M.gte(0)), 'count')` produces "count: number -5 -
  Must be >= 0." The label is interpolated into the
  error. §the-named-error-label-as-prefix-for-context
  as tier-3 meta-pattern; the labelled-error pattern
  threads context through validation.

  §the-named-interface-guard-build-via-method-chaining
  — lines 276-293. M.call(required).optional(more).
  rest(more).returns(type). The signature is built up
  via method chaining. §the-named-method-chaining-for-
  interface-guard-construction as tier-3 meta-pattern;
  builder-style API for guards.

  §the-named-M-remotable-with-optional-label — line
  137: `M.remotable('Counter')`. The remotable matcher
  accepts an optional label for discrimination by
  Far-tag. §the-named-remotable-matcher-with-label-
  discrimination as tier-3 meta-pattern.

  §the-named-M-kind-takes-pass-style-name-string —
  line 141: `M.kind('copyArray')`. The kind matcher
  takes a pass-style name as a string. Connects to
  cycle 424's PassStyleHelper styleName ('copyRecord',
  etc.). §the-named-pass-style-string-as-kind-name as
  tier-3 meta-pattern.

  §the-named-M-symbol-requires-registered-or-well-known
  — line 55: "Matches registered/well-known symbols."
  General Symbols (created via Symbol()) are NOT
  matched; only Symbol.for() registered and
  Symbol.iterator/asyncIterator etc. §the-named-symbol-
  passable-restriction-registered-or-well-known as
  tier-3 meta-pattern.

  §the-named-M-partial-vs-M-splitRecord-shorthand —
  lines 96-103. M.partial({name}) matches records
  with AT LEAST a name property. M.splitRecord
  ({required}, {optional}, M.any()) is the long form.
  partial is shorthand for splitRecord with required
  + rest. §the-named-partial-as-shorthand-for-
  required-plus-rest as tier-3 meta-pattern.

  §the-named-M-array-with-maxSize — lines 75-76:
  `M.array({ maxSize: 10 })` constrains element
  count; `M.string({ maxSize: 100 })` constrains
  string length. §the-named-container-size-constraint
  as tier-3 meta-pattern.

  §the-named-CopyBag-as-multiset-with-bigint-counts —
  lines 204-221. CopyBag is a MULTISET with bigint
  counts: `[['apples', 5n], ['oranges', 3n]]`. Counts
  are combined (5n + 2n = 7n). Bigint not number —
  matches the cluster's pattern of distinguishing
  Number from BigInt at the Passable level. §the-
  named-multiset-counts-as-bigints as tier-3 meta-
  pattern.

  §the-named-CopyMap-supports-any-Key-as-key — line
  236-243. CopyMap supports Remotable keys, not just
  strings. Plain JS objects can only have string/
  symbol keys; CopyMap supports the full Key type.
  §the-named-arbitrary-Key-as-CopyMap-key as tier-3
  meta-pattern.

  §the-named-keyEQ-for-distributed-equality — lines
  325-340. `keyEQ('hello', 'hello')` is true;
  `keyEQ(r1, r2)` with different Far('Obj', {}) is
  false (different remotables). Distributed equality
  semantics: content-equal for primitives and copy-
  collections; identity-equal for remotables. §the-
  named-distributed-equality-content-and-identity as
  tier-3 meta-pattern.

  §the-named-Error-and-Promise-as-non-Key-Passable —
  the Passable hierarchy excludes Error and Promise
  from the Key subset. Errors and Promises can pass
  but aren't keys (not stable in the comparable
  sense). §the-named-Error-Promise-passable-not-key
  as tier-3 meta-pattern.

  §the-named-seventy-five-conformant-cycles-and-
  counting.

  Closes ten citation arcs: cycle 426 (1, adjacent
  forward; introspection-meta-method-sibling-pair
  references M.interface InterfaceGuard which is
  patterns' central construct) + cycle 425 (5,
  exo-as-far-plus-interface-guard now grounded —
  patterns provides the guard half; M.callWhen,
  M.call, M.optional, M.rest, M.returns all named)
  + cycle 424 (5, predicate-vs-assertion discipline
  shared between pass-style and patterns; matches/
  mustMatch parallels canBeValid/assertRestValid) +
  cycle 423 (5, marshal classification + Passable
  hierarchy now extended with Pattern tier; three-
  tier hierarchy named) + cycle 401 (3, SmallCaps
  BigInt connects to CopyBag's bigint counts;
  M.interface from cycle 401 now in context) +
  cycle 387 (5, branded-types via Pattern/Key/
  Passable type hierarchy) + cycle 326 (75) + cycle
  322 (75, errors framing reaches labelled-error
  pattern) + cycle 364 (4, shapes growing with
  hierarchy) + cycle 318 (3, Endo idiom). Pushes
  citation-arc-closures-in-pivot to SEVEN-HUNDRED-
  AND-THIRTY-TWO (722 + 10 net new).
---

415-line README.md for @endo/patterns — the M namespace for pattern matching and interface guards. Closes the infrastructure triangle (marshal → pass-style → patterns → exo). Designs-lane after cycle 426 chat-lane exo/src/get-interface.js. **Single most structurally interesting move**: §the-named-passable-key-pattern-three-tier-hierarchy — *lines 372-391 articulate the cluster's central type hierarchy: Passable ⊃ Key (stable + comparable subset; no Error, no Promise) ⊃ Pattern (describes subset of Passables). The cluster's accumulated infrastructure framings now have a clean hierarchical placement: marshal classifies Passables; pass-style validates each Passable kind; patterns describes subsets of Passables.* §the-named-three-tier-passable-hierarchy-with-pattern-not-subsumed as tier-3 meta-pattern. §the-named-keys-have-partial-order-not-total-order (compareKeys returns NaN for incomparable; different remotables have no order; CopySets use subset relationships); §the-named-partial-order-on-keys-via-NaN-for-incomparable. §the-named-six-M-DSL-categories (primitive + container + structured + logical + comparison + special); §the-named-M-DSL-organized-into-six-categories. §the-named-copy-collections-as-passable-alternatives-to-builtin (JavaScript Set/Map not Passable; CopySet/CopyMap exist for distributed compatibility); §the-named-passable-only-data-discipline-forces-copy-collections. §the-named-eref-as-eventual-reference-matcher (value or promise-for-value); §the-named-value-or-promise-as-eventual-reference-shape. §the-named-matches-vs-mustMatch-predicate-vs-assertion (parallels cycle 424's confirmCanBeValid/assertRestValid); §the-named-predicate-function-paired-with-assertion-function. §the-named-labelled-error-via-mustMatch-third-arg; §the-named-error-label-as-prefix-for-context. §the-named-interface-guard-build-via-method-chaining; §the-named-method-chaining-for-interface-guard-construction. §the-named-M-remotable-with-optional-label; §the-named-remotable-matcher-with-label-discrimination. §the-named-M-kind-takes-pass-style-name-string; §the-named-pass-style-string-as-kind-name. §the-named-M-symbol-requires-registered-or-well-known; §the-named-symbol-passable-restriction-registered-or-well-known. §the-named-M-partial-vs-M-splitRecord-shorthand; §the-named-partial-as-shorthand-for-required-plus-rest. §the-named-M-array-with-maxSize; §the-named-container-size-constraint. §the-named-CopyBag-as-multiset-with-bigint-counts; §the-named-multiset-counts-as-bigints. §the-named-CopyMap-supports-any-Key-as-key; §the-named-arbitrary-Key-as-CopyMap-key. §the-named-keyEQ-for-distributed-equality; §the-named-distributed-equality-content-and-identity. §the-named-Error-and-Promise-as-non-Key-Passable; §the-named-Error-Promise-passable-not-key. §the-named-seventy-five-conformant-cycles-and-counting. Ten citation arcs closed; pushes citation-arc-closures-in-pivot to SEVEN-HUNDRED-AND-THIRTY-TWO.
