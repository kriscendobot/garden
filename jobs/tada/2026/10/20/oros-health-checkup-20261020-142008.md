**Verdict: healthy.** oros-studio-garden-ce242c49 is running `8a2b6a63`, one commit behind origin/main2 `3bab9998`. That commit is the weaver handler-timeout default. The deploy is waiting behind a running job, which is the normal path, and nothing is blocking it.

**Snapshot** (logged newest-first in `journal2:projects/garden/oros-health-log.md`):
- **Load and memory:** load is 3.30, 2.99, 3.13 with 4 monks running. 12 GiB of 15 GiB memory is available. Swap is full (1 GiB of 1 GiB) but flat, with no memory pressure.
- **Disk and inodes:** the overlay is 7% used and the virtiofs garden mount 52% (225G free). Inodes are at 1%.
- **Uptime:** 18d21h, no reboots.
- **Deploy:** self-deploy last advanced at 13:13Z. `upgrade-ready` was refreshed at 14:22Z. Self-deploy is deferring behind `long-job monk 3`, which had been running 631s at 14:24Z. There are no gate timeouts. fleet/health reports `roll_status: deployed` with 0 of 290 units failed.
- **Units and workers:** no garden units have failed, and `garden-monk@1..4` are running (`monks: 4`). The host is not draining and has no derotation marker.
- **Budget meter:** the claude-oros snapshot was 25 minutes old at check time, with status ok at 2% of the weekly window. The last 5 pushes all succeeded, every ~15 minutes. There is no publish-outage latch.
- **State clones:** the largest are repo-watcher (50 packs), gardener-scaler (48) and reaper (47). All are at or below the 50-pack threshold, with no tmp_pack, no `gc.log`, and no stale `.lock` files. The root repo has 15 packs and no `gc.log`.
- **Timeouts and errors:** no rc=124 timeouts in the last 3h, and no error-priority entries in the system journal.

**Changed:** nothing on the host. The only write was the health-log note.

**Minor observation:** landing the log note waited twice on the producer clone lock (busy for more than 60s each time) before it got through at 14:36Z. Producers are competing for that lock, but nothing was lost and no action is needed unless it keeps happening.

**Needs a person or the maintainer:** nothing.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/oros-health-checkup-20261020-142008.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1038316 cached reads)
- Output: 6571 tokens
- Cost: $0.7359072
- Wall-clock: 662s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
