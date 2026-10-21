**Verdict: healthy.** oros-studio-garden-ce242c49 runs the current main2 tip, has no failed units, and its meter is publishing. I landed one fix for the budget meter.

**Snapshot** (also appended to `journal2:projects/garden/oros-health-log.md`, newest first):
- **Load and memory:** load 2.83/3.21/3.21 with 3 monks running. 12.4 of 15.6 GiB available. Swap is full but flat.
- **Disk:** 7% used, inodes 1%.
- **Uptime:** 20 days, no reboot.
- **Deploy:** the deployed sha is `b577f3cd`, which matches origin/main2. It went out at 16:50Z and fleet/health shows `roll_status: deployed`. Nothing blocks the deploy.
- **Units:** 0 of 289 garden units failed, and none need a daemon-reload. `hosts/oros` says `monks: 3`. There is no drain and no derotation marker.
- **Budget meter:** the last snapshot was sampled at 18:48:07Z and pushed at 18:48:21Z. Every 15-minute push since 17:18Z succeeded.
- **State clones:** 81 journal clones, the largest at 47 packs, below the threshold of 50. No tmp_pack, no `gc.log`, and no stale git locks.
- **rc=124 timeouts:** one in the last 3 hours. `garden-library-link-scan` hit its 600s bound at 18:32Z. It looks isolated: the hourly runs since 08:27Z each took about a minute of CPU.

**Anomaly:** twice the meter published a sample far below the real spend for one 15-minute tick:
- 18:32Z today: 20.3M, between 33.4M and 35.0M.
- 2026-10-20 21:03Z: 0, between 9.0M and 11.1M.

Within one weekly window this total should only grow. The logs hold no seven-day rejection, so the window start did not move. A scan I ran by hand read 35.1M with clean exits. I did not find the root cause. It may be an incomplete directory listing on the shared mount (virtiofs) or a scan killed under load. The low readings showed more headroom than really existed.

**Changed:** I landed `f9d731f5` on main2, with a new test, `budget-snapshot-spend-regression-test.sh`. When a reading comes in below the last published spend for the same window, the meter now measures again once and publishes the larger reading. A real drop reads low both times and still publishes. The related budget tests pass. Two other test files fail with the same results on unmodified main2:
- `budget-live-percent-label-test.sh`: the commit message reads `ok` where the test expects `backoff`.
- `live-budget-admission-test.sh`: 4 failures.

`budget-snapshot-publish-retry-test.sh` passes but took 7m10s under load. `f9d731f5` reaches oros with the next roll.

I did not touch drains, worker leveling, derotation markers, budget pools or schedules.

**Needs a person or the maintainer:** nothing.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/oros-health-checkup-20261021-183508.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 116 tokens (4539716 cached reads)
- Output: 25924 tokens
- Cost: $2.2531752
- Wall-clock: 1520s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
