---
title: "@endo/stream README.md — streams as hardened async iterators; symmetric reader-writer type; parity as odd-vs-even channel protocol invariant; fifth package, content-first README shape"
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
---

# `@endo/stream README.md` — symmetric streams; parity as channel-protocol invariant; fifth package, content-first shape

The 140-line README for `@endo/stream` — the cross-package stream substrate cited from cycle 315's @endo/lp32 README round-trip example as the composition partner for `makePipe`. Cycle 319 is **designs-lane after cycle 318's chat-lane @endo/hex/src/decode.js**. **Tenth consecutive non-garden source after the pivot** (cycles 310-319). **§ten-cycles-with-named-pivot-domain-stay**. **§five-named-packages-in-the-pivot-cluster** (@endo/nat + @endo/memoize + @endo/hex + @endo/lp32 + @endo/stream).

## The single most structurally interesting move

**§the-named-parity-IS-named-odd-vs-even-channel-protocol-invariant** — the README names the concept **parity** with explicit *odd vs even* values, applied to channel-protocol-priming (line 81-84):

> This makes the parity of a pump "odd", because the reader needs a free acknowledgement to start. This is in contrast to a pipe, which has "even" parity, because the reader and writer can both proceed initially.

This is **mathematical vocabulary (parity, with odd/even values) applied to channel-protocol structure**. It names a structural invariant of the message-pair protocol — *how many free acknowledgements must be in flight to make the channel productive*. Pipes have even parity (both sides can start producing immediately). Pumps and generator-writers have odd parity (one side needs a primer-acknowledgement before it can start).

The vocabulary makes the property *name-able* and *reasonable-about*. Once you have the word *parity*, you can ask:

- What's the parity of *this* channel?
- Does combining channels preserve parity?
- What corrects odd parity? (**§the-named-prime-IS-named-parity-corrector** — the answer.)
- Is parity inherent to the channel's *topology* or to its *initial state*?

The README answers the last one structurally: pumps are odd because of their *topology* (reader-to-writer chain); generator-writers are odd because of *JS-language semantics* (the first yield discards its argument; **§the-named-generator-writers-have-odd-parity**). The fix in both cases is the same — prime the channel — but the *cause* differs. §the-named-different-causes-same-corrector. First-explicit-observation in library.

## Other key moves

