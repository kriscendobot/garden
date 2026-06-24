---
source: designs/daemon-mount.md
source_repo: endojs/endo-but-for-bots
source_url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/daemon-mount.md
source_path: designs/daemon-mount.md
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - capability-security
  - patterns
genre: §endo-but-for-bots-design
cycle: 166
lane: designs
status: current
title: §Five-design-dependencies
parent: endo-but-for-bots--llm-designs-daemon-mount--two-formula-type-split-with-shared-exo-interface-and-realpath-at-operation-time-confinement
---

| Design | Relationship |
|--------|-------------|
| [platform-fs] | Uses `ReadableTree`, `ReadableBlob`, `File`, `Directory`, `SnapshotTree` types |
| [daemon-capability-filesystem] | Speculative vision; mount implements a concrete subset |
| [daemon-checkin-checkout] | `snapshot()` produces `readable-tree` consumable by `endo checkout` |
| [daemon-agent-tools] | Agent filesystem tools backed by mount capabilities |
| [daemon-content-store-gc] | Scratch-mount cleanup + content-store pruning |

§Dependency-graph-is-explicit. §Speculative-vision-realized-
as-concrete-subset observation: §daemon-capability-
filesystem.md is the wider design; mount is the §concrete-
mergeable-slice.
