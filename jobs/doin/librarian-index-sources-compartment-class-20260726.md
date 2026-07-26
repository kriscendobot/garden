# Index gap: sources/README.md missing compartment-class

Add `tc39-module-harmony--compartments-compartment-class` to
`library/sources/README.md`. The source file
`library/sources/tc39-module-harmony--compartments-compartment-class.md`
exists (status: `current`, section_count 5, ingested 2026-07-21 by scholar,
part of the tc39-module-harmony Compartments layer-4 cluster) but is NOT
linked from `sources/README.md`, while every sibling in the same cluster
(`--compartments-evaluator`, `--compartments-graph`, `--compartments-overview`,
`--compartments-static-analysis`, `--compartments-virtual-module-source`,
`--compartments-module-and-source`) IS listed. Insert its entry alongside the
siblings, following the existing per-source entry format.

Land the edit through `scripts/jobs/land-journal-edit.sh library/sources/README.md`
(per skills/context-library and roles/librarian). Do NOT hand-git the live
journal/ worktree. Deliverable: sources/README.md lists compartment-class.

(Found by the librarian library audit, job librarian-library-audit-20260725-170501.)

<!-- garden-reaped: 1 -->

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: gardener
  claimed_at: 2026-07-26T05:33:09Z
