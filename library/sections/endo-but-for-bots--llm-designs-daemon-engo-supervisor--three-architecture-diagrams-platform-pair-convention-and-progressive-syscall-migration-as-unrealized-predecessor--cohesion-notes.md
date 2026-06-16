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
title: §Cohesion notes
parent: endo-but-for-bots--llm-designs-daemon-engo-supervisor--three-architecture-diagrams-platform-pair-convention-and-progressive-syscall-migration-as-unrealized-predecessor
---

- §Three-architecture-diagrams (current / target / future) is
  the §visualize-the-transition pattern. §Each-stage-is-a-
  complete-and-runnable-architecture; the design moves
  through them.
- §-go-vs-node-vs-web platform-pair-naming-convention with
  §four-file-quadruple-per-platform (daemon + daemon-powers +
  worker + worker-powers).
- §Near-copies-with-channel-adapted migration-path (new
  platform pairs start as near-copies; over time they
  diverge).
- §Progressive-syscall-migration with §named-priority-order
  (fs first, net second, crypto third — most-impactful-first
  not smallest-first).
- §Incrementalism-as-the-key-constraint named-explicitly.
- §Rollback-trivial — `-node` modules remain alongside `-go`
  modules.
- §Five-phase-incremental-implementation with §Validation-
  per-phase; §Phase-4-unbounded.
- §Handle-rewriting (engo router; sender field implicit in
  the asymmetry of the rewrite).
- §Deadlock-prevention-via-spawn-tree with §canBlock check
  and §sync-from-child-to-ancestor-only rule.
- §CBOR-with-4-byte-big-endian-length-prefix-framing (big-
  endian because inter-language IPC; different from cycle
  179-lp32's host-byte-order).
- §Out-of-scope-but-architecture-supports-it for subprocess-
  isolation (engo could apply macOS sandbox-exec or Linux
  namespaces+seccomp; deferred).
- §The-§Unrealized-predecessor relationship to cycle 176-
  endor-architecture: substantial DNA inherited; Rust pivot;
  neither design names the supersedes-record explicitly.
- §Web-future-architecture-pair with §dashes-for-worker-
  entries (named-but-not-built).
