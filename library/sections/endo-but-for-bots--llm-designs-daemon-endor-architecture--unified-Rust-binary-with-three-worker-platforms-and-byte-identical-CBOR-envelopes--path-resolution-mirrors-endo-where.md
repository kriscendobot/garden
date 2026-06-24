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
title: §Path-resolution-mirrors-@endo/where
parent: endo-but-for-bots--llm-designs-daemon-endor-architecture--unified-Rust-binary-with-three-worker-platforms-and-byte-identical-CBOR-envelopes
---

§Cycle-167's-@endo/where defined the path-resolution
surface in JS. §This-design-implements-the-same-shape-in-
Rust:

| Path | Env override | macOS default | Linux default |
|------|--------------|---------------|---------------|
| State | ENDO_STATE_PATH | ~/Library/Application Support/Endo | $XDG_STATE_HOME/endo |
| Ephemeral | ENDO_EPHEMERAL_STATE_PATH | (same as state) | $XDG_RUNTIME_DIR/endo |
| Socket | ENDO_SOCK_PATH | {ephemeral}/captp0.sock | {ephemeral}/captp0.sock |
| Cache | ENDO_CACHE_PATH | ~/Library/Caches/Endo | $XDG_CACHE_HOME/endo |

§Identical-conventions-across-runtime-implementations.
§The-deployment-shape-is-stable.
