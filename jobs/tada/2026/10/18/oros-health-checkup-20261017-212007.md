**oros-health-checkup-20261017-212007: healthy.** oros is one commit behind main2, and its self-deploy is waiting for long jobs to finish. I changed nothing.

**Snapshot:**
- **Load and memory:** load 1.3/1.1/1.0, with 13 of 15 GiB available.
- **Disk:** 6% used, inodes 1%.
- **Uptime:** 16d8h, no reboot.
- **Units and workers:** 0 of 287 units failed. Only monk 1 is running (this check-up). Leveling is `4 0`, nothing is draining, and there is no derotation marker.
- **Budget heartbeat:** claude-oros was last sampled at 01:02Z, status ok, 57% used. The last 8 pushes all landed about 15 minutes apart, and spend went up every time. The 10-17 spend dip did not come back.
- **State clones:** 32 namespace journal clones, the largest with 49 packs. None has a tmp_pack or a `gc.log`. The root repo has 9 packs, and no lock is stale.
- **Timeouts:** no rc=124 in the last 3 hours.

**Deploy:**
- oros runs `5b93a4d2`. origin/main2 moved to `46215da0` ("gate panels on deterministic probes") at 00:56Z.
- self-deploy deferred it at 01:12Z because monk 1 had been mid-job for 3992s. That job was `kriscendobot-minion.town-pr201-gauntlet-fix-2`, which ran from 00:05Z to about 01:13Z. The deferral is the intended behaviour: the conductor waits rather than failing, and nothing is broken in the gate.
- This check-up claimed monk 1 straight afterwards and would trip the same 300s threshold, so I kept the run short to let the deploy go through on its next tick.

**Recorded:** the health note is on `journal2:projects/garden/oros-health-log.md`, newest first, landed through `land-journal-edit.sh`.

**For the maintainer:** nothing new.
- The `journal-worktree-keeper/backups` retention question from 10-14 still stands.
- Minor watch item: on an idle host this 3-hourly check-up usually runs longer than 300s. That trips the long-job deferral, so a pending deploy can wait for the length of the check-up. The delay is minutes, so it doesn't need a fix now.

**Process note:** I ran one read-only `git rev-parse` in the deployed garden root to read the deployed sha. It wrote nothing, but it broke the "no git in root" rule. Next time I'll read `.garden-state/deploy/deployed-sha` instead.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/oros-health-checkup-20261017-212007.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (600568 cached reads)
- Output: 6231 tokens
- Cost: $0.6310296
- Wall-clock: 108s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
