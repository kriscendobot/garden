---
source: packages/stream/index.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/stream/index.js
source_branch: master
source_commit: e56bf00f289ff8484094b785b11636b8bc71d87e
source_authors: [Kris Kowal (prompted)]
ingested: 2026-06-03
ingested_by: scholar
section_count: 1
status: current
notes: |
  Cycle 171. Chat-lane after cycle 170's designs-lane.
  §Endo-source-comment-fragment genre.

  247-line file. §The-canonical-async-stream-substrate
  referenced by cycle 137 daemon-message-streaming, cycle
  163 ocap-kernel glossary, and CapTP's wire transport.

  **§Fourteenth file in the e56bf00f coordinated-update
  cluster** (cycles 108/110/115/118/123/125/132/134/138/
  140/144/167/169/171).

  Seven exports: makeQueue + makeStream + makePipe + pump +
  prime + mapReader + mapWriter.

  **Single most structurally interesting move**: §symmetric-
  stream-interface where Reader and Writer differ only by
  convention, not structure. The same object shape serves
  both ends; §convention names §sends-data-and-receives-
  undefined as Writer; §receives-data-and-sends-undefined
  as Reader.

  §Why-this-file-exists (opening comment): §compatible-
  with-AsyncIterator-and-Generator-but-stricter; §every-
  method-and-argument-required (vs vanilla iterators'
  optional methods); §three-method-symmetry (next / return
  / throw).

  §makeQueue with §functional-async-queue idiom: chain of
  §{value, promise} cons-cells. §Producer-makes-cons-cell;
  §consumer-walks-chain. §Promise-as-pointer. §No-bounded-
  buffer; §producer-never-blocks.

  §makeStream pairs §acks-and-data. §Stream-is-cross-wired-
  pair-of-queues. §Three-symmetric-methods all put-to-data
  and get-from-acks. §throw-puts-a-rejected-promise (errors
  flow through data queue). §Shallow-freeze (typed arrays
  aren't freezable).

  §makePipe = §two-queues-cross-wired. Three-line
  implementation reveals the simplicity. §Back-pressure-
  via-acks (writer's next doesn't resolve until reader
  acks). §The-rate-of-flow-is-rate-of-acks.

  §pump-with-tick-tock-mutual-recursion: §behold-mutual-
  recursion (literal code comment). §tick processes
  reader-result; §tock processes writer-result. §E.when-
  not-await — §let-this-work-on-remote-eventual-send-
  values (cycle 137 relies on this).

  §prime captures §first-returned-promise: §async-
  generator-needs-priming. §The-first-.next(value)-is-
  actually-the-second-value. §Uniform-discipline-across-
  iterator-protocol.

  §mapReader / mapWriter §two-different-shapes-for-same-
  pattern. §Reader-side-uses-async-generator (for-await
  + yield); §writer-side-uses-method-wrapping (intercept
  next, pass-through throw/return). §The-direction-of-
  iteration-matters-for-implementation-shape.

  §Harden-everything-individually (7 export-level harden
  calls). §Defensive-harden-discipline. §Harden-the-
  factory-not-just-the-result.

  §The-stream-substrate-ecosystem: cycle 137 (daemon-
  message-streaming uses streams over CapTP), cycle 163
  (ocap-kernel glossary names @endo/stream as shared
  substrate), cycle 154 (trap.js's async-generator
  resumable-state pattern), cycle 158 (loopback.js cross-
  wires two CapTP via streams), @endo/captp wire transport
  built on Reader/Writer pair.

  §Vocabulary-drift-where-substrate-is-shared (named in
  cycle 163): ocap-kernel calls bidirectional a *channel*
  and unidirectional a *stream*; @endo/stream's Stream is
  symmetric; @endo/captp calls bidirectional a
  *connection*. §Three-different-vocabularies-for-two-or-
  three-different-things.

  §Promise-kit-foundation: uses makePromiseKit. §Cycle-152's-
  memo-race is the racing-with-cleanup sibling; this file's
  makeQueue is sequencing-with-back-pressure. §Two-promise-
  based-async-primitives.

  §Gap-revealing-comparison with cycles 137/163/158/154/152/
  169.

  §Synthesis-target: §symmetric-stream-interface pattern is
  borrowable; §makePipe-from-two-queues idiom; §back-
  pressure-via-acks. Slot machine library will need stream-
  like primitives — §reuse-this-substrate.

  §Tier-1 vocabulary borrowing: §symmetric-stream-interface,
  §makePipe-from-two-cross-wired-queues, §functional-async-
  queue (promise-chain cons-cells), §back-pressure-via-acks,
  §prime-captures-first-returned-promise, §async-generator-
  for-reader-transform-method-wrapping-for-writer-transform,
  §E.when-not-await, §harden-everything-individually.

  §Small-file-but-foundational. §247-lines-7-exports.
  §Sibling-to-cycle-167's-where/index.js and cycle-169's
  atomics.js as §small-files-with-large-knowledge-density.
  §The-substrate-files-are-often-the-shortest.

  Cycle 171 was nominally chat-lane (after cycle 170's
  designs-lane). Papers-lane blocked 65+ consecutive
  cycles.
---

> Abstract: `packages/stream/index.js` (247 lines) is the
> **§Endo-async-stream-substrate**. Seven exports
> (makeQueue + makeStream + makePipe + pump + prime +
> mapReader + mapWriter) implement the canonical async-
> iterator-stream protocol.
>
> **Cycle 171 — chat-lane** after cycle 170's designs-lane.
> §Endo-source-comment-fragment genre.
>
> §Fourteenth file in the e56bf00f coordinated-update
> cluster.
>
> **Single most structurally interesting move**: §symmetric-
> stream-interface where Reader and Writer differ only by
> convention, not structure.
>
> §makeQueue uses §functional-async-queue (promise-chain
> cons-cells). §makePipe is two-queues-cross-wired. §pump
> uses §tick-tock-mutual-recursion (behold-mutual-recursion
> per the literal comment). §E.when-not-await lets streams
> work on remote eventual-send values.
>
> §prime captures first-returned-promise to handle
> async-generator priming asymmetry.
>
> §mapReader and mapWriter have §two-different-shapes-for-
> same-pattern — §the-direction-of-iteration-matters-for-
> implementation-shape.
>
> §The-substrate-many-files-depend-on: daemon-message-
> streaming, ocap-kernel glossary, CapTP wire transport,
> loopback.
>
> §Vocabulary-drift-where-substrate-is-shared: ocap-kernel
> uses *channel* + *stream*; @endo/stream uses symmetric
> *Stream*; @endo/captp uses *connection*. §Three-different-
> vocabularies-for-shared-substrate.
>
> §Tier-1 borrowing: §symmetric-stream-interface, §makePipe-
> from-two-cross-wired-queues, §functional-async-queue,
> §back-pressure-via-acks, §prime-captures-first-returned-
> promise, §E.when-not-await, §harden-everything-
> individually.
>
> §Small-file-but-foundational. §Sibling-to-cycle-167's-
> where/index.js and cycle-169's atomics.js.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [symmetric-async-iterator-streams-with-makeQueue-makePipe-pump-and-prime-utilities](../sections/endo--packages-stream-index-js--symmetric-async-iterator-streams-with-makeQueue-makePipe-pump-and-prime-utilities.md) | streams, patterns, captp | current |

One cohesion-honest section. §The-seven-utilities-form-a-
coherent-substrate around §symmetric-stream-interface;
§splitting-would-fragment.

## Provenance

- Fetched 2026-06-03 from `endojs/endo@master`
  (file last touched in commit `e56bf00f`).
- Author: Kris Kowal (prompted).
- **Fourteenth file in the e56bf00f coordinated-update
  cluster** (cycles 108/110/115/118/123/125/132/134/138/
  140/144/167/169/171).
- Cycle 171 was nominally **chat-lane** (after cycle 170's
  designs-lane). Papers-lane has been blocked for **65+
  consecutive cycles**.
- One cohesion-honest section.
