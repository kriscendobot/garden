I added `scripts/jobs/host-health-watch.sh`, wired it into the scheduler, and pushed it to `main2` as `74a2b296b40`. The controller health-watch no longer hands a mentor the "confirm this cycle local run completed" prompt, which is what exited 0 in 22s at 10:44:05Z and burned its retry. The confirmation now runs in code, and a mechanic only gets a repair job when the evidence is stale or unhealthy. It goes live when the leader next deploys.

**What changed**
- **New script `scripts/jobs/host-health-watch.sh`:**
  - It exits 3 and writes nothing unless the journal `leader` marker names this host.
  - It runs `mechanic-health-controller.sh`. When the target is healthy or a check is routinely pending, it exits 0 and posts nothing.
  - On stale or unhealthy evidence it stages one mechanic repair job named `mechanic-repair-<target>-<YYYYMMDD>-<hash of the reasons>`. The job's body contains the deterministic findings and says the confirmation is already done.
  - It posts nothing if a repair job or an old-style watch instance for the target is still in `plan/`, `todo/` or `doin/`. It also posts nothing if a repair for the same reasons already completed that UTC day. Either way it records `Escalation: owned by <base>`.
- **`mechanic-health-controller.sh`:** it now also reads the newest entry written by the target's own checkup in `projects/garden/host-health/<target>.md`. Entries the leader-side controller wrote in that file don't count. A missing entry, one older than `GARDEN_MECHANIC_LOCAL_MAX_AGE` (default 6h), or a verdict other than healthy now triggers a repair job.
- **`scheduler.sh`:** the staged repair job is committed in the same push as the schedule's timestamp, so it posts exactly once per cycle. The schedule's own prompt is only sent to a worker if the deterministic check itself errors.
- **Docs:** `designs/mechanic-role.md` describes the new flow.

**Testing**
- `mechanic-health-controller-test.sh` passes, with four new cases: stale local record, non-healthy local verdict, no repeat repair the same day, and a non-leader host skipping the check. The existing cases now expect a repair job instead of a watch-job dispatch.
- `mechanic-role-test`, `scheduler-handler-timeout-test` and `scheduler-preflight-tempfail-test` pass.
- `scheduler-admission-test` fails in this sandbox because it tries to create a directory under the read-only home directory, before it reaches anything this change touches.
- A dry run against a copy of the live journal read Oros as a check backlog (31 checkups queued, newest local record from 2026-11-05) with 1 failed unit. It posted nothing because old watch jobs still own the escalation: `oros-health-watch-20261105-135010` and the in-progress `-20261110-102016`.

**Follow-ups**
- No Oros repair job will post until those old `oros-health-watch-*` jobs leave the board. The parked 11-05 one is the one worth clearing.
- I left both Oros schedule bodies and `check-mechanic-role.sh` alone. Changing the schedule's wording would need a matching journal edit, and that prompt is still what a worker gets if the check errors.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-deterministic-host-health-watch.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 58 tokens (2747797 cached reads)
- Output: 24184 tokens
- Cost: $1.8725353999999998
- Wall-clock: 341s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
