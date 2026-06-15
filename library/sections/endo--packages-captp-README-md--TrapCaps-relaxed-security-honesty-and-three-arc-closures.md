---
title: "@endo/captp README.md — TrapCaps relaxed-security-model honesty; sync-iterator-drives-async-iterator; eighth package; three citation arcs close; Hardened-JS discipline break"
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
---

# `@endo/captp README.md` — TrapCaps relaxed-security-model honesty; three citation arcs close

The 65-line README for `@endo/captp` — a minimal CapTP implementation. Cycle 323 is **designs-lane after cycle 322's chat-lane @endo/exo/src/exo-makers.js**. **Fourteenth consecutive non-garden source after the pivot** (cycles 310-323). **§fourteen-cycles-with-named-pivot-domain-stay**. **Eighth package added to the pivot cluster** (nat + memoize + hex + lp32 + stream + eventual-send + exo + **captp**) — though @endo/captp was already extensively in the library via cycles 154 + 156 + 158 (trap.js + finalize.js + loopback.js comment-fragments).

Cycle 323 closes **three citation arcs**:
- **§the-named-citation-arc-from-cycle-154-takes-169-cycles-to-close** — cycle 154 ingested trap.js (lifted-from-E.js synchronous CapTP proxy); cycle 323 README's TrapCaps section names the Trap proxy.
- **§the-named-citation-arc-from-cycle-158-takes-165-cycles-to-close** — cycle 158 ingested loopback.js (async-isolated CapTP channel); cycle 323 README has a Loopback section.
- **§the-named-citation-arc-from-cycle-321-takes-2-cycles-to-close** — cycle 321's eventual-send README cited *"Network Transport: @endo/captp"* with a role-label; cycle 323 IS @endo/captp's README.

The pivot has now closed **seven citation arcs** of lengths 2, 4, 165, 169, 175, 214, 255.

## The single most structurally interesting move

**§the-named-API-with-honesty-about-relaxed-security-model** — the TrapCaps section opens (line 40-42):

> This is a specialized and advanced use case, not for mutually-suspicious CapTP parties, but instead for clear "guest"/"host" relationship, such as user-space code and synchronous devices.

The README **explicitly admits** that TrapCaps relaxes CapTP's foundational security guarantee — *not for mutually-suspicious parties*. CapTP's whole point is to allow mutually-suspicious parties to communicate without trusting each other; TrapCaps gives that up. Rather than hide the tradeoff or present TrapCaps as equally-safe, the README names the relaxation and gates the use case ("clear guest/host relationship").

This is a **discipline-of-honesty** that pairs with cycle 321's eventual-send README's §the-named-API-with-honesty-about-low-utility-paths (which named the *"most users don't need this"* disclaimer for E.resolve and HandledPromise). Together they form a transferable meta-pattern:

**§the-named-honesty-about-API-tradeoffs** — two named subtypes now:
- **Low-utility-paths** (cycle 321): admit that some exports are rarely-used
- **Relaxed-security-models** (cycle 323): admit that some exports give up a foundational guarantee

The pattern is *"name the trade in user-facing prose so consumers can reason about whether the trade fits their use case"*. First-explicit-observation in library as a *parameterized* discipline.

**§the-named-not-for-mutually-suspicious-parties-disclaimer** is the specific phrase that does the work. It's surgical: it names *what the trade is* (mutual suspicion) and *what the API expects instead* (clear guest/host). The reader can immediately check whether their use case fits without reading further.

## The Hardened-JS-discipline break

**§the-named-discipline-breaks-in-pivot-at-cycle-323** — the §eleven-cycles-with-named-Hardened-JS-discipline (which ran 310 + 312 + 313 + 315 + 316 + 317 + 318 + 319 + 320 + 321 + 322) **stops at cycle 323**. The captp README does *not* have a Hardened-JavaScript section, does *not* mention `harden`, does *not* claim a Hardened-JS dependency in prose.

But the captp source files heavily use harden (cycles 154 + 156 + 158 all import and use it). So this is **§the-named-Hardened-JS-absent-from-README-but-present-in-code** — a *documentation-side* break of a discipline that holds *implementation-side*. The README assumes the reader understands the Hardened-JS context from elsewhere; the source files exhibit the discipline directly.

Two interpretations:
- **Discipline-as-presentation**: Hardened-JS is *visible* in code but *hidden* in docs; the README treats Hardened-JS as implicit-context
- **Discipline-as-documentation-rule**: every package's README should call out Hardened-JS; captp's README is an oversight or omission

The first interpretation is more charitable and structurally meaningful: cycle 323 is the first pivot cycle where a README's framing assumes Hardened-JS as background rather than naming it. First-explicit-observation as a pattern-break.

## Other key moves

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

## Patterns the cycle extends

