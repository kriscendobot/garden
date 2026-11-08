The controller health watch now runs deterministically in the scheduler. Routine cycles close with no worker and no requeue. The test file passes 7/7, and my follow-up is pushed to `main2` as `d02b2fae8f5`.

**What was already there.** When I claimed the job, `main2` already had `4e086814e60` (12:30Z, "Make mechanic health watch deterministic"). It looks like a previous run of this job that died before signalling. It added:
- `scripts/jobs/mechanic-health-controller.sh`, which reads the prior paired checkup and the fleet-health, roll, latest sysop and host records. It writes one bounded file per host at `projects/garden/controller-health/<host>.md`, replaced each cycle rather than appended to.
- A scheduler hook that closes healthy or still-pending cycles in the same commit as the clock stamp. Only real problems go to a mechanic job, with the disposition attached as evidence.
- Tests and a design note.

I checked it and its tests passed.

**What I fixed.** Run against the live journal, that version would never have escalated:
- **"Pending" never ran out.** Oros has 16 checkups queued and unclaimed, the oldest from 2026-10-13. Because only the most recent checkup was checked, each cycle read "pending" and closed as routine. Now any live checkup older than two cycles escalates as `paired-check-backlog` (the threshold is `GARDEN_MECHANIC_PAIRED_MAX_AGE`, default 6h). A checkup that vanished from the board escalates as `paired-missing`. The disposition also records how many checkups are live and the oldest one.
- **Escalations could pile up.** If a controller job is already in `plan/`, `todo/` or `doin/`, an escalation no longer posts a new one. It adds `Escalation: deferred to live <base>` to the disposition and closes the cycle, so there is at most one mechanic per problem.
- **Tests:** three new cases (duplicate suppressed by a live job, backlog escalates, vanished checkup escalates). The design note in `designs/mechanic-role.md` is updated to match.

Three other scheduler tests (`scheduler-admission`, `scheduler-preflight-deploy-lag`, `scheduler-preflight-typo`) fail, but they fail the same way on the commit before mine. They try to create a directory under `$HOME`, which is read-only in this sandbox.

**Needs your attention:**
1. **Oros isn't claiming its checkups.** Run against a copy of the live journal, the new code returns `mechanic-required / paired-check-backlog`. Oros's fleet-health record is stale (last written 02:58Z), and the roll to `21585bda` shows as not completed.
2. **Ten old controller jobs are parked in `plan/`** (`oros-health-watch-*`) from earlier failed runs. Under the new rule they count as the live owner, so the backlog escalation is being recorded but not dispatched. To get one fresh mechanic run on oros, withdraw them or promote one.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-mechanic-health-controller.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 32 tokens (1129278 cached reads)
- Output: 12029 tokens
- Cost: $1.0485156 (1 engagement(s) unpriced)
- Wall-clock: 755s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
