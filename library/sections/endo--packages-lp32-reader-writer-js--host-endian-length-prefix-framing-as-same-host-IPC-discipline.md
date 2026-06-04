---
source: packages/lp32/{reader,writer}.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages/lp32
source_path: packages/lp32/reader.js, packages/lp32/writer.js, packages/lp32/src/host-endian.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - streams
  - captp
genre: §endo-source-comment-fragment
cycle: 179
lane: chat
status: current
---

# Host-endian length-prefix framing as same-host IPC discipline with single-buffer copyWithin shift

> §Chat-lane after cycle 178's designs-lane. §Endo-source-
> comment-fragment genre. §Direct-sibling to cycle 177's
> netstring/reader.js — same problem (length-prefixed message
> framing as async iterators), different encoding choices.

`packages/lp32/reader.js` (82 lines) + `packages/lp32/writer.js`
(49 lines) + `packages/lp32/src/host-endian.js` (9 lines)
implement the binary message framing protocol used by
**[WebExtension Native Messaging][native]**. Each message is
prefixed with a 32-bit unsigned integer length in **host byte
order**, followed by the payload of that length.

[native]: https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/Native_messaging

§The-single-most-structurally-interesting-move is §host-byte-
order-as-deliberate-IPC-marker: the protocol target is
**same-host** (browser extension ↔ native helper via stdio
pipes), so endianness is moot, and using host byte order
avoids per-message byte-swapping on every modern (little-
endian) platform. §Compare-to-network-protocols, which must
choose an endianness (almost always big-endian / network
byte order); §compare-to-netstring (cycle 177), which uses
ASCII-decimal length and is endian-free by construction.

## §Sibling-comparison-with-netstring (cycle 177)

| Property                  | netstring (cycle 177)             | lp32 (cycle 179)                |
|---------------------------|-----------------------------------|---------------------------------|
| Length encoding           | ASCII decimal + colon             | uint32 binary                   |
| Length size               | Variable (1–N digits + `:` + `,`) | Fixed 4 bytes                   |
| Endianness                | Irrelevant (ASCII text)           | Host byte order                 |
| Self-describing on wire   | Yes (visible in hex dump)         | No (need parser)                |
| Sanity terminator         | Trailing `,`                      | None                            |
| Use case                  | CapTP-over-anything; daemon socket| WebExtension native messaging   |
| State machine             | Explicit two-state iterator       | Implicit (length always at +0)  |
| Allocation strategy       | Two buffers; subarray fast-path   | Single growing buffer; slice    |
| Default `maxMessageLength`| 1 MiB                             | 1 MiB                           |

§Same-shape-different-encoding. §Both-are-makeReader+makeWriter
pairs. §Both-target-Reader<Uint8Array,void>-from-@endo/stream
(cycle 171). §Both-are-hardened. §Difference-is-the-wire-format-
and-the-runtime-properties-that-flow-from-it.

## §The-lp32-format

```
[ length: uint32 host-byte-order ][ payload: length bytes ]
```

§Example a 5-byte message `hello` on a little-endian host:

```
[0x05, 0x00, 0x00, 0x00][h, e, l, l, o]
```

§No-framing-overhead-beyond-4-bytes. §No-sanity-terminator.
§No-self-description.

## §The-implicit-state-machine (no two-state iterator)

§Compare-to-cycle-177-netstring's explicit two-state iterator
(waiting-for-length / waiting-for-data, with `lengthBuffer
=== null` as the state discriminator). §lp32-needs-no-such-
state: the length is **always** at offset 0 of the buffer.

```js
let capacity = Math.max(4, initialCapacity);
let length = 0;
let array8 = new Uint8Array(capacity);
let data = new DataView(array8.buffer);
let offset = 0;
```

§Single-growing-buffer-with-DataView-view. §`length` is the
**fill level** (how many bytes are currently in the buffer);
§`offset` is the **cumulative byte position** in the input
stream (used only in the dangling-message error message).

