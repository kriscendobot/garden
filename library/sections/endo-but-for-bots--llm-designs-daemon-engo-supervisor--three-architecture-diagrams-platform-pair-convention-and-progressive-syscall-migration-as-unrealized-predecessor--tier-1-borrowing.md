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
title: §Tier-1 borrowing
parent: endo-but-for-bots--llm-designs-daemon-engo-supervisor--three-architecture-diagrams-platform-pair-convention-and-progressive-syscall-migration-as-unrealized-predecessor
---

- §three-architecture-diagrams-current-target-future
  (visualize the transition; each stage runnable)
- §-platform.js + §-platform-powers.js naming convention
  (four-file-quadruple per platform)
- §near-copies-with-channel-adapted (new platform pairs
  start as near-copies of existing ones)
- §progressive-syscall-migration-with-named-priority-order
  (most-impactful-first; phase is unbounded)
- §incrementalism-as-the-key-constraint
- §rollback-trivial discipline (preserve existing alongside
  new)
- §validation-per-phase with §process-tree-inspection-as-test
- §handle-rewriting (sender field implicit in the asymmetry
  of the rewrite)
- §spawn-tree-deadlock-prevention with §canBlock check
- §CBOR-with-big-endian-length-prefix-for-cross-language-IPC
- §when-pivoting-architectures-write-an-explicit-Supersedes-
  record (or update old design's Status)
