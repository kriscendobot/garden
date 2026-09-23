---
title: §Progress Tracking — two-level discipline
source-slug: endo-but-for-bots--llm-designs-CLAUDE-md
section-slug: the-canonical-design-doc-template-spec-and-three-required-and-two-optional-metadata-fields-and-eight-status-values-and-seven-document-sections-and-two-level-progress-tracking
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/CLAUDE.md
source-repo: endojs/endo-but-for-bots
source-path: designs/CLAUDE.md
source-author: Endo project (collective)
total-lines: 115
ingest-cycle: 265
ingest-date: 2026-06-10
lane: designs
parent: endo-but-for-bots--llm-designs-CLAUDE-md--the-canonical-design-doc-template-spec-and-three-required-and-two-optional-metadata-fields-and-eight-status-values-and-seven-document-sections-and-two-level-progress-tracking
---

Lines 88-114 specify a two-level progress-tracking discipline:

### Per-document level
- **Status** field is the primary indicator.
- **`## Status` prose section** is the detail companion.

### Cross-document level (lines 100-114)
- `designs/README.md` maintains a **summary table** of all designs with Created, Updated, Status columns.
- The README also contains:
  - **Mermaid dependency graph** — visual dep relationships.
  - **Milestone tables** with exit criteria.
  - **Size/time estimates** calibrated against observed velocity.
  - **Gantt timeline** — visual schedule.

§First-explicit-observation in library: **§the-cross-document-progress-tracking-IS-five-named-artifacts-in-one-README — §summary-table + §Mermaid-dependency-graph + §milestone-tables-with-exit-criteria + §size-and-time-estimates-calibrated-against-observed-velocity + §Gantt-timeline**.

§"calibrated against observed velocity" (line 103-104) — §empirical-estimate-discipline; §the-estimates-ARE-not-naive + §the-template-mandates-calibration; §sibling-pattern to evidence-based-planning conventions; §first-explicit-observation in library of §empirical-estimate-discipline-named-explicitly-in-the-CLAUDE.md.
