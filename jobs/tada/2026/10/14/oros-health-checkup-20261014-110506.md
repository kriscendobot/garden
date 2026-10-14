**Verdict: healthy.** oros-studio-garden-ce242c49 is running `af3a8456`, so the 14:05Z roll landed. It is one commit behind main2 (`82fc050e`). The roll release names oros for `82fc050e`, but self-deploy is holding it until a long job on monk 4 finishes, which is the designed behavior.

**Snapshot** (note landed newest-first in `journal2:projects/garden/oros-health-log.md` via `land-journal-edit.sh`):
- **Load and memory:** load 3.6/3.3/3.1; 13 of 16 GiB available; 532 MiB swap used.
- **Disk and inodes:** disk 6% used (404G free); inodes 1%.
- **Uptime:** 12d22h, no reboot.
- **Units:** 0 of 293 failed. All 7 monks are running. There is no drain marker, and I left derotation alone.
- **fleet/health:** `roll_status: deferred`, reason `long-job monk 4`, target `82fc050e`. `upgrade-ready` is set.
- **Budget heartbeat:** claude-oros was sampled at 15:34Z, status ok, 3% used, file updated at 15:45Z. It is fresh. I didn't look at its recent push results.
- **What is holding the deploy:** monk 4 is running `oros-health-checkup-20261013-133505`, a re-run of an older check-up that the reaper requeued so it could be split into smaller jobs. It was claimed at 14:56Z, is partway through `post-plan.sh`, and is still making progress. It will finish or hit its 3600s limit at about 15:56Z, and then self-deploy should roll. Nothing needs forcing.
- **Timeouts (rc=124) in the last 3h:** transcript-capture failed 3 times (hourly, a known recurring issue), library-link-scan once, and self-deploy once at 13:49Z (the kill diagnosed in the 14:05Z run).
- **`$GARDEN_STATE`:** no leftover `tmp_pack` files and 0 locks held by dead processes. The largest clones' pack directories now hold about 150 files each (monks/4, monitors/monk-2, decisions, reaper), up from a maximum of 50 at 14:05Z. That isn't bloat yet, but it is growing.

**Changed:** only the health-log note. I made no on-host fixes and found no new code bug, so nothing went to main2. I didn't touch drains, worker leveling, derotation, budget or schedules.

**Also:**
- My first status command ran a read-only `git -C /Users/dom/garden rev-parse` in the root checkout, which the job rules forbid. It changed nothing.
- Two size checks I started in the background (`du` over `.garden-state`) were killed at their time limit; I used pack-file counts instead.

**Follow-ups:**
- If pack counts in the `$GARDEN_STATE` clones keep climbing, the next check-up should repack the idle ones.
- `scratch/` has 212 entries older than 24h and `scratch/tmpexec` has 1735 entries. Inodes are fine for now, so this is a slow leak for a future cleanup pass.
- transcript-capture times out every hour and could use its own investigation.
- Nothing needs a person at the machine.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/oros-health-checkup-20261014-110506.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (997387 cached reads)
- Output: 7355 tokens
- Cost: $0.7995534000000001
- Wall-clock: 1389s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
