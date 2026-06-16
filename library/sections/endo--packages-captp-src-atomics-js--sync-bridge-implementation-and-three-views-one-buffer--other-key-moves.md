---
title: Other key moves
source: endo--packages-captp-src-atomics-js
url: https://github.com/endojs/endo/blob/master/packages/captp/src/atomics.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/captp/src/atomics.js
total-lines: 170
ingest-cycle: 324
ingest-date: 2026-06-15
lane: chat
section-tags:
  - the-named-yield-as-three-completion-path-rendezvous
  - the-named-Atomics-sync-bridge-implementation
  - the-named-three-views-one-buffer
  - the-named-multi-view-one-buffer-pattern
  - the-named-Int32Array-for-Atomics.notify-with-MDN-link
  - the-named-language-spec-citation-with-link
  - the-named-bit-flags-for-status
  - the-named-orthogonal-flags-via-power-of-two-discipline
  - the-named-OR-to-combine-orthogonal-bitfields
  - the-named-AND-to-test-bitfield-flag
  - the-named-Atomics.notify-with-Infinity-wake-all
  - the-named-Atomics.wait-as-named-blocking-primitive
  - the-named-MIN_DATA_BUFFER_LENGTH-IS-pathological-minimum
  - the-named-pathological-minimum-IS-named-test-discipline
  - the-named-TRANSFER_OVERHEAD_LENGTH-IS-named-computed-constant
  - the-named-derive-don't-hardcode-discipline
  - the-named-assert.equal-with-X-tagged-template
  - the-named-X-vs-Fail-distinction
  - the-named-internal-error-prefix
  - the-named-fast-path-for-single-chunk
  - the-named-allocate-after-first-chunk-reveals-size
  - the-named-it.throw-null-as-graceful-cleanup
  - the-named-TODO-with-blocking-reason-named
  - the-named-line-level-eslint-disable-discipline
  - the-named-captp-five-file-cluster-now
  - fifteen-cycles-with-named-pivot-domain-stay
  - eight-citation-arc-closures-in-pivot-now
parent: endo--packages-captp-src-atomics-js--sync-bridge-implementation-and-three-views-one-buffer
---

- **§the-named-bit-flags-for-status** (line 13-16) — `STATUS_WAITING = 1`, `STATUS_FLAG_DONE = 2`, `STATUS_FLAG_REJECT = 4`. Powers of 2 → bitwise-combinable. **§the-named-orthogonal-flags-via-power-of-two-discipline**; **§the-named-OR-to-combine-orthogonal-bitfields** (line 86: `rejectFlag | doneFlag`); **§the-named-AND-to-test-bitfield-flag** (line 130: `statusbuf[0] & STATUS_FLAG_DONE`). First-explicit-observation as a *bitfield discipline*.

- **§the-named-MIN_DATA_BUFFER_LENGTH-IS-pathological-minimum** (line 4-5) — *"This is a pathological minimum, but exercised by the unit test."* Names the minimum-of-one-byte as a deliberate edge case kept alive by a test. **§the-named-pathological-minimum-IS-named-test-discipline**; the test is what keeps the minimum honest. First-explicit-observation.

- **§the-named-TRANSFER_OVERHEAD_LENGTH-IS-named-computed-constant** (line 7-11) — overhead derived from `BigUint64Array.BYTES_PER_ELEMENT + Int32Array.BYTES_PER_ELEMENT`; not hardcoded. **§the-named-derive-don't-hardcode-discipline**; §the-named-constant-IS-named-derived-from-type-system-not-fixed-value. First-explicit-observation.

- **§the-named-assert.equal-with-X-tagged-template** (line 33-37) — `assert.equal(overheadLength, TRANSFER_OVERHEAD_LENGTH, X\`Internal error; ...\`)`. The **X** tagged template is the @endo/errors sibling of **Fail** (cycle 316/320). §the-named-X-vs-Fail-distinction: X is for *assertion-detail*; Fail is for *short-circuit-throw*. The two are paired imports `import { X, Fail } from '@endo/errors'`. First-explicit-observation.

