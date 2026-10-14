**Verdict: degraded.** oros-studio-garden-ce242c49 is running fine but sits behind main2: it is deployed at `320cfbed` while main2 was at `8eb6caec`. The roll to main2 has been deferred all morning because a long-running job is always busy on the host.

**Snapshot:**
- **Load and memory:** load 2.4/2.9/3.2; 13 of 15 GiB free; no swap.
- **Disk:** 6% used, inodes 1%.
- **Uptime:** 12 days 16 hours, no reboot.
- **Units:** 0 of 292 failed; 6 monks running. No drain marker; derotation untouched.
- **Budget heartbeat:** sampled at 09:03Z, status ok, 2% used; the last five pushes all succeeded.
- **rc=124 timeouts:** 18 in the last 3 hours, all self-heal handlers hitting their 600s limit (transcript-capture and library-link-scan most often).
- **State clones:** none bloated, no stale locks.

**Changes on main2:**
- **`6c8c058b` — `gardener.sh` no longer blocks on the overrun alert.** Monk 4's handler died at 08:47Z, but the worker stayed marked busy for another hour. Most of that was spent waiting for its handler-budget-overrun alert to reach the maintainer inbox. That delivery can retry up to 50 times and ran over 30 minutes, holding the deploy back the whole time. The gardener now writes the reaper hint first and sends the alert in the background.
- **`handler-budget-test` was already failing on main2.** Every subtest failed at the budget gate, because the fixture set up a budget pool for the retired `gardener` worker kind instead of `monk`. I fixed the fixture and added a subtest proving a slow alert no longer holds the worker. It now passes 14/14.

**Changes on oros:**
- Removed 7 leftover per-job inbox clones (8 remain).
- Deleted 21 lock-holder records left by dead processes.
- Logged this run in `projects/garden/oros-health-log.md`.

**Follow-up job posted:** `fix-reaper-supersede-stale-scheduled-recurrence`. The old check-up `oros-health-checkup-20261013-163508` was reaped at 04:33Z and claimed again at 07:27Z, after three newer check-ups had been scheduled. It ran a full hour and hit its timeout again. It is now eligible to be split into an orchestration, which would run it a third time. The job asks the reaper to retire a scheduled run once a newer run of the same schedule exists, instead of re-running or splitting it.

**Needs attention:**
- **The deploy:** oros needs a quiet window to roll to main2. That would bring in `d43e3363` (the slow first inbox-read, which still cost 18 minutes on monk 4 at 07:27→07:45Z) and `6c8c058b`. I didn't touch drains or worker leveling.
- **The check-up itself:** these hour-long check-ups also keep the deploy deferred while they run; this run did too.
- **Board cleanup:** the stale `…163508` claim is still in `doin/` waiting for the reaper.

Nothing needs a person at the machine.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/oros-health-checkup-20261014-045008.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 130 tokens (5421839 cached reads)
- Output: 26702 tokens
- Cost: $2.5028078000000007
- Wall-clock: 2000s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
