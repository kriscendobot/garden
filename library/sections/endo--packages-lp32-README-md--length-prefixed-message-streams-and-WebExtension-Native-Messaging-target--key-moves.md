---
title: Key moves
section-slug: endo--packages-lp32-README-md--length-prefixed-message-streams-and-WebExtension-Native-Messaging-target
source-slug: endo--packages-lp32-README-md
url: https://github.com/endojs/endo/blob/master/packages/lp32/README.md
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/lp32/README.md
total-lines: 136
ingest-cycle: 315
ingest-date: 2026-06-11
lane: designs
scope: full
parent: endo--packages-lp32-README-md--length-prefixed-message-streams-and-WebExtension-Native-Messaging-target
---

- **§the-named-WebExtension-Native-Messaging-IS-named-target-protocol** (first-explicit-observation):

> This package implements the binary message framing protocol used by [WebExtension Native Messaging][native-messaging].

**§the-named-cite-the-named-external-protocol-target**: the README names the specific external protocol the package implements (WebExtension Native Messaging, a Mozilla MDN spec). **§the-named-implementing-an-external-protocol-IS-named-explicit**. **§the-named-package-IS-named-protocol-implementation**.

§the-named-named-protocol-link-via-reference-Markdown: `[WebExtension Native Messaging][native-messaging]` + reference at bottom. **§three-cycles-with-named-reference-style-Markdown-links** (310 + 311 + 315).

- **§the-named-32-bit-host-byte-order-discipline** (first-explicit-observation):

> Each message IS prefixed with a 32-bit unsigned integer indicating the message length in bytes, using host byte order.

**§the-named-host-byte-order-IS-named-deliberate**: distinct from network byte order (big-endian). Host byte order IS named because the protocol IS for same-host process communication, not cross-network. **§the-named-protocol-target-determines-byte-order-discipline**.

§the-named-32-bit-IS-named-uint32-not-int32: "32-bit unsigned integer" — explicit named-unsigned. **§the-named-unsigned-IS-named-message-length-IS-non-negative**.

§the-named-three-bullet-protocol-description (the protocol IS named in 2 + 1 bullets):
1. A 4-byte length prefix (uint32, host byte order)
2. Followed by the message payload of that length

**§the-named-simple-protocol-IS-named-named-explicitly-simple**: "The protocol IS simple:" — the README names the simplicity claim. **§the-named-explicit-simplicity-claim**.

- **§the-named-worked-byte-sequence-example** (first-explicit-observation):

```
[0x05, 0x00, 0x00, 0x00] [h, e, l, l, o]
```

**§the-named-byte-level-example-IS-named-evidentiary**: a concrete 5-byte "hello" message IS shown as the exact 9-byte transmitted sequence. **§the-named-show-the-bytes-discipline**.

§the-named-host-byte-order-IS-explicit-in-the-example: the bytes `[0x05, 0x00, 0x00, 0x00]` IS little-endian (5 = 0x00000005; little-endian = least-significant byte first = `[0x05, 0x00, 0x00, 0x00]`). The example IS host-byte-order on x86-64 + ARM (the common host architectures). **§the-named-little-endian-IS-named-implicit-in-host-byte-order**.

§the-named-hello-IS-the-named-canonical-test-message: cycle 314's hex encode used `bytes` as a generic; cycle 315's lp32 uses "hello" — the named-classic-test-string. **§the-named-canonical-test-string**.

- **§the-named-makeLp32Reader-and-makeLp32Writer-named-pair** (first-explicit-observation):

```javascript
import { makeLp32Reader } from '@endo/lp32';
// ...
import { makeLp32Writer } from '@endo/lp32';
```

**§the-named-reader-writer-pair-shape**: a symmetric reader/writer pair (read messages from a stream + write messages to a stream). **§the-named-reader-and-writer-IS-named-symmetric-pair**. **§the-named-make-prefix-IS-named-factory-shape**: both names start with `make` indicating factories that return the actual iterator.

§the-named-async-iterator-discipline: "hardened async iterator streams for reading and writing these length-prefixed messages, represented as `Uint8Array`s." **§the-named-async-iterator-IS-named-stream-shape**. **§the-named-Uint8Array-IS-named-byte-representation**.

§the-named-for-await-of-loop-IS-named-canonical-consume: `for await (const message of reader) { ... }`. **§the-named-async-iterator-consumption-via-for-await-of**.

- **§the-named-named-error-context-via-name-option** (first-explicit-observation):

```javascript
const reader = makeLp32Reader(byteStream, {
  name: '<my-stream>',        // optional, for error messages
  maxMessageLength: 1024 * 1024, // optional, defaults to 1MB
});
```

**§the-named-name-option-IS-named-for-error-messages**: the optional `name` option labels the stream in error messages. **§the-named-named-context-for-error-attribution**. **§the-named-name-for-debuggability-discipline**.

§the-named-three-named-options:
- `name` (optional; error message context)
- `maxMessageLength` (default 1MB)
- `initialCapacity` (default 1024)

**§three-named-Reader-options**. **§the-named-explicit-default-IS-named-named-in-the-doc**.

§the-named-1MB-default-bound: `1024 * 1024` = 1 MiB (binary mebibyte). **§the-named-explicit-1024-multiplication-for-binary-megabyte**. **§the-named-deliberate-bound-IS-named-default**.

§the-named-buffer-pre-allocation: `initialCapacity: 1024` — explicit initial buffer size for the reader. Extends cycle 314's named-pre-allocate-for-linear-time-discipline. **§two-cycles-with-named-pre-allocation-discipline** (314 chars-array + 315 reader-buffer).

