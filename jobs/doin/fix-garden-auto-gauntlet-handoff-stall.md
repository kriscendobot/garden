# Fix: builds' auto-gauntlet never fires (4 consecutive stalls)

Garden infrastructure fix on `main2` (scripts/jobs/gardening/, designs/gardening-state-machine.md). CLAUDE.md's invariant says a build's draft PR "auto-runs the gauntlet (clean → panel → fix-loop → un-draft) under its supervising gardener via the gardening state machine". In practice it has NOT fired on four consecutive builds in the daemon data-plane arc — endojs/endo-but-for-bots PRs #749, #783, #789, #792 (build jobs `build-endo-content-locators-magnet-urn-phase1` … `…phase4-http-web-seed`): each build completed to tada with a draft PR, then the PR sat draft with no gauntlet job anywhere on the board until a press dispatch hand-posted one (see tada reports `endo-daemon-data-plane-press-2026071{7,8}-*`). Diagnose why the builder→gauntlet hand-off does not engage — e.g. whether build jobs posted/parked by producers (post-plan.sh --blocked bodies with builder briefs) bypass the gardening state machine's post-build segment, or the segment itself fails silently — and fix it so a completed build whose PR is still draft deterministically gets its gauntlet (or the supervising gardener continues into it). Add whatever evidence trail (log line, journal record) makes the next stall visible instead of silent. Cite the root cause in the completion report.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 5
  worker_kind: cleric
  claimed_at: 2026-07-18T12:24:58Z
