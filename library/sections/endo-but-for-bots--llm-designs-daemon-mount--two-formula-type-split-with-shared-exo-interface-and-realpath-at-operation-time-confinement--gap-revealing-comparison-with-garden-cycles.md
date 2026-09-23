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
title: §Gap-revealing-comparison with garden cycles
parent: endo-but-for-bots--llm-designs-daemon-mount--two-formula-type-split-with-shared-exo-interface-and-realpath-at-operation-time-confinement
---

| Cycle | Connection |
|-------|------------|
| 161 (filesystem-watchers) | Direct sibling — `followNameChanges` on PR #277 extends EndoMount; same §operation-time-verification discipline |
| 156 (finalize.js) | §Transient-exos-from-lookup() relies on §weak-value-map-GC pattern |
| 164 (identity-backup-recovery) | §Existing-identity-conflict-guard analog: §single-mistake-cannot-destroy-state |
| 162 (ken-protocol-assessment) | §Atomic-checkpoint analog: host methods with deferred-tasks are atomic-creation; cranks are atomic-execution |
| 105 (daemon-capability-bank) | Sister daemon-capability design; both use exo/host axis |
| 89 (eventual-send pipeline) | §Read-soft-write-hard sibling: §don't-let-error-paths-reveal-too-much |
