# Garden bulletin

_As of 2026-06-24T22:16:31Z · updated continuously as the job board advances (garden-bulletin.service). Rewritten only when the dashboard changes, so this marks the last change._

The maintainer dashboard: what needs a human first, then the state of ongoing
autonomous work. Regenerated deterministically by scripts/jobs/bulletin.sh, with a
journalist's narrative in the Latest section. This page (the journal's README.md)
IS the bulletin; the journal's layout and design narrative lives in [DESIGN.md](DESIGN.md).

## Messages to the maintainer

(no pending maintainer messages)

## Board
- todo: 0
- doin: 8
- tada: 66

## Watch set
(none)

## Hosts
- endolinbot: 100 gardeners

## Recent progress
- 203607Z-progress-gardener-5da9f8.md: gardener-26 on endolinbot completed job scholar-ingest-frb
- 203617Z-progress-gardener-74480a.md: gardener-91 on endolinbot completed job audit-inbox-discipline-and-deadmail
- 203644Z-progress-gardener-dd4c5b.md: gardener-74 on endolinbot claimed job harden-producer-push-path
- 204029Z-progress-gardener-b890ee.md: gardener-58 on endolinbot claimed job finish-ebfb-pr96
- 204146Z-progress-gardener-0968a9.md: gardener-7 on endolinbot claimed job scholar-ingest-cask-2
- 204152Z-result-scholar-e0c77c.md: Scholar cycle for job `scholar-ingest-collections` (gardener 19 on endolinbot). Continues the `kriskowal/collections` ingest begun by `scholar-ingest-new-forks` (which filed only the root README). Read-only from a scratch clone of `kriskowal/collections` (default branch `master`, HEAD `c7855495`).
- 204201Z-result-scholar-bf7c5a.md: project: cask
- 220841Z-progress-gardener-83517f.md: gardener-51 on endolinbot claimed job fix-bulletin-unit-type
- 221008Z-progress-gardener-e79cb6.md: gardener-51 on endolinbot completed job fix-bulletin-unit-type
- 221215Z-progress-gardener-2f7bf1.md: gardener-53 on endolinbot claimed job build-pr-comment-watcher
- 221237Z-progress-gardener-525ed8.md: gardener-22 on endolinbot claimed job scholar-ingest-collections
- 221241Z-progress-gardener-3138b4.md: gardener-3 on endolinbot claimed job scholar-ingest-frb-2
- 221426Z-message-gardener-30f2af.md: # Authorization: comment-watching for endojs/endo-but-for-bots
- 221603Z-progress-gardener-8b06ff.md: gardener-53 on endolinbot completed job build-pr-comment-watcher
- 221615Z-progress-gardener-6931dc.md: gardener-60 on endolinbot claimed job harden-producer-push-path
## Latest

The PR/issue comment watcher landed — `build-pr-comment-watcher` moved to tada (gardener-53), completing the job-board side of the verb-table → reactji → verified-job-post flow committed at HEAD. Backing it, a gardener filed a `message` recording maintainer authorization to monitor comments on `endojs/endo-but-for-bots`, the one repo gated enough to be monitor-safe. Otherwise the board is steady: `harden-producer-push-path` and `port-ebfb-pr57-onto-475` are both still in progress (claims refreshed, not yet done), leaving 8 jobs in flight and an empty todo queue.
