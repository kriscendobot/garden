---
title: "`@endo/captp src/atomics.js` — sync-bridge implementation; three-views-one-buffer; yield as three-completion-path rendezvous"
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

The 170-line atomics.js implements the SharedArrayBuffer + Atomics sync-bridge mechanism that cycle 323's README named explicitly. Cycle 324 is **chat-lane after cycle 323's designs-lane @endo/captp README**. **Fifteenth consecutive non-garden source after the pivot** (cycles 310-324). **§fifteen-cycles-with-named-pivot-domain-stay**. **Eighth package extends** (captp's fifth file in the cluster; the README at cycle 323 was the fourth).

**Note on prior ingest**: This file was previously ingested in **cycle 169** by a scholar dispatch (paired with cycle 154's trap.js as "abstract interface + concrete implementation"). The cycle 169 section took the *synchronous-RPC-as-meta-capability* lens: three-buffer-split + Atomics-wait-notify-for-blocking-RPC + async-generator-as-resumable-state-machine + iterator-protocol-as-bidirectional-channel.

Cycle 324 is a **§the-named-complementary-lens-re-ingest** (the librarian discipline named in cycle 322 for exo-makers.js): a different lens on the same file. This cycle's framing emphasizes:
- **Pivot-cluster context**: how atomics.js relates to cycle 316 reader / cycle 320 writer (multi-view-one-buffer generalization to N views) and cycles 314/318 hex (line-level vs file-level eslint-disable variants)
- **Doc-to-impl citation-arc closure** with cycle 323 (1-cycle arc; shortest in the pivot)
- **Tier-3 discipline-variants** named for the first time (derive-don't-hardcode + X-vs-Fail distinction + internal-error-prefix + view-type-determined-by-API-constraint + language-spec-citation-with-link)
- **Yield-as-three-completion-path-rendezvous**: more specific than cycle 169's iterator-protocol-as-bidirectional-channel — the source comment explicitly narrates all three completion paths (`next()` / `return()` / `throw()`)

**§two-cycles-with-named-complementary-lens-re-ingest** (322 exo-makers.js + 324 atomics.js) — the librarian discipline is now applied to two distinct prior ingests. First-explicit-observation as a Tier-2 pattern. The cycle 169 section file lives at `endo--packages-captp-src-atomics-js--SharedArrayBuffer-three-buffer-split-with-Atomics-wait-notify-and-chunked-transfer-via-async-generator.md`.

**§the-named-captp-five-file-cluster-now** — cycles 154 (trap.js) + 156 (finalize.js) + 158 (loopback.js) + 323 (README) + 324 (atomics.js) = **first five-file cluster of the pivot**. The hex cluster is three files (314 + 317 + 318); the lp32 cluster is three files (315 + 316 + 320); captp is now five. **§the-named-substrate-package-IS-named-deeper-cluster** — substrate packages accumulate more files because they sit at a foundation. First-explicit-observation.

**§the-named-citation-arc-from-cycle-323-takes-1-cycle-to-close** — cycle 323 README cited *"the one based on SharedArrayBuffers in src/atomics.js"*; cycle 324 is that file. **Shortest README→source citation arc in the pivot** (1 cycle). The §the-named-cross-package-citation-arc-closes-with-cycle-315 (cycle 319) had 4 cycles; the §the-named-citation-arc-from-cycle-321-takes-2-cycles-to-close (cycle 323) had 2 cycles. Cycle 324 sets a new minimum at 1.

**§eight-citation-arc-closures-in-pivot-now** — adding cycle 323 → 324 (1 cycle) to the prior seven.
