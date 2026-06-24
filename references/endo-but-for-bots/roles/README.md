# Roles (residual reference shelf)

The garden has adopted most reference roles into its own active library at `<garden-root>/roles/`. What remains here is the **residual set**: roles whose substance has not yet been folded in. The liaison consults these when a user prompt has no obvious fit in the active library.

For how references work, see [`../../README.md`](../../README.md).

## Residual roles

- [chronicler.md](./chronicler.md) — doc-debt audit role. Maintains per-package `process/doc-debt/<package>.md` and the doc-debt queue; hands off to the [scribe](./scribe.md) for the writing. The garden has no doc-debt posture yet; adopt when documentation-debt becomes a first-class engagement.
- [juror.md](./juror.md) — the reference's single-juror role (pre-panel-split). The garden's active jury is the twelve-seat panel dispatched by the [judge](../../../roles/judge/AGENT.md). Keep as the ancestor of the active panel if a future engagement wants a standalone reviewer.
- [marshal.md](./marshal.md) — design-pipeline pick-next with the continuous-occupancy invariant (floor 1, ceiling 3 in flight). The active steward has no design-pick-next analog yet; adopt when designs become a first-class garden surface.
- [namer.md](./namer.md) — three-laws naming procedure: verify the source name, scan sibling PRs for already-applied conventions, apply the project's case discipline. Adopt as a role (or fold into `rename-discipline` skill) when the garden takes on naming-heavy work.
- [scribe.md](./scribe.md) — doc-builder counterpart to [chronicler](./chronicler.md). Adopt together with chronicler when doc-debt lands.
- [stratego.md](./stratego.md) — upstream-port stack planner (substance map, dependency graph for clusters, drop-liberally posture). Highly specific to the bots-llm vs upstream-master scenario; useful when a long-running fork wants to land upstream and the boatman's per-PR ferry is not enough.
- [triager.md](./triager.md) — cross-repo population survey role with controlled vocabulary and editorial-audit-cap-up-front discipline. Adopt when a maintainer requests a cross-corpus audit (e.g., classify every open PR across the endojs org).

## Adopted (no longer in this shelf)

The following reference roles have been fully adopted into the active library and the snapshots removed: botanist, builder, cleaner, conductor, designer, director (folded into the active [steward](../../../roles/steward/AGENT.md)), fixer, groom, investigator, liaison, major-general, saboteur, scout, shepherd, steward, watchman-cadence + watchman-events + watchman-schedule (folded into [steward](../../../roles/steward/AGENT.md), [monitor](../../../roles/monitor/AGENT.md), [timekeeper](../../../roles/timekeeper/AGENT.md), [`scheduling`](../../../skills/scheduling/SKILL.md)), weaver.

The full adoption history is in the journal; `git log -- references/endo-but-for-bots/roles/` on `main` traces the deletions.
