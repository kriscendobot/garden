The worker health gate no longer reports a short CLI absence: an npm relink blip like the 2026-10-26 one now parks the pool silently. A CLI that stays missing past a 120-second window still raises one error. Pushed to `main2` as `5cdd673f46a`. `worker-health-gate-test.sh` passes 87/87, including the new cases, and `claude-bin-resolver-test.sh` passes 27/27.

**What changed** (`scripts/jobs/common.sh`, `worker_health_gate`)
- **First miss:** the worker still refuses to claim, but opens a host-local "pending" record per worker kind (`$GARDEN_STATE/health/<kind>.missing-pending`) instead of reporting.
- **Claims:** refused on every miss throughout the window. Only the report waits.
- **Sustained miss:** once the CLI has been missing for `GARDEN_WORKER_HEALTH_CONFIRM_SECS` (default 120s), it opens the episode and sends one error entry and maintainer notice. The pending record is cleared and recovery is reported once, as before.
- **Recovery inside the window:** the pending record is deleted with no error entry, no recovery entry and no notice. The 07:46:56Z → 07:47:36Z absence would now produce nothing.
- **Stop-awareness:** the gate never sleeps. The window is measured from timestamps in the state directory, so the poll loop's drain/stop checks and backoff are unchanged, and timer-driven one-shot workers share the window across ticks.
- **Bounds:**
  - If no worker refreshes the pending record for `GARDEN_WORKER_HEALTH_CONFIRM_GAP` seconds (default 300s, for example because the pool was stopped), or its start time is in the future, the window restarts rather than counting that time as missing.
  - If the state directory can't be written, the gate falls back to reporting on the first miss.
  - Setting `GARDEN_WORKER_HEALTH_CONFIRM_SECS=0` restores the old immediate report.
- **Unchanged:** the model-too-old and dead-credential episodes still report immediately.

**Tests and docs**
- `scripts/jobs/test/worker-health-gate-test.sh` gains SUBTEST 9, covering:
  - a blip refuses claims but reports nothing;
  - a sustained miss reports exactly once, then reports its recovery once;
  - a stale pending record restarts the window.
- Subtests 2–8 now set the window to 0 so they still test the immediate report on its own.
- `designs/job-board.md` (the health-gate section) documents the confirmation window.

**Follow-ups:** none required. Hosts pick this up on their next rolling deploy.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-worker-cli-health-debounce.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (1035076 cached reads)
- Output: 10819 tokens
- Cost: $1.0152431999999998
- Wall-clock: 222s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
