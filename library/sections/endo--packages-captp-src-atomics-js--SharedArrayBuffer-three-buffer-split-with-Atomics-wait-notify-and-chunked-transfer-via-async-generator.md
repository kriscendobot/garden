---
source: packages/captp/src/atomics.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/captp/src/atomics.js
source_path: packages/captp/src/atomics.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - captp
  - patterns
  - tooling
genre: §endo-source-comment-fragment
cycle: 169
lane: chat
status: current
---

# SharedArrayBuffer three-buffer split with Atomics wait/notify and chunked transfer via async generator

> §Chat-lane after cycle 168's designs-lane. §Endo-source-
> comment-fragment genre. §Pair-with-cycle-154's-trap.js
> — that file defines `TrapHost` / `TrapGuest` as the
> abstract interface; this file is the SharedArrayBuffer
> implementation.

`packages/captp/src/atomics.js` (170 lines) is the
**§SharedArrayBuffer-as-synchronous-RPC-transport** for
@endo/captp's Trap mechanism. The single most structurally
interesting move is the §three-buffer-split-in-one-
SharedArrayBuffer paired with §Atomics-wait-notify-for-
blocking-RPC. The §load-bearing-premise: SharedArrayBuffer +
Atomics = blocking RPC across worker boundaries.

## §Why-this-file-exists

§Trap-needs-synchronous-cross-worker-RPC. Cycle 154's
trap.js lifted the synchronous-trap mechanism from E.js;
this file provides the concrete *transport* that makes it
work across web worker (or worker_thread / xs worker)
boundaries.

§SharedArrayBuffer-is-the-only-way: postMessage is async
(returns to event loop); only SharedArrayBuffer + Atomics
gives §truly-blocking-synchronous-communication. §No-polling-
required (Atomics.wait blocks the thread until notify).

