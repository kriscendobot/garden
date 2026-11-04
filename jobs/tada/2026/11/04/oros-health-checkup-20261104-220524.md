**Verdict: degraded.** Oros is running normally, but its deploy is still deferred. It's on `746d220507c`, while the release target is the `main2` tip, `36a2080657e`.

**Deploy**
- **Blocker:** self-deploy deferred at 23:18:54Z, before any gate ran, because monk 1 had been mid-job for 434s (the limit is 300s).
- **Status:** `fleet/health` reads `deferred`, not a failure, and no drain was engaged.
- **Outlook:** this is the only check-up left on the board, with none in `jobs/todo`. The next deploy trigger after the running jobs finish should get through, unless a new long job has started by then.
- **My part:** I didn't intervene, and kept this run short so it wouldn't hold the deploy up.

**Snapshot at about 23:21Z**

| Area | Reading |
|---|---|
| Load | 3.60, 3.52, 3.13 |
| Memory | 12 GiB of 15 GiB available; swap full, unchanged |
| Uptime | 34 days, no reboot |
| Units | 0 failed of 289; `garden-monk@1..3` running |
| Timeouts | no `rc=124` in the last 3h |
| Budget heartbeat | last push 23:18:38Z, ok, about every 15 minutes; spend 20% of cap (derived) |
| Disk | 36070 MiB free on the garden mount (93%), inodes 3% |
| Root `.git` | 65 packs, no `gc.log`, no `*.lock` older than 30 minutes at depth 3 or less |

**What changed:** nothing on the host and no garden code; I only added a note to `journal2:projects/garden/oros-health-log.md`. It took two pushes because I corrected two statements in the first version.

**Left alone on purpose**
- **Root `.git`:** I didn't repack it, because that would contend with the deploy and `garden-root-repo-guard` held the repo lock at 23:22Z.
- **`/tmp/deploy-www-*`:** 96 of the 252 directories are over 24h old. I left them in place; they aren't urgent on a tmpfs that's only 18% full.

**Needs follow-up (no one needs to be at the machine)**
- **Disk use:** free space is about 800 MiB below the 23:12Z reading and is the lowest in the log's recent notes. The cause is still unknown because a `du` of `scratch` didn't finish in 75s. It isn't urgent, but it needs a longer trace than a check-up should run.
- **Pack growth:** the root `.git` went from 13 packs at 08:32Z to 65 now. If a later check-up still sees this after the deploy, it should run a repack.
- **Check-up pile-up:** the scheduler kept dispatching this pinned job while oros was drained, which queued up the check-ups now delaying the deploy. Schedules are out of scope for this job, so I'm leaving that to the maintainer.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/oros-health-checkup-20261104-220524.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (362295 cached reads)
- Output: 7613 tokens
- Cost: $0.655383
- Wall-clock: 456s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
