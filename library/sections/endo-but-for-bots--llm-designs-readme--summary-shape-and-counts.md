---
title: Summary table shape + status taxonomy + corpus-size guide
source: designs/README.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 510630411ebc26a6d9327928b4d71e5155802ea4
source_date: 2026-05-09
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [repository-governance, agent-conventions]
status: current
notes: This section deliberately does **not** transcribe the full 100+-row summary table — it would be lossy (the upstream table changes faster than this library cycles) and bulk-uninformative (the value of the table is per-row lookup, not bulk reading). Instead: capture the table's shape, the status taxonomy (which is defined in CLAUDE.md and re-used here), and the way to query upstream for the current state.
---

> Abstract: The Summary section is a 100+-row table with columns `Design | Created | Updated | Status` — one row per design in the corpus. **Status values** (per the CLAUDE.md taxonomy): Not Started, Proposed, In Progress, **Complete** (sometimes bolded), Implemented (synonym for Complete), Active (living document), Reference (informational), Deprecated. Plus per-PR status markers like `PR #93`. As of 2026-05-11 the corpus has **~100 designs**, of which the README's strategic-early-items section notes **26 of 95 complete/implemented** and **15 in progress** (per the 2026-05-08 progress note). **For per-design status the library does not mirror the upstream table** (it would diverge as upstream updates land); query upstream directly via `git --git-dir=worktrees/endojs-endo-but-for-bots.git show llm:designs/README.md | grep <design-slug>` for the current row, or open the URL on the GitHub `llm` branch.

## Summary

| Design | Created | Updated | Status |
|--------|---------|---------|--------|
| (this is a 100+-row table; library does not mirror to avoid divergence) | ... | ... | ... |

*The full table lives in the upstream README. As of 2026-05-11, the corpus contains roughly 100 designs across the 7 milestones tracked in the Milestones section. Status counts (from the 2026-05-08 progress note): **26 of 95 complete/implemented, 15 in progress**. To query a specific design's current status, consult the upstream README at the commit in this section's frontmatter or follow the `llm` branch on GitHub.*

### Status values used (from CLAUDE.md)

| Status | Meaning |
|--------|---------|
| Not Started | Design written, no implementation work begun |
| Proposed | Design under discussion, not yet accepted |
| In Progress | Implementation underway |
| **Complete** | Fully implemented (bolded) |
| Implemented | Synonym for Complete |
| Active | Living document, continuously maintained |
| Reference | Informational; not an implementation target |
| Deprecated | Superseded by another design |
| `PR #N` | In review on the named PR |

Source: [designs/README.md](https://github.com/endojs/endo-but-for-bots/blob/510630411ebc26a6d9327928b4d71e5155802ea4/designs/README.md) at commit `51063041` on branch `llm`.
