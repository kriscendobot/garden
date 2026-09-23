---
source: designs/daemon-endor-architecture.md
source_repo: endojs/endo-but-for-bots
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/daemon-endor-architecture.md
source_path: designs/daemon-endor-architecture.md
source_branch: llm
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - tooling
  - hardened-javascript
genre: §endo-but-for-bots-design
cycle: 176
lane: designs
status: current
title: §Byte-identical-CBOR-envelopes across transports
parent: endo-but-for-bots--llm-designs-daemon-endor-architecture--unified-Rust-binary-with-three-worker-platforms-and-byte-identical-CBOR-envelopes
---

```
Envelope { handle, verb, payload, nonce }
  CBOR 4-element array on the wire:
  [i64, text, bytes, i64]
```

§Both-separate-and-shared-workers-speak-byte-identical-
CBOR-envelopes. §The-supervisor-routing-layer-is-
transport-agnostic.

§Two-transport-implementations:
- **PipeTransport**: fd 3 (write) / fd 4 (read), for
  child-process workers.
- **ChannelTransport**: `std::sync::mpsc`, for in-process
  workers. §Pre-seeded-init-no-handshake-roundtrip.

§Same-protocol-different-substrate. §Cycle-119's-
envelope-protocol named this discipline; this design
implements it.

§Nonce-semantics: 0 = fire-and-forget; positive =
synchronous call (response carries same nonce). §Cycle-
162's-Ken-protocol-FIFO-via-TCP sibling.
