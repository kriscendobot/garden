---
source: packages/netstring/reader.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/netstring/reader.js
source_path: packages/netstring/reader.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Mathieu Hofman (prompted)
topics:
  - streams
  - patterns
  - captp
genre: §endo-source-comment-fragment
cycle: 177
lane: chat
status: current
---

# Two-state iterator with zero-copy fast-path and allocate-on-multi-chunk

> §Chat-lane after cycle 176's designs-lane. §Endo-source-
> comment-fragment genre. §The-canonical-netstring-decoder
> used by daemon socket framing (cycle 49 + cycle 176
> endor's client bridging), daemon-cas-management's
> envelope-bus (cycle 141), and OCapN-TCP-syrups-framing
> (cycle 174 dependency).

`packages/netstring/reader.js` (163 lines) decodes
**netstrings** — `<length>:<data>,` — from an async byte
stream. The single most structurally interesting move is
the §two-state-iterator (waiting-for-length-prefix /
waiting-for-data) with §zero-copy-fast-path and §allocate-
on-multi-chunk discipline.

## §The-netstring-format

§Netstring = §length-decimal-prefix + §colon + §data-bytes
+ §comma:

```
13:hello world!,
9:goodbye!!,
```

§Self-delimiting-binary-protocol. §No-escaping-needed:
length is known before data; comma is a sanity check.

§Cycle-167-where/index.js named netstring's role: §the-
daemon's-CLI-socket-speaks-netstring-framed-CapTP. §This-
file-is-the-decoder-of-that-framing.

§Cycle-141-daemon-cas-management uses netstring for
envelope-bus framing. §Cycle-176-daemon-endor-architecture
uses the same in `socket.rs` (Rust implementation of the
same protocol).

## §The-two-state-iterator (the spine)

```js
/** @type {number[] | null} */
let lengthBuffer = [];
/** @type {Uint8Array | null} */
let dataBuffer = null;
let remainingDataLength = -1;
```

§State-encoded-as-lengthBuffer-null-or-not:

| State | `lengthBuffer` | Meaning |
|-------|----------------|---------|
| Waiting for length | `number[]` (digits) | Accumulating length-prefix chars |
| Waiting for data | `null` | Have length; consuming data bytes |

§Boolean-state-as-null-vs-not-null. §Cycle-173's-promise-
executor-kit had a similar §undefined-vs-null-meaningful-
distinction; this is §null-vs-array-meaningful-distinction.

§Two-named-states-with-explicit-comment:

> *The iterator can be in 2 states: waiting for the
> length, or waiting for the data*

§Named-states-in-comments before they're implicit in
code. §The-comment-tells-you-the-machine.

## §Zero-copy-fast-path

```js
if (buffer.length > remainingDataLength) {
  const remainingData = buffer.subarray(0, remainingDataLength);
  const data = dataBuffer
    ? (dataBuffer.set(remainingData, ...), dataBuffer)
    : remainingData;
  ...
  yield data;
}
```

§If-data-fits-in-current-chunk-no-allocation. §subarray-is-
zero-copy. §The-fast-path-pays-zero-byte-copy.

§Slow-path-allocates: §dataBuffer-pre-allocated-to-
remainingDataLength.

§Why-this-matters: §netstring-framing-is-the-hot-path on
the daemon socket; §zero-copy-decoding-keeps-latency-low.

§Allocation-elision-for-common-case (§cycle-169-atomics.js
sibling: §special-case-done-on-first-try uses the same
discipline at a different layer).

## §Allocate-on-multi-chunk

```js
} else if (buffer.length) {
  if (!dataBuffer && buffer.length === remainingDataLength) {
    dataBuffer = buffer;
  } else {
    dataBuffer = dataBuffer || new Uint8Array(remainingDataLength);
    dataBuffer.set(buffer, dataBuffer.length - remainingDataLength);
  }
  remainingDataLength -= buffer.length;
  buffer = buffer.subarray(buffer.length);
}
```

§Three-sub-cases:

1. **§First-chunk-fills-exactly**: assign `buffer`
   directly to `dataBuffer` (zero-copy, but commits to
   waiting for more).
2. **§First-chunk-partial**: allocate `dataBuffer` of
   `remainingDataLength`, copy `buffer` to start.
3. **§Subsequent-chunks**: copy into existing `dataBuffer`
   at the right offset.

§Allocate-once-per-message-not-per-chunk. §The-allocation-
is-amortized-across-chunks.

§Tail-call-by-buffer.subarray: §progress-is-made-by-
shrinking-buffer. §Loop-exits-when-buffer-empty.

## §Char-by-char prefix parsing

```js
for await (const chunk of input) {
  let buffer = chunk;
  while (buffer.length) {
    if (lengthBuffer) {
      let i = 0;
      while (i < buffer.length) {
        const c = buffer[i];
        i += 1;
        if (c >= ZERO && c <= NINE) {
          lengthBuffer.push(c);
          ...
        } else if (c === COLON && lengthBuffer.length) {
          lengthBuffer.push(c);
          break;
        } else {
          throw Error(`Invalid netstring length prefix ...`);
        }
      }
      buffer = buffer.subarray(i);
      ...
    }
  }
}
```

§Three-character-cases: digit / COLON / anything-else.

§Digit-accumulates; §COLON-terminates; §anything-else-
throws. §Strict-validation at the character level.

§COLON-required-after-at-least-one-digit (`lengthBuffer.
length` check prevents empty-prefix). §Empty-length-prefix-
is-an-error.

§Constants-pre-computed: `COLON = ':'.charCodeAt(0)`,
`COMMA = ','.charCodeAt(0)`, `ZERO`/`NINE`. §Compile-time-
constants for §hot-path-byte-comparison.

## §Sanity caps (defense-in-depth)

```js
const maxPrefixLength = `${maxMessageLength | 0}:`.length;
```

§maxMessageLength-default-999999999 (~1 GiB).

§maxPrefixLength derived from maxMessageLength + 1 (for
the colon). §If-we've-accumulated-this-many-digits-the-
message-must-be-too-big-or-malformed.

§Two-level-cap: §reject-prefix-too-long-before-converting
+ §reject-length-too-large-after-converting.

§Defense-in-depth against §protocol-attacks: §a-malicious-
sender-sending-9999999999999999... never gets past the
prefix-length cap.

§Cycle-170's-daemon-capability-filesystem §threat-model-
with-citations has a sibling discipline: §defense-driven-
by-evidence. Here, §cap-the-attack-surface-before-the-
attack-arrives.

## §Comma-separator-validation

```js
if (buffer[remainingDataLength] !== COMMA) {
  throw Error(
    `Invalid netstring separator "${String.fromCharCode(
      buffer[remainingDataLength],
    )} at offset ${offset} of ${name}`,
  );
}
```

