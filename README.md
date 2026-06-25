# Garden bulletin

_As of 2026-06-25T17:27:34Z · updated continuously as the job board advances (garden-bulletin.service). Rewritten only when the dashboard changes, so this marks the last change._

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

### doin (3)
- `address-review-garden-pr4` — Address kriskowal's review on garden#4 (the cross-repo plan-in-journal design)
- `fix-ebfb-pr503-banners-and-set` — fix endojs/endo-but-for-bots PR #503 — banners (generally) + set perf
- `scholar-ingest-cask-14` — Scholar: continue the library ingest of kriskowal/cask (cycle 15) — comment-f...

### tada (134)
- `endojs-endo-but-for-bots-pr503-7822ef8a` — Completion report — job endojs-endo-but-for-bots-pr503-7822ef8a
- `build-mirror-closer-service` — Completion report — build-mirror-closer-service
- `mirror-and-shepherd-endo-3254` — Waiting for CI. The background poll on PR #530's matrix will notify me when i...
- `reconcile-pr96-general-case` — Completion report: reconcile-pr96-general-case
- `encode-pr-summary-comment-norm` — Done. The norm is encoded and pushed to origin/main2.
- … and 129 more

## Watch set
(none)

## Hosts
- endolinbot: 100 gardeners

## Recent progress
- 165247Z-progress-gardener-5e2152.md: gardener-26 on endolinbot completed job design-propagator-endo-exo
- 165527Z-progress-gardener-161cc7.md: gardener-100 on endolinbot claimed job encode-pr-summary-comment-norm
- 165633Z-progress-gardener-8d7ae7.md: gardener-21 on endolinbot claimed job endojs-endo-but-for-bots-pr96-rebase
- 165710Z-progress-gardener-2f0a2c.md: gardener-23 on endolinbot completed job endojs-endo-but-for-bots-pr96-d9e3df0b
- 170043Z-progress-gardener-49f9b9.md: gardener-4 on endolinbot claimed job build-mirror-closer-service
- 170106Z-progress-gardener-479ef9.md: gardener-21 on endolinbot completed job endojs-endo-but-for-bots-pr96-rebase
- 170245Z-progress-gardener-bea046.md: gardener-8 on endolinbot claimed job mirror-and-shepherd-endo-3254
- 170301Z-progress-gardener-9d2d15.md: gardener-100 on endolinbot completed job encode-pr-summary-comment-norm
- 170707Z-progress-gardener-4de159.md: gardener-6 on endolinbot completed job reconcile-pr96-general-case
- 171029Z-progress-gardener-0f6cbf.md: gardener-8 on endolinbot completed job mirror-and-shepherd-endo-3254
- 171307Z-progress-gardener-a894b6.md: gardener-40 on endolinbot claimed job endojs-endo-but-for-bots-pr503-7822ef8a
- 171742Z-progress-gardener-e4bc20.md: gardener-4 on endolinbot completed job build-mirror-closer-service
- 172336Z-progress-gardener-3ec5cd.md: gardener-37 on endolinbot claimed job fix-ebfb-pr503-banners-and-set
- 172436Z-progress-gardener-37983e.md: gardener-40 on endolinbot completed job endojs-endo-but-for-bots-pr503-7822ef8a
- 172701Z-progress-gardener-3c08a3.md: gardener-15 on endolinbot claimed job address-review-garden-pr4
## Latest

A gardener just claimed `address-review-garden-pr4`, picking up kriskowal's review on the cross-repo plan-in-journal design (garden#4); the board now holds three live jobs and an empty todo queue. The item most worth a look is the unread maintainer message on endojs/endo-but-for-bots #96: the triager misclassified your "nested-transitive fixtures + complete impl + extension overrides" comment as a "rebase" when it was a builder directive, and #96 was already MERGEABLE/CLEAN — the directive was instead routed to the live `reconcile-pr96-general-case` worker (which since completed), and a self-improvement was filed to fix the verb map. Upstream of this turn, four jobs landed: the PR #503 banners/set-perf pass (now being re-worked under `fix-ebfb-pr503-banners-and-set`), the mirror-closer service build, the endo #3254 mirror-and-shepherd (now waiting on CI), and the PR-summary-comment norm encoding to main2.
