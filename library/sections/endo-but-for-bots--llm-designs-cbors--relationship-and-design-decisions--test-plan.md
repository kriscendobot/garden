---
title: Test Plan
source: designs/cbors.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 0a99c7bc4a83b61b0b488146e262de08a588a998
source_date: 2026-05-05
source_authors: [Kriscendo Bot]
ingested: 2026-05-14
ingested_by: scholar
topics: [streams, repository-governance]
status: current
notes: The three-sibling-packages pattern (netstring / syrups / cbors) is principled — each framing grammar is its own package, no shared dependencies between siblings, head-parsing scaffolding deliberately duplicated. The daemon's `packages/daemon/src/envelope.js` is the obvious first consumer-migration target. The two open questions (top-level vs framing/ subtree placement; tagged-default) are maintainer-taste calls.
parent: endo-but-for-bots--llm-designs-cbors--relationship-and-design-decisions
---

Tests are ported from `packages/netstring/test/netstring.test.js` and adapted to the CBOR byte-string head grammar.

Cases to port:

- Read short frames (zero-length, 1-byte, 23-byte, 24-byte, 256-byte, 65 537-byte payloads, exercising each argument-width form).
- Read short frames with bytes divided over chunk boundaries (the central test for streaming correctness).
- Read a frame in a single chunk, with payload in separate chunk, with payload divided over chunk boundary.
- Read multiple frames divided over chunk boundaries.
- Read a head divided over chunk boundaries (head length varies between 1 and 9 bytes).
- Round-trip short frames with and without `chunked` and with and without `tagged`.
- Round-trip a stream that mixes tagged and untagged frames.
- Concurrent writes, varying-size round-trips, writer-closes-mid-frame backpressure.

Cases CBOR-specific:

- Reject any initial byte whose major type is not 2 (and not 6 with argument 24 wrapping a major-2 head).
- Reject indefinite-length byte strings (initial byte `0x5f`).
- Reject a tag-24 wrapper followed by anything other than a plain byte-string head.
- Reject a length argument exceeding `maxMessageLength` without buffering the payload.
- Reject a truncated head or payload.
- Round-trip with the `name` option set; verify error messages include the configured name.
- Verify the writer always emits the shortest argument form for the length (canonical encoding).

Test file: `packages/cbors/test/cbors.test.js`.

Source: [designs/cbors.md](https://github.com/endojs/endo-but-for-bots/blob/0a99c7bc4a83b61b0b488146e262de08a588a998/designs/cbors.md) at commit `0a99c7bc` on branch `llm`.