§The-decode-loop is one pass:

```js
let drained = false;
while (!drained && length >= 4) {
  const messageLength = data.getUint32(0, hostIsLittleEndian);
  messageLength <= maxMessageLength || Fail`...`;
  const envelopeLength = 4 + messageLength;
  drained = envelopeLength > length;
  if (!drained) {
    // Must allocate to support concurrent reads.
    yield array8.slice(4, envelopeLength);
    // Shift
    array8.copyWithin(0, envelopeLength);
    length -= envelopeLength;
    offset += envelopeLength;
  }
}
```

§Drain-as-many-complete-messages-as-possible. §Each iteration:
read length at +0 → check bound → if we have envelope → yield
payload → shift buffer left → loop. §When we can't fit a full
envelope (`envelopeLength > length`), set `drained = true` and
fall back to reading more chunks.

§State-is-positional-not-flag-based. §No-`null`-vs-array
discriminator like netstring. §The-position-of-the-cursor
encodes everything: §if-length<4-we-need-more-bytes-for-the-
length-prefix-itself; §if-length>=4-but-envelopeLength>length-
we-need-more-bytes-for-the-payload.

## §Host-byte-order-as-deliberate-choice (the file-header comment)

```js
// @ts-check
// DataView does not default to host byte order like TypedArrays, so we must
// pass an explicit endianness argument.
```

§This-comment-justifies-the-existence-of-host-endian-js.
§Without-DataView-quirk-the-file-could-have-just-used-
Uint32Array-typed-views which are implicitly host-endian.
§But-DataView-defaults-to-big-endian (network byte order)
unless you pass the `littleEndian` boolean explicitly. §So-
the-code-needs-to-detect-host-endianness-at-load-time-and-
pass-it-to-every-getUint32/setUint32-call.

§Cycle-152-pass-style/symbol.js had a similar §runtime-probe
pattern (`Symbol.for('@@asyncIterator')` to detect SES
environment); §cycle-179-host-endian.js is the §runtime-
endianness-probe.

§The-probe (`packages/lp32/src/host-endian.js`, 9 lines):

```js
const isHostLittleEndian = () => {
  const array8 = new Uint8Array([1, 0]);
  const array16 = new Uint16Array(array8.buffer);
  return array16[0] === 1;
};

export const hostIsLittleEndian = isHostLittleEndian();
```

§Module-load-time-probe. §Write-1-then-0-as-bytes; §read-as-
uint16; §if-uint16-equals-1-then-low-byte-came-first → little-
endian. §Stored-as-a-constant-bound-at-module-init-not-
recomputed-per-message.