- **§the-named-streams-are-symmetric** (line 7-8) — *"The same stream type serves for both a reader and a writer."* Structurally counterintuitive: most stream libraries (including cycle 315's lp32) have separate Reader<T> and Writer<T> types. @endo/stream collapses them into one shape. **§the-named-symmetric-shape-with-pair-shaped-API** — the API has both `mapReader`/`mapWriter`, both `makeNodeReader`/`makeNodeWriter`, both for ergonomic reasons (different verb tenses are clearer), but the underlying type is one. The naming of the pair is for the human reader, not for the type system. First-explicit-observation.

- **§the-named-streams-as-hardened-async-iterators** (line 3) — *"Endo models streams as hardened async iterators."* Conceptual frame in the first sentence. **§the-named-conceptual-frame-IS-named-first-sentence-discipline**. First-explicit-observation.

- **§the-named-async-iterators-suffice-for-back-pressure** (line 4-6) — *"Async iterators are sufficient to model back-pressure or pacing since they are channel messages both from producer to consumer and consumer to producer."* Names a non-obvious claim: the *return value* of `next()` is itself a channel message in the reverse direction. §the-named-return-value-IS-named-reverse-channel; §the-named-bidirectional-from-unidirectional-protocol. First-explicit-observation.

- **§the-named-back-pressure-by-awaiting-next** (line 23) — *"Awaiting the returned promise slows the writer to match the pace of the reader."* §the-named-back-pressure-IS-named-await-discipline; §the-named-pacing-IS-named-emergent-from-await.

- **§the-named-mapReader-and-mapWriter-named-pair** (line 35-54) — symmetric functions with reversed semantics. **§the-named-writer-transform-runs-in-reverse-direction**: `singleWriter = mapWriter(doubleWriter, n => n * 2)` means writing 1 to singleWriter writes 2 to doubleWriter (the transform is applied *before* the inner write). §the-named-writer-transform-direction-flips-the-naming-intuition; the example in the README is deliberately the inverse of the mapReader example to surface this. First-explicit-observation.

- **§the-named-makePipe-returns-entangled-pair** (line 58-65) — *"returns an entangled pair of streams"*. The word **entangled** is deliberate — back-pressure crosses the pair. §the-named-entanglement-IS-named-coupled-by-back-pressure; §the-named-array-destructure-as-canonical-shape (`const [writer, reader] = makePipe();`). First-explicit-observation.

- **§the-named-pipes-for-mocking-streams-in-tests** (line 60) — explicitly cites *testing* as a use case. §the-named-mock-via-real-shape-not-fake; §the-named-test-fixture-via-real-substrate.

- **§the-named-makeQueue-IS-named-async-promise-queue** (line 66-72) — *"like a queue except that `get` returns a promise and `put` accepts a promise, so `get` can be called before `put`."* §the-named-get-before-put-discipline; §the-named-async-promise-queue-IS-named-rendezvous-shape; §the-named-promise-queue-IS-named-temporal-decoupling. First-explicit-observation.

- **§the-named-no-promise-ordering-guarantee** (line 70-72) — *"provides no guarantee about the order in which promises settle."* §the-named-honest-about-absent-guarantees — the library is explicit about what it does *not* guarantee. The negative space of the contract is documented as carefully as the positive space. First-explicit-observation.

- **§the-named-stream-IS-named-pair-of-queues** (line 73-74) — *"A stream is consequently a pair of queues that transport iteration results, one to send messages forward and another to receive acknowledgements."* The structural construction is laid bare. **§the-named-mechanism-IS-named-in-the-README** — implementations don't have to be opaque; the README explains the construction. §the-named-pair-of-queues-IS-named-stream. First-explicit-observation.

- **§the-named-pump-IS-named-reader-to-writer-bridge** (line 76-94) — `pump(writer, reader)` bridges them; takes the writer first as a stylistic choice (left-to-right reading: *writer ← reader*). §the-named-cat-implemented-via-pump (the canonical Unix `cat` in seven lines via pump + makeNodeWriter/Reader); §the-named-canonical-OS-utility-as-canonical-example. First-explicit-observation.

- **§the-named-async-generator-as-writer** (line 109-114) — *"async generator functions can also serve as writers, because `yield` evaluates to the argument passed to `next`."* This is a JS-language-fact-made-load-bearing. The README invokes the language semantics directly. §the-named-yield-IS-named-bidirectional-channel-point; §the-named-language-semantics-as-architectural-substrate. First-explicit-observation.

- **§the-named-program-counter-as-named-mental-model** (line 113) — *"the program counter proceeds from the beginning of the function to the first `yield`, `return`, or `throw`"*. The README invokes the **program counter** as the mental model for understanding the odd-parity bug. A low-level abstraction surfacing in user-facing documentation. §the-named-low-level-abstraction-in-user-facing-docs; §the-named-PC-IS-named-execution-cursor. First-explicit-observation.

- **§the-named-prime-IS-named-parity-corrector** (line 116-128) — *"The `prime` function compensates for this by sending a primer to the generator once."* §the-named-primer-IS-named-canonical-fix-for-odd-parity; the primer's value is *discarded* by the function body, but the act of sending it advances the program counter to the first `yield` (or further), making subsequent values reach the loop body. First-explicit-observation.

- **§the-named-iteration-results-are-shallowly-frozen** (line 136-137) — *"This implementation of streams ensures that iteration results are shallowly frozen."* The README distinguishes *shallow* freezing from deep hardening. §the-named-shallow-freeze-vs-deep-harden-distinction (the implementation freezes the IteratorResult wrapper, not the transported value). First-explicit-observation.

- **§the-named-shallow-freeze-vs-deep-harden-distinction** (line 137-138) — *"The user is responsible for hardening the transported values if that is their intent."* §the-named-deep-harden-IS-user-responsibility; **§the-named-library-takes-responsibility-for-shape-not-content**. First-explicit-observation.

- **§the-named-some-values-cannot-be-frozen** (line 140) — *"Some values like array buffers cannot be frozen."* Names a JS-language limitation honestly. §the-named-frozenness-IS-named-bounded-by-JS; §the-named-honest-about-language-limitations. First-explicit-observation.

- **§the-named-Hardening-section-not-Hardened-JavaScript** (line 130) — the section header is **Hardening** (gerund/action), not **Hardened JavaScript** (named environment). Subtly different framing from cycles 311 nat, 313 memoize, 315 lp32, 317 hex. **§the-named-section-header-discriminates-framing**; the action-headed section (Hardening) is about *what the library does*; the environment-headed section (Hardened JavaScript) is about *what the library requires or targets*. First-explicit-observation.

- **§the-named-no-Install-section-as-new-shape-variant** — the stream README *omits* the Install section. Cycles 311/313/315/317 all had Install sections. The stream README is *library-author-oriented*, not *library-user-oriented*. §the-named-library-author-oriented-README-shape; §the-named-library-IS-named-meant-to-be-composed-not-installed-directly. First-explicit-observation.

- **§the-named-content-first-README-shape** — seven content sections (Writing + Reading + Map + Pipe + Pump + Prime + Hardening) + heading-less intro. No Install, no License. **§five-README-shapes-now** in the pivot:
  - 311 nat: six sections (Overview + Math + JS + Validators-and-Coercers + History + License)
  - 313 memoize: six sections (Overview + Usage + API + Memoization-Safety + Install + License)
  - 315 lp32: six sections (Overview + Usage + API + Hardened-JavaScript + Install + License)
  - 317 hex: four sections (Install + Usage + API + Hardened-JavaScript), no Overview heading, no License
  - 319 stream: seven content sections (Writing + Reading + Map + Pipe + Pump + Prime + Hardening), no Install, no License, no Overview heading

  **§the-named-README-shape-IS-named-tailored-to-package-depth-and-audience** extends — the shape varies along two axes now: package depth (smaller → fewer sections) and audience (user → has Install; author → omits Install).

- **§the-named-cross-package-citation-arc-closes-with-cycle-315** — cycle 315 lp32 README cited `@endo/stream` (the `makePipe` import) as the cross-package composition partner. Cycle 319 stream README IS `@endo/stream`. The arc closes: cycle 315 promised the partnership; cycle 319 supplies the other end. §the-named-citation-arc-takes-four-cycles-to-close (315 + 316 + 317 + 318 + 319; four cycles after the promise). First-explicit-observation.

## Patterns the cycle extends

- §ten-cycles-with-named-pivot-domain-stay (310 + 311 + 312 + 313 + 314 + 315 + 316 + 317 + 318 + 319)
- §five-named-packages-in-the-pivot-cluster (@endo/nat + @endo/memoize + @endo/hex + @endo/lp32 + @endo/stream)
- §eight-cycles-with-named-Hardened-JS-discipline (310 + 312 + 313 + 315 + 316 + 317 + 318 + 319)
- §five-README-shapes-now (six-section nat + six-section memoize + six-section lp32 + four-section hex + seven-section content-first stream)
- §four-shapes-of-pair-discipline (unchanged; stream is a singleton ingest within the package, not yet paired with a stream source file)
- §the-named-cross-package-citation-arc-closes-with-cycle-315 — first citation-arc closure across non-adjacent cycles

## Tier-1 borrowing (twenty-plus first-explicit-observations)

All §-tags marked first-explicit-observation above. Highest-portability observations: parity-as-channel-protocol-invariant with odd/even values; streams-are-symmetric (one type for reader and writer); program-counter-as-mental-model in user-facing docs; honest-about-absent-guarantees (the negative space of the contract); shallow-freeze-vs-deep-harden distinction.

## Tier-2 borrowing (multi-cycle patterns extended)

- §ten-cycles-with-named-pivot-domain-stay (310-319)
- §five-named-packages-in-the-pivot-cluster (new package added; pivot is no longer four-package)
- §five-README-shapes-now (six × 3 + four × 1 + seven-content-first × 1)
- §eight-cycles-with-named-Hardened-JS-discipline
- §the-named-cross-package-citation-arc-closes-with-cycle-315 (first cross-cycle arc closure)

## Tier-3 borrowing (meta-patterns)

- **§the-named-parity-IS-named-odd-vs-even-channel-protocol-invariant** — mathematical vocabulary applied to channel-protocol-priming makes a structural property name-able
- **§the-named-streams-are-symmetric** — collapse Reader<T> and Writer<T> into one type when the underlying message protocol is symmetric; keep pair-shaped names at the API for ergonomic clarity
- **§the-named-honest-about-absent-guarantees** — the negative space of the contract (what the library does NOT guarantee) is documented as carefully as the positive space
- **§the-named-mechanism-IS-named-in-the-README** — implementations don't have to be opaque; explaining the construction (pair of queues) helps users reason about what the abstraction can and cannot do
- **§the-named-program-counter-as-named-mental-model** — low-level execution-model abstractions can surface in user-facing docs when they're the clearest explanation
- **§the-named-section-header-discriminates-framing** — "Hardening" (action) vs "Hardened JavaScript" (environment) — same Hardened-JS topic, different framing chosen for the section header
- **§the-named-library-author-oriented-README-shape** — a library meant to be composed (not installed directly) omits Install; the README's shape signals the intended audience
- **§the-named-different-causes-same-corrector** — pumps are odd-parity from topology; generator-writers are odd-parity from JS-language semantics; the same `prime` function corrects both

## Synthesis-target

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
