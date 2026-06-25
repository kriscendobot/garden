# Garden bulletin

_As of 2026-06-25T16:48:06Z · updated continuously as the job board advances (garden-bulletin.service). Rewritten only when the dashboard changes, so this marks the last change._

The maintainer dashboard: what needs a human first, then the state of ongoing
autonomous work. Regenerated deterministically by scripts/jobs/bulletin.sh, with a
journalist's narrative in the Latest section. This page (the journal's README.md)
IS the bulletin; the journal's layout and design narrative lives in [DESIGN.md](DESIGN.md).

## Messages to the maintainer

(no pending maintainer messages)

## Board
### todo (0)
(none)

### doin (2)
- `design-propagator-endo-exo` — Design: a Sussman/Radul propagator at the Endo and Exo layers
- `scholar-ingest-cask-14` — Scholar: continue the library ingest of kriskowal/cask (cycle 15) — comment-f...

### tada (126)
- `reconstruct-cancel-on-llm` — Inbox empty. The job is already satisfied — I will not duplicate the work. Wr...
- `shepherd-ebfb-pr96` — Completion report
- `finish-ebfb-pr96` — Completion report — finish endo-but-for-bots #96 (Phase 7)
- `fix-reaper-requeue-reliability` — Report: fix-reaper-requeue-reliability
- `scholar-ingest-cask-13` — Completion report — scholar-ingest-cask-13 (gardener 91, endolinbot)
- … and 121 more

## Watch set
(none)

## Hosts
- endolinbot: 100 gardeners

## Recent progress
- 152754Z-progress-gardener-df8b49.md: gardener-80 on endolinbot completed job scholar-ingest-cask
- 152946Z-result-scholar-e7f75d.md: # Scholar cask ingest cycle 14 (job `scholar-ingest-cask-13`)
- 153108Z-progress-gardener-694fe6.md: gardener-24 on endolinbot claimed job scholar-ingest-cask-14
- 153243Z-progress-gardener-25fcae.md: gardener-78 on endolinbot completed job scholar-ingest-cask-13
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
## Latest

The scholar cask ingest advanced through cycles 13 and 14, but two reliability snags surfaced. `scholar-ingest-cask-13` was claimed and fully worked twice — gardeners 78 and 91 both completed it — and a `message` entry flags this double-claim as a defect worth a look at the claim race. Separately, `scholar-ingest-cask-14`'s handler failed under gardener-24, was captured as an empty-output error, escalated to the gardener inbox, and left in `doin` for the reaper; gardener-24 had claimed it, so it is the active in-flight item alongside the newly claimed `design-propagator-endo-exo`. On the upside, `fix-reaper-requeue-reliability` landed, and the endo-but-for-bots #96 thread closed out cleanly with both `shepherd-ebfb-pr96` and `finish-ebfb-pr96` completing. `reconstruct-cancel-on-llm` resolved as a no-op — its inbox was empty and the work was already satisfied.
