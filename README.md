# Garden bulletin

_As of 2026-06-25T17:03:15Z · updated continuously as the job board advances (garden-bulletin.service). Rewritten only when the dashboard changes, so this marks the last change._

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
- `mirror-and-shepherd-endo-3254` — Mirror endojs/endo#3254 onto endo-but-for-bots, record the mapping, and sheph...
- `reconcile-pr96-general-case` — Reconcile PR #96 Phase 7: land the general dependency-subtree case (maintaine...
- `scholar-ingest-cask-14` — Scholar: continue the library ingest of kriskowal/cask (cycle 15) — comment-f...

### tada (130)
- `encode-pr-summary-comment-norm` — Done. The norm is encoded and pushed to origin/main2.
- `endojs-endo-but-for-bots-pr96-rebase` — Completion report — endojs-endo-but-for-bots-pr96-rebase
- `endojs-endo-but-for-bots-pr96-d9e3df0b` — Completion report — endojs-endo-but-for-bots-pr96-d9e3df0b (attention/routing)
- `design-propagator-endo-exo` — Job complete.
- `reconstruct-cancel-on-llm` — Inbox empty. The job is already satisfied — I will not duplicate the work. Wr...
- … and 125 more

## Watch set
(none)

## Hosts
- endolinbot: 100 gardeners

## Recent progress
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
- 170245Z-progress-gardener-bea046.md: gardener-8 on endolinbot claimed job mirror-and-shepherd-endo-3254
- 170301Z-progress-gardener-9d2d15.md: gardener-100 on endolinbot completed job encode-pr-summary-comment-norm
## Latest

The PR-summary-comment norm landed: `encode-pr-summary-comment-norm` completed and pushed to origin/main2, closing the loop on kriskowal's #474/#513 feedback that PR work needs a top-level summary comment alongside inline replies. A new job, `mirror-and-shepherd-endo-3254`, was just claimed and is underway (mirroring endojs/endo#3254 onto endo-but-for-bots and shepherding it). Four jobs are now in flight, including the ongoing #96 general-case reconciliation. One item wants a human's eye: a gardener flagged that kriskowal's latest #96 comment (nested-transitive fixtures + complete impl + extension overrides) was mis-triaged as a "rebase" when it was a builder directive — it was correctly re-routed to the live `reconcile-pr96-general-case` worker rather than spawning a colliding implementation, and a self-improvement was filed to teach the triager verb-map that "produce tests"/"complete the implementation" maps to builder, not rebase.
