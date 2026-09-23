---
source: designs/daemon-engo-supervisor.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/daemon-engo-supervisor.md
section_kind: design
ingested: 2026-06-05
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - capability-security
status_at_ingest: Not Started
genre: §endo-but-for-bots-design §unrealized-predecessor-of-cycle-176
cycle: 192
lane: designs
status: current
title: §CBOR-with-4-byte-big-endian-length-prefix-framing
parent: endo-but-for-bots--llm-designs-daemon-engo-supervisor--three-architecture-diagrams-platform-pair-convention-and-progressive-syscall-migration-as-unrealized-predecessor
---

```
- **CBOR** is a binary format with well-defined byte string
  support, making it suitable for passing binary payloads
  without base64 encoding.
- **Framing**: Each frame is length-prefixed (4-byte big-
  endian length prefix followed by CBOR bytes), matching the
  `endo-engo` prototype.

The Node.js side uses a CBOR library (e.g., `cbor-x` or
`@ipld/dag-cbor`).
The Go side uses `fxamacker/cbor/v2`.
```

§Two-named-CBOR-libraries-for-each-side. §The-Go-side-is-
`fxamacker/cbor/v2`; §the-Node.js-side-is-`cbor-x`-or-
`@ipld/dag-cbor`.

§4-byte-big-endian-length-prefix is §a-different-choice from
cycle 179-lp32's §host-byte-order-uint32. §Why-big-endian:
this is §inter-language-IPC (Go ↔ Node.js); §host-byte-order-
might-be-mismatched-across-architectures-or-implementations.
§Big-endian-is-the-network-byte-order-default.

§Compare-to-cycle-179-lp32's §host-byte-order-as-deliberate-
IPC-marker (same-host-only-IPC). §Cycle-179 uses host-byte-
order because both sides are on the same machine and
endianness is moot; §cycle-192 uses big-endian because cross-
language framing benefits from a canonical byte-order.

§Compare-to-cycle-181-base64's §pre-pasted-pako-crc32 +
cycle 177-netstring/reader.js' §ASCII-decimal length prefix.
§Three-different-framing-disciplines for three-different-
contexts.
