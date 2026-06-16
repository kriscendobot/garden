---
title: The single most structurally interesting move
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

**§the-named-parity-IS-named-odd-vs-even-channel-protocol-invariant** — the README names the concept **parity** with explicit *odd vs even* values, applied to channel-protocol-priming (line 81-84):

> This makes the parity of a pump "odd", because the reader needs a free acknowledgement to start. This is in contrast to a pipe, which has "even" parity, because the reader and writer can both proceed initially.

This is **mathematical vocabulary (parity, with odd/even values) applied to channel-protocol structure**. It names a structural invariant of the message-pair protocol — *how many free acknowledgements must be in flight to make the channel productive*. Pipes have even parity (both sides can start producing immediately). Pumps and generator-writers have odd parity (one side needs a primer-acknowledgement before it can start).

The vocabulary makes the property *name-able* and *reasonable-about*. Once you have the word *parity*, you can ask:

- What's the parity of *this* channel?
- Does combining channels preserve parity?
- What corrects odd parity? (**§the-named-prime-IS-named-parity-corrector** — the answer.)
- Is parity inherent to the channel's *topology* or to its *initial state*?

The README answers the last one structurally: pumps are odd because of their *topology* (reader-to-writer chain); generator-writers are odd because of *JS-language semantics* (the first yield discards its argument; **§the-named-generator-writers-have-odd-parity**). The fix in both cases is the same — prime the channel — but the *cause* differs. §the-named-different-causes-same-corrector. First-explicit-observation in library.
