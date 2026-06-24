---
ts: 2026-06-19T01:08:50Z
kind: result
role: solicitor
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - entries/2026/06/18/181354Z-dispatch-liaison-f8c3fa.md
---

## Solicitor result — PR #467 R2

**PR:** endojs/endo-but-for-bots#467
`docs(designs): filesystem interface reconciliation + mount-seam fixes`
Author: kumavis

**Round:** R2 (kumavis pushed updates addressing R1 findings)

**Panel kind:** design-panel (override: `panel-hints.sh --base origin/llm` returned `code-panel` because the 126-file diff includes source files; the dispatch specifies design-panel override for the designs/-layout reason, and R1 was conducted as design-panel)

**Panel-hints output (verbatim):**

```
Panel-kind: code-panel

Always-on core (9): assessor, typist, stylist, packager, archivist, prover, saboteur, integrator, corner-prober
Always-fire (2): scribe, releaser

Path-triggered (7): breaker, curator, fast-checker, gateway, migrator, pruner, surfacer
  breaker  designs/fs-interface-consolidation.md (M.interface / makeExo / ## Invariants)
  curator  packages/9p-server/package.json (exports/main/types field)
  fast-checker  packages/9p-server/test/server.test.js
  gateway  yarn.lock
  migrator  dependency/peerDeps change in package.json
  pruner  designs/fs-interface-consolidation.md (+355 lines)
  surfacer  packages/endo-fs (2 surface files touched)

Content-triggered (6): engine-realist, locksmith, purist, spec-keeper, warden, wire-watcher
  ...
```

**Override rationale:** R1 was solicitor/design-panel; this R2 re-runs the same panel on the design documents. The 126-file diff is the implementation of the design, not a separate design-only PR.

**Panel execution:** in-band-fallback

**R1 resolution check:**

| R1 item | Status in R2 |
|---|---|
| must-fix: `stat` row absent from conformance matrix | Resolved |
| must-fix: `writeText` two-signature violation | Resolved |
| summary-fix: em-dashes throughout | Not addressed (83 lines in reconciliation, 37 in consolidation) |
| summary-fix: heading capitalization mixed | Not addressed |
| summary-fix: Status section orientation | Resolved |
| summary-fix: FsBackend seam before definition | Resolved |
| summary-fix: copy() observable equivalence note | Resolved |
| follow-up: librarian/scholar tasks | Parked |
| follow-up: pending-adapter asterisk tracking | F7 documents adapter status |

**Verdict:** CHANGES_REQUESTED

**Disposition counts:**
- must-fix-loop: 1
- summary-fix: 1
- follow-up: 2
- acknowledge: 3
- drop: 0

**Must-fix-loop items:**

1. `designs/fs-interface-reconciliation.md` line 880 — `## Design Decisions` uses title case while all other `##` headings use sentence case. R1 summary-fix not addressed in R2. Fix: `## Design decisions`. [proposed-rule: all `##` and `###` headings within a single design document use the same capitalization convention; sentence case is the prevailing convention in this corpus]

**Summary-fix bundle:**

1. Em-dashes in both design documents (83 occurrences in reconciliation, 37 in consolidation). R1 summary-fix not addressed. Per `skills/em-dash-style/SKILL.md`, rewrite as period, parentheses, or colon. [rule: skills/em-dash-style/SKILL.md]

**Follow-up items:**

1. `followNameChanges` empty-stream semantics for CAS (D6): a viewer cannot distinguish "immutable CAS" from a broken watcher connection. Design should state which condition is observable and which is not. [proposed-rule: design documents proposing empty-stream semantics should address distinguishability from a broken or disconnected stream]

2. "Library and project references" section (200 lines) preceding main analysis should open with a skip-sentence for readers already familiar with the prior designs. [proposed-rule: long reference sections preceding the main technical analysis should open with a skip-sentence]

**Review submitted:** `gh pr review 467 -R endojs/endo-but-for-bots --request-changes --body-file /tmp/panel-r2-467.md` at 2026-06-19T01:08:31Z (review id 4529479413)

**Next stage:** `next: liaison` (external PR; user decides on fixer dispatch or kumavis addresses the must-fix)

**Proposed rules:** 3 `[proposed-rule]` tags raised; message to gardener will follow via standard post-loop action.

Self-improvement: nothing this time. The in-band-fallback procedure worked cleanly for a R2 design-panel re-run with a must-fix-loop item carry-through from R1 summary-fix. No structural gaps in the solicitor role or panel-review skill identified.
