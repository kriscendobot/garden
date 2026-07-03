The 08:08Z gardener entry shows a full press-driver tick consumed just to decide "observe-and-defer — the chain owns the branch and is advancing" — an agent doing deterministic gatekeeping. The stall bar it applied is fully mechanical: take the wheel only if branch HEAD is unchanged across two consecutive ticks AND no live `xs2rust-endor-build-stage3-*` child is in `journal:jobs/doin/`/on the bus AND arrays is no longer in doin without a successor promoted. Author the missing `scripts/jobs/gardening/xs2rust-endor-press-preflight.sh` (already referenced by the schedule) to encode exactly this: persist last-seen HEAD in per-host `$GARDEN_STATE` state, exit 2 ("no work") while the chain is healthily advancing (HEAD moved or a live stage3 child exists), and exit 0 (dispatch the Fable driver) only when the stall bar is met. This moves the observe-and-defer judgment off the hourly agent onto the scheduler's plain-code gate, saving a Fable dispatch per 30m tick and giving the gate the file it was configured to run.

<!-- garden-reaped: 1 -->

---
claim:
  host: endolinbot2
  gardener: 17
  claimed_at: 2026-07-03T08:43:11Z