§COMMA-after-data-is-required-and-checked. §The-comma-is-
the-message-boundary-marker.

§If-COMMA-missing: §error-with-the-actual-byte-shown.
§Helpful-diagnostic.

§Why-the-comma: §netstring-spec-requires-it; §it's-the-
sanity-check that the length prefix was honest. §If-length-
was-wrong-the-comma-won't-be-at-the-expected-offset.

## §Dangling-message detection

```js
if (!lengthBuffer) {
  throw Error(`Unexpected dangling message at offset ${offset} of ${name}`);
}
```

§At-EOF-of-input-stream: §if-still-in-waiting-for-data-
state-throw.

§Half-a-message-is-an-error. §Sender-must-flush-complete-
messages.

§Cycle-149's-error-path-cannot-depend-on-error-path has a
sibling discipline: §the-error-message-is-helpful-when-
the-protocol-is-broken (offset + name).

## §Helpful error messages

Every throw includes:
- §What-was-expected-or-what-went-wrong.
- §The-actual-bytes-at-fault (`JSON.stringify`'d, or
  `String.fromCharCode`).
- §Offset-into-the-stream (§where-in-the-byte-stream).
- §Name (caller-supplied; §what-stream-this-was).

§Four-pieces-of-context per error. §Debuggable-rejection.

§Comparison-with-cycle-149-unhandled-rejection-display:
§error-rendering-discipline shared. §Both-care-about-
producing-actionable-diagnostics.

## §Async-generator-yields-as-it-decodes

```js
async function* makeNetstringIterator(input, opts) {
  for await (const chunk of input) {
    ...
    yield data;
    ...
  }
}
```

§Not-buffer-everything-then-yield. §Stream-in-stream-out.

§Each-complete-netstring-yields-to-consumer. §Backpressure-
via-async-iteration: §if-consumer-is-slow-the-generator-
pauses.

§Cycle-171-stream/index.js's §functional-async-queue + §back-
pressure-via-acks have a sibling discipline. Here, §back-
pressure-via-await-of-next.

