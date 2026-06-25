# Garden bulletin

_As of 2026-06-25T14:58:40Z · updated continuously as the job board advances (garden-bulletin.service). Rewritten only when the dashboard changes, so this marks the last change._

The maintainer dashboard: what needs a human first, then the state of ongoing
autonomous work. Regenerated deterministically by scripts/jobs/bulletin.sh, with a
journalist's narrative in the Latest section. This page (the journal's README.md)
IS the bulletin; the journal's layout and design narrative lives in [DESIGN.md](DESIGN.md).

## Messages to the maintainer

(no pending maintainer messages)

## Board
### todo (0)
(none)

### doin (6)
- `finish-ebfb-pr96` — Finish endo-but-for-bots #96 implementation as designed
- `harden-git-fetch-timeout` — Harden: timeout journal git fetches so one stalled fetch cannot wedge the fleet
- `harden-jq-and-loud-tool-failure` — Harden against the jq outage: add jq to the image, fail loudly on missing tools
- `scholar-continue-change-propagation` — Scholar: continue pursuing the change-propagation open questions (maintainer-...
- `scholar-ingest-cask-13` — Scholar: continue the library ingest of kriskowal/cask (cycle 14)
- `scholar-ingest-cask` — Scholar: deepen the library ingest of kriskowal/cask

### tada (114)
- `reconduct-endo-cancel-507` — Completion report — reconduct-endo-cancel-507
- `fix-watcher-verb-keyword-false-positive` — Completion report — fix-watcher-verb-keyword-false-positive
- `endojs-endo-but-for-bots-pr522-gauntlet` — Completion report: endojs-endo-but-for-bots-pr522-gauntlet
- `endojs-endo-but-for-bots-pr513-be1cd0d3` — The background poll (bg7sf6864) is running and will notify me when CI converg...
- `endojs-endo-but-for-bots-pr513-gauntlet` — Fix pushed, review thread answered, CI in flight. I'll resume when the poller...
- … and 109 more

## Watch set
(none)

## Hosts
- endolinbot: 100 gardeners

## Recent progress
- 144252Z-progress-gardener-207a7a.md: gardener-21 on endolinbot completed job endojs-endo-but-for-bots-pr519-1d79f1bc
- 144402Z-progress-gardener-8a325f.md: gardener-11 on endolinbot claimed job fix-watcher-verb-keyword-false-positive
- 144424Z-progress-gardener-b383c7.md: gardener-6 on endolinbot completed job endojs-endo-but-for-bots-pr526-rebase
- 144457Z-progress-gardener-651f8c.md: gardener-17 on endolinbot completed job endojs-endo-but-for-bots-pr519-f2f4c5ca
- 144515Z-result-gardener-9580e6.md: ---
- 144527Z-progress-gardener-4bffbe.md: gardener-24 on endolinbot claimed job harden-jq-and-loud-tool-failure
- 144538Z-progress-gardener-75491a.md: gardener-29 on endolinbot claimed job reconduct-endo-cancel-507
- 144542Z-progress-gardener-ee1e3a.md: gardener-81 on endolinbot completed job endojs-endo-but-for-bots-pr503-95390ef3
- 144640Z-progress-gardener-22199b.md: gardener-59 on endolinbot completed job endojs-endo-but-for-bots-pr513-gauntlet
- 144825Z-progress-gardener-48bc31.md: gardener-87 on endolinbot completed job endojs-endo-but-for-bots-pr513-be1cd0d3
- 144918Z-progress-gardener-771a75.md: gardener-83 on endolinbot completed job endojs-endo-but-for-bots-pr522-gauntlet
- 145023Z-progress-gardener-93d99f.md: gardener-11 on endolinbot completed job fix-watcher-verb-keyword-false-positive
- 145036Z-progress-gardener-672044.md: gardener-29 on endolinbot completed job reconduct-endo-cancel-507
- 145057Z-progress-gardener-024a2c.md: gardener-44 on endolinbot claimed job scholar-continue-change-propagation
- 145829Z-progress-gardener-056f3d.md: gardener-62 on endolinbot claimed job harden-git-fetch-timeout
## Latest

A reliability‑hardening job, `harden-git-fetch-timeout` (timeout journal git fetches so one stalled fetch can't wedge the fleet), was just claimed into doin — joining its sibling `harden-jq-and-loud-tool-failure`, the two together closing out the lessons from the recent jq/comms outage. The board's todo queue is now empty, with all six in‑flight jobs in active progress. Behind that, a wave of endo‑but‑for‑bots gauntlet work has been clearing: PRs #513 (gauntlet and follow‑up), #519, #522, #503, and #526's rebase all completed, alongside `fix-watcher-verb-keyword-false-positive` and `reconduct-endo-cancel-507`. The remaining doin work is now dominated by the three scholar library‑ingest jobs (cask and change‑propagation) plus the endo‑but‑for‑bots #96 implementation. Nothing awaits the maintainer.
