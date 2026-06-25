# Garden bulletin

_As of 2026-06-25T17:01:25Z · updated continuously as the job board advances (garden-bulletin.service). Rewritten only when the dashboard changes, so this marks the last change._

The maintainer dashboard: what needs a human first, then the state of ongoing
autonomous work. Regenerated deterministically by scripts/jobs/bulletin.sh, with a
journalist's narrative in the Latest section. This page (the journal's README.md)
IS the bulletin; the journal's layout and design narrative lives in [DESIGN.md](DESIGN.md).

## Messages to the maintainer

- `20260625T170030Z-9a0f2d` — from gardener:endojs-endo-but-for-bots-pr96-rebase, reply_to `endojs-endo-but-for-bots-pr96-rebase` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260625T170030Z-9a0f2d.md)

> Status on your endojs/endo-but-for-bots #96 comment (2026-06-25T16:51Z, nested-transitive fixtures + complete impl + extension overrides for all packages):
>
> The triager mapped this to "rebase" — a misclassification (it's a builder directive, and #96 is already MERGEABLE/CLEAN, so no rebase was warranted or performed). I routed the full directive to the LIVE worker on #96's general-case workstream (`reconcile-pr96-general-case`), which is the right owner — it has commits on the branch from an hour before your comment. It will fold in the transitive-dependency fixture (auxiliary package.json without an intermediate node_modules) and generalize the extension overrides to all packages, then reply on the PR.
>
> No competing implementation was spawned (would have collided on the same branch). Self-improvement filed: the triager verb-map needs "produce tests"/"complete the implementation" → builder, not "rebase".


## Board
### todo (0)
(none)

### doin (4)
- `build-mirror-closer-service` — Build a deterministic (no-claude) service: close our mirror PR when its upstr...
- `encode-pr-summary-comment-norm` — Encode the norm: every PR-touching job posts a top-level summary comment, not...
- `reconcile-pr96-general-case` — Reconcile PR #96 Phase 7: land the general dependency-subtree case (maintaine...
- `scholar-ingest-cask-14` — Scholar: continue the library ingest of kriskowal/cask (cycle 15) — comment-f...

### tada (129)
- `endojs-endo-but-for-bots-pr96-rebase` — Completion report — endojs-endo-but-for-bots-pr96-rebase
- `endojs-endo-but-for-bots-pr96-d9e3df0b` — Completion report — endojs-endo-but-for-bots-pr96-d9e3df0b (attention/routing)
- `design-propagator-endo-exo` — Job complete.
- `reconstruct-cancel-on-llm` — Inbox empty. The job is already satisfied — I will not duplicate the work. Wr...
- `shepherd-ebfb-pr96` — Completion report
- … and 124 more

## Watch set
(none)

## Hosts
- endolinbot: 100 gardeners

## Recent progress
- 154136Z-progress-gardener-3a798b.md: gardener-47 on endolinbot completed job fix-reaper-requeue-reliability
- 154945Z-progress-gardener-35fe1c.md: gardener-33 on endolinbot completed job finish-ebfb-pr96
- 155052Z-progress-gardener-af96ac.md: gardener-76 on endolinbot completed job shepherd-ebfb-pr96
- 164312Z-progress-gardener-6027f4.md: gardener-65 on endolinbot claimed job reconstruct-cancel-on-llm
- 164519Z-progress-gardener-82a378.md: gardener-26 on endolinbot claimed job design-propagator-endo-exo
- 164527Z-progress-gardener-cef1d0.md: gardener-65 on endolinbot completed job reconstruct-cancel-on-llm
- 164928Z-progress-gardener-f4c253.md: gardener-6 on endolinbot claimed job reconcile-pr96-general-case
- 165144Z-result-designer-6c372a.md: Designed a Radul/Sussman propagator at the Endo and Exo layers (job
- 165157Z-progress-gardener-4127f0.md: gardener-23 on endolinbot claimed job endojs-endo-but-for-bots-pr96-d9e3df0b
- 165247Z-progress-gardener-5e2152.md: gardener-26 on endolinbot completed job design-propagator-endo-exo
- 165527Z-progress-gardener-161cc7.md: gardener-100 on endolinbot claimed job encode-pr-summary-comment-norm
- 165633Z-progress-gardener-8d7ae7.md: gardener-21 on endolinbot claimed job endojs-endo-but-for-bots-pr96-rebase
- 165710Z-progress-gardener-2f0a2c.md: gardener-23 on endolinbot completed job endojs-endo-but-for-bots-pr96-d9e3df0b
- 170043Z-progress-gardener-49f9b9.md: gardener-4 on endolinbot claimed job build-mirror-closer-service
- 170106Z-progress-gardener-479ef9.md: gardener-21 on endolinbot completed job endojs-endo-but-for-bots-pr96-rebase
## Latest

The board cleared its backlog (todo now empty) as the misclassified `endojs-endo-but-for-bots-pr96-rebase` job completed — the work was correctly recognized as a builder directive on #96 (already MERGEABLE/CLEAN, so no rebase was warranted) and rerouted to the live `reconcile-pr96-general-case` worker, which already had branch commits and will fold in the nested-transitive fixture and generalize extension overrides before replying on the PR. That routing decision was escalated to the maintainer inbox, with a self-improvement filed to teach the triager verb-map that "produce tests"/"complete the implementation" maps to builder, not rebase. The newly claimed `build-mirror-closer-service` (a deterministic, no-Claude service to auto-close mirror PRs once their upstream merges) begins work alongside the in-flight PR-summary-comment norm encoding and the cask cycle-15 scholar ingest.
