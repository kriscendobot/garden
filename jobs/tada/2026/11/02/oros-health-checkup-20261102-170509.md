**Verdict: degraded (disk only).** Everything else on oros-studio-garden-ce242c49 is healthy.

**Snapshot** (landed in `journal2:projects/garden/oros-health-log.md`):
- **Deploy:** the root and origin/main2 are both `9f4eb64`, and `roll_status` is deployed, so it needed no help.
- **Units and workers:** 0 failed units and `garden-monk@1..4` running, with claims landing. I found no drain or derotation marker at the paths I checked.
- **Budget heartbeat:** the last sample was 7 minutes old at the snapshot, and the last 8 logged pushes were ok. Spend is 17.6M of 180M.
- **Timeouts and races:** no rc=124 in the last 3 hours. There were 2 lost-race lines and 21 replay lines in that window, from a coarse grep count.
- **One-off failure:** `garden-repo-watcher` exited 1 once at 15:50Z, cause not established. Later runs finished normally.
- **State clones:** no `gc.log`, temp packs or stale `.git` locks in the monk and monitor clones. A wider `.garden-state` search hit its time limit, so that check isn't complete.

**Changed:** nothing on the host, and no garden code. The 15 dead `repo.lock` holder records are left for the lock code to clear itself.

**Needs a person: disk**
- **Rate:** the garden mount has 57.4G free (88% used) and has lost about 1G/h since 14:53Z. At that rate it fills in a little over two days, though the rate has moved around between runs.
- **Source still unknown:** `scratch/tmpexec` and the bare clones look too small to explain it, and the sweeper is running. Project worktrees are still unmeasured because `du` hits its time limit on them.
- **Possible cause outside the garden:** the mount's size suggests it reports the Mac host's whole volume, so usage outside the garden would also count. I can't confirm that from inside the container, so someone at the Mac should run `du` or check Storage.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/oros-health-checkup-20261102-170509.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (531984 cached reads)
- Output: 12274 tokens
- Cost: $0.8123488
- Wall-clock: 631s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
