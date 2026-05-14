---
title: Progress tracking (per-document Status + cross-document README synchronization)
source: designs/CLAUDE.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 60a63bc404ce8b28c11021d622c0c65ef1f73e00
source_date: 2026-03-13
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [agent-conventions, repository-governance]
status: current
notes: The load-bearing rule of this section: **any modification to a design document must be synchronized with designs/README.md**. The README holds the summary table, mermaid dependency graph, milestones, size/duration estimates, and Gantt timeline; out-of-sync state would corrupt the cross-document plan.
---

> Abstract: Progress is tracked at two levels. **Per-document**: the metadata-table Status field is primary; an optional `## Status` prose section provides implementation details (file paths built, design deviations, what remains). **Cross-document**: `designs/README.md` maintains a summary table, a mermaid dependency graph, milestone tables with exit criteria, size/duration estimates calibrated against observed velocity, and a Gantt timeline. **Critical synchronization rule**: any modification to a design doc (especially metadata) must be reflected in `designs/README.md`. New designs require adding a summary-table row, assigning to a milestone, inserting into the dependency graph if applicable, adding a size/duration estimate, and updating milestone totals + timeline if the critical path changes.

## Progress Tracking

Progress is tracked at two levels:

### Per-document

- The **Status** field in the metadata table is the primary indicator.
- The optional `## Status` prose section provides implementation details: file paths built, design deviations, and what remains.

### Cross-document

- `designs/README.md` maintains a summary table of all designs with Created, Updated, and Status columns.
- The README also contains a Mermaid dependency graph, milestone tables with exit criteria, size/time estimates calibrated against observed velocity, and a Gantt timeline.
- **Any modification to a design document — especially its metadata — must be synchronized with `designs/README.md`.** Update the summary table row to reflect the current Status, Updated date, and any other changed fields.
- **New designs must be incorporated into the README plan.** This means: adding a row to the summary table, assigning the design to a milestone, adding it to the appropriate milestone table, inserting it into the dependency graph if it has dependencies or dependents, adding a per-design size/duration estimate, and updating the milestone totals and timeline if the new work changes the critical path.

Source: [designs/CLAUDE.md](https://github.com/endojs/endo-but-for-bots/blob/60a63bc404ce8b28c11021d622c0c65ef1f73e00/designs/CLAUDE.md) at commit `60a63bc4` on branch `llm`.
