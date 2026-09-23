---
kind: result
role: liaison
host: endolin
dispatch_root: /home/kris/garden/dispatches/liaison--1288da
ts: 2026-06-03T20:49:07Z
ref_id: 1288da
---

# Cycle 169: endo packages/captp/src/atomics.js (chat-lane; SharedArrayBuffer-backed Trap transport)

Cycle 169 — chat-lane after cycle 168's designs-lane.
§Endo-source-comment-fragment genre. §Pair-with-cycle-154's-
trap.js (trap.js = abstract interface; this = concrete
SharedArrayBuffer implementation).

## Source

`endojs/endo packages/captp/src/atomics.js`. Author Kris
Kowal (prompted). 170 lines. File last-touched in commit
`e56bf00f` (thirteenth file in the §coordinated-update-
cluster spanning cycles 108/110/115/118/123/125/132/134/
138/140/144/167/169).

## Sections written (1)

`endo--packages-captp-src-atomics-js--SharedArrayBuffer-
three-buffer-split-with-Atomics-wait-notify-and-chunked-
transfer-via-async-generator.md` (380 lines; commit
`4fe82f48`).

**§Cohesion-honest section count**: One. §The-mechanism-
is-tight (one SharedArrayBuffer, one async generator, one
wait/notify pair); splitting would fragment.

## Single most structurally interesting move

**§Three-buffer-split-in-one-SharedArrayBuffer** paired
with **§Atomics-wait-notify-for-blocking-RPC**.

The 170-line file encodes:
- §SharedArrayBuffer-three-buffer-split (lenbuf + statusbuf
  + databuf — each TypedArray view typed to its purpose).
- §Atomics.wait/notify usage pattern.
- §Async-generator chunking protocol.
- §Iterator-protocol-as-bidirectional-channel.
- §JSON-encoding-then-UTF-8-bytes layering.
- §Two-status-bit-flags (DONE / REJECT) plus initial
  WAITING.

## Structural moves captured

- **§Why-Int32Array-for-status**: §standard-API-constraint-
  acknowledged-in-comment (cites MDN docs for
  Atomics.notify).
- **§Three-status-bit-flags as §bit-flags-not-enum-when-
  states-are-orthogonal**.
- **§Async-generator-as-trapHost** (§yield-as-resume-
  point; §JS-language-feature-as-control-flow-primitive).
- **§Iterator-protocol-as-bidirectional-channel** (host
  via notify; guest via it.next/return/throw).
- **§Special-case-done-on-first-try**: §allocation-
  elision-for-common-case via subarray.
- **§Cleanup-via-iterator-protocol** with §TODO-named
  honest-limitation about error types and noisy captp
  logging.
- **§Pathological-MIN_DATA_BUFFER_LENGTH=1**: §test-the-
  boundary discipline; the unit test exercises it.
- **§Three-buffer-write-order discipline**: data, length,
  status, notify. §Status-write-plus-notify-is-commit-
  point.

## §Synchronous-RPC-as-meta-capability

§Rare-and-valuable-primitive in JS ecosystem (most cross-
worker communication is async via postMessage). §Atomics-
based-blocking is the §only-way to get truly synchronous
cross-thread calls.

§This-enables-Trap-in-cycle-154 + §XS-debugger-style-
stepping in cycle 159.

## §Gap-revealing-comparison with garden cycles

| Cycle | Connection |
|-------|------------|
| 154 (trap.js) | §Pair-file — abstract interface; this is concrete transport |
| 158 (loopback.js) | §Local-CapTP-instance shape (two CapTP wired cross); this is SharedArrayBuffer variant |
| 156 (finalize.js) | §WeakValueMap-GC pattern; this transport carries values that finalize tracks |
| 167 (where/index.js) | §Small-file-but-load-bearing-knowledge sibling |
| 159 (daemon-debug-worker-restart) | §Synchronous-cross-worker-step needs this mechanism |

## §Tier-1 vocabulary borrowing candidates

§Three-buffer-split-in-one-SharedArrayBuffer, §Atomics-
wait-notify-for-blocking-RPC, §Async-generator-as-
resumable-state-machine, §Bit-flags-not-enum-when-states-
are-orthogonal, §Allocation-elision-for-common-case,
§Cleanup-via-iterator-protocol, §Pathological-test-case-
anchors-the-design.

## §Synthesis-target

Future synchronous-RPC needs (e.g., slot machine's
blocking-mode operations) can §reuse-this-substrate
rather than reinventing.

## Files written / edited

- `library/sections/endo--packages-captp-src-atomics-js--
  SharedArrayBuffer-three-buffer-split-with-Atomics-wait-
  notify-and-chunked-transfer-via-async-generator.md`
  (380 lines; commit `4fe82f48`)
- `library/sources/endo--packages-captp-src-atomics-js.md`
  (new source page)
- `library/sources/README.md` (cycle-169 row added in the
  @endo source-fragment section above where/index.js)
- `library/sections/README.md` (cycle-169 entry; totals
  bumped 673/214 → 674/215)
- `library/topics/captp.md` (cycle-169 row)
- `library/topics/patterns.md` (cycle-169 row)
- `library/topics/tooling.md` (cycle-169 row)
- `library/keywords.md` (56 new keyword rows)
- `inboxes/endolin/scholar.md` (timestamp + commit hash
  bumped manually)

## Library totals

673 / 214 → **674 sections from 215 source documents**.

## Lane rotation note

Cycle 169 was nominally **chat-lane** (after cycle 168's
designs-lane). Papers-lane blocked **63+ consecutive
cycles**.

Lane sequence over the last 13 cycles maintains §steady-
rotation-discipline:
- 157-160: designs/chat/designs/chat
- 161: designs + user-directed off-rotation
- 162-165: comments (ocap-kernel mini-series)
- 166: designs (break)
- 167: chat
- 168: designs
- 169: chat

§The-designs/chat-alternation since cycle 166 has been
maintained for four cycles.

## Cycle 169 — done. Schedule cycle 170.
