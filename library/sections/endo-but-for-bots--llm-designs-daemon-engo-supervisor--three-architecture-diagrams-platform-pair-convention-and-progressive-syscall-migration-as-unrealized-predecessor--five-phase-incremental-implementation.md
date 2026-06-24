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
title: §Five-phase-incremental-implementation
parent: endo-but-for-bots--llm-designs-daemon-engo-supervisor--three-architecture-diagrams-platform-pair-convention-and-progressive-syscall-migration-as-unrealized-predecessor
---

```
Phase 0: Scaffold engo (minimal Go binary spawning Node.js daemon, inherited stdio)
Phase 1: Envelope protocol and daemon-go entry point (fd 3/4 + CBOR)
Phase 2: Worker spawning through engo (handle table + per-worker goroutines + handle rewriting)
Phase 3: First syscall — logging (worker logs to handle 0 instead of stderr)
Phase 4: Progressive syscall migration (fs/net/crypto, in suggested order)
```

§Five-phases with §explicit-Validation-per-phase. §Each-phase-
has-a-§Goal-paragraph and a §Validation-paragraph.

§Phase-0-validation: "`engo start` produces a working daemon
reachable by `endo ping`. Workers are still spawned by the
Node.js daemon directly."

§Phase-2-validation includes-§ps-check ("Workers appear as
children of engo (not of the Node.js daemon) in `ps`. Killing
engo terminates both the daemon and all workers.").

§Phase-4-§This-phase-is-unbounded named.

§Compare-to-cycle-190-endo-posix-sandbox's §phase-list-with-
exit-criteria. §Both-record-§goal+validation-per-phase. §Cycle-
192-uses-"Validation" header; cycle-190-uses-"Exit criteria".

§The-§validation-via-`ps` is a §process-tree-inspection-as-
test pattern. §Compare-to-cycle-184-metering's §benchmark-
numbers-cited-from-three-angles. §Both-are-§empirical-
verification-disciplines.
