I changed the dependabotany preflight so it now retires its own `dependabotany-recheck-<project>` schedule through `remove-schedule.sh`; a botanist no longer has to delete it by hand. It is pushed to `main2` as `3b98faac700`, and the new tests and the neighboring scheduler tests all pass.

**When it retires the schedule.** All of these must hold on an idle tick (exit 2):
- There are zero open `dependabot[bot]` PRs.
- The project's ledger was actually found, not just empty or unreadable.
- No active rows are left once drains, per-PR terminal markers and PRs closed during this run are taken into account.

A tick with a live embargo that hasn't matured yet keeps the schedule, since the backstop still has a job then.

**Failure handling.** Any failure, timeout or doubt leaves the schedule in place:
- **Stale-check:** `remove-schedule.sh` has a new `--expect-blob <sha>` option. It removes the schedule only while the file is still exactly the version the preflight read. If someone rewrote it in the meantime, it exits 3 and keeps it.
- **Bounds:** the removal is limited by the preflight's remaining time budget (at most 30s by default) and 3 push attempts. A failure, timeout or exit 3 is logged and keeps the schedule, but the preflight still exits 2, so tomorrow's tick tries again.
- **Off switch:** `GARDEN_DEPB_RETIRE=0` turns self-retirement off.

**Scheduler fix.** Once the preflight deletes the schedule mid-tick, the scheduler's own commit recording the run loses the push race. On the retry, reading the now-missing file crashed `scheduler.sh` (rc=2) and skipped every later schedule in that tick. The scheduler now checks for the file after each sync and skips a schedule that has been retired, so it is not written back. I confirmed the new test fails without this fix.

**Tests**
- `scripts/jobs/test/dependabotany-preflight-test.sh` has 15 new assertions, 60 passing in total. They cover:
  - a drained ledger, and a ledger emptied by a deterministic close, both retiring the schedule;
  - an unmatured embargo, an open PR, an empty ledger and the off switch all keeping it;
  - a failing or hung removal keeping it with exit 2;
  - the `--expect-blob` mismatch and already-absent cases.
- New `scripts/jobs/test/scheduler-preflight-retire-test.sh` (4 passing): the schedule stays deleted and no job is posted.
- The tempfail, timeout, typo, handler-timeout and anchored-cadence scheduler tests all still pass.

`roles/botanist/AGENT.md` now says the gate deletes the schedule itself.

**Remaining gap.** If a botanist re-arms an existing schedule without changing its content, in the seconds between the preflight's read and its removal, the stale-check can't see it, so the daily backstop could be deleted for that new PR. It is low risk: that PR's own one-time recheck at its maturity date (the primary mechanism) still fires. No follow-up job is posted.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-retire-drained-dependabotany-schedule.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (2246201 cached reads)
- Output: 23074 tokens
- Cost: $1.8561682000000004
- Wall-clock: 290s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
