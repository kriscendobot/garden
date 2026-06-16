---
title: The Hardened-JS-discipline break
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

**§the-named-discipline-breaks-in-pivot-at-cycle-323** — the §eleven-cycles-with-named-Hardened-JS-discipline (which ran 310 + 312 + 313 + 315 + 316 + 317 + 318 + 319 + 320 + 321 + 322) **stops at cycle 323**. The captp README does *not* have a Hardened-JavaScript section, does *not* mention `harden`, does *not* claim a Hardened-JS dependency in prose.

But the captp source files heavily use harden (cycles 154 + 156 + 158 all import and use it). So this is **§the-named-Hardened-JS-absent-from-README-but-present-in-code** — a *documentation-side* break of a discipline that holds *implementation-side*. The README assumes the reader understands the Hardened-JS context from elsewhere; the source files exhibit the discipline directly.

Two interpretations:
- **Discipline-as-presentation**: Hardened-JS is *visible* in code but *hidden* in docs; the README treats Hardened-JS as implicit-context
- **Discipline-as-documentation-rule**: every package's README should call out Hardened-JS; captp's README is an oversight or omission

The first interpretation is more charitable and structurally meaningful: cycle 323 is the first pivot cycle where a README's framing assumes Hardened-JS as background rather than naming it. First-explicit-observation as a pattern-break.
