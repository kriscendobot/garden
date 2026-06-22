---
source_kind: source
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/pass-style/src/copyRecord.js
source_line_range: 1-71
ingested: 2026-06-21
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 424 chat-lane ingest. 70-line copyRecord.js from
  @endo/pass-style/src — the canonical implementation of
  the pass-by-copy/Record classification cycle 423 named.
  Companion to cycle 423's marshal README. Seventy-second
  AUTHORED conformant single-body section doc in post-
  refactor era. One-hundred-and-fourteen consecutive non-
  garden sources after the pivot (310-424). §one-hundred-
  and-fourteen-cycles-with-named-pivot-domain-stay.

  Single most structurally interesting move: §the-named-
  two-phase-validation-can-be-valid-then-rest-valid —
  lines 50-69 split the validation into TWO PHASES.
  confirmCanBeValid (lines 50-59) checks the CANDIDATE
  itself: prototype must be Object.prototype, all keys
  must be string, no method-like values. assertRestValid
  (lines 61-69) RECURSES into the values, calling
  passStyleOfRecur on each. The split separates SHALLOW
  STRUCTURAL VALIDITY (can this object possibly be a
  record at all?) from DEEP RECURSIVE VALIDITY (do all
  its members validly pass-style?). §the-named-shallow-
  structural-vs-deep-recursive-validation as tier-3
  meta-pattern; the validator design choice is
  thoughtful — fast shallow check rules out most
  rejects before recursive walk. The pass-style helpers
  share this pattern (cycle 424 sees it in copyRecord;
  presumably copyArray and others mirror it).

  §the-named-three-names-for-same-marshal-classification
  — cluster naming drift in infrastructure code:
  - marshal README (cycle 423): "pass-by-copy"
  - copyRecord.js styleName (line 48): "copyRecord"
  - copyRecord.js error messages (lines 21, 35, 39):
    "Records"
  Three names for the SAME classification across
  README + style-name + error-message. §the-named-
  pass-by-copy-copyRecord-Records-three-names as tier-
  3 meta-pattern; cluster's naming drift extends into
  marshal infrastructure.

  §the-named-record-constraints-three-conditions —
  three explicit constraints from lines 18-41:
  1. Records must inherit from Object.prototype (line
     21)
  2. Records can only have string-named properties
     (line 35)
  3. Records cannot contain non-far functions (because
     they may be methods of an implicit Remotable;
     line 39)
  §the-named-three-conditions-for-record-validity as
  tier-3 meta-pattern.

  §the-named-Rejector-as-tagged-template-error-pattern
  — lines 18-21, 31-40 use a `Rejector` parameter that
  can be called with a tagged template literal:
  `reject\`Records must inherit from Object.prototype:
  ${candidate}\``. §the-named-Rejector-tagged-template-
  for-error-threading as tier-3 meta-pattern; a clean
  way to thread error reporting through validation
  functions without throwing.

  §the-named-short-circuit-with-reject-template-as-
  validation-idiom — lines 32-40: the validation
  uses logical-AND short-circuit with template literal
  calls. Either the condition is true (and remains
  truthy) OR `reject\`...\`` is called and contributes
  the error message. The whole expression returns
  truthy iff validation passes. §the-named-short-
  circuit-validation-with-inline-reject as tier-3
  meta-pattern; a clean inline error-reporting idiom.

  §the-named-stale-error-message-with-TODO-comment —
  line 38: `// TODO: Update message now that there is
  no such thing as "implicit Remotable"`. The error
  message refers to a concept ("implicit Remotable")
  that no longer exists. The TODO ACKNOWLEDGES the
  drift. §the-named-acknowledged-stale-error-message
  as tier-3 meta-pattern; cycle 422 named intra-file
  convention-drift without acknowledgment; cycle 424
  finds drift that has an explicit TODO marker.

  §the-named-canBeMethod-as-method-shape-predicate —
  line 4, 36: canBeMethod imported from remotable.js;
  checks if a value could be a method. The validation
  rejects records with method-like values. Method is
  a function with proper shape for remote calling.
  §the-named-method-shape-vs-data-shape-discrimination
  as tier-3 meta-pattern.

  §the-named-Reflect-ownKeys-for-validation-enumeration
  — line 11: `const { ownKeys } = Reflect`. The
  validator uses ownKeys to enumerate ALL properties
  (including non-enumerable and symbol-keyed). Symbol-
  keyed properties are then rejected via the typeof
  string check. §the-named-enumerate-all-keys-but-
  reject-symbols as tier-3 meta-pattern.

  §the-named-prototype-identity-check-for-plain-object
  — lines 11-12, 20: prototype is unwrapped via
  destructuring; the check is `getPrototypeOf
  (candidate) === objectPrototype` (reference
  identity). §the-named-strict-reference-equality-for-
  prototype-identity as tier-3 meta-pattern.

  §the-named-PassStyleHelper-interface-per-style —
  line 45: `@type {PassStyleHelper}`. The
  CopyRecordHelper conforms to a PassStyleHelper
  interface. Other helpers exist (copyArray.js,
  error.js, etc.). Each style has its own helper.
  §the-named-helper-per-pass-style-category as tier-3
  meta-pattern; the pass-style package has a HELPER
  per pass-style category, sharing the validation
  protocol.

  §the-named-confirmOwnDataDescriptor-as-safety-helper
  — line 3, 66: confirmOwnDataDescriptor imported
  from passStyle-helpers.js. Used in assertRestValid
  to access values safely without triggering getters.
  §the-named-own-data-descriptor-access-for-getter-
  safety as tier-3 meta-pattern.

  §the-named-CopyRecordHelper-as-hardened-object —
  line 47: the helper is hardened via `harden({ ... })`.
  Standard discipline. §the-named-pass-style-helpers-
  follow-harden-convention as tier-3 meta-pattern.

  §the-named-styleName-as-string-tag — line 48:
  `styleName: 'copyRecord'`. Each helper has a
  string tag identifying its pass-style category.
  §the-named-string-tag-as-style-discriminator as
  tier-3 meta-pattern.

  §the-named-passStyleOfRecur-as-mutual-recursion-
  callback — line 61, 67. assertRestValid accepts a
  passStyleOfRecur callback; calls it on each value.
  The callback knows how to dispatch back to the
  appropriate helper. §the-named-mutual-recursion-
  via-callback as tier-3 meta-pattern; the helpers
  don't directly call each other; they go through
  the dispatcher.

  §the-named-Fail-from-endo-errors-as-throw-helper —
  line 2: `import { Fail } from '@endo/errors'`. The
  Fail tagged template helper for throwing tagged
  errors. Used in assertRestValid (line 66) as the
  rejector. §the-named-Fail-tagged-template-as-
  unconditional-rejector as tier-3 meta-pattern.

  §the-named-reject-vs-Fail-asymmetry — line 50:
  confirmCanBeValid takes a `reject` Rejector
  parameter (can be optional/dummy). Line 61:
  assertRestValid uses Fail directly (always throws).
  §the-named-conditional-reject-vs-unconditional-Fail
  as tier-3 meta-pattern; two error-reporting
  modes: conditional (for can-be checks) and
  unconditional (for must-be checks).

  §the-named-seventy-two-conformant-cycles-and-
  counting.

  Closes ten citation arcs: cycle 423 (1, adjacent
  forward; marshal-depends-on-pass-style framing now
  confirmed by reading pass-style source; the
  classification cycle 423 named in marshal is
  IMPLEMENTED here) + cycle 422 (3, intra-file
  drift comparison: cycle 422 had unacknowledged
  drift; cycle 424 has TODO-acknowledged drift) +
  cycle 421 (3, three-name-drift like cycle 421's
  ChatMessage cross-package duplication — same
  classification, multiple names) + cycle 416 (3,
  trust-boundary asymmetric error handling
  parallels conditional-reject-vs-unconditional-
  Fail asymmetry) + cycle 408 (3, role-cardinality-
  reduction is itself a kind of validation
  filtering, sibling to pass-style classification)
  + cycle 326 (75) + cycle 322 (75, errors framing
  reaches the Rejector pattern) + cycle 387 (5,
  branded-types via PassStyleHelper interface) +
  cycle 364 (4, shapes growing) + cycle 318 (3,
  Endo idiom — Fail and tagged templates). Pushes
  citation-arc-closures-in-pivot to SEVEN-HUNDRED-
  AND-THREE (693 + 10 net new). **Cluster crosses
  700 citation-arc-closures.**
