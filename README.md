# Garden bulletin

_As of 2026-06-25T17:39:21Z · updated continuously as the job board advances (garden-bulletin.service). Rewritten only when the dashboard changes, so this marks the last change._

The maintainer dashboard: what needs a human first, then the state of ongoing
autonomous work. Regenerated deterministically by scripts/jobs/bulletin.sh, with a
journalist's narrative in the Latest section. This page (the journal's README.md)
IS the bulletin; the journal's layout and design narrative lives in [DESIGN.md](DESIGN.md).

## Messages to the maintainer

(no pending maintainer messages)

## Board
### todo (0)
(none)

### doin (3)
- `bulletin-restructure-latest-top-parked-prs` — Restructure the bulletin: lead with "Latest" (claude summary + PR links), dro...
- `fix-ebfb-pr503-banners-and-set` — fix endojs/endo-but-for-bots PR #503 — banners (generally) + set perf
- `scholar-ingest-cask-14` — Scholar: continue the library ingest of kriskowal/cask (cycle 15) — comment-f...

### tada (135)
- `address-review-garden-pr4` — The worktree was removed (the earlier error was just the shell's cwd being de...
- `endojs-endo-but-for-bots-pr503-7822ef8a` — Completion report — job endojs-endo-but-for-bots-pr503-7822ef8a
- `build-mirror-closer-service` — Completion report — build-mirror-closer-service
- `mirror-and-shepherd-endo-3254` — Waiting for CI. The background poll on PR #530's matrix will notify me when i...
- `reconcile-pr96-general-case` — Completion report: reconcile-pr96-general-case
- … and 130 more

## Watch set
(none)

## Hosts
- endolinbot: 100 gardeners

## Recent progress
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
- 173210Z-progress-gardener-28cca0.md: gardener-73 on endolinbot claimed job bulletin-restructure-latest-top-parked-prs
- 173300Z-progress-gardener-edffee.md: gardener-15 on endolinbot completed job address-review-garden-pr4
## Latest

The board drained its todo queue to zero — every open item has been claimed. The mirror-closer service (`build-mirror-closer-service`) landed, giving the fleet deterministic closing of mirror PRs when their upstream counterparts close, and the `mirror-and-shepherd-endo-3254` job completed after its CI poll cleared. Work on endo-but-for-bots PR #96 wrapped a rebase plus a `reconcile-pr96-general-case` pass, and a first round on PR #503 (`7822ef8a`) completed before a follow-up job for banner and set-perf fixes was immediately claimed. Three jobs remain in flight: the PR #503 banner/set fix, the scholar's cask ingest (cycle 15), and a self-referential bulletin restructure to lead with "Latest" and surface parked PRs. Nothing is waiting on the maintainer.
