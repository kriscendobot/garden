# Garden bulletin

_As of 2026-06-25T16:53:05Z · updated continuously as the job board advances (garden-bulletin.service). Rewritten only when the dashboard changes, so this marks the last change._

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
- `endojs-endo-but-for-bots-pr96-d9e3df0b` — attention directive on endojs/endo-but-for-bots PR #96
- `reconcile-pr96-general-case` — Reconcile PR #96 Phase 7: land the general dependency-subtree case (maintaine...
- `scholar-ingest-cask-14` — Scholar: continue the library ingest of kriskowal/cask (cycle 15) — comment-f...

### tada (127)
- `design-propagator-endo-exo` — Job complete.
- `reconstruct-cancel-on-llm` — Inbox empty. The job is already satisfied — I will not duplicate the work. Wr...
- `shepherd-ebfb-pr96` — Completion report
- `finish-ebfb-pr96` — Completion report — finish endo-but-for-bots #96 (Phase 7)
- `fix-reaper-requeue-reliability` — Report: fix-reaper-requeue-reliability
- … and 122 more

## Watch set
(none)

## Hosts
- endolinbot: 100 gardeners

## Recent progress
- 153454Z-progress-gardener-088800.md: gardener-91 on endolinbot completed job scholar-ingest-cask-13
- 153500Z-message-scholar-bef28b.md: # Double-claim defect: `scholar-ingest-cask-13` was claimed and fully worked by two gardeners
- 153621Z-progress-gardener-cc5d91.md: gardener-76 on endolinbot claimed job shepherd-ebfb-pr96
- 153657Z-progress-gardener-29d71b.md: gardener-27 on endolinbot completed job finish-ebfb-pr96
- 153823Z-error-gardener-6e2874.md: gardener-24 on endolinbot: job scholar-ingest-cask-14 handler FAILED; output captured as e69de29bb2d1d6434b8b29ae775ad8c2e48c5391, escalated to the gardener inbox, left in doin for the reaper
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
## Latest

The propagator design landed: `design-propagator-endo-exo` moved to tada — a designer specced a Radul/Sussman-style propagator at both the Endo and Exo layers. Three jobs remain in flight: the PR #96 attention directive and its Phase-7 general-dependency-subtree reconcile, plus the cask library ingest. Two items warrant a maintainer's eye from the preceding window: a logged **double-claim defect** where `scholar-ingest-cask-13` was claimed and fully worked by two separate gardeners, and `scholar-ingest-cask-14`, whose handler failed and was escalated to the gardener inbox and left in doin for the reaper. The earlier endo-but-for-bots #96 shepherd/finish runs and the reaper requeue-reliability fix all completed cleanly.