§Async-generator-as-resumable-state-machine (cycle 169
atomics.js, cycle 173 promise-executor-kit) is the §JS-
language-feature-as-control-flow-primitive at work.

## §Legacy export carry-forward

```js
// Legacy
export const netstringReader = (input, name, _capacity) => {
  return harden(makeNetstringIterator(input, { name }));
};
```

§Old-API kept as alias. §Three-positional-args mapped to
new opts shape.

§_capacity-prefix-with-underscore: §ESLint convention for
§intentionally-unused-parameter. §Honest-comment about
API drift.

§Migration-discipline: §don't-break-existing-callers;
§new-API-via-makeNetstringReader.

§Cycle-176's-renames-from-kind-to-platform follows a
similar shape: §old-name-aliased; §new-name-canonical.

## §The-canonical-decoder for §netstring-protocol-family

§Netstring-is-the-substrate. Used by:

| Cycle | Use |
|-------|-----|
| 49 (daemon-locator-reference) | ENDO_SOCK_PATH speaks netstring-framed CapTP |
| 141 (daemon-cas-management) | Envelope-bus framing |
| 174 (gateway-package) | ocapn-tcp-syrups-framing dependency |
| 176 (daemon-endor-architecture) | `socket.rs` client bridging (Rust) |

§This-file-is-the-JS-implementation. §The-Rust-supervisor-
has-its-own-implementation but speaks the same wire.

§Same-protocol-different-substrate (cycle 176 sibling
observation about CBOR envelopes).

## §The-Mathieu-Hofman authorship

§Author Mathieu Hofman (prompted) — same author as cycle
100's unhandled-rejection.js. §Two-Hofman-authored-files
ingested.

§Hofman-style: §detailed-state-machine-with-honest-error-
messages. §Cycle-100's-FinalizationRegistry-based-
rejection-tracking has the same §careful-protocol-state-
management.

## §Gap-revealing-comparison with garden cycles

| Cycle | Connection |
|-------|------------|
| 100 (unhandled-rejection.js) | §Same-author Mathieu Hofman; §protocol-state-management discipline |
| 169 (atomics.js) | §Allocation-elision-for-common-case sibling |
| 171 (stream/index.js) | §Async-generator-as-resumable-state-machine sibling |
| 141 (daemon-cas-management) | §Envelope-bus-framing consumer of this decoder |
| 174 (gateway-package) | §ocapn-tcp-syrups-framing dependency |
| 176 (daemon-endor-architecture) | §Rust-port speaks the same protocol |

## §Tier-1 vocabulary borrowing candidates

§Two-state-iterator-state-machine (named states +
implicit-null-as-state-discriminator).

§Zero-copy-fast-path (subarray-instead-of-allocate when
data fits in one chunk).

§Allocate-on-multi-chunk (one allocation per message; not
per chunk).

§Sanity-caps-defense-in-depth (maxMessageLength +
maxPrefixLength).

§Four-pieces-of-context-per-error (what / actual-bytes /
offset / name).

§Dangling-message-detection at EOF.

§Tier-2: §pre-computed-byte-constants (COLON, COMMA,
ZERO, NINE), §legacy-export-as-alias (migration
discipline), §state-encoded-as-null-vs-not-null.

## §Synthesis-target

§Slot-machine-library may need a §self-delimiting-binary-
protocol-decoder; the §two-state-iterator + §zero-copy-
fast-path pattern is borrowable for any §length-prefixed-
data-framing.

§The-§netstring-protocol-itself is a §minimal-wire-
framing — the §discipline is in the implementation
shape, not the protocol.

## §Small-file-but-load-bearing-knowledge

163 lines, two exports (new + legacy). §The-substrate-
many-downstream-files-depend-on. §The-Rust-supervisor-
re-implements-this-byte-for-byte.

§Seventh-member-of-the-§small-files-with-large-knowledge-
density family:
- 165: ocap-kernel platform-specific.md (92)
- 167: @endo/where/index.js (115)
- 169: @endo/captp/atomics.js (170)
- 171: @endo/stream/index.js (247)
- 173: @endo/promise-kit/src/promise-executor-kit.js (55)
- 175: @endo/harden/make-selector.js (69)
- 177: @endo/netstring/reader.js (163)

§The-pattern-holds. §The-substrate-files-are-often-the-
shortest.
