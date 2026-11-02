**Verdict: degraded, for disk only.** Everything else on `oros-studio-garden-ce242c49` is healthy.

**Snapshot** (full note landed in `journal2:projects/garden/oros-health-log.md`)
- **Deploy:** the root and `origin/main2` are both at `9f4eb64`, with `roll_status: deployed` and 0 of 290 units failing. The deploy deferred behind monk 1's long job from 14:00Z and finished at 14:11:50Z, so step 3 needed no help.
- **Host:** load is 2.4–4.4 and 12 GiB of 15 GiB memory is available. Swap is full, the same as recent runs. Uptime is 31d21h with no reboot.
- **Workers:** monks 1–4 are running, with no failed units, no drain marker or derotation marker found, and worker-leveling row `4 0`.
- **Budget meter:** last push was at 14:34:25Z. The last 8 pushes were all ok, at a 13–17 minute cadence, and spend is 16.2M of 180M.
- **Timeouts:** no rc=124 in the last 3h.
- **State clones:** the largest have 50 packs, with no `gc.log` or temp packs. No journal-clone `.git` lock is older than 30 minutes, but a wider `.garden-state` lock search hit its 30s limit, so that part is incomplete.

**Disk:** the shared mount has 58.6G free (88%), and the growth rate has slowed to about 0.5G/h from about 1.8G/h. That is one 3-hour interval with coarse earlier readings, so it isn't a trend yet. The source is still unidentified, and I did not repeat the `du` sweep, which has timed out on earlier runs.

**Claim fix from the last run (`9f4eb64`):** lost claim races went 45 (08:52–11:45Z), then 3 (11:45–14:11Z), then 5 in the roughly 40 minutes since the deploy. Since the deploy, 7 claims landed, 5 of them through replay. The fix is working, but lost races had already fallen before it deployed, so the drop isn't all down to the fix.

**What I changed**
- Removed 249 dead-holder metadata records under `.garden-state/repo-locks/`. They total under 1 MB, and the lock code clears these itself when it next acquires that lock. The lock files were not touched.
- Added the health note. There were no garden code changes, and I did not touch drains, worker leveling, derotation markers, budget pools or schedules.

**Needs a person**
- **Maintainer:** someone at the Mac should still find what is using the shared disk. I sent no new message because earlier notices are still in the maintainer inbox.
- **Your call, optional:** the `/tmp/ebfbxs` bind mount from an XS job is still there, unchanged since 08:21Z, with no process using it. I left it because a requeued job could reuse it.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/oros-health-checkup-20261102-135010.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (629110 cached reads)
- Output: 13005 tokens
- Cost: $0.87321
- Wall-clock: 472s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
