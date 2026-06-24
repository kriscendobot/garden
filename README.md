# Garden bulletin

_As of 2026-06-24T22:08:52Z · updated continuously as the job board advances (garden-bulletin.service). Rewritten only when the dashboard changes, so this marks the last change._

The maintainer dashboard: what needs a human first, then the state of ongoing
autonomous work. Regenerated deterministically by scripts/jobs/bulletin.sh, with a
journalist's narrative in the Latest section. This page (the journal's README.md)
IS the bulletin; the journal's layout and design narrative lives in [DESIGN.md](DESIGN.md).

## Messages to the maintainer

(no pending maintainer messages)

## Board
- todo: 0
- doin: 10
- tada: 64

## Watch set
(none)

## Hosts
- endolinbot: 100 gardeners

## Recent progress
- 202329Z-result-scholar-899e98.md: Scholar cycle for job `scholar-ingest-new-forks` (gardener 64 on endolinbot).
- 202543Z-progress-gardener-601be2.md: gardener-26 on endolinbot claimed job scholar-ingest-frb
- 202545Z-progress-gardener-29e136.md: gardener-36 on endolinbot claimed job scholar-ingest-cask
- 202624Z-progress-gardener-f95aa9.md: gardener-64 on endolinbot completed job scholar-ingest-new-forks
- 202833Z-progress-gardener-9917a3.md: gardener-14 on endolinbot claimed job build-pr-comment-watcher
- 203503Z-progress-gardener-bfc0d8.md: gardener-94 on endolinbot claimed job scholar-ingest-frb-2
- 203521Z-result-scholar-6b5904.md: ts: 2026-06-24
- 203607Z-progress-gardener-5da9f8.md: gardener-26 on endolinbot completed job scholar-ingest-frb
- 203617Z-progress-gardener-74480a.md: gardener-91 on endolinbot completed job audit-inbox-discipline-and-deadmail
- 203644Z-progress-gardener-dd4c5b.md: gardener-74 on endolinbot claimed job harden-producer-push-path
- 204029Z-progress-gardener-b890ee.md: gardener-58 on endolinbot claimed job finish-ebfb-pr96
- 204146Z-progress-gardener-0968a9.md: gardener-7 on endolinbot claimed job scholar-ingest-cask-2
- 204152Z-result-scholar-e0c77c.md: Scholar cycle for job `scholar-ingest-collections` (gardener 19 on endolinbot). Continues the `kriskowal/collections` ingest begun by `scholar-ingest-new-forks` (which filed only the root README). Read-only from a scratch clone of `kriskowal/collections` (default branch `master`, HEAD `c7855495`).
- 204201Z-result-scholar-bf7c5a.md: project: cask
- 220841Z-progress-gardener-83517f.md: gardener-51 on endolinbot claimed job fix-bulletin-unit-type
## Latest

Two garden-infra jobs just landed in flight: gardener-51 claimed `fix-bulletin-unit-type`, and `harden-fleet-gh-identity` also moved into doin — both reliability fixes to the bulletin unit and fleet GitHub identity. They join an already-busy board (10 jobs in progress, nothing waiting). The scholar ingest sweep is the bulk of recent throughput: `scholar-ingest-new-forks` and `scholar-ingest-frb` completed, with `collections`, `cask`, `frb-2`, and `cask-2` cycles still working their way through. On the PR side, `build-pr-comment-watcher` and `finish-ebfb-pr96` are claimed and active, and `audit-inbox-discipline-and-deadmail` finished. Nothing here needs a maintainer's hand — no pending messages and no watch-set items.
