# Plan-in-journal Phase 3: cross-repo records + dependency edges + file unfiled designs

Follow-on to implement-plan-in-journal (garden#4). Phase 0 landed 141
endo-but-for-bots records with EMPTY depends_on and ~52 designs unfiled (no
milestone), because the source endo README encodes dependencies and some milestone
membership only in prose (not mechanically extractable).

Do Phase 3 + enrichment:
- **Dependency edges:** populate `depends_on:` on the journal/plan records from the
  endo README's Mermaid dependency graph + the prose milestone narratives. Run
  scripts/jobs/plan/validate.sh (dangling-edge warnings) and skills/
  dependency-graph-maintenance (cycle check). The renderer already emits the Mermaid
  graph from depends_on.
- **File unfiled designs:** assign milestone: to the ~52 records that imported without
  one, where the endo roadmap makes membership clear.
- **Cross-repo records:** add records (with narrative) for garden-itself designs
  (repository: garden) and endojs/endo designs (repository: endo); confirm
  repositories.md covers them; let milestones span repositories. Confirm the
  agoric-sdk exclusion holds in the validator.

Bounds: bot identity; journal2 writes via an isolated worktree off origin/journal2
(NEVER reset --hard the live tree). Validate before pushing. Report what was filed.
