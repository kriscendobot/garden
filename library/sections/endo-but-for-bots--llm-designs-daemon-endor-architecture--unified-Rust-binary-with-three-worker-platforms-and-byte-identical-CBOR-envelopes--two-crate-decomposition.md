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
title: §Two-crate-decomposition
parent: endo-but-for-bots--llm-designs-daemon-endor-architecture--unified-Rust-binary-with-three-worker-platforms-and-byte-identical-CBOR-envelopes
---

```
rust/endo/       endo crate — supervisor, routing, process management
rust/endo/xsnap/ xsnap crate — XS engine bindings
```

§endo-crate-handles-routing-and-process-management:
supervisor, inbox routing, suspend/resume state.

§xsnap-crate-handles-XS-bindings: machine lifecycle, host
powers, envelope dispatch, snapshot I/O.

§Separation-of-routing-from-engine. §The-supervisor-doesn't-
know-XS-internals; §xsnap-handles-them.

§Reflects-cycle-141's-supervisor-owned-vs-worker-owned
decision: supervisor owns shared resources (routing, CAS,
filesystem); workers own JS execution.
