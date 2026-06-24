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
title: Unified Rust binary with three worker platforms and byte-identical CBOR envelopes
parent: endo-but-for-bots--llm-designs-daemon-endor-architecture--unified-Rust-binary-with-three-worker-platforms-and-byte-identical-CBOR-envelopes
---

> §Endo-but-for-bots-design genre (designs-lane). Status:
> **Active**. Created 2026-04-16. §Sibling-design to
> cycle 141's daemon-cas-management (also Rust supervisor
> work).

`designs/daemon-endor-architecture.md` (806 lines) is the
**§Rust-supervisor-architecture-design** for `endor`, the
unified Rust binary that replaces the Node.js-only daemon
with a §native-supervisor routing messages between
workers running on multiple platforms.

The single most structurally interesting move is the
**§three-worker-platforms-with-byte-identical-CBOR-
envelopes**: workers can run as XS child process
(separate), XS in-process (shared), or Node.js child
process (node), and the §supervisor-is-transport-agnostic.
