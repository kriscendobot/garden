---
source: packages/captp/src/atomics.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/captp/src/atomics.js
source_branch: master
source_commit: e56bf00f289ff8484094b785b11636b8bc71d87e
source_authors: [Kris Kowal (prompted)]
ingested: 2026-06-03
ingested_by: scholar
section_count: 2
status: current
notes: |
  Cycle 169. Chat-lane after cycle 168's designs-lane.
  §Endo-source-comment-fragment genre. §Pair-with-cycle-
  154's-trap.js (trap.js = abstract interface; this = 
  SharedArrayBuffer implementation).

  170-line file. §SharedArrayBuffer-as-synchronous-RPC-
  transport for @endo/captp's Trap mechanism. §Load-
  bearing-premise: SharedArrayBuffer + Atomics =
  blocking RPC across worker boundaries.

  Same coordinated-update commit `e56bf00f` as cycles
  108 + 110 + 115 + 118 + 123 + 125 + 132 + 134 + 138 +
  140 + 144 + 167. **Thirteenth file in the e56bf00f
  cluster.**

  **Single most structurally interesting move**: §three-
  buffer-split-in-one-SharedArrayBuffer paired with
  §Atomics-wait-notify-for-blocking-RPC.

  §Three-buffer-split: lenbuf (BigUint64Array; 8 bytes;
  remaining-data-length 64-bit) + statusbuf (Int32Array;
  4 bytes; Atomics-compatible flags) + databuf (Uint8Array;
  rest; payload chunk). §Single-allocation-three-views over
  one SharedArrayBuffer.

  §Why-Int32Array-for-status: §standard-API-constraint-
  acknowledged-in-comment (cites MDN docs for
  Atomics.notify). §32-bit-atomic-integer is the canonical
  wake-target.

  §Three-status-bit-flags: STATUS_WAITING (1) +
  STATUS_FLAG_DONE (2) + STATUS_FLAG_REJECT (4). §Bit-
  flags-not-enum-when-states-are-orthogonal — can simultane-
  ously say *last chunk AND rejection*.

  §Async-generator-as-trapHost: §yield-as-resume-point.
  §Async-generator-as-resumable-state-machine. §JS-language-
  feature-as-control-flow-primitive. §Iterator-protocol-as-
  bidirectional-channel — host sends chunks via
  Atomics.notify; guest controls iteration via it.next() /
  it.return() / it.throw().

  §Chunked-transfer-by-buffer-size: arbitrarily-large JSON
  encoded message split into databuf-sized chunks; remaining
  byte count sent in lenbuf. §Allocate-once-zero-copy-chunk
  (subarrays).

  §Special-case-done-on-first-try: §allocation-elision-for-
  common-case. When the encoded JSON fits entirely in
  databuf, the guest uses databuf as the encoded buffer via
  subarray (zero copy). §Optimization-by-shape-recognition.

  §Guest-side-it.throw(null)-to-terminate-host-generator:
  §cleanup-via-iterator-protocol. §Null-as-the-error-value
  because captp logging would spam with spurious messages.
  §TODO-named (use an error type when captp is less noisy)
  — §honest-limitation-with-named-future-improvement
  (sibling to cycle 167's roaming-AppData TODO).

  §Pathological-MIN_DATA_BUFFER_LENGTH=1: §test-the-
  boundary-not-just-the-happy-path. §The-unit-test-
  exercises-this-edge. §Discipline-named: §pathological-
  test-case-anchors-the-design.

  §Pairs-with-cycle-154's-trap.js: trap.js defines TrapHost
  / TrapGuest as abstract interface; this is concrete
  SharedArrayBuffer transport. §Two-paired-files-
  implementing-one-mechanism.

  §Synchronous-RPC-as-meta-capability: §rare-and-valuable-
  primitive in the JS ecosystem (most cross-worker
  communication is async via postMessage). §Atomics-based-
  blocking is the §only-way to get truly synchronous cross-
  thread calls.

  §This-enables-XS-debugger-style-stepping (cycle 159's
  daemon-debug-worker-restart). §This-enables-Trap-in-cycle-
  154.

  §JSON-encoding-not-marshal-direct: §two-step-encoding
  (JSON-for-structure + UTF-8-for-bytes). §Layering-
  discipline named: marshal happens upstream; this is pure
  bytes transport.

  §Three-buffer-write-order discipline: data first, length
  second, status last, then notify. §Status-write-plus-
  notify is the §commit-point. §Implicit-invariant
  enforced-by-code-position.

  §Gap-revealing-comparison with cycles 154 / 158 / 156 /
  167 / 159.

  §Tier-1 vocabulary borrowing: §three-buffer-split-in-one-
  SharedArrayBuffer, §Atomics-wait-notify-for-blocking-RPC,
  §async-generator-as-resumable-state-machine, §bit-flags-
  not-enum-when-states-are-orthogonal, §allocation-elision-
  for-common-case, §cleanup-via-iterator-protocol,
  §pathological-test-case-anchors-the-design.

  §Small-file-but-load-bearing-knowledge — sibling to
  cycle 167's where/index.js and cycle 165's platform-
  specific.md. §Reading-this-file-tells-you-how-Trap-works
  across worker boundaries.

  §Synthesis-target: future synchronous-RPC needs (e.g.,
  slot machine's blocking-mode operations) can §reuse-this-
  substrate.

  Cycle 169 was nominally chat-lane (after cycle 168's
  designs-lane). Papers-lane blocked 63+ consecutive
  cycles.
---

> Abstract: `packages/captp/src/atomics.js` (170 lines) is
> the **§SharedArrayBuffer-as-synchronous-RPC-transport**
> for @endo/captp's Trap mechanism.
>
> **Cycle 169 — chat-lane** after cycle 168's designs-lane.
> §Endo-source-comment-fragment genre.
>
> §Pair-with-cycle-154's-trap.js: trap.js = abstract
> interface; this = SharedArrayBuffer implementation. §Two-
> paired-files-implementing-one-mechanism.
>
> **Single most structurally interesting move**: §three-
> buffer-split-in-one-SharedArrayBuffer (lenbuf +
> statusbuf + databuf) paired with §Atomics-wait-notify-
> for-blocking-RPC.
>
> §Three-status-bit-flags (WAITING + DONE + REJECT) as
> §bit-flags-not-enum-when-states-are-orthogonal.
>
> §Async-generator-as-resumable-state-machine; §iterator-
> protocol-as-bidirectional-channel.
>
> §Special-case-done-on-first-try: §allocation-elision-for-
> common-case via subarray.
>
> §Cleanup-via-iterator-protocol (it.throw(null)) with
> §TODO-named honest-limitation about error types.
>
> §Pathological-MIN_DATA_BUFFER_LENGTH=1 with §test-the-
> boundary discipline.
>
> §Synchronous-RPC-as-meta-capability — rare-and-valuable
> primitive. §This-enables-Trap-in-cycle-154 + §XS-
> debugger-style-stepping in cycle 159.
>
> §Small-file-but-load-bearing-knowledge — sibling to
> cycle 167's where/index.js.
>
> §Tier-1 borrowing: §three-buffer-split, §Atomics-wait-
> notify-for-blocking-RPC, §async-generator-as-resumable-
> state-machine, §bit-flags-not-enum, §allocation-elision-
> for-common-case, §cleanup-via-iterator-protocol,
> §pathological-test-case-anchors-the-design.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [SharedArrayBuffer-three-buffer-split-with-Atomics-wait-notify-and-chunked-transfer-via-async-generator](../sections/endo--packages-captp-src-atomics-js--SharedArrayBuffer-three-buffer-split-with-Atomics-wait-notify-and-chunked-transfer-via-async-generator.md) | captp, patterns, tooling | current (cycle 169; synchronous-RPC-as-meta-capability lens) |
| [sync-bridge-implementation-and-three-views-one-buffer](../sections/endo--packages-captp-src-atomics-js--sync-bridge-implementation-and-three-views-one-buffer.md) | captp, pivot-cluster-context, doc-to-impl-arc | current (cycle 324; complementary-lens-re-ingest — pivot-context lens + doc-to-impl arc closure with cycle 323) |

The cycle 169 section was one cohesion-honest unit (§The-mechanism-is-tight). Cycle 324 adds a complementary section per **§the-named-complementary-lens-re-ingest** discipline (first-explicit-observed in cycle 322 for exo-makers.js); §two-cycles-with-named-complementary-lens-re-ingest (322 + 324). The cycle 324 lens emphasizes pivot-cluster context, the doc-to-impl citation arc with cycle 323, and Tier-3 discipline-variants (derive-don't-hardcode + X-vs-Fail + line-level vs file-level eslint).

## Provenance

- Fetched 2026-06-03 from `endojs/endo@master`
  (file last touched in commit `e56bf00f`).
- Author: Kris Kowal (prompted).
- **Thirteenth file in the e56bf00f coordinated-update
  cluster** (cycles 108/110/115/118/123/125/132/134/138/
  140/144/167/169).
- Cycle 169 was nominally **chat-lane** (after cycle 168's
  designs-lane). Papers-lane has been blocked for **63+
  consecutive cycles**.
- One cohesion-honest section.
