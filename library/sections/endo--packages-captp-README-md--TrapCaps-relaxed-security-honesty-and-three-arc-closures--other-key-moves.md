---
title: Other key moves
source: endo--packages-captp-README-md
url: https://github.com/endojs/endo/blob/master/packages/captp/README.md
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/captp/README.md
total-lines: 65
ingest-cycle: 323
ingest-date: 2026-06-15
lane: designs
section-tags:
  - the-named-API-with-honesty-about-relaxed-security-model
  - the-named-honesty-about-API-tradeoffs
  - the-named-not-for-mutually-suspicious-parties-disclaimer
  - the-named-synchronous-iterator-drives-async-iterator-pattern
  - the-named-sync-bridge-via-SharedArrayBuffer-and-Atomics
  - the-named-Trap-and-E-named-pair
  - the-named-Loopback-as-named-test-fixture
  - the-named-async-barrier-between-near-and-far
  - the-named-myconn-disclaimer
  - the-named-library-boundary-explicitly-named
  - the-named-numbered-three-step-recipe-for-TrapCaps
  - the-named-asymmetric-numbered-steps-for-asymmetric-roles
  - the-named-explanation-by-analogy-to-named-abstraction
  - the-named-advanced-section-IS-named-longer-than-canonical-section
  - the-named-partial-support-disclaimer
  - the-named-named-limitation-with-specific-mechanism
  - the-named-Hardened-JS-absent-from-README-but-present-in-code
  - the-named-discipline-breaks-in-pivot-at-cycle-323
  - the-named-four-section-shape-recurs-with-different-content
  - fourteen-cycles-with-named-pivot-domain-stay
  - eight-named-packages-in-the-pivot-cluster
  - seven-citation-arc-closures-in-pivot-now
  - two-cycles-with-named-Agoric-as-named-genealogy
  - two-cycles-with-named-four-section-README-shape
parent: endo--packages-captp-README-md--TrapCaps-relaxed-security-honesty-and-three-arc-closures
---

- **§the-named-Trap-and-E-named-pair** (line 49-51) — *"Trap(target) proxy maker much like E(target), but it will return a synchronous result"*. The README explicitly pairs Trap with E. **§the-named-symmetric-shape-with-different-semantics** (Trap and E share the proxy-maker shape but differ on sync vs async return). Closes citation arc with cycle 154 (trap.js comment-fragment, which had the §sibling-to-E.js observation). §two-cycles-with-named-Trap-and-E-named-pair (154 + 323).

- **§the-named-synchronous-iterator-drives-async-iterator-pattern** (line 57-61) — *"The returned (synchronous) iterator from startTrap() drives the async iterator of the host until it fully transfers the trap results to the guest, and the guest unblocks."* Sync→async coupling via *shared iteration*: the guest holds a sync iterator that drives an async iterator on the host side; iteration is the protocol-level synchronization point. **§the-named-iteration-as-protocol-synchronization-point**; §the-named-sync-driver-async-driven-asymmetry. First-explicit-observation.

- **§the-named-sync-bridge-via-SharedArrayBuffer-and-Atomics** (line 44-46) — *"the one based on SharedArrayBuffers in src/atomics.js"*. Names the canonical sync-bridge mechanism (SharedArrayBuffers + Atomics.wait). JS-language mechanism explicitly named. §the-named-JS-language-mechanism-for-sync-bridge; first-explicit-observation.

