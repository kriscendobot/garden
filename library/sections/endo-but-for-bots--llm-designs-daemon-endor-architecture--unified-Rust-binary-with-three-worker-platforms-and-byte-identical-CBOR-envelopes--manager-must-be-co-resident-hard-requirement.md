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
title: §Manager-must-be-co-resident (hard requirement)
parent: endo-but-for-bots--llm-designs-daemon-endor-architecture--unified-Rust-binary-with-three-worker-platforms-and-byte-identical-CBOR-envelopes
---

> *The manager (initial peer) always runs in the same
> process as the supervisor message bus.*

§Hard-requirement-not-platform-preference. §The-daemon-
binary-is-self-contained. §Bootstrap-completes-without-
depending-on-external-process.

§Unlike-workers, the manager's hosting mode is §not-
caller-selectable. §Daemon-configuration-choice.

§Legacy-Node.js-child-mode (`ENDO_MANAGER_NODE=1`): exists
only for compatibility. §Co-resident-manager-is-the-
default-and-future.

§Cycle-141's-supervisor-owned-CAS depends on this: §the-
supervisor-and-the-manager-share-state.
