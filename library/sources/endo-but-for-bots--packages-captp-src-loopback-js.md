---
source_kind: source
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/captp/src/loopback.js
source_line_range: 1-117
ingested: 2026-06-22
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 430 chat-lane ingest. 117-line loopback.js from
  @endo/captp/src — the in-process CapTP cycle 429
  framed as "async barrier between near and far
  objects." Companion to cycle 429's captp README.
  Seventy-eighth AUTHORED conformant single-body
  section doc in post-refactor era. **ONE-HUNDRED-AND-
  TWENTIETH consecutive non-garden source after the
  pivot (310-430) — session-level milestone, AND
  numeric milestone cycle 430.** §one-hundred-and-
  twenty-cycles-with-named-pivot-domain-stay.

  Single most structurally interesting move: §the-named-
  loopback-is-real-CapTP-in-degenerate-configuration —
  lines 54 and 83 each call `makeCapTP(...)`. The
  Loopback creates TWO CapTP instances:
  - One named `near-${ourId}`
  - One named `far-${ourId}`
  Each side's send function is the OTHER side's
  dispatch (line 54 passes `o => farDispatch(o)`; line
  83 passes `nearDispatch` directly). They exchange
  JSON-serialized messages through real CapTP
  serialization. Cycle 429 framed Loopback as "mock
  CapTP with real in-process objects" (inverse of
  cycle 403's mock-internals-real-externals). Cycle
  430 refines: Loopback isn't a MOCK at all — it's
  REAL CapTP in a DEGENERATE configuration where both
  "remote" sides happen to live in the same address
  space. §the-named-degenerate-configuration-vs-mock
  as tier-3 meta-pattern; the cluster's framing of
  Loopback now distinguishes "mock" (different code
  paths for testing) from "degenerate configuration"
  (same code paths, simpler input). Loopback is the
  latter — every byte of serialization, every CapTP
  protocol message, every ref-resolution still goes
  through the production code.

  §the-named-nonce-based-round-trip-creates-async-
  barrier — lines 29-39, 92-105. To pass an object as
  "far," the loopback:
  1. Assigns the object a fresh nonce (lastNonce++)
  2. Stores `{nonce -> object}` in the
     makeFinalizingMap
  3. Asks the OTHER side via E(refGetter).getRef
     (nonce)
  4. The other side fetches and deletes the entry
  The object passes through the JSON serialization
  layer even though it's the same address space. The
  async barrier is created by routing through the
  CapTP serialization protocol. §the-named-serialization-
  round-trip-as-async-barrier as tier-3 meta-pattern.

  §the-named-makeFinalizingMap-for-no-leak-nonce-
  storage — line 30. A finalizing Map that releases
  entries when not referenced. The nonce-to-ref Map
  uses this to prevent leaks. Connects to cycle 423's
  rights-amplification framing about WeakMap. §the-
  named-finalizing-map-as-anti-leak-storage as tier-3
  meta-pattern.

  §the-named-makeFar-and-makeNear-as-symmetric-pair —
  lines 108-109. makeFar takes a real object and
  returns its "remoted" version (via farGetter, the
  OTHER side's bootstrap). makeNear takes a real
  object and returns its "local-from-far-perspective"
  version. Symmetric naming for either-direction.
  §the-named-symmetric-far-near-makers as tier-3
  meta-pattern.

  §the-named-shared-bootstrap-for-loopback — lines
  32-39 + 54 + 83. The `bootstrap` (a refGetter Far
  object) is created ONCE and passed to BOTH
  makeCapTP calls. Both sides expose the SAME
  refGetter. Unusual — normally each side has its
  own bootstrap. The Loopback structure uses a
  shared bootstrap to enable the nonce-based ref
  protocol. §the-named-shared-bootstrap-as-loopback-
  trick as tier-3 meta-pattern.

  §the-named-loopback-uses-original-qclass-encoding-
  not-smallcaps — lines 41-44: `JSON.stringify({
  '@qclass': 'slot', index: 0 })`. The Loopback
  uses the ORIGINAL marshal encoding (with @qclass
  property) for its slot reference, not smallcaps.
  Cycle 423's two-marshal-encodings framing (cycle
  423) now extends with a specific use case: Loopback
  intentionally uses original-encoding. §the-named-
  qclass-encoding-as-loopback-choice as tier-3 meta-
  pattern.

  §the-named-isOnlyNear-and-isOnlyFar-predicates —
  lines 21-22, 110-111. The library exposes
  predicates for testing whether an object is "only"
  near or "only" far. Objects can be classified by
  which side they live on. §the-named-side-
  classification-predicates as tier-3 meta-pattern.

  §the-named-per-side-stats-via-getNearStats-and-
  getFarStats — lines 23-24, 112-113. Per-side
  statistics. §the-named-per-CapTP-monitoring as
  tier-3 meta-pattern.

  §the-named-loopback-trapGuest-via-nearTrapImpl —
  lines 55-70. The Loopback implements its own
  trapGuest using the nearTrapImpl from trap.js. The
  trapGuest handles cross-boundary traps
  synchronously via the in-process nature.
  Connects to cycle 429's TrapCaps framing — Loopback
  has a built-in TrapCaps implementation. §the-named-
  loopback-built-in-trap-implementation as tier-3
  meta-pattern.

  §the-named-mutual-CapTP-references-require-use-
  before-define-disable — lines 53, 60, 68. Three
  uses of `eslint-disable-next-line no-use-before-
  define`. Necessary because the two CapTP instances
  reference each other's dispatch + serialize/
  unserialize, creating circular definition. §the-
  named-circular-definition-via-eslint-disable as
  tier-3 meta-pattern.

  §the-named-Far-without-exo-for-minimal-bootstrap —
  line 32: `Far('refGetter', { getRef(nonce) {...}
  })`. Uses Far from @endo/marshal directly, NOT
  through exo/makeExo. The bootstrap is minimal — no
  need for interface guards. Cycle 425 noted exos
  add validation; here that overhead is skipped.
  §the-named-Far-skipping-exo-when-no-guard-needed as
  tier-3 meta-pattern.

  §the-named-single-use-nonce-for-generative-security
  — line 36: after `getRef` returns the value,
  `nonceToRef.delete(nonce)`. Each ref pass uses a
  FRESH NONCE that's consumed on fetch. Single-use.
  This is a SECURITY PROPERTY: an attacker can't
  replay a nonce. §the-named-single-use-nonce as
  generative-capability tier-3 meta-pattern.

  §the-named-ts-expect-error-as-known-type-
  imperfection — line 103. The `@ts-expect-error`
  marks a place where the type system can't easily
  express the EResult<T> coercion. §the-named-known-
  type-imperfection-as-explicit-acknowledgment as
  tier-3 meta-pattern; sibling to cycle 424's
  acknowledged-stale-error-message — both are
  in-source acknowledgments of imperfection.

  §the-named-harden-on-ref-before-storage — line 102:
  `nonceToRef.set(myNonce, harden(val))`. Before
  storing in the nonce map, the value is hardened.
  Ensures the stored value is frozen. Consistent with
  cycle 423's marshal-requires-frozen-input framing.
  §the-named-harden-before-storage-discipline as
  tier-3 meta-pattern.

  §the-named-loopback-as-the-test-double-for-CapTP —
  the practical purpose: enable testing of cap-based
  code in-process without an actual network. The
  serialization round-trip catches bugs (forgotten
  Far, unhardened values) that production CapTP
  would also catch. §the-named-loopback-as-CapTP-
  conformance-tester as tier-3 meta-pattern.

  §the-named-seventy-eight-conformant-cycles-and-
  counting.

  §the-named-cycle-430-as-numeric-milestone — cycle
  430 is the numeric 430-cycle mark AND the one-
  hundred-and-twentieth post-pivot cycle. Double
  milestone.

  Closes ten citation arcs: cycle 429 (5, MAJOR
  REFINEMENT — Loopback isn't mock; it's real CapTP
  in degenerate configuration; cycle 429's framing
  sharpened) + cycle 428 (3, harden-before-storage
  parallels the harden-required-by-marshal framing)
  + cycle 425 (3, Far-without-exo as a skip of the
  defensive-remotable discipline when guards aren't
  needed) + cycle 423 (3, qclass-original-encoding
  vs smallcaps now has a use-case justification —
  Loopback uses original) + cycle 403 (5, mock-vs-
  degenerate-configuration framing refines the
  mock-internals-real-externals topology) + cycle
  408 (3, role-cardinality-reduction parallels the
  two-CapTP-back-to-back shape) + cycle 326 (75) +
  cycle 322 (75) + cycle 387 (3, branded-types via
  Far('refGetter', ...) label) + cycle 318 (3,
  E and eventual send underlie both CapTPs in
  Loopback). Pushes citation-arc-closures-in-pivot
  to SEVEN-HUNDRED-AND-SIXTY-TWO (752 + 10 net new).
