---
title: Synthesis-target
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

Slot machine library **§`@game/streaming/README.md`** — streams between game-server and renderer (extending cycle 315's synthesis-target):

1. Name the **conceptual frame in the first sentence** ("the game models streams as hardened async iterators").
2. Claim **back-pressure via awaiting next** explicitly; explain that the return value of next() is itself a reverse-channel message.
3. If reader and writer share the same underlying type (one IteratorResult shape), say so — call this **§streams-are-symmetric**; keep pair-shaped API names (mapReader/mapWriter) for ergonomic clarity.
4. Name the structural invariant of the channel protocol with **mathematical vocabulary**: parity (odd/even), entanglement, rendezvous — whatever fits.
5. Be **honest about absent guarantees**: enumerate what the library does NOT promise (e.g., promise-settle ordering, concurrent-write safety).
6. **Explain the mechanism in the README** if it's load-bearing for user reasoning — "a stream is a pair of queues that transport iteration results"-style construction summaries.
7. Use a **canonical OS utility as canonical example** (e.g., `cat` via pump + makeNodeReader/Writer) — shows how the abstraction composes for real tasks.
8. Distinguish **shallow freeze from deep harden** explicitly; name what the library takes responsibility for (shape) and what the user must take responsibility for (content).
9. Name **JS-language limitations honestly** ("some values like array buffers cannot be frozen") rather than papering over them.
10. **Use program-counter or other low-level execution-model vocabulary** when it's the clearest explanation of a hazard (e.g., generator-writer odd parity).
11. Choose the section header **Hardening** (action) vs **Hardened JavaScript** (environment) deliberately based on framing.
12. Omit Install when the library is meant to be composed, not installed directly — the README's shape signals audience.
13. If a citation-arc was opened by a prior README (e.g., "this library uses @endo/stream's makePipe"), the receiving README's existence closes the arc; cross-package documentation forms a graph.
