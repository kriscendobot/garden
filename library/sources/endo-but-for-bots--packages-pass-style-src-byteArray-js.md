---
source_kind: source
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/pass-style/src/byteArray.js
source_line_range: 1-69
ingested: 2026-06-22
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 432 chat-lane ingest. 68-line byteArray.js from
  @endo/pass-style/src — the pass-style helper for the
  ImmutableArrayBuffer-based ByteArray pass-style.
  Companion to cycle 424's copyRecord.js (same shape:
  PassStyleHelper export). Eightieth AUTHORED conformant
  single-body section doc in post-refactor era. One-
  hundred-and-twenty-two consecutive non-garden sources
  after the pivot (310-432). §one-hundred-and-twenty-
  two-cycles-with-named-pivot-domain-stay.

  Single most structurally interesting move: §the-named-
  pre-lockdown-trust-capture-pattern — lines 31-34: "As
  proposed, this will be the same as `ArrayBuffer.
  prototype`. As shimmed, this will be a hidden intrinsic
  that inherits from `ArrayBuffer.prototype`. Either way,
  get this in a way that we can trust it after lockdown,
  and require that all immutable ArrayBuffers directly
  inherit from it." The fundamental SES discipline: at
  MODULE LOAD TIME (pre-lockdown), capture trusted
  references (intrinsics, prototypes) into module-scope
  variables. After lockdown, these references are
  TRUSTWORTHY because they were captured before any
  attacker could tamper with the global environment.
  Lines 44-45 implement this: `const {
  immutableArrayBufferPrototype, immutableGetter } =
  adaptImmutableArrayBuffer()`. The destructure happens
  at module-load; the values are then used in the
  hardened ByteArrayHelper. §the-named-capture-intrinsics-
  at-module-load-before-lockdown as tier-3 meta-pattern.
  This explains why so much Endo code does feature
  detection and reference-capture at module load time:
  the trust model REQUIRES it. The cluster's accumulated
  SES framings (cycle 423's marshal-requires-frozen-
  input, cycle 428's triple-slash-SES-reference, cycle
  431's eval-twins-mitigation) now have a fundamental
  discipline named.

  §the-named-byteArray-depends-on-immutableArrayBuffer-
  proposal — line 29-30: "As proposed, this will be the
  same as ArrayBuffer.prototype." So sliceToImmutable
  and .immutable getter are PROPOSED extensions to
  ArrayBuffer. ByteArray relies on this proposal. §the-
  named-pass-style-pre-uses-TC39-proposal as tier-3
  meta-pattern; sibling to cycle 431's eventual-send-
  as-TC39-proposal-polyfill — Endo packages routinely
  polyfill or pre-use TC39 proposals.

  §the-named-feature-detection-with-graceful-degradation
  — lines 14-24: detect platform support via
  `anArrayBuffer.sliceToImmutable === undefined`. On
  unsupported platforms, return null prototype and
  always-false getter. ByteArrays cannot be constructed
  on those platforms, but other pass-style operations
  still work. §the-named-feature-detection-with-null-
  fallback as tier-3 meta-pattern.

  §the-named-two-phase-validation-uniform-across-pass-
  style-helpers — confirms cycle 424's two-phase-
  validation-can-be-valid-then-rest-valid framing
  uniformly across the pass-style helpers. ByteArrayHelper
  exports confirmCanBeValid (line 53) + assertRestValid
  (line 57). Same shape as copyRecord. §the-named-pass-
  style-helper-shape-is-confirmCanBeValid-plus-
  assertRestValid as tier-3 meta-pattern.

  §the-named-byteArray-four-validation-checks — the
  validity criteria are four:
  1. `instanceof ArrayBuffer` (line 54, confirmCan)
  2. `.immutable` getter returns true (line 54, confirmCan)
  3. `getPrototypeOf === immutableArrayBufferPrototype`
     (line 58, assertRest)
  4. `ownKeys.length === 0` (line 62, assertRest — no
     expandos)
  §the-named-byteArray-validity-as-four-criteria as
  tier-3 meta-pattern.

  §the-named-Reflect-apply-for-defensive-getter-
  invocation — line 60: `apply(immutableGetter, candidate,
  [])`. Reflect.apply explicitly invokes the getter on
  the candidate. Defensive — avoids prototype chain
  pollution that could redefine `.immutable`. §the-
  named-explicit-getter-invocation-via-Reflect-apply as
  tier-3 meta-pattern; sibling to cycle 424's
  confirmOwnDataDescriptor-as-safety-helper.

  §the-named-byteArray-disallows-expandos — lines 62-66:
  ByteArrays MUST NOT have own properties. The
  ImmutableArrayBuffer must be pristine. §the-named-no-
  own-properties-for-pristine-pass-style as tier-3 meta-
  pattern.

  §the-named-assert-fail-with-X-and-error-type — lines
  59, 63-66: `assert.fail(X\`...\`, TypeError)`. X is
  the tagged-template error helper from @endo/errors,
  similar to Fail but with explicit error-type
  parameter. The error toolkit has BOTH Fail (default
  Error) AND assert.fail+X (custom error type). §the-
  named-X-and-Fail-as-tagged-template-error-helpers as
  tier-3 meta-pattern.

  §the-named-typo-in-source-comment-desciptor — line
  37: "@ts-expect-error We know the desciptor is
  there." `desciptor` is a typo of `descriptor`. The
  cluster has documented typo/drift patterns; cycle
  432 adds another instance. §the-named-typo-in-source-
  comment as tier-3 meta-pattern; sibling to cycle
  424's stale-error-message and cycle 428's TODO-for-
  not-yet-tooled.

  §the-named-styleName-byteArray — line 51:
  `styleName: 'byteArray'`. The pass-style name is
  'byteArray'. Adds to the cluster's collection: cycle
  424's 'copyRecord', cycle 428's 'copySet' (in
  patterns via makeTagged). Now byteArray. §the-named-
  pass-style-names-as-lowercase-camelCase as tier-3
  meta-pattern.

  §the-named-hidden-intrinsic-vs-prototype-distinction
  — line 30: "As proposed, this will be the same as
  ArrayBuffer.prototype. As shimmed, this will be a
  hidden intrinsic that inherits from
  ArrayBuffer.prototype." The proposal target is the
  same prototype; the shim implementation uses a
  hidden intrinsic. Either way, the code captures the
  REAL TARGET via getPrototypeOf. §the-named-hidden-
  intrinsic-as-shim-implementation as tier-3 meta-
  pattern.

  §the-named-passStyleOfRecur-unused-in-assertRestValid
  — line 57: `(candidate, _passStyleOfRecur) => {...}`.
  The underscore prefix marks the parameter as
  intentionally unused. ByteArrays have no nested
  values to recurse into (they're primitive content),
  so the recursive parameter is not needed. §the-named-
  underscore-prefix-for-unused-recursion-parameter as
  tier-3 meta-pattern; sibling to cycle 416's eslint-
  rules-about-underscore-prefixed-variables.

  §the-named-ImmutableArrayBuffer-immutable-property —
  the getter `.immutable` is the runtime predicate
  for "is this an immutable ArrayBuffer?" Per the
  proposal, it's a getter on the prototype that
  returns true if the buffer was created via
  sliceToImmutable. §the-named-immutable-as-runtime-
  predicate as tier-3 meta-pattern.

  §the-named-Reflect-destructured-at-module-top — line
  9: `const { ownKeys, apply } = Reflect`. Same
  pattern as cycle 424's copyRecord destructuring of
  Reflect.ownKeys. §the-named-Reflect-pre-lockdown-
  capture as tier-3 meta-pattern; more pre-lockdown-
  trust-capture pattern instances.

  §the-named-Object-destructured-at-module-top — line
  8: `const { getPrototypeOf, getOwnPropertyDescriptor
  } = Object`. Pre-lockdown capture of Object methods.
  Once captured, these references are immune to
  subsequent Object monkey-patching. §the-named-Object-
  method-pre-lockdown-capture as tier-3 meta-pattern.

  §the-named-eighty-conformant-cycles-and-counting —
  eightieth AUTHORED conformant single-body section
  doc in post-refactor era — a milestone.

  Closes ten citation arcs: cycle 431 (1, adjacent
  forward; eventual-send-as-TC39-proposal-polyfill
  sibling to byteArray-as-TC39-proposal pre-use) +
  cycle 424 (5, two-phase-validation pattern uniform
  across helpers — copyRecord + byteArray same
  shape) + cycle 423 (3, marshal-requires-frozen-
  input grounded in SES pre-lockdown discipline) +
  cycle 428 (3, triple-slash-SES-reference + pre-
  lockdown-capture both part of SES discipline) +
  cycle 416 (3, eslint-around-underscore-prefix
  parallel) + cycle 326 (75) + cycle 322 (75, X and
  Fail tagged-template helpers from errors) + cycle
  387 (5, branded-types via prototype identity) +
  cycle 364 (4, shapes growing with byteArray as
  third pass-style implementation observed) + cycle
  318 (3, Endo idiom — Reflect destructuring). Pushes
  citation-arc-closures-in-pivot to SEVEN-HUNDRED-AND-
  EIGHTY-TWO (772 + 10 net new).
---

68-line byteArray.js from @endo/pass-style/src — the pass-style helper for the ImmutableArrayBuffer-based ByteArray pass-style. Chat-lane after cycle 431 designs-lane eventual-send/README.md. **Single most structurally interesting move**: §the-named-pre-lockdown-trust-capture-pattern — *lines 31-34: "Either way, get this in a way that we can trust it after lockdown, and require that all immutable ArrayBuffers directly inherit from it." The fundamental SES discipline: at MODULE LOAD TIME (pre-lockdown), capture trusted references (intrinsics, prototypes) into module-scope variables. After lockdown these references are TRUSTWORTHY because they were captured before any attacker could tamper.* §the-named-capture-intrinsics-at-module-load-before-lockdown as tier-3 meta-pattern. This explains why so much Endo code does feature detection and reference-capture at module load: the trust model REQUIRES it. §the-named-byteArray-depends-on-immutableArrayBuffer-proposal (sliceToImmutable / .immutable getter are PROPOSED ArrayBuffer extensions); §the-named-pass-style-pre-uses-TC39-proposal (sibling to cycle 431's eventual-send-as-polyfill). §the-named-feature-detection-with-graceful-degradation (null fallback on unsupported platforms); §the-named-feature-detection-with-null-fallback. §the-named-two-phase-validation-uniform-across-pass-style-helpers (cycle 424's framing now confirmed across helpers); §the-named-pass-style-helper-shape-is-confirmCanBeValid-plus-assertRestValid. §the-named-byteArray-four-validation-checks (instanceof + .immutable + prototype-identity + no-expandos); §the-named-byteArray-validity-as-four-criteria. §the-named-Reflect-apply-for-defensive-getter-invocation (Reflect.apply explicitly invokes getter; sibling to cycle 424's confirmOwnDataDescriptor); §the-named-explicit-getter-invocation-via-Reflect-apply. §the-named-byteArray-disallows-expandos; §the-named-no-own-properties-for-pristine-pass-style. §the-named-assert-fail-with-X-and-error-type (X tagged-template with TypeError); §the-named-X-and-Fail-as-tagged-template-error-helpers. §the-named-typo-in-source-comment-desciptor (`desciptor` typo on line 37; sibling to cycle 424's stale-error-message and cycle 428's TODO); §the-named-typo-in-source-comment. §the-named-styleName-byteArray ('byteArray' joins 'copyRecord' + 'copySet'); §the-named-pass-style-names-as-lowercase-camelCase. §the-named-hidden-intrinsic-vs-prototype-distinction; §the-named-hidden-intrinsic-as-shim-implementation. §the-named-passStyleOfRecur-unused-in-assertRestValid (ByteArrays have no nested values); §the-named-underscore-prefix-for-unused-recursion-parameter. §the-named-ImmutableArrayBuffer-immutable-property; §the-named-immutable-as-runtime-predicate. §the-named-Reflect-destructured-at-module-top; §the-named-Reflect-pre-lockdown-capture. §the-named-Object-destructured-at-module-top; §the-named-Object-method-pre-lockdown-capture. §the-named-eighty-conformant-cycles-and-counting (MILESTONE). Ten citation arcs closed; pushes citation-arc-closures-in-pivot to SEVEN-HUNDRED-AND-EIGHTY-TWO.
