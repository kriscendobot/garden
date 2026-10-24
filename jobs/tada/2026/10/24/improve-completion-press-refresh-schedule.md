The report wrapper now fetches the journal itself before working out its window, so a lagging ref can no longer make it report the previous 6h window. This is pushed to `main2` as ab17325c50f. The new test passes, and the existing `completion-window-report` test still passes.

**Changes to `scripts/jobs/claude-on-minion-town-completion-report.sh`.** These apply only to the default schedule-derived window, i.e. when the caller passes none of `--since`, `--schedule`, `--repo` or `--ref`:
- **Refresh:** it loads `common.sh` and syncs the producer journal clone (`ensure_clone` then `sync_clone`) under the existing clone lock.
- **Pinning:** it records the fetched `origin/journal2` tip and releases the lock, then runs the report against that fixed commit with `--repo` and `--ref`. The report can take minutes, so it doesn't hold the producer lock that long, and later producer resets can't move the ref under it.
- **Freshness check:** it reads the schedule file at that commit. If the newest `last_dispatched` is older than one cadence (6h for this schedule), it exits with a clear "current dispatch stamp is unavailable" error and prints no report. The check is valid because the scheduler writes the stamp in the same commit that posts the press job. `daily-at-*`/`weekly-at-*` cadences get a day/week plus one hour of DST slack, and an unrecognised cadence also fails with an error.
- `GARDEN_REPORT_NOW` overrides the clock for tests. An explicit `--since`/`--until` still bypasses all of this.

**New test, `scripts/jobs/test/claude-on-minion-town-completion-report-test.sh`.** It sets up a local origin and a producer clone stuck at the 07:35 dispatch, then puts the 13:50 dispatch upstream only. It checks three things:
- the wrapper reports 07:35→13:50, not the stale window;
- it fails loudly when no newer stamp exists;
- explicit `--since` still works.

**Follow-ups:**
- If a press job sits unclaimed for longer than a full cadence, the wrapper will now refuse instead of reporting. That is deliberate, but such a run will look like a failure.
- The hosts only pick this up after their next deploy.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-completion-press-refresh-schedule.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (1590482 cached reads)
- Output: 12686 tokens
- Cost: $1.1651684
- Wall-clock: 238s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
