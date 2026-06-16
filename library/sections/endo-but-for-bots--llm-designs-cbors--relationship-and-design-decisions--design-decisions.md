---
title: Design Decisions
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

1. **Byte-string framing only.** The package implements only enough of CBOR to read and write a byte-string head, optionally wrapped in tag 24. It does not parse or emit any other CBOR type. This keeps the package small, auditable, and useful as a peer of `@endo/netstring` and the proposed `@endo/syrup-frame`. Consumers that want to carry structured CBOR encode or decode the payload bytes themselves.

2. **Use CBOR tag 24 for the wrapping.** When `tagged` is set, each frame is wrapped in CBOR tag 24 (Encoded CBOR data item; [RFC 8949 § 3.4.5.1][rfc8949-tag24]). That tag is defined precisely for byte strings whose contents are themselves CBOR. Wrapping in tag 24 makes the wire format self-describing to a generic CBOR-aware packet analyzer: the analyzer can drop into the payload and continue parsing. The reader accepts both wrapped and unwrapped frames so a peer that does not bother with the tag still interoperates.

3. **Reject indefinite-length and non-byte-string forms outright.** The reader's tolerance is the place where new attack surface appears. By rejecting any initial byte that is not a recognized byte-string head (or tag-24 wrapper of one), the package keeps its decision surface tight and makes interop bugs surface as clear errors at the wire boundary instead of as confused payloads downstream.

Source: [designs/cbors.md](https://github.com/endojs/endo-but-for-bots/blob/0a99c7bc4a83b61b0b488146e262de08a588a998/designs/cbors.md) at commit `0a99c7bc` on branch `llm`.