- **§fourteen-cycles-with-named-pivot-domain-stay** (310-323)
- **§eight-named-packages-in-the-pivot-cluster** (eighth: captp; previously in library via cycles 154 + 156 + 158)
- **§seven-citation-arc-closures-in-pivot-now** (4 + 165 + 169 + 175 + 214 + 255 + 2 cycles)
- **§two-cycles-with-named-Agoric-as-named-genealogy** (321 + 323)
- **§two-cycles-with-named-four-section-README-shape** (317 + 323)
- **§two-cycles-with-named-CapTP-or-E-language-jargon-as-given** (321 + 323; "vat"/"presence"/"near"/"far"/"bootstrap")

## Patterns the cycle breaks

- **§the-named-discipline-breaks-in-pivot-at-cycle-323** — §eleven-cycles-with-named-Hardened-JS-discipline (310-322) stops; captp README does not mention Hardened-JS even though the source files use harden. **§the-named-Hardened-JS-absent-from-README-but-present-in-code**. First-explicit-observation as a pattern-break.

## Tier-1 borrowing (twenty-plus first-explicit-observations)

All §-tags marked first-explicit-observation above. Highest-portability observations: the API-with-honesty-about-relaxed-security-model with the *not-for-mutually-suspicious-parties* phrase; the synchronous-iterator-drives-async-iterator pattern as a sync→async coupling mechanism; the explanation-by-analogy-to-named-abstraction (consider X as Y framing); the named-limitation-with-specific-mechanism for partial-support disclaimers; the library-boundary-explicitly-named via NOTE prefix.

## Tier-2 borrowing (multi-cycle patterns extended)

- §fourteen-cycles-with-named-pivot-domain-stay
- §eight-named-packages-in-the-pivot-cluster
- §seven-citation-arc-closures-in-pivot-now
- §two-cycles-with-named-Agoric-as-named-genealogy
- §two-cycles-with-named-four-section-README-shape
- §two-cycles-with-named-CapTP-or-E-language-jargon-as-given

## Tier-3 borrowing (meta-patterns)

- **§the-named-honesty-about-API-tradeoffs** — two named subtypes (low-utility-paths from cycle 321 + relaxed-security-models from cycle 323); pattern is *name the trade in user-facing prose*
- **§the-named-API-with-honesty-about-relaxed-security-model** — when an API gives up a foundational security guarantee, name the relaxation and gate the use case
- **§the-named-synchronous-iterator-drives-async-iterator-pattern** — iteration as protocol-level synchronization point between sync and async
- **§the-named-sync-bridge-via-SharedArrayBuffer-and-Atomics** — JS-language mechanism for sync-from-async-environment
- **§the-named-explanation-by-analogy-to-named-abstraction** — "consider X as Y" framing for protocol explanation
- **§the-named-discipline-breaks-in-pivot-at-cycle-323** — a Tier-2 streak (eleven cycles of Hardened-JS-discipline) breaks here; document the break as a meaningful event
- **§the-named-Hardened-JS-absent-from-README-but-present-in-code** — documentation can omit what implementation includes
- **§the-named-advanced-section-IS-named-longer-than-canonical-section** — when an advanced/specialized feature is structurally complex, it deserves more space than the canonical use case
- **§the-named-shape-recurs-content-differs** — README shapes recur across packages but content varies entirely; the shape is a *form*, not a *content*
- **§the-named-library-boundary-explicitly-named** — when caller-supplied code interleaves with library code, the README must name the boundary explicitly

## Synthesis-target

Slot machine library **§`@game/comms/README.md`** — game-server-to-renderer communication via CapTP-style protocol:

1. **Minimal package-name + one-line description** opening; assume reader-in-the-tradition for vocabulary like "channel", "session", "bootstrap".
2. **NOTE prefix** at the start of Usage to distinguish caller-supplied connection from library-provided dispatch/bootstrap/abort.
3. **Three return values destructured** from the library's main maker.
4. **Eight-line lifecycle example** showing make → wire-up → call → abort.
5. **Explicit abort with Error argument** for teardown.
6. **Honest disclaimer for advanced features** — if an extension trades security for capability, name the trade ("this is for clear server/client trust, not for mutually-suspicious parties").
7. **Numbered three-step recipe** with explicit asymmetry between roles (server vs client vs middleware).
8. **Explanation by analogy** to a named JS-language abstraction ("consider the broadcast bus as a maker of AsyncIterators that...").
9. **Named limitation with specific mechanism** for partial-support — if one composition only works for a subset, name the subset surgically.
10. **Four-section shape** with the advanced section *longer* than the canonical one if the advanced use case is structurally complex.
11. **JS-language sync-bridge** (SharedArrayBuffer / Atomics.wait) named if sync-from-async is supported.
12. **Iteration-as-protocol-synchronization-point** — if sync→async coupling is needed, model it as a shared iterator pair.
13. **Library boundary explicitly named** — what's provided by the library vs what the caller must supply.
14. **Hardened-JS can be implicit** — if every package in the family uses harden, the README can assume it as background rather than dedicating a section to it.
