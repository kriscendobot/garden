Pushed to main2 on the first attempt. The job is complete.

## Completion report

**What the job asked:** make job completion a deterministic explicit signal rather than "handler exited 0," so a `claude` that exits without genuinely finishing (API error, rate limit, quota exhaustion, or a clean-but-unsatisfying exit-0) is requeued to `todo` instead of being marked done and lost in `tada`.

**Root cause confirmed:** `gardener.sh` ran `complete-job.sh` (doin→tada) on any handler exit 0, and `complete-job.sh` moved the job with no validation — so an exit-0-unsatisfying run was recorded as done and never reaped.

**What I changed** (committed `a4d55c3da`, pushed to `main2`):

1. **The signal (two-layer, deterministic):**
   - `common.sh`: added `GARDEN_COMPLETION_MARKER` plus `report_has_completion_marker` (last-line-anchored, so a quoted marker can't forge completion) and `strip_completion_marker`.
   - `handlers/gardener-claude.sh`: the `claude -p` worker is instructed to emit the marker as its report's final line **only** when genuinely finished; after claude exits 0 the handler confirms the marker, strips it, and writes the sentinel at `GARDEN_COMPLETION_SENTINEL`. Worktree teardown is now keyed on the sentinel (a would-be-requeued run keeps its worktree for resume), not the bare exit code.

2. **The gate (`gardener.sh`):** captures the handler rc explicitly and branches three ways — (exit 0 + sentinel)=complete doin→tada; **(exit 0 + no sentinel)=new exit-0-unsatisfying branch** that requeues via the reaper's single-writer reap-now path (leave in doin + reap-now hint, kind:progress note, no escalation); (non-zero)=the existing transient-vs-real classifier, unchanged.

3. **All four modes → requeue, bounded:** API error / rate limit / quota are non-zero with a transient signature (existing path, kept); clean-but-unsatisfying exit-0 is the new path. All funnel into the reaper's reap-now→requeue→`garden-reaped:N` poison counter, so a job that never completes is dropped and surfaced to the maintainer after `GARDEN_REAP_POISON_THRESHOLD` — never silently lost, never infinitely requeued. **The reaper needed no change** (it reuses the existing machinery).

4. **`complete-job.sh` left as a dumb primitive** — it is also called directly (e.g. run-test subtests), so the gate correctly lives in `gardener.sh` per the directive.

**Verification:**
- New `completion-signal-test.sh` (+ `completion-signal-handler-stub.sh`): 17/17 pass — pure helpers, (b) exit-0-with-signal→tada, (a) exit-0-without-signal→NOT tada then reaper requeues to todo, (c) all four modes→requeue, and the poison bound (never-completing job dropped + surfaced to maintainer).
- Updated `stub-handler.sh` and `gardener-worktree-test.sh` to the new sentinel contract; both green (16/16 worktree).
- No regressions: `run-test.sh 4 6` (26 subtests incl. reaper/poison), `signal-kill`, `timeout`, `empty-output`, and `claude-session-limit` classifier tests all pass. `bash -n` clean on every changed file (CI runs `bash -n` broadly; strict shellcheck's explicit list doesn't include these files).

**Follow-ups / notes:** the pre-existing "failed-job lane" OPEN question (dedicated `jobs/failed/` vs staying in doin, flagged in `gardener.sh`) is untouched — deliberately out of scope. Inbox was empty during the run.
