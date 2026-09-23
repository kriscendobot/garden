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
title: §The-three-pre-existing-shapes-and-the-gap
parent: endo-but-for-bots--llm-designs-daemon-mount--two-formula-type-split-with-shared-exo-interface-and-realpath-at-operation-time-confinement
---

The doc opens by naming what the daemon *had* and what was
missing:

| Existing | What it is | What it lacks |
|----------|------------|---------------|
| `readable-tree` | Immutable content-addressed snapshots | Cannot be modified |
| `directory` | Pet-name capability namespace | Not a filesystem |
| (none) | — | **Live mutable filesystem access** |

§Naming-the-shape-of-the-gap. §AI-coding-agent-as-motivating-
use-case: an agent needs to read project files, write
generated code, create build artifacts — all confined.

§Today's-two-bad-options: §ambient-host-permissions
(violates least authority) OR §everything-through-store-
checkin (immutable snapshots only, no incremental edits).
§Mount-bridges-this-gap.