- **§the-named-internal-error-prefix** (line 34, 123) — error messages prefixed with *"Internal error;"* to mark them as library-bug indicators (not user errors). **§the-named-internal-error-IS-named-library-bug**; §the-named-error-prefix-discriminates-error-class. First-explicit-observation.

- **§the-named-async-generator-as-trapHost** (line 58) — `async function* trapHost([isReject, serialized])`. **§two-cycles-with-named-async-generator-protocol** (316 reader + 324 trapHost).

- **§the-named-while-not-done-with-chunked-encoding** (line 64-95) — outer loop chunks the encoded JSON; each iteration: copy slice → set remaining length → calculate next-slice + done-flag → notify guest → maybe yield. **§the-named-chunked-iteration-with-explicit-loop-state**.

- **§the-named-fast-path-for-single-chunk** (line 135-141) — *"Special case: we are done on first try, so we don't need to copy anything."* Optimizes the common case of fits-in-one-buffer payloads by avoiding allocation. §the-named-common-case-optimization-named-in-comment. First-explicit-observation.

- **§the-named-allocate-after-first-chunk-reveals-size** (line 142-144) — *"Allocate our buffer for the remaining data."* The total size is unknown until the first chunk arrives carrying `remaining`. Allocate the accumulator *once* after seeing the size. **§the-named-size-revealed-by-protocol-not-known-up-front**; §the-named-allocate-once-after-size-reveal. First-explicit-observation.

- **§the-named-it.throw-null-as-graceful-cleanup** (line 156-157) — *"This throw is harmless if the host iterator has already finished, and if not finished, captp will correctly raise an error."* Uses `it.throw(null)` to terminate the host generator. **§the-named-cleanup-via-iterator-protocol-termination**; the trapGuest *relies on* the trapHost's yield-three-completion-path discipline to clean up via `it.throw`. First-explicit-observation.

- **§the-named-TODO-with-blocking-reason-named** (line 153-155) — *"TODO: It would be nice to use an error type, but captp is just too noisy with spurious 'Temporary logging of sent error' messages."* Names the *upstream noise* that blocks the better approach. **§the-named-honest-about-temporary-workaround**; §the-named-TODO-cites-the-blocker. First-explicit-observation.

- **§the-named-TextEncoder-and-TextDecoder-as-named-pair** (line 56, 163) — host has `new TextEncoder()`, guest has `new TextDecoder('utf-8')`. **§the-named-encoder-decoder-symmetric-pair**.

- **§the-named-JSON-encode-then-byte-encode-pipeline** (line 60-61) — `const json = JSON.stringify(serialized); const encoded = te.encode(json);` — two-step serialization (object → JSON string → UTF-8 bytes). **§the-named-two-step-serialization**; §the-named-JSON-first-bytes-second-discipline. First-explicit-observation.

- **§the-named-tuple-as-protocol-payload** (line 58, 168) — `[isReject, serialized]` — 2-tuple where first is boolean-status-flag, second is the actual data. **§the-named-tagged-tuple-via-position**. Sibling to cycle 154 trap.js's §isException-tagged-tuple-result; **§two-cycles-with-named-tagged-tuple-via-position** (154 + 324).

- **§the-named-line-level-eslint-disable-discipline** (line 85, 129, 159) — three uses of `// eslint-disable-next-line no-bitwise` rather than file-level disable. Compare to cycle 314 hex encode and cycle 318 hex decode which used *file-level* `/* eslint no-bitwise: ["off"] */`. **§the-named-line-level-vs-file-level-eslint-disable**; the line-level form *marks each individual deliberate use*, while the file-level form *grants blanket permission*. §the-named-eslint-disable-discipline-variants (file-level for many-uses + line-level for few-uses). First-explicit-observation as a *discipline-variant*.

- **§the-named-startTrap-IS-named-guest-side-driver** (line 113) — `const it = startTrap()` — guest gets the iterator and drives it. Names the *role* of startTrap from the protocol description in cycle 323's README.
