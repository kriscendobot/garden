---
title: Tier-1 borrowing (twenty-plus first-explicit-observations)
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

All §-tags marked first-explicit-observation above. Highest-portability observations:

- **yield-as-three-completion-path-rendezvous** — the JS iterator protocol's built-in cleanup semantics via `return()` and `throw()`
- **Atomics-sync-bridge-implementation** — SharedArrayBuffer + Int32Array + Atomics.notify(buf, 0, +Infinity) + Atomics.wait
- **three-views-one-buffer** generalized to N views by API constraint
- **language-spec-citation-with-link** — cite MDN/specs in comments for any non-obvious type-coupling
- **bit-flags-with-power-of-two-discipline** — orthogonal flags combinable via OR, testable via AND
- **TRANSFER_OVERHEAD_LENGTH-IS-named-computed-constant** — derive constants from the type system; don't hardcode
- **internal-error-prefix** for library-bug error messages
- **it.throw-null-as-graceful-cleanup** via iterator protocol termination
- **TODO-with-blocking-reason-named** — TODOs cite the upstream blocker