---

70-line copyRecord.js from @endo/pass-style/src — the canonical implementation of the pass-by-copy/Record classification cycle 423 named. Chat-lane after cycle 423 designs-lane marshal/README.md. **Single most structurally interesting move**: §the-named-two-phase-validation-can-be-valid-then-rest-valid — *validation is split into TWO PHASES. confirmCanBeValid (lines 50-59) checks the CANDIDATE itself: prototype must be Object.prototype, keys must be string, no method-like values. assertRestValid (lines 61-69) RECURSES into values via passStyleOfRecur. The split separates SHALLOW STRUCTURAL VALIDITY from DEEP RECURSIVE VALIDITY.* §the-named-shallow-structural-vs-deep-recursive-validation as tier-3 meta-pattern. §the-named-three-names-for-same-marshal-classification (marshal README: "pass-by-copy"; styleName: "copyRecord"; error messages: "Records"); §the-named-pass-by-copy-copyRecord-Records-three-names (cluster naming drift extends into marshal infrastructure). §the-named-record-constraints-three-conditions (Object.prototype + string-keys + no-methods); §the-named-three-conditions-for-record-validity. §the-named-Rejector-as-tagged-template-error-pattern; §the-named-Rejector-tagged-template-for-error-threading. §the-named-short-circuit-with-reject-template-as-validation-idiom; §the-named-short-circuit-validation-with-inline-reject. §the-named-stale-error-message-with-TODO-comment (TODO acknowledges drift on "implicit Remotable"); §the-named-acknowledged-stale-error-message (contrast cycle 422's unacknowledged intra-file drift). §the-named-canBeMethod-as-method-shape-predicate; §the-named-method-shape-vs-data-shape-discrimination. §the-named-Reflect-ownKeys-for-validation-enumeration; §the-named-enumerate-all-keys-but-reject-symbols. §the-named-prototype-identity-check-for-plain-object; §the-named-strict-reference-equality-for-prototype-identity. §the-named-PassStyleHelper-interface-per-style; §the-named-helper-per-pass-style-category. §the-named-confirmOwnDataDescriptor-as-safety-helper; §the-named-own-data-descriptor-access-for-getter-safety. §the-named-CopyRecordHelper-as-hardened-object; §the-named-pass-style-helpers-follow-harden-convention. §the-named-styleName-as-string-tag; §the-named-string-tag-as-style-discriminator. §the-named-passStyleOfRecur-as-mutual-recursion-callback; §the-named-mutual-recursion-via-callback. §the-named-Fail-from-endo-errors-as-throw-helper; §the-named-Fail-tagged-template-as-unconditional-rejector. §the-named-reject-vs-Fail-asymmetry; §the-named-conditional-reject-vs-unconditional-Fail. §the-named-seventy-two-conformant-cycles-and-counting. **Citation arcs cross 700.** Ten citation arcs closed; pushes citation-arc-closures-in-pivot to SEVEN-HUNDRED-AND-THREE.
