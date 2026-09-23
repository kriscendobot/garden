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
title: §Three-architecture-diagrams (the §visualize-the-transition pattern)
parent: endo-but-for-bots--llm-designs-daemon-engo-supervisor--three-architecture-diagrams-platform-pair-convention-and-progressive-syscall-migration-as-unrealized-predecessor
---

```
### Current architecture
endo (CLI) ──► node daemon ──►* node worker

### Target architecture (this design)
                          ┌─► node daemon
endo (CLI) ──► engo (Go) ─┤
                          └─►* node worker

### Future architecture (out of scope)
endo (CLI) ─┐
engo (Go) ──┼─► node daemon
             ├─►* node worker
             ├─►* go worker
             ├─►* wasm worker
             └─► platform I/O (fs, net, crypto)
```

§Three-stages-of-architectural-evolution shown as three
diagrams. §The-current-state names what exists. §The-target-
state names what this design proposes. §The-future-state
names what the target enables (out-of-scope for this design,
but motivating).

§The-§"out of scope" label on the future-architecture is the
§named-scope-boundary pattern. §The-design-acknowledges-the-
future-direction while §refusing-to-commit-to-it-in-this-
document.

§Compare-to-cycle-190-endo-posix-sandbox's §living-phase-list-
records-its-own-renumbering. §Both-record-§architectural-
evolution; cycle 192's three-diagrams record a §multi-stage-
transition where each stage is itself a complete-and-runnable
architecture.

§Compare-to-cycle-188-perf's §working-copy-inventory which
maps in-progress work to design documents. §Cycle-192-uses-
diagrams; cycle-188-uses-tables. §Both-are-§visualization-of-
transition-state.
