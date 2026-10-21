**Verdict: healthy.** oros-studio-garden-ce242c49 is deployed at `fd6f8a87`, which was the origin/main2 tip when I checked. I fixed two garden bugs and recorded the run in `journal2:projects/garden/oros-health-log.md` (newest first).

**Snapshot**
- **Load and memory:** load is 3.8 to 4.3 with 3 monks running; 11 to 13 GiB of 15 GiB is free. Swap is full but flat, which is not memory pressure (it is page cache).
- **Disk:** 7% of the overlay is used and 51% of the virtiofs garden mount; inodes are at 1%.
- **Uptime:** 19 days 22 hours, no reboot.
- **Deploy:** fd6f8a87 deployed at 13:47Z. `fleet/health` shows `roll_status: deployed` with 0 of 289 units failed.
- **Units:** no failed garden units and none need a daemon-reload. `hosts/oros` says `monks: 3`. There is no drain and no derotation marker.
- **Budget heartbeat:** the claude-oros snapshot was pushed at 15:33Z and is fresh. Status is ok at 29.9M of 180M (7%), and the pushes at 14:47, 15:02, 15:17 and 15:33Z were all ok.
- **Timeouts:** no rc=124 timeouts in the last 3 hours.

**What I fixed**
1. **`4d57b792` — the repack was being cut off at 120s.**
   - `transcripts/clone` was still at 75 packs and 3.7 GB after `fd6f8a87` was deployed.
   - The fleet git wrapper limits each call to 120s (`GARDEN_REPO_GIT_TIMEOUT`), and that limit overrode the maintenance script's 1800s repack timeout. So `fd6f8a87` could never actually repack this clone.
   - The fix raises the wrapper's limit for the repack. Its new test passes with the fix and fails without it.
   - I also ran the pass once by hand: 75 packs became 2 in 95s, and the clone is now 3.5 GB.
2. **`1205fd4b` — three config readers could read stale data.**
   - The model-routing, openrouter-promos and kimi-fallback lookups fall back to the leader clone's working tree before the root journal.
   - That tree is never updated, because the clone is only read through `origin/journal2:` refs. On oros it is frozen at its 2026-10-18 checkout, 5,792 commits behind.
   - I removed it from those fallbacks and added `leader-clone-tree-fallback-test.sh`. Nothing was actually misread: the only flag file present has the same value in both places.

**Mistake on my part**
- I deleted an `index.lock` in `decisions/journal` that a live `reset --hard` had just recreated. My command removed it even though it had found the live git process.
- The decision write it interrupted re-landed on retry at 15:56:47Z, and the clone is clean at the tip, so there was no lasting damage.

**Follow-ups (nothing needs a person at the machine)**
- `kimi-opus-fallback-test.sh` and `worker-spine-kinds-test.sh` fail the same way on unmodified main2, so I did not cause these. The second one has 3 FAILs, including `pinnedclaude_m` monk eligibility, and runs past 580s under load. Someone should look at these.
- My inbox had 1 message, delivered at 16:33Z. It was the attempt's deadline nudge (about 15 minutes left), not a peer or maintainer message.
- `4d57b792` and `1205fd4b` are waiting for the normal rolling deploy; nothing is blocking it.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/oros-health-checkup-20261021-153508.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 138 tokens (5657982 cached reads)
- Output: 30268 tokens
- Cost: $2.5518443999999993
- Wall-clock: 3244s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
