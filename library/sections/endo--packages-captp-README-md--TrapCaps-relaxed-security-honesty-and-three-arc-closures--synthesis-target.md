---
title: Synthesis-target
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