§Why-not-just-pick-an-endianness? §Because-the-protocol-is-
WebExtension-native-messaging, where both sides run on the
same physical machine, and Chrome/Firefox use **host** byte
order for the length prefix (so the native helper can use
the host's natural uint32 ops). §Endo's-implementation-must-
match-the-host-OS-the-browser-is-running-on.

## §WebExtension-native-messaging-as-design-target

§The-README-cites-Mozilla's-native-messaging-docs. §This-is-
not-an-abstract-framing-protocol — it's a specific wire
protocol mandated by Chrome and Firefox for stdio-based
communication between a browser extension and a native helper
binary. §Endo-implements-it-so-that-an-Endo-runtime-can-be-the-
native-helper.

§Cycle-127-getGuardPayloads named "spec-driven implementation
discipline"; §lp32-is-a-similar-shape: the protocol is defined
externally (browser vendors), and the @endo package must match
it byte-for-byte. §Endianness-host-byte-order-is-not-a-design-
choice-Endo-made; it's a constraint inherited from the spec.

§Cycle-176-daemon-endor-architecture mentions WebExtension as
one of the daemon's potential hosts ("the daemon could run as
a native messaging helper"); §cycle-179-lp32-is-the-framing-
layer-that-makes-that-deployment-possible.

## §Single-growing-buffer-with-copyWithin-shift

§The-buffer-grows-but-never-shrinks. §Compare-to-cycle-177-
netstring which uses two buffers (`lengthBuffer` array of
digits + `dataBuffer` Uint8Array).

```js
if (length + chunk.byteLength >= capacity) {
  while (length + chunk.byteLength >= capacity) {
    capacity *= 2;
  }
  const replacement = new Uint8Array(capacity);
  replacement.set(array8, 0);
  array8 = replacement;
  data = new DataView(array8.buffer);
}
array8.set(chunk, length);
length += chunk.byteLength;
```

§Doubling-growth-strategy. §Amortized-O(1)-append. §The-
DataView-must-be-replaced-when-the-underlying-buffer-changes
(DataViews are bound to ArrayBuffers, not to Uint8Arrays).

§After-yielding-a-message: §shift-the-remainder-to-the-front:

```js
array8.copyWithin(0, envelopeLength);
length -= envelopeLength;
```

§`copyWithin(0, envelopeLength)` shifts bytes from
`[envelopeLength, length)` to `[0, length - envelopeLength)`
**in place**. §No-second-allocation. §The-tail-of-the-buffer-
(beyond-the-new-length) is left dirty but unreachable through
`length`.

§Compare-to-cycle-177-netstring: netstring's dataBuffer is
allocated fresh per message and disposed after yield. §lp32-
keeps-one-buffer-for-the-lifetime-of-the-stream and reuses
it. §Tradeoff: §lp32-uses-less-allocation-pressure-but-cannot-
shrink-after-a-large-message; §netstring-can-have-arbitrarily-
small-resident-memory-but-allocates-per-message.

## §"Must allocate to support concurrent reads" — the slice comment

```js
// Must allocate to support concurrent reads.
yield array8.slice(4, envelopeLength);
```

§This-comment-is-the-key-correctness-property. §`slice` (not
`subarray`) copies the bytes; the yielded `Uint8Array` is
independent of `array8`.

§Why-must-it-be-independent? §Because-the-caller-of-the-async-
iterator may hold the yielded message **while another message
is being decoded into `array8`**. §If-we-yielded-a-subarray
view, the next `copyWithin` would corrupt the caller's data.

§Compare-to-cycle-177-netstring which has §zero-copy-fast-path
when a message fits in a single chunk — netstring can yield a
subarray of the *chunk* (which is owned by the upstream
reader's chunk lifecycle, separate from the framing decoder's
buffer). §lp32-cannot-take-that-shortcut because it always
copies chunks into its own buffer first.

§The-tradeoff-is-explicit: §netstring-optimizes-for-the-common-
case (single-chunk message, no copy); §lp32-pays-the-copy-cost
unconditionally for simpler buffer management.

§Cycle-130-message-breakpoints had a similar §correctness-
property-encoded-as-a-comment (the breakpoint must run
between turns, not within); §cycle-179-lp32-encodes the
concurrent-reads invariant the same way.

## §maxMessageLength-1MB-default (matches WebExtension max)

```js
maxMessageLength = 1024 * 1024, // 1MB
```

§Both-reader-and-writer-default to 1 MiB. §This-is-the-
Chrome/Firefox-native-messaging-limit. §Chrome's-limit-is-1MB-
sent-from-extension-to-host-and-1MB-the-other-way; Firefox's
match. §Endo's-defaults-honor-the-spec.

§Configurable-per-instance: callers can raise the limit for
non-WebExtension uses of the protocol (intra-Endo daemon IPC
on stdio, for example).

§Reader-enforces-the-limit-before-allocating-the-envelope:

```js
messageLength <= maxMessageLength ||
  Fail`Messages on ${q(name)} must not exceed ${q(
    maxMessageLength,
  )} bytes in length`;
```

§DOS-protection. §A-malformed-or-malicious-sender-cannot-
trigger-a-multi-GB-allocation by claiming a giant length. §The-
check-runs-before-the-`envelopeLength`-computation, so a
length of 0xFFFFFFFF is rejected on its own merits without
overflowing into envelopeLength arithmetic.

§Writer-enforces-the-same-limit:

```js
message.byteLength <= maxMessageLength ||
  Fail`Messages on ${q(name)} must not exceed ${maxMessageLength} bytes in length`;
```

§Symmetric-enforcement. §A-misbehaving-Endo-caller-cannot-
send-a-message-the-decoder-would-reject. §Cycle-127-
getGuardPayloads named the §spec-driven-discipline; lp32 has
§spec-driven-symmetric-validation.

## §Writer-allocates-fresh-array8-per-message

```js
async next(message) {
  message.byteLength <= maxMessageLength || Fail`...`;
  const array8 = new Uint8Array(4 + message.byteLength);
  const data = new DataView(array8.buffer);
  data.setUint32(0, message.byteLength, hostIsLittleEndian);
  array8.set(message, 4);
  return output.next(array8);
},
```

§Per-message-allocation-on-the-write-side. §Each-call-to-`next`
allocates a fresh `Uint8Array(4 + N)`, writes the length
prefix, copies the payload, and hands it to the downstream
writer.

§Why-not-write-the-length-and-payload-as-two-separate-`next`-
calls? §Because-async-iterators-don't-guarantee-atomicity
between successive `next` calls. §If-two-concurrent-callers
each called `writer.next(message)`, their length prefixes and
payloads could interleave. §Single-`next`-call-with-prefixed-
payload-is-atomic by the underlying writer's contract.

§Cycle-171-stream/index.js documented §symmetric-stream-
interface; §lp32-writer-respects-the-Writer<Uint8Array>-
contract: one `next` call equals one downstream byte buffer.

## §Hardened-throughout

```js
const writer = harden({
  /** @param {Uint8Array} message */
  async next(message) { ... },
  async return() { ... },
  async throw(error) { ... },
  [Symbol.asyncIterator]() { return writer; },
});
return writer;
};
harden(makeLp32Writer);
```

§Writer-object-hardened-after-construction. §`makeLp32Writer`-
factory-also-hardened. §`makeLp32Reader`-similarly:

```js
export const makeLp32Reader = (reader, options) => {
  return harden(makeLp32Iterator(reader, options));
};
harden(makeLp32Reader);
```

§Cycle-175-make-selector.js named §race-to-install-harden;
§lp32-is-a-consumer-of-that-discipline. §Both-the-factory-and-
the-resulting-iterator-are-hardened-so-callers-cannot-tamper-
with-the-message-handling-machinery-mid-stream.

§The-iterator-itself-is-hardened-via-`harden(makeLp32Iterator(reader, options))` —
the returned async generator object is frozen. §Generators-
have-mutable-state-by-construction (their internal pause/
resume bookkeeping); §harden-cannot-stop-the-generator-from-
advancing, but it can stop callers from monkey-patching the
generator's methods.

## §Symmetric-asyncIterator-self-return

```js
[Symbol.asyncIterator]() {
  return writer;
},
```

§The-writer-is-its-own-asyncIterator. §`for await (const x of writer)`-
would-call-next-without-arguments which would fail; but a
write-side iterator isn't meant to be iterated. §This-
declaration-is-here-so-that-the-writer-can-be-passed-anywhere-
that-expects-an-AsyncIterable<T,R,N>-with-N=Uint8Array.

§Cycle-171-stream/index.js documented the asymmetry: readers
yield (no `next(arg)`); writers consume (`next(arg)` is the
useful direction). §The-`[Symbol.asyncIterator]`-self-return
is the §type-compatibility-handshake — it makes a `Writer` an
`AsyncIterableIterator` even though one direction of the
duality is unused.

## §Two-files-with-shared-semantics-via-host-endian-js

§The-host-endian-probe-runs-once-at-module-load. §Both-reader
and writer import the constant. §If-they-imported-different-
copies-or-if-the-probe-were-non-deterministic, the encoded
and decoded length prefixes could disagree — a write of length
5 could be read back as length 0x05000000 (= 83 886 080).

§This-is-the-classic-endianness-mismatch-bug. §lp32-avoids-it-
by-using-a-single-shared-host-endian-constant: on any given
host, reader and writer always agree because both consult the
same probe.

§Cross-host-deployment: §a-little-endian-x86-laptop-cannot-
exchange-lp32-messages-with-a-big-endian-mainframe-over-the-
network. §But-lp32-is-not-a-network-protocol — it's stdio
within one OS process tree, where both sides run on the same
CPU. §The-constraint-and-the-design-match.

## §When-to-use-netstring-vs-lp32

§Cycle-167-where/index.js established that the daemon's CLI
socket speaks **netstring-framed CapTP**. §Cycle-141-daemon-
cas-management uses netstring for the envelope bus. §So-why-
not-just-use-netstring-everywhere?

§The-WebExtension-protocol-mandates-lp32-host-endian. §If-the-
daemon-deploys-as-a-WebExtension-native-helper, the framing
must be lp32. §Netstring-is-Endo's-internal-choice; §lp32-is-
the-external-protocol's-choice.

§Cycle-174-gateway-package mentioned multiple wire framings as
a forward-compatibility hedge; §lp32-and-netstring-are-the-two-
already-in-tree.

## §The-dangling-message-error

```js
if (length > 0) {
  throw Error(
    `Unexpected dangling message of length ${length} at offset ${offset} of ${name}`,
  );
}
```

§After-the-input-stream-ends, if there are bytes left in the
buffer, throw. §This-catches-truncated-streams: the sender
sent a 4-byte length prefix promising N more bytes, but the
stream ended with fewer than N delivered.

§Compare-to-cycle-177-netstring which has a different end-of-
stream behavior (returns gracefully when in waiting-for-length
state with no bytes buffered). §lp32's-rule-is-stricter: any
residual bytes are an error.

§The-error-message-includes-`offset`: the cumulative bytes
successfully consumed before the dangling bytes appeared.
§This-is-the-only-use-of-`offset`-in-the-decoder — it exists
solely to make the error message diagnostic-useful.

## §Cohesion notes

- §Sibling-encoding-pair with cycle 177 (netstring/reader.js).
  Same problem (length-prefixed framing), different decisions
  on every axis: encoding (ASCII vs binary), endianness
  (irrelevant vs host), state (explicit vs implicit), buffer
  (two vs one), zero-copy (yes vs no).
- §The-WebExtension-Native-Messaging spec is the §external
  constraint that forces every design decision. §Compare-to-
  cycle-127-getGuardPayloads' §spec-driven-implementation-
  discipline.
- §Cycle-179-lp32 + cycle-177-netstring + cycle-171-stream/
  index.js = §three-layer-stream-stack: §generic-Reader/
  Writer-types → §two-concrete-framing-codecs.
- §Host-endian-probe is a §runtime-environment-detection
  pattern; cycle 152 pass-style/symbol.js had a similar
  §runtime-Symbol-probe.
- §"Must allocate to support concurrent reads" is the §key-
  correctness-comment, like cycle 130 message-breakpoints'
  §between-turns-not-within comment.
- §1MB-default-matches-WebExtension-limit — §spec-conformance
  even in the defaults.
- §All-factories-and-resulting-iterators-hardened — §consumer-
  of-cycle-175's-harden-discipline.

## §Provenance

- §Source: `packages/lp32/reader.js` (82 lines), `packages/
  lp32/writer.js` (49 lines), `packages/lp32/src/host-endian.
  js` (9 lines).
- §README at `packages/lp32/README.md` (137 lines) ingested
  in this cycle as a complement.
- §First-commit-of-these-files in the public history is
  blame-able via the package's CHANGELOG; the host-endian
  comment ("DataView does not default to host byte order")
  has been stable for the life of the package.
