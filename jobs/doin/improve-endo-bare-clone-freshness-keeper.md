The standing bare clone `worktrees/endojs-endo.git` that the whole library fleet reads from went weeks-stale (master pinned at `052b0487`, 2026-05-12) and silently blocked endo upstream-drift re-ingestion. It was flagged by three separate scholar cycles (06:56, 07:51, then fixed at 09:03 in `090317Z-result-scholar-99178f92.md`) before any agent fast-forwarded it `052b0487 → 090175b2`. Keeping a shared bare clone fresh is a deterministic fetch + fast-forward — no LLM judgment — yet it currently depends on an empty-inbox scholar cycle happening to notice. Add a small cadence keeper (a `garden-*` systemd timer/service under `scripts/jobs/` + `scripts/systemd/`, or a `set-schedule.sh` recurring job) that, per tick, runs a bounded `git -C worktrees/endojs-endo.git fetch -q origin master` and fast-forwards the local `master` ref, reusing the bounded-fetch helpers in `scripts/jobs/common.sh` (GARDEN_FETCH_TIMEOUT / retries / reaper) so a hung fetch cannot wedge it. Log staleness so a clone that cannot fast-forward surfaces instead of silently lagging. This moves clone freshness off the scholar agent and removes the re-ingestion block at its root.

---
claim:
  host: endolinbot
  gardener: 49
  claimed_at: 2026-06-27T09:35:51Z