- **§the-named-Writer-API-shape** (first-explicit-observation):

```javascript
const writer = makeLp32Writer(outputStream, { ... });
await writer.next(encoder.encode('hello'));
await writer.next(encoder.encode('world'));
await writer.return();
```

**§the-named-async-iterator-writer-via-next-and-return**: the writer IS shaped as an async iterator's producer-side; `.next(value)` writes; `.return()` closes. **§the-named-await-each-write-discipline**. **§the-named-explicit-close-via-return**.

§the-named-TextEncoder-IS-named-explicit-string-to-bytes: the README uses `new TextEncoder()` rather than implicit conversion. **§the-named-no-implicit-string-bytes-conversion-discipline**.

- **§the-named-round-trip-example-shape** (first-explicit-observation):

```javascript
import { makePipe } from '@endo/stream';
import { makeLp32Reader, makeLp32Writer } from '@endo/lp32';

const [input, output] = makePipe();
const writer = makeLp32Writer(output);
const reader = makeLp32Reader(input);

// Producer + Consumer in the same example
```

**§the-named-cross-package-stream-pair-example**: combines `@endo/stream`'s `makePipe()` with `@endo/lp32`'s reader/writer pair. **§the-named-package-composition-IS-named-discipline**.

§the-named-makePipe-returns-input-output-tuple-via-destructuring: `const [input, output] = makePipe();`. **§the-named-pipe-IS-named-tuple-of-input-and-output**.

§the-named-producer-and-consumer-IS-named-in-comments: `// Producer` + `// Consumer` — the example labels the two sides. **§the-named-comments-mark-conceptual-roles**.

- **§the-named-API-section-IS-named-formal-parameter-documentation** (first-explicit-observation):

```
### makeLp32Reader(reader, options?)

**Parameters:**
- `reader` - An `Iterable<Uint8Array>` or `AsyncIterable<Uint8Array>`
- `options.name` - Optional name for error messages
- `options.maxMessageLength` - Maximum allowed message size (default: 1MB)
- `options.initialCapacity` - Initial buffer size (default: 1024)

**Returns:** An async iterator yielding `Uint8Array` messages.
```

**§the-named-API-section-IS-named-formal-parameter-documentation**: distinct from the named-Usage-section-IS-named-worked-example (cycle 313 named). The API section IS reference-shaped (parameters + returns); the Usage section IS tutorial-shaped (worked examples).

§the-named-parameters-and-returns-as-named-API-shape: matches the API documentation convention from JSDoc / TypeScript.

§the-named-Iterable-or-AsyncIterable-IS-named-flexible-input: the reader accepts both. **§the-named-input-type-IS-named-broadened-via-union**.

- **§the-named-Hardened-JavaScript-section** (first-explicit-observation):

> This package depends on Hardened JavaScript. The environment must be locked down before use, typically via `@endo/init`. All exported functions and the streams they produce are hardened.

**§the-named-dependency-on-Hardened-JS-IS-named-explicit**: this package IS NOT just-uses-harden (like cycle 312's @endo/memoize); it DEPENDS on Hardened JavaScript. **§the-named-environment-precondition-IS-named-stronger**.

§four-cycles-with-named-Hardened-JS-discipline (310 + 312 + 313 + 315): cycle 310 (freeze-stand-in for Apps Script compat) + cycle 312 (harden-import directly) + cycle 313 (Hardened-JS target named) + cycle 315 (dependency on Hardened JS named explicitly).

§the-named-environment-must-be-locked-down-discipline: "The environment must be locked down before use, typically via `@endo/init`." **§the-named-precondition-IS-named-environment-state**. **§the-named-typically-via-endo-init-IS-named-canonical-locking-mechanism**.

§the-named-streams-they-produce-are-hardened: extends cycle 312's named-defensive-harden-on-every-exposed-value to include the streams (iterables, not just functions). **§the-named-iterables-also-hardened**.

- **§six-named-README-sections** (first-explicit-observation; extends): Overview + Usage + API + Hardened-JavaScript + Install + License. **§three-cycles-with-named-six-section-README-shape** (311 nat + 313 memoize + 315 lp32). **§the-named-shape-varies-by-package-content**: each package has a few standard sections + a package-specific section (nat: History; memoize: Memoization-Safety; lp32: API + Hardened-JavaScript).

§the-named-API-section-IS-named-lp32-specific: distinct from the Usage section. **§the-named-Usage-tutorial-and-API-reference-separation**.

§the-named-three-cycles-with-named-Apache-2.0-license-confirmation-extends: cycle 310 source + cycle 311 nat README + cycle 313 memoize README + cycle 315 lp32 README. **§four-cycles-with-named-Apache-2.0-license-confirmation**.

- **§the-named-Install-section-with-npm-and-yarn-extends** (first-explicit-observation): npm + yarn shown. **§three-cycles-with-named-two-named-package-manager-commands** (311 + 313 + 315). **§the-named-multi-tool-install-discipline-extends**.

- **§the-named-six-cycle-stay-after-pivot** (first-explicit-observation):

§six-cycles-with-named-pivot-domain-stay: 310 + 311 + 312 + 313 + 314 + 315 all @endo/* sources.

§four-named-packages-in-the-pivot-cluster: @endo/nat + @endo/memoize + @endo/hex + @endo/lp32.

§the-named-pivot-IS-named-productive-six-cycles-in: the pattern surface continues to refresh with fresh content.
