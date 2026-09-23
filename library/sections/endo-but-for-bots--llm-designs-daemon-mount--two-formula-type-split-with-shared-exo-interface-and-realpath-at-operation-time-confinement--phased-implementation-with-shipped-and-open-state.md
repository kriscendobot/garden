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
title: §Phased-implementation-with-shipped-and-open-state
parent: endo-but-for-bots--llm-designs-daemon-mount--two-formula-type-split-with-shared-exo-interface-and-realpath-at-operation-time-confinement
---

| Phase | Status | Content |
|-------|--------|---------|
| 1: Core mount exo + `mount` formula | **Complete** | reads + provideMount + `endo mount` CLI |
| 2: Mutation methods | **Complete** | write/remove/move/makeDirectory |
| 3: Scratch mounts | **Complete** | `scratch-mount` formula + `endo mkscratch` |
| 4: Sub-mounts + snapshot | **Not Started** | PR #135 |
| 5: Transient lookup exos | **Complete** | directory + file transient exos |
| 6: CLI commands (endo ls/cat/write) | **Partially Complete** | PR #153 absorbed some |

§Phases-1-3-and-5-shipped-2026-03-21 in commit `e22f71327`.
§Phase-4-and-6-open-as-PRs-#135-/-#127-/-#277.

§Twenty-integration-tests in `packages/daemon/test/endo.
test.js`: 13 core operations + 7 symlink confinement.
§Cross-reference-against-fs.promises ensures the daemon
observation matches direct-filesystem observation.
