The scheduler no longer posts a job when a preflight check exits 75 (EX_TEMPFAIL, "can't decide right now"). It leaves the schedule due and tries again on the next tick, after the GitHub API cooldown has expired. The fix is pushed to `main2` as `d628cd13456`.

**What changed**
- **`scripts/jobs/scheduler.sh`:** when a preflight exits 75, the scheduler now logs `preflight deferred for <name> (rc=75, EX_TEMPFAIL)` and moves on. It does not post a job or update `last_dispatched`. A missing gate, a gate that times out (rc 124/137) and any other non-0/2 exit still dispatch as before.
- **`scripts/jobs/dependabotany-preflight.sh`:** the scheduler change alone would not have fixed this incident. During the cooldown, the open-PR lookup this preflight runs gets exit code 75 back, but the preflight then exited 0 ("work present"). That is why a botanist job was posted every tick. It now passes the 75 through to the scheduler.
- **`scripts/jobs/scholar-preflight.sh`:** comment updated only. An offline journal makes this check exit 75, so it now defers instead of dispatching.
- **`skills/schedule/SKILL.md`:** documents exit 75 as "deferred".

**Tests**
- New `scripts/jobs/test/scheduler-preflight-tempfail-test.sh` (5/5 pass): a 75 exit posts nothing and leaves the clock alone; a later exit 0 dispatches and updates the clock.
- `dependabotany-preflight-test.sh` has a new case for the cooldown (exit 75); it passes 28/28.
- The existing scheduler preflight timeout (7/7), deploy-lag (14/14) and scholar preflight (10/10) tests still pass.

**Follow-up worth considering:** a preflight that exits 75 indefinitely would now hold its schedule back with nothing but log lines to show for it. The task asked for that quiet behavior, and the cooldown is capped at 7200s by default, so the main risk is a journal that stays offline. If that matters, a later change could start dispatching again once a schedule is overdue by more than one full cadence.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-scheduler-tempfail-preflight.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1269284 cached reads)
- Output: 9764 tokens
- Cost: $1.0223208
- Wall-clock: 116s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
