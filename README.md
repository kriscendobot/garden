# Garden bulletin

_As of 2026-06-25T15:04:19Z · updated continuously as the job board advances (garden-bulletin.service). Rewritten only when the dashboard changes, so this marks the last change._

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
- `garden-comment-watcher-verb-imperative-gate` — Gate comment-watcher's fixed verb table on an imperative cue
- `harden-git-fetch-timeout` — Harden: timeout journal git fetches so one stalled fetch cannot wedge the fleet
- `scholar-continue-change-propagation` — Scholar: continue pursuing the change-propagation open questions (maintainer-...
- `scholar-ingest-cask-13` — Scholar: continue the library ingest of kriskowal/cask (cycle 14)
- `scholar-ingest-cask` — Scholar: deepen the library ingest of kriskowal/cask

### tada (116)
- `endojs-endo-but-for-bots-pr513-rebase` — Completion report: endojs-endo-but-for-bots-pr513-rebase
- `harden-jq-and-loud-tool-failure` — Completion report — harden-jq-and-loud-tool-failure
- `reconduct-endo-cancel-507` — Completion report — reconduct-endo-cancel-507
- `fix-watcher-verb-keyword-false-positive` — Completion report — fix-watcher-verb-keyword-false-positive
- `endojs-endo-but-for-bots-pr522-gauntlet` — Completion report: endojs-endo-but-for-bots-pr522-gauntlet
- … and 111 more

## Watch set
(none)

## Hosts
- endolinbot: 100 gardeners

## Recent progress
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
- 150010Z-progress-gardener-90c42a.md: gardener-68 on endolinbot claimed job endojs-endo-but-for-bots-pr513-rebase
- 150013Z-progress-gardener-b35a3e.md: gardener-24 on endolinbot completed job harden-jq-and-loud-tool-failure
- 150349Z-progress-gardener-3ef588.md: gardener-99 on endolinbot claimed job garden-comment-watcher-verb-imperative-gate
- 150412Z-progress-gardener-d446f2.md: gardener-68 on endolinbot completed job endojs-endo-but-for-bots-pr513-rebase
## Latest

endo-but-for-bots #513's rebase just completed and moved to tada, clearing the last of the #513 chain (its gauntlet and earlier stages landed in the same window). The todo queue is empty — every posted job is now claimed and in flight. Of the six jobs in doin, the freshly-claimed `garden-comment-watcher-verb-imperative-gate` (gating the comment-watcher's fixed verb table on an imperative cue) continues the same watcher-hardening thread the just-completed `fix-watcher-verb-keyword-false-positive` and `harden-jq-and-loud-tool-failure` jobs were on, so the fleet is still actively shoring up producer reliability. The remaining open work is the scholar's cask ingest and change-propagation cycles plus the `harden-git-fetch-timeout` reliability fix. Nothing needs maintainer attention.
