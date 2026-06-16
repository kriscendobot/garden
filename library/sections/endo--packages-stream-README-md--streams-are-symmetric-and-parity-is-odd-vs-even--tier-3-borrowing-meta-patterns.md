---
title: Tier-3 borrowing (meta-patterns)
source: endo--packages-stream-README-md
url: https://github.com/endojs/endo/blob/master/packages/stream/README.md
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/stream/README.md
total-lines: 140
ingest-cycle: 319
ingest-date: 2026-06-11
lane: designs
section-tags:
  - the-named-parity-IS-named-odd-vs-even-channel-protocol-invariant
  - the-named-streams-are-symmetric
  - the-named-symmetric-shape-with-pair-shaped-API
  - the-named-streams-as-hardened-async-iterators
  - the-named-async-iterators-suffice-for-back-pressure
  - the-named-back-pressure-by-awaiting-next
  - the-named-makePipe-returns-entangled-pair
  - the-named-makeQueue-IS-named-async-promise-queue
  - the-named-get-before-put-discipline
  - the-named-no-promise-ordering-guarantee
  - the-named-honest-about-absent-guarantees
  - the-named-stream-IS-named-pair-of-queues
  - the-named-pump-IS-named-reader-to-writer-bridge
  - the-named-async-generator-as-writer
  - the-named-generator-writers-have-odd-parity
  - the-named-prime-IS-named-parity-corrector
  - the-named-program-counter-as-named-mental-model
  - the-named-iteration-results-are-shallowly-frozen
  - the-named-shallow-freeze-vs-deep-harden-distinction
  - the-named-some-values-cannot-be-frozen
  - the-named-Hardening-section-not-Hardened-JavaScript
  - the-named-content-first-README-shape
  - the-named-no-Install-section-as-new-shape-variant
  - the-named-cross-package-citation-arc-closes-with-cycle-315
  - the-named-cat-implemented-via-pump
  - ten-cycles-with-named-pivot-domain-stay
  - five-named-packages-in-the-pivot-cluster
  - eight-cycles-with-named-Hardened-JS-discipline
  - five-README-shapes-now
parent: endo--packages-stream-README-md--streams-are-symmetric-and-parity-is-odd-vs-even
---

- **§the-named-parity-IS-named-odd-vs-even-channel-protocol-invariant** — mathematical vocabulary applied to channel-protocol-priming makes a structural property name-able
- **§the-named-streams-are-symmetric** — collapse Reader<T> and Writer<T> into one type when the underlying message protocol is symmetric; keep pair-shaped names at the API for ergonomic clarity
- **§the-named-honest-about-absent-guarantees** — the negative space of the contract (what the library does NOT guarantee) is documented as carefully as the positive space
- **§the-named-mechanism-IS-named-in-the-README** — implementations don't have to be opaque; explaining the construction (pair of queues) helps users reason about what the abstraction can and cannot do
- **§the-named-program-counter-as-named-mental-model** — low-level execution-model abstractions can surface in user-facing docs when they're the clearest explanation
- **§the-named-section-header-discriminates-framing** — "Hardening" (action) vs "Hardened JavaScript" (environment) — same Hardened-JS topic, different framing chosen for the section header
- **§the-named-library-author-oriented-README-shape** — a library meant to be composed (not installed directly) omits Install; the README's shape signals the intended audience
- **§the-named-different-causes-same-corrector** — pumps are odd-parity from topology; generator-writers are odd-parity from JS-language semantics; the same `prime` function corrects both