- **§the-named-Loopback-as-named-test-fixture** (line 27-31) — *"This is useful for testing and isolation within the same address space."* Closes citation arc with cycle 158 loopback.js (which had §test-utility-doesn't-want-gc-nondeterminism). §two-cycles-with-named-Loopback-as-named-test-fixture (158 + 323).

- **§the-named-async-barrier-between-near-and-far** (line 29-31) — *"async barrier between 'near' and 'far' objects"*. **§the-named-near-and-far-IS-named-canonical-CapTP-vocabulary**. The README assumes the reader knows what "near" and "far" mean in CapTP context (jargon-as-given, similar to cycle 321's "vat" and "presence"). §two-cycles-with-named-CapTP-or-E-language-jargon-as-given (321 + 323). First-explicit-observation.

- **§the-named-myconn-disclaimer** (line 7-10) — *"NOTE: `myconn` below is not part of the CapTP library, it represents a connection object that you have created..."* The README explicitly distinguishes what the library provides from what the caller provides. **§the-named-library-boundary-explicitly-named**; §the-named-NOTE-prefix-marks-boundary-clarification. First-explicit-observation.

- **§the-named-three-return-values-from-makeCapTP** (line 17) — `{ dispatch, getBootstrap, abort }` — destructured triple of capabilities. §the-named-destructured-triple-of-capabilities; §three-named-CapTP-capabilities.

- **§the-named-three-step-Usage-with-bootstrap** (line 17-24) — make → onReceive wire-up → call → abort. Full lifecycle in 8 lines. §the-named-eight-line-lifecycle-example.

- **§the-named-abort-IS-named-explicit-teardown** (line 23-24) — `abort(Error('Connection aborted by user.'));` — explicit abort with Error argument; **§the-named-error-arg-IS-named-cause**. First-explicit-observation.

- **§the-named-advanced-section-IS-named-longer-than-canonical-section** — the TrapCaps section is line 33-66 (33 lines); Usage is line 5-25 (20 lines); Loopback is line 27-31 (4 lines). The advanced/specialized section is the *longest*, which inverts the conventional ordering. **§the-named-advanced-section-deserves-more-explanation**; §the-named-section-length-IS-named-proportional-to-complexity-not-importance. First-explicit-observation.

- **§the-named-numbered-three-step-recipe-for-TrapCaps** (line 44-51) — three numbered steps with *explicit asymmetry* between host (step 2) and guest (step 3). **§the-named-asymmetric-numbered-steps-for-asymmetric-roles**. First-explicit-observation.

- **§the-named-explanation-by-analogy-to-named-abstraction** (line 53-55) — *"consider the trapHost as a maker of AsyncIterators which don't return any useful value"*. The README explains the protocol *by analogy* to a named JS-language abstraction (AsyncIterator). **§the-named-consider-X-as-Y-framing**; §the-named-protocol-explained-as-iterator. First-explicit-observation.

- **§the-named-Trap-throws-if-not-TrapHandler** (line 51) — *"Trap will throw an error if target was not marked as a TrapHandler by the host"*. Explicit failure mode with named precondition. §the-named-mark-as-discipline (host explicitly marks each target).

- **§the-named-partial-support-disclaimer** (line 63-65) — *"The Loopback implementation provides partial support for TrapCaps, except it cannot unwrap promises. Loopback TrapHandlers must return synchronously, or an exception will be thrown."* — names a specific limitation of one composition with surgical precision. **§the-named-named-limitation-with-specific-mechanism**; §the-named-honest-about-composition-limits. First-explicit-observation.

- **§the-named-Agoric-cited-as-genealogy** (line 3) — *"leveraging Agoric's published modules"*. **§two-cycles-with-named-Agoric-as-named-genealogy** (cycle 321's money-flow example + cycle 323's package-introduction). The Agoric naming recurs across the pivot; the captp package is positioned as *built on top of* Agoric work.

- **§the-named-import-just-two-things** (line 13) — `import { E, makeCapTP } from '@endo/captp';` — two imports; §the-named-minimal-import-shape.

- **§the-named-four-section-shape-recurs-with-different-content** — captp has four sections (heading-less intro + Usage + Loopback + TrapCaps); cycle 317 hex also had four sections (Install + Usage + API + Hardened-JavaScript). **§two-cycles-with-named-four-section-README-shape** but the *content* of the four sections differs entirely between the two packages. First-explicit-observation as a shape-recurs-content-differs pattern.
