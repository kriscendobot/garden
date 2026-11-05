**Health check for `oros-studio-garden-ce242c49`: healthy, no repairs made.** One job-level defect keeps retrying and needs a decision. I landed the standard record to `projects/garden/host-health/oros-studio-garden-ce242c49.md` on `journal2`, then landed a correction to it.

## 2026-11-05T07:33Z - oros-health-checkup-20261105-072053

- **Verdict:** healthy
- **Target / role / mode:** oros-studio-garden-ce242c49 / follower (leader marker: endolin-garden-ece02cb4) / local
- **Trigger:** schedule/oros-health-checkup
- **Evidence:**
  - **Units and deploy:** 0 of 291 units failed in fleet health at 07:11:32Z, and none locally at 07:27Z. The roll token, deployed SHA and `origin/main2` are all `d1453f822b8`, so there was no active release or drain to exit early for. The canary probe finished at 07:19Z.
  - **Budget and jobs:** `claude-oros` is ok at 25% (sampled 07:03Z). Over 3h there were 20 claims, 17 completions, 4 terminal hints and 1 transient kill.
  - **Resources:** load 2.05, 12G memory available, swap full at 1.0G but with no swap activity. virtiofs is 94% used with 30G free and 4% of inodes used; `/tmp` is 18% used; uptime is 34 days.
  - **Journal and repo:** contention probe shows `outage_skips=0`, latch off. The root `.git` has 6 packs (560M) and no `gc.log`. No namespace clone has more than 49 packs or any tmp packs.
  - **Sysop:** the newest record, `20261105T063504Z-280db5`, is a rolling-deploy quiesce drain that has since been lifted.
  - **`rc=124` in the logs (past 3h):** the scaler overran its 600s bound once (05:40Z), `backfill-receipt-rollup-20261105` hit its 2400s wall (05:57Z), and three contention notices were deferred (06:44, 06:47, 06:59Z).
  - **Not checked:** the `du` of `scratch` didn't finish in 240s and I stopped it, so scratch size is unmeasured. I also didn't check lock-holder liveness individually.
- **Cause:** no host failure established. All 4 terminal hints (04:31, 05:14, 05:52, 06:23Z) are on `kriscendobot-minion.town-pr199-land-20261104-gauntlet-wait`.
  - **Retry loop:** its handler returns in 61–115s in the cycles I inspected, then `gardener.sh` can't record the panel-head stale-review disposition (`rc=76`). That has happened 7 times since 01:00Z, plus once on `pr237-gauntlet-20261105`. The job stays in `doin` and retries, with 215–243s of bookkeeping per cycle.
  - **Effect on the host:** at 04:48:02Z one of these `rc=76` exits was classified as a provider outage. It published a 300s anthropic health cooldown that pauses claims on this route, and I found no sign of a real outage.
  - **Latest cycle:** it ended differently, with handler `rc=75` after 12s at 07:15Z.
  - **Still unknown:** why the docket request returns 76. The gauntlet behind the wait job has finished at review-budget-reached, and PR 199 is open and draft at `c3ce331ca29`.
  - **Unrelated log noise:** six `run-u*.service` starts failed on a missing environment file at 06:04Z. They aren't `garden-*` units and didn't recur; I didn't trace which job ran them.
- **Actions:** none; no sysop operation, worker, drain or code change.
- **Final state:** heartbeat current, 3 monks active and claiming since the deploy (07:14, 07:17, 07:21, 07:26Z), deployed `d1453f822b8` matching `origin/main2`, undrained, 0 failed units.
- **Maintainer:** none in the landed record (see the decision below).
- **Next mechanic:**
  - **Disk:** virtiofs free space keeps falling (36G at 23:24Z, 32G at 01:43Z, 31G at 04:51Z, 30G now). It needs an owner if it drops below 20G; measure `scratch` with a bounded `du`.
  - **pr199 wait job:** check whether it's still cycling, and compare with the parked plan job below.
  - **Possible orphan:** check `.garden-state/receipts-backfill-20261105` (824M). Its successor job ran on endolin.

Earlier follow-ups are closed: the deploy reached the release, and root packs fell from 127 to 6.

**Decision for the maintainer:** should the parked fix go ahead? `jobs/plan/improve-gardener-handler-rc76-collision-expanded-window.md` looks related, going by its name and the docket helper and rc constant it describes, though I didn't confirm it covers this failure. It is gated on go-ahead and carries a doomed marker from 2026-11-04 (`requeue-exhausted`). I posted no new job, since this code is outside the mechanic's scope and a successor may already exist.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/oros-health-checkup-20261105-072053.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (981701 cached reads)
- Output: 16795 tokens
- Cost: $1.2383682000000003
- Wall-clock: 555s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
