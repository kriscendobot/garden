---
title: The single most structurally interesting move
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

**§the-named-yield-as-three-completion-path-rendezvous** — the `trapHost` async generator's bare `yield;` (line 93) sits inside a `while (!done)` loop, with a comment (line 89-93) that *explicitly names three completion paths*:

```js
if (!done) {
  // Wait until the next call to `it.next()`.  If the guest calls
  // `it.return()` or `it.throw()`, then this yield will return or throw,
  // terminating the generator function early.
  yield;
}
```

The yield is **not** just data-output. It's a **bidirectional rendezvous point** that propagates the caller's completion semantics back into the producer:

1. **`it.next()`** resumes the generator at the yield, returning normally
2. **`it.return()`** causes the yield to return (the generator function exits as if it ran to completion)
3. **`it.throw()`** causes the yield to *throw* (the generator function propagates the thrown error)

§the-named-yield-IS-named-rendezvous-with-caller — the producer doesn't have to handle cleanup-on-cancel separately because the iterator protocol *already* provides cleanup-on-cancel via the `return()` and `throw()` methods. The comment narrates that this is *deliberate* — the trapHost relies on the iterator protocol's three-path completion semantics. **§the-named-iteration-protocol-IS-named-built-in-cleanup-protocol**. First-explicit-observation in library.

This concretizes cycle 323's Tier-3 **§the-named-iteration-as-protocol-synchronization-point** at the source level. The pattern was *named* at the README level (323); the *comment that documents the yield's three-path semantics* is at the source level (324). The doc→impl arc closes in one cycle with the source-level comment serving as the *implementation-side rationale* for the README-level concept.
