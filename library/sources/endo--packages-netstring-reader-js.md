---
source: packages/netstring/reader.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/netstring/reader.js
source_branch: master
source_commit: e56bf00f289ff8484094b785b11636b8bc71d87e
source_authors: [Mathieu Hofman (prompted)]
ingested: 2026-06-03
ingested_by: scholar
section_count: 1
status: current
notes: |
  Cycle 177. Chat-lane after cycle 176's designs-lane.
  §Endo-source-comment-fragment genre.

  163-line file. §The-canonical-netstring-decoder used by
  daemon socket framing (cycle 49 + cycle 176 endor's
  client bridging), daemon-cas-management's envelope-bus
  (cycle 141), and OCapN-TCP-syrups-framing (cycle 174
  dependency).

  **§Sixteenth file in the e56bf00f coordinated-update
  cluster** (cycles 108/110/115/118/123/125/132/134/138/
  140/144/167/169/171/173/175/177).

  **Single most structurally interesting move**: §two-
  state-iterator (waiting-for-length-prefix /
  waiting-for-data) with §zero-copy-fast-path and §allocate-
  on-multi-chunk discipline.

  §The-netstring-format: `<length>:<data>,` — §self-
  delimiting-binary-protocol; §no-escaping-needed.

  §State-encoded-as-lengthBuffer-null-or-not (cycle 173's
  §undefined-vs-null-meaningful-distinction at a different
  scale).

  §Zero-copy-fast-path: §subarray-instead-of-allocate when
  data fits in one chunk. §Allocation-elision-for-common-
  case (cycle 169 atomics.js sibling).

  §Allocate-on-multi-chunk: §one-allocation-per-message
  not §per-chunk.

  §Char-by-char prefix parsing with §three-character-cases
  (digit / COLON / anything-else). §Pre-computed-byte-
  constants (COLON, COMMA, ZERO, NINE).

  §Sanity-caps-defense-in-depth: maxMessageLength +
  derived maxPrefixLength. §Reject-prefix-too-long-before-
  converting.

  §Comma-separator-validation: §the-comma-is-the-message-
  boundary-marker; §sanity-check-that-length-prefix-was-
  honest.

  §Dangling-message detection at EOF.

  §Four-pieces-of-context-per-error: what / actual-bytes /
  offset / name. §Debuggable-rejection.

  §Async-generator-yields-as-it-decodes: §stream-in-
  stream-out; §back-pressure-via-await-of-next. §Cycle-171-
  stream/index.js's §functional-async-queue + §back-
  pressure-via-acks sibling.

  §Legacy-export `netstringReader` as alias for
  `makeNetstringReader` — §migration-discipline (cycle 176
  §renames-from-kind-to-platform sibling).

  §The-canonical-decoder for §netstring-protocol-family
  used by cycles 49/141/174/176. §Same-protocol-different-
  substrate: §Rust-supervisor-(cycle-176)-re-implements-
  this-byte-for-byte.

  Author Mathieu Hofman (prompted) — §same-author as
  cycle 100's unhandled-rejection.js. §Two-Hofman-authored-
  files ingested.

  §Seventh-member-of-the-§small-files-with-large-
  knowledge-density family (cycles 165/167/169/171/173/
  175/177). §The-substrate-files-are-often-the-shortest.

  §Tier-1 vocabulary borrowing: §two-state-iterator-
  state-machine + §zero-copy-fast-path + §allocate-on-
  multi-chunk + §sanity-caps-defense-in-depth + §four-
  pieces-of-context-per-error + §dangling-message-
  detection-at-EOF.

  §Synthesis-target: §slot-machine-library may need a
  §self-delimiting-binary-protocol-decoder; the §two-
  state-iterator + §zero-copy-fast-path pattern is
  borrowable for any §length-prefixed-data-framing.

  Cycle 177 was nominally chat-lane (after cycle 176's
  designs-lane). Papers-lane blocked 71+ consecutive
  cycles.
---

> Abstract: `packages/netstring/reader.js` (163 lines)
> decodes **netstrings** — `<length>:<data>,` — from an
> async byte stream.
>
> **Cycle 177 — chat-lane**. §Endo-source-comment-fragment
> genre. §Sixteenth file in the e56bf00f coordinated-
> update cluster.
>
> **Single most structurally interesting move**: §two-
> state-iterator with §zero-copy-fast-path and §allocate-
> on-multi-chunk.
>
> §The-canonical-decoder for the §netstring-protocol-
> family used by daemon socket, CAS envelope-bus,
> gateway, and endor's Rust port.
>
> §Same-author as cycle 100 (Mathieu Hofman).
>
> §Tier-1 borrowing: §two-state-iterator-state-machine,
> §zero-copy-fast-path, §allocate-on-multi-chunk, §sanity-
> caps-defense-in-depth, §four-pieces-of-context-per-
> error, §dangling-message-detection-at-EOF.
>
> §Seventh-member-of-the-§small-files-with-large-
> knowledge-density family.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [two-state-iterator-with-zero-copy-fast-path-and-allocate-on-multi-chunk](../sections/endo--packages-netstring-reader-js--two-state-iterator-with-zero-copy-fast-path-and-allocate-on-multi-chunk.md) | streams, patterns, captp | current |

One cohesion-honest section.

## Provenance

- Fetched 2026-06-03 from `endojs/endo@master`
  (file last touched in commit `e56bf00f`).
- Author: Mathieu Hofman (prompted).
- **Sixteenth file in the e56bf00f coordinated-update
  cluster**.
- Cycle 177 was nominally **chat-lane** (after cycle 176's
  designs-lane). Papers-lane blocked **71+ consecutive
  cycles**.
- One cohesion-honest section.
