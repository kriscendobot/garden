---
kind: result
role: liaison
dispatch-root: dispatches/liaison--d032b9
cycle: 319
lane: designs
host: endolin
date: 2026-06-15
---

# Result — liaison cycle 319: @endo/stream README.md (designs-lane; tenth consecutive @endo/* source; fifth package; cross-package citation arc with cycle 315 closes)

Cycle 319 ingest: **@endo/stream README.md** (140 lines) — the cross-package stream substrate cited from cycle 315's @endo/lp32 README as the `makePipe` composition partner. Designs-lane after cycle 318's chat-lane. **Tenth consecutive non-garden source after the pivot** (cycles 310-319). **Fifth package** in the pivot cluster (@endo/nat + @endo/memoize + @endo/hex + @endo/lp32 + @endo/stream). **The cross-package citation arc opened in cycle 315 closes in cycle 319.**

## Single most structurally interesting move

**§the-named-parity-IS-named-odd-vs-even-channel-protocol-invariant** — the README names *parity* (with explicit odd/even values) as a structural invariant of the channel protocol:

> This makes the parity of a pump "odd", because the reader needs a free acknowledgement to start. This is in contrast to a pipe, which has "even" parity, because the reader and writer can both proceed initially.

Mathematical vocabulary (parity) applied to channel-protocol-priming makes a structural property *name-able*. Once you have the word *parity*, you can ask whether combining channels preserves it, what corrects odd parity (answer: **§the-named-prime-IS-named-parity-corrector**), and whether the odd-parity hazard is inherent to topology or to language semantics.

**§the-named-different-causes-same-corrector** — pumps are odd-parity by *topology* (reader-to-writer chain); generator-writers are odd-parity by *JS-language semantics* (first yield discards its argument; the program counter must reach the first yield before subsequent values land). The same `prime` function corrects both, even though the causes differ. First-explicit-observation.

## Cross-package citation arc closes

**§the-named-cross-package-citation-arc-closes-with-cycle-315** — cycle 315's lp32 README's round-trip example imported `makePipe` from `@endo/stream` and named it as the cross-package composition partner. Cycle 319's stream README *is* `@endo/stream`. **§the-named-citation-arc-takes-four-cycles-to-close** (315 promises; 316 + 317 + 318 intervene; 319 supplies). This is the first cross-cycle citation-arc closure in the pivot.

## Other key first-explicit-observations (twenty-plus)

