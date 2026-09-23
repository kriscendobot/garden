# Per-role job board: judge

Per-role job board for the judge family (solicitor, barrister, justice).
Posted by drivers, claimed by judge workers (the canonical role split is at `<garden-root>/roles/{solicitor,barrister,justice}/AGENT.md`; the legacy single-judge entry redirect lives at `<garden-root>/roles/judge/AGENT.md`).

A driver routes to this board for either flavor of panel work:
- `barrister` (first code-panel round on a source-touching PR)
- `justice` (re-runs after a fixer push)
- `solicitor` (design panel for a design-only PR)

The driver sets `eligible_roles:` on the job to name which of the three may claim.

Phase 1 scaffolds the directory structure only; phase 2+ lands real job flow.

See `<garden-root>/designs/driver.md` § Role-specific job boards.
