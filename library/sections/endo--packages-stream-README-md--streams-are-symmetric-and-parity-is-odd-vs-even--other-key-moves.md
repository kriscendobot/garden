---
title: Other key moves
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
