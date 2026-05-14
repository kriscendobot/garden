---
title: Relationship to existing packages + Test plan + Design decisions + Open questions
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
---

> Abstract: **Relationship**: three peer framing packages — `@endo/netstring` (`<digits>:<bytes>,`), `@endo/syrup-frame` (proposed; `<digits>:<bytes>`; will be renamed `@endo/syrups`), `@endo/cbors` (this design; CBOR byte-string head ± tag 24). None depend on the others. The daemon's `envelope.js` is the obvious migration target. **Test plan**: tests ported from `packages/netstring/test/netstring.test.js`, adapted to CBOR head grammar. Covers all short-frame round-trips with/without chunked/tagged, chunk-boundary edges, head-spanning-chunks (head length 1-9 bytes), concurrent writes, CBOR-specific rejections (non-major-2, indefinite-length, oversize-against-maxMessageLength, truncated head/payload, name-option error messages, canonical-shortest-form encoding verification). **Design decisions**: (1) byte-string framing only — no full-CBOR-codec dependency; (2) use tag 24 specifically (Encoded CBOR data item; defined for byte strings whose contents are themselves CBOR) so the wire is self-describing to a generic CBOR analyzer; (3) reject indefinite-length and non-byte-string forms outright — narrow decision surface, clear errors at wire boundary. **Open questions**: (1) top-level vs `framing/` subtree for layout? sibling consistency suggests top-level; revisit when family grows past 4-5 members; (2) `tagged: true` as default? initial recommendation is untagged to minimize peer surprise.

## Relationship to existing packages

| Package | Role |
|---|---|
| [`@endo/netstring`](../packages/netstring/) | Frames byte payloads as `<digits>:<bytes>,` |
| `@endo/syrup-frame` ([PR 29](./ocapn-tcp-syrup-framing.md), proposed, not yet landed) | Frames byte payloads as `<digits>:<bytes>` |
| `@endo/cbors` (this design) | Frames byte payloads as a CBOR byte-string head plus payload, optionally wrapped in CBOR tag 24 |
| `packages/daemon/src/envelope.js` | Inline CBOR codec for the engo bus envelope protocol; a candidate consumer of `@endo/cbors` for the framing layer |

The three are sibling packages. Each frames a sequence of byte payloads using a different head grammar. A consumer that wants the netstring grammar takes a dependency on `@endo/netstring` and gets nothing else; a consumer that wants the syrup-frame grammar (once it lands) would take `@endo/syrup-frame` only; a consumer that wants the CBOR-byte-string grammar takes `@endo/cbors` only. None of the three depends on any of the others, and adopting one does not entrain the rest.

The daemon's existing inline encoder is the obvious migration target for the framing layer: once `@endo/cbors` exists, the engo envelope protocol can drop its private head-bytes code and use the streaming reader and writer for that layer. The daemon would still encode and decode the *contents* of each frame with whatever CBOR codec it likes. That migration is out of scope here; this design only delivers the framing package.

## Test Plan

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

## Design Decisions

1. **Byte-string framing only.** The package implements only enough of CBOR to read and write a byte-string head, optionally wrapped in tag 24. It does not parse or emit any other CBOR type. This keeps the package small, auditable, and useful as a peer of `@endo/netstring` and the proposed `@endo/syrup-frame`. Consumers that want to carry structured CBOR encode or decode the payload bytes themselves.

2. **Use CBOR tag 24 for the wrapping.** When `tagged` is set, each frame is wrapped in CBOR tag 24 (Encoded CBOR data item; [RFC 8949 § 3.4.5.1][rfc8949-tag24]). That tag is defined precisely for byte strings whose contents are themselves CBOR. Wrapping in tag 24 makes the wire format self-describing to a generic CBOR-aware packet analyzer: the analyzer can drop into the payload and continue parsing. The reader accepts both wrapped and unwrapped frames so a peer that does not bother with the tag still interoperates.

3. **Reject indefinite-length and non-byte-string forms outright.** The reader's tolerance is the place where new attack surface appears. By rejecting any initial byte that is not a recognized byte-string head (or tag-24 wrapper of one), the package keeps its decision surface tight and makes interop bugs surface as clear errors at the wire boundary instead of as confused payloads downstream.

## Open Questions

1. **Should `@endo/cbors` (and other framing packages) live next to `@endo/netstring` or under a `framing/` subtree?** Today `@endo/netstring` lives at top level (`packages/netstring/`); the proposed `@endo/syrup-frame` follows the same pattern. Sibling consistency suggests `packages/cbors/` at top level, but a future `packages/framing/` subtree could be argued for once the family grows past four or five members. Layout question, not a design question.

2. **Should `tagged: true` be the default?** Tag-24 wrapping costs two bytes per frame and helps generic CBOR analyzers. If the dominant consumer is a peer that always carries CBOR, the default could be tagged; if many consumers carry opaque bytes, the default should remain untagged. Initial recommendation: `tagged: false` (untagged) — minimizes surprise for peers that don't expect a wrapping byte.

[rfc8949-tag24]: https://www.rfc-editor.org/rfc/rfc8949.html#section-3.4.5.1

Source: [designs/cbors.md](https://github.com/endojs/endo-but-for-bots/blob/0a99c7bc4a83b61b0b488146e262de08a588a998/designs/cbors.md) at commit `0a99c7bc` on branch `llm`.