- §the-named-streams-are-symmetric ("The same stream type serves for both a reader and a writer" — counterintuitive vs cycle 315 lp32 Reader/Writer pair)
- §the-named-symmetric-shape-with-pair-shaped-API (pair names are for ergonomic clarity; underlying type is one)
- §the-named-streams-as-hardened-async-iterators (conceptual frame in first sentence)
- §the-named-async-iterators-suffice-for-back-pressure (return value of next() is itself a reverse-channel)
- §the-named-makePipe-returns-entangled-pair (*entangled* deliberate; back-pressure crosses the pair)
- §the-named-makeQueue-IS-named-async-promise-queue (get-before-put)
- §the-named-no-promise-ordering-guarantee + §the-named-honest-about-absent-guarantees (negative space of contract)
- §the-named-stream-IS-named-pair-of-queues (mechanism explained in README)
- §the-named-pump-IS-named-reader-to-writer-bridge + §the-named-cat-implemented-via-pump
- §the-named-async-generator-as-writer (yield evaluates to next's argument — JS-language fact made load-bearing)
- §the-named-generator-writers-have-odd-parity
- §the-named-program-counter-as-named-mental-model (low-level abstraction in user-facing docs)
- §the-named-iteration-results-are-shallowly-frozen + §the-named-shallow-freeze-vs-deep-harden-distinction
- §the-named-some-values-cannot-be-frozen (array buffers; honest about JS limitations)
- §the-named-Hardening-section-not-Hardened-JavaScript (action-header vs environment-header — §the-named-section-header-discriminates-framing)
- §the-named-content-first-README-shape (seven content sections; no Install, no License, no Overview heading)
- §the-named-no-Install-section-as-new-shape-variant
- §the-named-library-author-oriented-README-shape

## Multi-cycle patterns extended

- §ten-cycles-with-named-pivot-domain-stay (310-319)
- §five-named-packages-in-the-pivot-cluster (fifth package adds: @endo/stream)
- §five-README-shapes-now (six-section × 3 + four-section × 1 + seven-section content-first × 1)
- §eight-cycles-with-named-Hardened-JS-discipline (310 + 312 + 313 + 315 + 316 + 317 + 318 + 319)
- §the-named-README-shape-IS-named-tailored-to-package-depth-and-audience (shape varies by package depth AND intended audience: user → has Install; library-author → omits Install)

## Tier-3 meta-patterns

- **§the-named-parity-IS-named-odd-vs-even-channel-protocol-invariant** — mathematical vocabulary makes structural properties name-able
- **§the-named-streams-are-symmetric** — collapse Reader<T>/Writer<T> into one type when the message protocol is symmetric; keep pair-shaped names at the API for ergonomic clarity
- **§the-named-honest-about-absent-guarantees** — document the negative space of the contract as carefully as the positive space
- **§the-named-mechanism-IS-named-in-the-README** — implementations don't have to be opaque; explaining the construction (pair of queues) helps users reason
- **§the-named-program-counter-as-named-mental-model** — low-level execution-model vocabulary can surface in user-facing docs when it's the clearest explanation
- **§the-named-section-header-discriminates-framing** — "Hardening" (action) vs "Hardened JavaScript" (environment) — same topic, different framing chosen for the header
- **§the-named-library-author-oriented-README-shape** — library meant to be composed (not installed directly) omits Install; the README's shape signals intended audience
- **§the-named-different-causes-same-corrector** — pumps are odd-parity by topology; generator-writers by language semantics; the same fix corrects both
- **§the-named-citation-arc-takes-N-cycles-to-close** — cross-package documentation forms a graph; arcs opened in one cycle close when the receiving package's README arrives, possibly many cycles later

## Synthesis-target

Slot machine library **§`@game/streaming/README.md`** — streams between game-server and renderer (extending cycle 315's synthesis-target):

1. Conceptual frame in the first sentence.
2. Back-pressure via awaiting next; the return value of next() is itself a reverse-channel.
3. If reader and writer share underlying type, name §streams-are-symmetric; keep pair-shaped API names for ergonomic clarity.
4. Name structural invariants with mathematical vocabulary (parity, entanglement, rendezvous).
5. Honest about absent guarantees (negative space of contract).
6. Explain the mechanism in the README if load-bearing for user reasoning.
7. Canonical OS utility as canonical example (cat via pump).
8. Distinguish shallow-freeze from deep-harden.
9. Name JS-language limitations honestly.
10. Use program-counter vocabulary when it's the clearest explanation.
11. Choose "Hardening" (action) vs "Hardened JavaScript" (environment) section header deliberately.
12. Omit Install when library is meant to be composed, not installed directly.
13. Citation arcs across READMEs form a graph; arcs opened by a prior README close when the receiving package's README arrives.

## Library state after cycle 319

- §library-reaches-831-sections from 369 source documents
- §one-hundred-and-fifty-second consecutive designs-chat alternation
- §ten-cycles-with-named-pivot-domain-stay (pivot productive at ten cycles)
- §five-named-packages-in-the-pivot-cluster (nat + memoize + hex + lp32 + stream)
- §five-README-shapes-now
- §eight-cycles-with-named-Hardened-JS-discipline
- First cross-cycle citation-arc closure (315 → 319; four-cycle arc)

## Next cycle pacing

Cycle 320 is chat-lane next. With @endo/stream introduced as the fifth package, candidate moves:

- **@endo/stream/index.js or src/...** — chat-lane; would form an immediate adjacent-reverse pair with cycle 319 (README → src), mirroring cycles 315-316 lp32 (README → reader). Productive.
- **@endo/lp32/writer.js** (49 lines) — chat-lane; would complete a *three-file* lp32 cluster (315 README + 316 reader + 320 writer), the second three-file cluster of the pivot.
- **@endo/nat docs/... or @endo/memoize docs/...** if any docs/ subdirs exist — would deepen those packages.

@endo/lp32 writer.js is the more productive choice (second three-file cluster of the pivot; tests whether the §the-named-three-file-cluster-doc-impl-sibling-arc shape extends from hex to lp32; lp32's writer is symmetric to its reader, so the encode-decode-asymmetry observation from cycle 318 doesn't apply — instead we'd expect the §the-named-sibling-file-shape-shared discipline to be even stronger between reader and writer). Picking freely but tracking for future work.
