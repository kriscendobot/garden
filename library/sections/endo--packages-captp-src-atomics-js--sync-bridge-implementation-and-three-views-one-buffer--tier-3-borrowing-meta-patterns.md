---
title: Tier-3 borrowing (meta-patterns)
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

- **§the-named-yield-as-three-completion-path-rendezvous** — the yield in async generators is a bidirectional rendezvous point with three completion paths (next/return/throw); use this instead of separate cleanup logic
- **§the-named-iteration-protocol-IS-named-built-in-cleanup-protocol** — the JS iterator protocol provides cleanup-on-cancel and propagation-of-throw "for free"
- **§the-named-multi-view-one-buffer-pattern** — N views over one ArrayBuffer; view-type is determined by API constraint
- **§the-named-Atomics-sync-bridge-implementation** — the canonical JS-runtime pattern for sync-from-async
- **§the-named-language-spec-citation-with-link** — cite MDN/ECMA in comments when a non-obvious type-coupling depends on it
- **§the-named-derive-don't-hardcode-discipline** — compute layout constants from the type system, not from hand-counted bytes
- **§the-named-pathological-minimum-IS-named-test-discipline** — keep edge-case minimums honest by having a test exercise them
- **§the-named-fast-path-for-single-chunk** — the common case of a single-chunk transfer gets a special-case optimization with the rationale commented
- **§the-named-line-level-vs-file-level-eslint-disable** — file-level for many-uses (cycles 314, 318); line-level for few-uses (cycle 324); the discipline reveals how often the rule is deliberately broken
