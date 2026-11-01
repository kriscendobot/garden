**Verdict: degraded.** oros is deployed at `ef0bbf4`, which was the main2 tip when this run started, but it has been stuck in drain mode since 12:57Z, taking no new work. Separately, the garden disk is filling fast.

**What happened with the drain**
- The leader sent oros a "quiesce for deploy" drain at 12:56:02Z. It acted on a stale `deferred` record from 12:46Z.
- oros's deploy had already landed and lifted its own drain at about 12:57:10Z. The sysop applied the leader's drain 7 seconds later, at 12:57:17Z.
- The leader then passed oros as a canary and cleared its release, so nothing owns the drain. oros is up to date, so self-deploy exits without doing anything.
- Monks 2 and 3 keep starting, seeing the drain, and exiting. Monks 1 and 4 are finishing their in-flight jobs. Per the job rules, I did not lift the drain by hand.

**What I changed**
- **Pushed `d1e41a9` to main2:** `fix(self-deploy): lift a quiesce drain that lands after its deploy`.
  - `self-deploy.sh` now lifts a `rolling-deploy-quiesce` drain when the host is current or its release is already deployed.
  - It never does this mid-deploy and never touches any other kind of drain.
  - I added regression cases to `scripts/jobs/test/rolling-deploy-test.sh`; the suite passes 134/0.
  - The roll of `d1e41a9` should free oros on its own, because a released deploy still runs under this drain and lifts it when it lands.
- **Health note** for 13:20Z added to `journal2:projects/garden/oros-health-log.md`.
- **Messaged the maintainer** about the disk and the drain.

**Snapshot**
- **Load and memory:** load 2.9/3.3/3.6, 13 GiB of 15 GiB free; swap steady at 963M.
- **Uptime:** 30d19h, no reboot.
- **Units:** 0 failed. The worker-leveling row is still `4 0` and there is no derotation marker.
- **Budget heartbeat:** last push at 13:02:41Z; the last six pushes were all ok at about 15-minute intervals. Spend is 9.0M of 180M.
- **State clones:** 84 journal clones, the largest at 47 packs, under the 50-pack threshold. No `gc.log`, no leftover temp packs, no stale git locks.
- **Timeouts (last 3h):** two ironhorse test262 jobs hit their 7200s limit, `deadmail-…fd9876` hit its 2400s limit, and the previous check-up (`oros-health-checkup-20261101-093536`) hit its 3600s limit without writing a note. All were classified as transient.

**Needs a person**
1. **Disk:** the virtiofs garden mount is at 81% (91G free), up from 66% (158G free) at 07:50Z. That is about 66G in 5.5 hours and still rising about 1G every 10 minutes, so it fills in roughly 15 hours. The container's own disk did not grow. My bounded `du` scans timed out before covering `scratch/`, `worktrees/` and `.garden-state/`, so I couldn't find the cause. It may be on the Mac side of the shared disk, so someone should look from the Mac.
2. **Drain fallback:** if oros is still draining after the `d1e41a9` roll, run `scripts/jobs/drain-fleet.sh off` on oros. The drain is stale and nobody owns it.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/oros-health-checkup-20261101-125015.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 88 tokens (3771642 cached reads)
- Output: 20836 tokens
- Cost: $2.0048403999999995
- Wall-clock: 1419s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
