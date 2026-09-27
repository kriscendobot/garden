The scheduler now puts a time limit on each schedule's preflight check, so one stuck check can no longer use up the whole scheduler run (the cause of the `garden-scheduler.service` timeout at 16:53:00Z). Pushed to `main2` as f30c60c8802. The new test passes, and the three existing scheduler tests (preflight-typo, preflight-deploy-lag, handler-timeout) still pass.

**The fix in `scripts/jobs/scheduler.sh`:**
- Each preflight now runs under `timeout`. The limit is `GARDEN_SCHEDULER_PREFLIGHT_TIMEOUT` (default 120s). If the check ignores the stop signal, it is force-killed `GARDEN_SCHEDULER_PREFLIGHT_KILL_AFTER` seconds later (default 10s).
- When a check runs out of time, the log shows `WARN schedule <name> preflight '<path>' exceeded Ns (rc=…); treating as work-present (fail-open)`.
- A timed-out check is treated like any other failed check: the schedule still posts its job. Any context the check wrote before being killed is thrown away, and its temp file is still deleted.

**Also changed:**
- `skills/schedule/SKILL.md` now describes the time limit and its settings.
- New test `scripts/jobs/test/scheduler-preflight-timeout-test.sh` runs one tick with a 2s limit, a stuck check and a healthy one. It confirms the tick ends in about 2s, the log names the stuck schedule, and the stuck schedule still posts its job without the killed check's context. It also confirms the later schedule posts normally with its own context and no temp file is left behind.

**Follow-up:** the service allows 900s per run and every due check gets up to about 130s, so roughly six stuck checks in one run could still hit the limit. That seems unlikely; a total time budget per run would close it if it ever happens.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-scheduler-preflight-time-bound.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (579666 cached reads)
- Output: 6845 tokens
- Cost: $0.7479292
- Wall-clock: 76s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