---

117-line loopback.js from @endo/captp/src — the in-process CapTP cycle 429 framed as "async barrier between near and far objects." Chat-lane after cycle 429 designs-lane captp/README.md. **CYCLE 430 = numeric 430-cycle mark AND 120th post-pivot cycle — double milestone.** **Single most structurally interesting move**: §the-named-loopback-is-real-CapTP-in-degenerate-configuration — *Loopback creates TWO real CapTP instances back-to-back (near-${ourId} and far-${ourId}), each side's send is the other's dispatch. Cycle 429 framed Loopback as "mock CapTP with real objects"; cycle 430 refines: Loopback isn't a mock — it's REAL CapTP in degenerate configuration where both remote sides happen to live in the same address space. Every byte of serialization, every protocol message, every ref-resolution goes through production code.* §the-named-degenerate-configuration-vs-mock as tier-3 meta-pattern. §the-named-nonce-based-round-trip-creates-async-barrier (object passes through JSON serialization even in same address space); §the-named-serialization-round-trip-as-async-barrier. §the-named-makeFinalizingMap-for-no-leak-nonce-storage; §the-named-finalizing-map-as-anti-leak-storage. §the-named-makeFar-and-makeNear-as-symmetric-pair; §the-named-symmetric-far-near-makers. §the-named-shared-bootstrap-for-loopback (unusual — both sides share same refGetter); §the-named-shared-bootstrap-as-loopback-trick. §the-named-loopback-uses-original-qclass-encoding-not-smallcaps (cycle 423's two-marshal-encodings framing now has a specific use case); §the-named-qclass-encoding-as-loopback-choice. §the-named-isOnlyNear-and-isOnlyFar-predicates; §the-named-side-classification-predicates. §the-named-per-side-stats-via-getNearStats-and-getFarStats; §the-named-per-CapTP-monitoring. §the-named-loopback-trapGuest-via-nearTrapImpl; §the-named-loopback-built-in-trap-implementation. §the-named-mutual-CapTP-references-require-use-before-define-disable; §the-named-circular-definition-via-eslint-disable. §the-named-Far-without-exo-for-minimal-bootstrap (cycle 425 noted exos add validation; here skipped); §the-named-Far-skipping-exo-when-no-guard-needed. §the-named-single-use-nonce-for-generative-security (consumed on fetch); §the-named-single-use-nonce-as-generative-capability. §the-named-ts-expect-error-as-known-type-imperfection (sibling to cycle 424's acknowledged-stale-error-message); §the-named-known-type-imperfection-as-explicit-acknowledgment. §the-named-harden-on-ref-before-storage; §the-named-harden-before-storage-discipline. §the-named-loopback-as-the-test-double-for-CapTP; §the-named-loopback-as-CapTP-conformance-tester (serialization round-trip catches bugs production CapTP would also catch). §the-named-seventy-eight-conformant-cycles-and-counting. §the-named-cycle-430-as-numeric-milestone (430 cycles + 120 post-pivot). Ten citation arcs closed; pushes citation-arc-closures-in-pivot to SEVEN-HUNDRED-AND-SIXTY-TWO.