§The-file-is-small-because-the-mechanism-is-tight: one
SharedArrayBuffer, one async generator, one wait/notify
pair. §The-LOC-doesn't-reflect-the-load-bearing-knowledge
(sibling observation to cycle 167's where/index.js).

## §Three-buffer-split-in-one-SharedArrayBuffer

```js
const splitTransferBuffer = transferBuffer => {
  const lenbuf = new BigUint64Array(transferBuffer, 0, 1);
  const statusbuf = new Int32Array(transferBuffer, lenbuf.byteLength, 1);
  const databuf = new Uint8Array(transferBuffer, overheadLength);
  return harden({ statusbuf, lenbuf, databuf });
};
```

§Single-allocation-three-views over one SharedArrayBuffer:

| View | Type | Size | Purpose |
|------|------|------|---------|
| `lenbuf` | `BigUint64Array` | 8 bytes | Remaining-data length (64-bit; can address up to 2^64 bytes) |
| `statusbuf` | `Int32Array` | 4 bytes | Status flags (Atomics-compatible) |
| `databuf` | `Uint8Array` | rest | Payload chunk |

§Why-Int32Array-for-status — cited from MDN in the comment:

> *The documentation says that this needs to be an Int32Array
> for use with Atomics.notify:
> https://developer.mozilla.org/en-US/docs/Web/JavaScript/
> Reference/Global_Objects/Atomics/notify#syntax*

§Standard-API-constraint-acknowledged-in-comment.
§Atomics.notify-requires-Int32Array (the §32-bit-atomic-
integer is the canonical wake-target). §BigUint64Array-can't-
be-used-here even though it would express the value more
naturally.

§Why-BigUint64Array-for-length: §message-can-exceed-32-bits
in size. §Future-proofing-via-bigint avoids the §4GiB-cap.
§Encoded-as-bigint at write site, §converted-to-Number on
read.

§TRANSFER_OVERHEAD_LENGTH = 12 bytes (8 + 4). §Const-derived-
from-other-consts (`BigUint64Array.BYTES_PER_ELEMENT +
Int32Array.BYTES_PER_ELEMENT`) — §self-documenting-arithmetic.

## §Three-status-bit-flags

```js
const STATUS_WAITING = 1;       // guest waiting for host
const STATUS_FLAG_DONE = 2;     // last chunk in this transfer
const STATUS_FLAG_REJECT = 4;   // the trapped value is a rejection
```

§Bit-flags-not-enum: §three-flags-compose. The status byte
can simultaneously say *this is the last chunk AND it's a
rejection*: `STATUS_FLAG_DONE | STATUS_FLAG_REJECT`.

§Why-not-an-enum: an enum can't express *multiple states
at once*. §Bitfield-when-states-are-orthogonal discipline.

§STATUS_WAITING-as-the-initial-guest-state: the guest sets
this *before* calling it.next() and Atomics.wait. The host
overwrites it when ready.

## §Async-generator-as-trapHost

```js
return harden(async function* trapHost([isReject, serialized]) {
  ...
  while (!done) {
    ... fill databuf with next slice ...
    statusbuf[0] = rejectFlag | doneFlag;
    Atomics.notify(statusbuf, 0, +Infinity);
    if (!done) {
      yield;  // suspend until next it.next()
    }
  }
});
```

§Async-generator-as-resumable-state-machine. §yield-as-
resume-point — yield blocks until guest calls it.next()
again. §Host-state-is-implicit-in-generator-position.

§Why-async-generator-not-callback-loop: async generators
let the host §pause-mid-transfer naturally, without
explicit state machine. §JS-language-feature-as-control-
flow-primitive.

§Comment-from-code:

> *Wait until the next call to `it.next()`. If the guest
> calls `it.return()` or `it.throw()`, then this yield will
> return or throw, terminating the generator function
> early.*

§Iterator-protocol-as-bidirectional-channel: host sends
chunks via Atomics.notify; guest controls iteration via
it.next() / it.return() / it.throw(). §Two-channels-
multiplexed-on-the-iterator-protocol.

§Atomics.notify(statusbuf, 0, +Infinity): wake §all-
waiters. The +Infinity argument means *unbounded-number-of-
threads-to-wake*; in practice it's one guest. §Defensive-
unbounded-wake.

## §Chunked-transfer-by-buffer-size

```js
const subenc = encoded.subarray(i, i + databuf.length);
databuf.set(subenc);
const remaining = BigInt(encoded.length - i);
lenbuf[0] = remaining;
i += subenc.length;
done = i >= encoded.length;
```

§Arbitrarily-large-JSON-message-split-into-databuf-sized-
chunks. §Send-remaining-byte-count-in-lenbuf — guest knows
how many bytes are still to come.

§Bigint-conversion-at-write: `BigInt(encoded.length - i)`.
§Number-conversion-at-read: `Number(lenbuf[0])` (in guest).
§Asymmetric-types-because-typed-arrays-are-typed.

§Decode-then-chunk: the encoded array is `te.encode(json)`
*once*; the chunks are §subarrays-not-new-allocations.
§Allocate-once-zero-copy-chunk.

## §Special-case-done-on-first-try

```js
if (!encoded) {
  if (done) {
    // Special case: we are done on first try, so we don't
    // need to copy anything.
    encoded = databuf.subarray(0, datalen);
    break;
  }
  // Allocate our buffer for the remaining data.
  encoded = new Uint8Array(remaining);
}
```

§Allocation-elision-for-common-case. When the encoded JSON
fits entirely in databuf on the first try, the guest *uses
databuf as the encoded buffer* via subarray (zero copy).
§The-common-case-is-fast; §the-multi-chunk-case-allocates-
once.

§Subarray-aliases-not-copies: `databuf.subarray(0, datalen)`
shares memory with databuf. The guest §reads-it-immediately-
before-databuf-is-reused for the next transfer (which never
happens because we break).

§Optimization-by-shape-recognition: the common case
(message fits in one chunk) is detected and §special-cased
for §lower-allocation-pressure.

## §Guest-side-it.throw-to-terminate-host-generator

```js
// This throw is harmless if the host iterator has already
// finished, and if not finished, captp will correctly
// raise an error.
//
// TODO: It would be nice to use an error type, but captp
// is just too noisy with spurious "Temporary logging of
// sent error" messages.
// it.throw(makeError(X`Trap host has not finished`));
it.throw(null);
```

§Cleanup-via-iterator-protocol. §it.throw(null)-terminates-
host-generator. §Null-as-the-error-value because the
captp logging would spam with spurious messages otherwise.

§TODO-named: §would-be-nice-to-use-an-error-type-but-captp-
is-noisy. §Honest-limitation-with-named-future-improvement
(sibling to cycle 167's roaming-AppData TODO and cycle
166's POSIX-`*at`-family future-hardening note).

§The-throw-is-defensive: *harmless if the host iterator has
already finished, and if not finished, captp will correctly
raise an error*. §Always-safe-to-call.

## §Pathological-MIN_DATA_BUFFER_LENGTH=1

```js
// This is a pathological minimum, but exercised by the
// unit test.
export const MIN_DATA_BUFFER_LENGTH = 1;
```

§Test-the-boundary-not-just-the-happy-path. §Pathological-
minimum-still-works: a 1-byte data buffer means the
implementation must handle arbitrarily-many chunks. §The-
unit-test-exercises-this-edge to prove the chunking logic
is correct.

§Discipline-named: §pathological-test-case-anchors-the-
design. Cycle 152's memo-race.js had a similar shape (the
race conditions were explicitly tested). §Don't-just-test-
the-typical-input.

§Minimum-transfer-buffer = data + overhead = 1 + 12 = 13
bytes. §A-13-byte-SharedArrayBuffer-can-transfer-any-size-
message via enough chunking iterations.

## §Pairs-with-cycle-154's-trap.js

§Trap.js-defines-TrapHost-TrapGuest-as-abstract-interface.
§Atomics.js-is-the-SharedArrayBuffer-implementation. §Two-
paired-files-implementing-one-mechanism.

§Cycle-154-noted: trap.js was *lifted from E.js* and
represents the abstract synchronous-trap protocol. This
file is the §concrete-transport for that protocol.

§Abstract-then-concrete pattern: §types-and-interface-
first; §implementation-after. The trap.js file is much
shorter (the interface); atomics.js is longer (the
mechanism). §Inverted-from-typical (where interface is
verbose and implementation is short) because the protocol
is simple but the SharedArrayBuffer wire-format needs
careful bookkeeping.

## §Synchronous-RPC-as-meta-capability

§Why-this-matters: synchronous RPC across worker boundaries
is a §rare-and-valuable-primitive in the JavaScript
ecosystem. Most cross-worker communication is async
(postMessage). §Atomics-based-blocking is the §only-way to
get *truly synchronous* cross-thread calls.

§This-enables-XS-debugger-style-stepping (cycle 159's
daemon-debug-worker-restart): a debugger must be able to
synchronously pause a worker and read its state.

§This-enables-Trap-in-cycle-154: the *trap* mechanism
appears synchronous to the caller, even though the actual
work happens in a different thread.

§Synthesis-target: future synchronous-RPC needs (e.g., slot
machine's blocking-mode operations) can §reuse-this-
substrate rather than reinventing.

## §JSON-encoding-not-marshal-direct

```js
const json = JSON.stringify(serialized);
const encoded = te.encode(json);
```

§Encode-to-JSON-then-UTF-8-bytes. §Two-step-encoding: §JSON-
for-structure + §UTF-8-for-bytes.

§Why-not-marshal-direct: marshal produces structured output
with slot references; this transport carries §already-
serialized-by-captp data. §The-marshalling-happened-
upstream; this layer is §pure-bytes-transport.

§Cycle-67-69's-marshal handles the §pass-style-aware
serialization; cycle 65's @endo/captp wires marshal to the
network; this file is the §inner-transport-for-the-trap-
mode.

§Layering-discipline named.

## §Three-buffer-write-order discipline

The host code does, in order:

1. `databuf.set(subenc)` — fill data first.
2. `lenbuf[0] = remaining` — set length.
3. `statusbuf[0] = rejectFlag | doneFlag` — set status (the
   atomic write).
4. `Atomics.notify(statusbuf, 0, +Infinity)` — wake guest.

§Write-status-last-then-notify. The guest is blocked on
`Atomics.wait(statusbuf, 0, STATUS_WAITING)` — it wakes
when statusbuf is changed *and* notified. §Status-write-
plus-notify is the §commit-point of each chunk.

§If-status-was-set-before-data: the guest could wake up
(via spurious wake or its own polling) and read stale data.
§Order-matters-for-correctness.

§The-comment-doesn't-spell-this-out — the order is enforced
by §code-position-not-by-explicit-discipline. §Implicit-
invariant noted here.

## §Gap-revealing-comparison with garden cycles

| Cycle | Connection |
|-------|------------|
| 154 (trap.js) | §Pair-file — abstract interface; this is concrete transport |
| 158 (loopback.js) | §Local-CapTP-instance shape (two CapTP wired cross); this is the SharedArrayBuffer variant for cross-worker |
| 156 (finalize.js) | §WeakValueMap-GC pattern; this transport carries the values that finalize.js tracks |
| 167 (where/index.js) | §Small-file-but-load-bearing-knowledge sibling observation |
| 159 (daemon-debug-worker-restart) | §Synchronous-cross-worker-step needs §Atomics-based-blocking (this file's mechanism) |

## §Tier-1 vocabulary borrowing candidates

§Three-buffer-split-in-one-SharedArrayBuffer (lenbuf +
statusbuf + databuf), §Atomics-wait-notify-for-blocking-RPC,
§Async-generator-as-resumable-state-machine, §Bit-flags-
not-enum-when-states-are-orthogonal, §Allocation-elision-
for-common-case, §Cleanup-via-iterator-protocol,
§Pathological-test-case-anchors-the-design.

§Tier-2: §Standard-API-constraint-acknowledged-in-comment
(MDN citation), §Honest-limitation-with-named-future-
improvement (TODO comment), §Layering-discipline (JSON +
UTF-8 + Atomics-chunked-transfer).

## §Small-file-but-load-bearing-knowledge

170 lines. Encodes:
- §SharedArrayBuffer-three-buffer-split shape.
- §Atomics.wait-notify usage pattern.
- §Async-generator chunking protocol.
- §Iterator-protocol-as-bidirectional-channel.
- §JSON-encoding-then-UTF-8-bytes layering.
- §Two-status-bit-flags (DONE / REJECT) plus initial WAITING.

§Reading-this-file-tells-you-how-Trap-works across worker
boundaries. §Sibling-observation to cycle 167's where/
index.js and cycle 165's platform-specific.md: small docs
can encode large knowledge.
