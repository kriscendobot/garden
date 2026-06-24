---
title: The single most structurally interesting move
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

**§the-named-API-with-honesty-about-relaxed-security-model** — the TrapCaps section opens (line 40-42):

> This is a specialized and advanced use case, not for mutually-suspicious CapTP parties, but instead for clear "guest"/"host" relationship, such as user-space code and synchronous devices.

The README **explicitly admits** that TrapCaps relaxes CapTP's foundational security guarantee — *not for mutually-suspicious parties*. CapTP's whole point is to allow mutually-suspicious parties to communicate without trusting each other; TrapCaps gives that up. Rather than hide the tradeoff or present TrapCaps as equally-safe, the README names the relaxation and gates the use case ("clear guest/host relationship").

This is a **discipline-of-honesty** that pairs with cycle 321's eventual-send README's §the-named-API-with-honesty-about-low-utility-paths (which named the *"most users don't need this"* disclaimer for E.resolve and HandledPromise). Together they form a transferable meta-pattern:

**§the-named-honesty-about-API-tradeoffs** — two named subtypes now:
- **Low-utility-paths** (cycle 321): admit that some exports are rarely-used
- **Relaxed-security-models** (cycle 323): admit that some exports give up a foundational guarantee

The pattern is *"name the trade in user-facing prose so consumers can reason about whether the trade fits their use case"*. First-explicit-observation in library as a *parameterized* discipline.

**§the-named-not-for-mutually-suspicious-parties-disclaimer** is the specific phrase that does the work. It's surgical: it names *what the trade is* (mutual suspicion) and *what the API expects instead* (clear guest/host). The reader can immediately check whether their use case fits without reading further.
