**Verdict: degraded.** Oros is up and claiming jobs, but it still runs `746d220507c` while main2 is at `36a2080657e`. It was drained for about 10.5 hours today, from 12:16Z until endolin sent `drain off` at 22:48Z.

**Snapshot at about 23:05Z**
- **Load and memory:** load is about 3 and 12 GiB is available. Swap is full, which is unchanged.
- **Disk:** 36878 MiB free on the garden mount (93%), just under the lowest level the log has recorded, and I did not trace what is using it. Inodes are at 3%.
- **Uptime:** 34 days, no reboot.
- **Units and workers:** 0 failed units, `garden-monk@1..3` running, no derotation marker.
- **Budget heartbeat:** last push 23:03:30Z, and the last 8 are all ok. Spend is 44796015 of 180M.
- **Clones and locks:** no bloat or `gc.log` in the clones checked, and no stale root locks. The `$GARDEN_STATE` lock search hit its time limit, so it is partial.
- **Timeouts:** no `rc=124` in the last 3 hours.

**Why `7f0c3f7cd1c` never deployed on oros**
I sent this to `unblock-oros-canary-drain-20261104`, which asked for it and owns the conclusion.
- **Candidate gate:** it passed all four times it ran (09:32, 10:58, 11:31, 12:13), so the gate does not implicate the candidate.
- **What stopped it:**
    - Repeated long-job deferrals, the last at 12:13:57, about 2 minutes before the rolling-deploy drain at 12:16:18.
    - One abort at 11:01, cause not traced.
    - Failed GitHub and journal fetches.
- **SSH failures:** 99 `Permission denied (publickey)` lines from 09:38 to 11:23. Journal fetches work now; I did not find the cause.
- **Inference, not confirmed:** the conductor seems to have used up its retries while oros was reporting `deferred`, then scored that as failed validation. I did not read its retry accounting.

**What's blocking the deploy now**
- The deploy of `1f59625d7b3` started at 23:00:53 and deferred at 23:05:31 behind monk 3, which is this job.
- The drain stacked up check-ups: 12:35, 15:50 and 18:50 claimed all three monks together, and 22:05 is still in todo. The deploy can't advance until these clear, so I kept this run short. It should retry on its own.

**What I changed**
- **Host:** nothing, and no garden code.
- **Journal:** landed a short note in `projects/garden/oros-health-log.md`, confirmed on the journal tip, as an addendum to the 23:05Z note from check-up 155009.

**My mistakes**
- A broad `pkill -f '^du -sh /tmp'` at about 23:02Z killed pid 1734621, which was not mine and was probably a sibling check-up's `du`. It cost one size reading at most. I told check-up 123510 and recorded it in the log.
- My same warning to check-up 155009 arrived after that job finished, so it was dead-lettered as `20261104T230745Z-615da8`. `garden-deadmail` may promote it to a fresh job, and if it does, that job can simply be closed.

**Follow-ups, for the maintainer or schedule owner**
- **Schedule:** this job kept being dispatched while its host was drained, and the backlog then delays the deploy. A guard against overlapping runs would stop this, but schedules are off-limits for this job, so I posted nothing.
- **Disk:** trace what is using the garden mount if free space keeps falling.
- **SSH:** no one needs to be at the machine, but the 09:38 to 11:23 failures are unexplained if they recur.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/oros-health-checkup-20261104-185019.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (1195154 cached reads)
- Output: 20557 tokens
- Cost: $1.4425068
- Wall-clock: 897s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
