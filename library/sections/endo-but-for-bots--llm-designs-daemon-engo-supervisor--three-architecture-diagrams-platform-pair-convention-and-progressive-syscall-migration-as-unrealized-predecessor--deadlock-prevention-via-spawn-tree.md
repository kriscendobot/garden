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
title: §Deadlock-prevention-via-spawn-tree
parent: endo-but-for-bots--llm-designs-daemon-engo-supervisor--three-architecture-diagrams-platform-pair-convention-and-progressive-syscall-migration-as-unrealized-predecessor
---

```
The Go supervisor inherits the deadlock prevention strategy
from the `endo-engo` prototype:

- The supervisor maintains a **spawn tree** recording parent-
  child relationships (logical, not OS-level — all processes
  are OS-level children of engo).
- **Synchronous calls** (requestID > 0) are only permitted
  from child to ancestor in the logical tree or to the
  control plane (handle 0).
- The `canBlock(caller, callee)` check prevents cycles.
- **Asynchronous messages** (requestID = 0) are always
  permitted.
```

§Spawn-tree-as-logical-DAG (engo → daemon → workers). §All-
processes-are-OS-children-of-engo; §logical-tree-is-separate.

§Two-rules:

1. §Sync-calls-only-child-to-ancestor-or-control-plane
   (handle 0).
2. §Async-messages-always-permitted (no cycle-detection
   needed).

§The-`canBlock`-check is the §canonical-deadlock-prevention.
§Sibling-workers-cannot-synchronously-call-each-other; they
use §asynchronous-messages-via-the-daemon's-CapTP-layer.

§Compare-to-cycle-176-endor-architecture's §blocking-call-
authorization-via-parent-tree (§deadlock-prevention-by-
structure). §Same-name-same-discipline. §Cycle-176-inherits-
this-from-cycle-192's-engo-design.

§Cycle-184-metering's §custom-fxAbort-via-longjmp + §three-
phase-drain-loop are §different-deadlock-prevention-
strategies at a different layer. §The-spawn-tree-discipline
is §protocol-level; §fxAbort is §runtime-level.
