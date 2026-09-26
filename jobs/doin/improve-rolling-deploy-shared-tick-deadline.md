---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/rolling-deploy.sh
`journal_put` (line 108) and `journal_rm` (line 137) each start their own fresh 300s wall-clock clock (`put_start=$SECONDS`/`rm_start=$SECONDS`, checked at lines 123 and 146) instead of sharing one deadline for the whole tick, but a single tick can call them several times (catch-up per follower at 518/523, offline-clear at 544, canary release/clear at 647/725, roll-completed record at 742). Under sustained degraded connectivity each call can independently burn its full 300s allowance, so the cumulative total for a tick with multiple followers/state-transitions can exceed the unit's `TimeoutStartSec=900` (garden-rolling-deploy.service:20) even though each call is individually "bounded." That's what happened at 07:35:00 on 2026-09-26: systemd logged "garden-rolling-deploy.service: start operation timed out. Terminating" / "Failed with result 'timeout'" — a hard SIGTERM kill, not the intended clean `EX_TEMPFAIL` skip the deadline comment (lines 112-120) promises. Fix: capture one shared tick-start timestamp near the top of the script (after `ensure_clone "$DIR"` at line 104) and have `journal_put`/`journal_rm` measure elapsed time against that shared start rather than their own local one, so the cumulative budget across every journal write in one tick stays bounded well under 900s.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-26T07:53:31Z
