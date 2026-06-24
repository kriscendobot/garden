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
title: §Blocking-call-authorization
parent: endo-but-for-bots--llm-designs-daemon-endor-architecture--unified-Rust-binary-with-three-worker-platforms-and-byte-identical-CBOR-envelopes
---

> *A caller can block on a callee only if the callee is
> an ancestor of the caller in the parent tree (or the
> callee is handle 0). This prevents deadlocks: a parent
> can call into a child synchronously, but a child cannot
> block its parent.*

§Deadlock-prevention-by-structure (parent tree).
§Blocking-by-default-is-unsafe; §authorize-blocking-via-
ancestry.

§Sync-calls (positive nonce, from ≠ 0): check
`can_block(caller, callee)` via parent chain. §Drop-the-
message-silently-if-not-authorized.

§The-tree-structure-of-handles enforces a §total-order-
within-a-process-subtree. §Calls-flow-up-the-tree;
§responses-flow-down.

§Cycle-162's-Ken-protocol §transactional-turns has a
sibling shape: §turn-boundaries-prevent-cross-vat-
deadlock. Here, §parent-tree-prevents-cross-handle-
deadlock.
