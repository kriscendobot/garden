**Verdict: degraded.** oros was unhealthy when I arrived because of a runaway test, which is now gone. Disk and slow journal writes remain problems. The run took about 50 minutes, over the 45-minute target.

**Incident**
- **What ran away:** one process group held 13,525 of the host's 13,630 processes, growing for about 3 hours. It came from an uncommitted test in the `oros-health-checkup-20261103-150510` worktree.
- **Cause:** the test's git shim execed `command -v git`, which on a worker's PATH is `bin/git`. The wrapper then treated the shim as the real git, so the two called each other without end.
- **Effect:** memory pressure reached 71%, and monk slot 3's post-handler `ps` sat stuck in D state for about 6,380s.

**Changed on the host**
- I killed pgid 2390507 after checking that every member belonged to that test.
- Afterwards there were 102 processes and 11–12 GiB of memory available, and memory pressure was 0 by 18:39Z. Load fell from about 7 to about 4.
- Nothing else was touched; there were no failed units or stale git locks to clear.

**Landed on main2 (not yet deployed on oros, which is on `40e4859456a`)**
- **`f60b08bc323`:** `bin/git` now exits 126 with a diagnosis past 32 nested levels. The new `git-wrapper-recursion-test.sh` passes 8 of 8 and is listed in CI; 4 of its checks fail against the old wrapper.
- **`8b364fc1b55`:** `land-journal-edit.sh` now replays a lost CAS (journal push race) without resetting the working tree. One landing without replay ran 540s and did not land; two with replay enabled through the environment took 188s and 160s. The shipped script default was only exercised by the tests, which pass.
- **Log:** the health note is on `journal2:projects/garden/oros-health-log.md`.

**Other health checks**
- **Deploy:** roll status is `deployed`, with no unit failures reported at the last health write (13:23Z).
- **Workers:** four monks are running, not draining, and there is no derotation marker.
- **Budget meter:** last push 18:33Z, and every recent result was ok.
- **State clones:** 4–46 packs, with no temp packs or `gc.log`.
- **Timeouts:** the only rc=124 line in the 3h window was one contention-watch notice deferral, searched before the kill.

**Open problems**
1. **Surviving session:** the 150510 `claude` (pid 2252247) outlived its rc=137 at 16:27Z and was still running at 19:00Z, with no gardener reading its report.
   - It landed `1218012e3db` (claim fix) and rewrote its test to avoid the shim.
   - The job is still in doin. I left the session alone because it was behaving, but my message to it was not delivered: `inbox-send` lost 6 push races and was killed at the 10-minute tool limit.
   - The watchdog's failure to kill it is not fixed and its mechanism is not proven; the likely story is in the log note.
2. **Journal writes are still slow, even after the kill:**
   - `inbox-send.sh` still has no replay, because it checks the doer's state before writing; that needs its own decision.
   - My final `inbox-read.sh` was still running after about 7 minutes, so my inbox was not drained.
3. **Disk:** 37.6 GiB free (93%). It dropped about 3.2 GiB between 18:14 and 18:39Z and I could not explain that, partly because a `du` of `scratch/tmpexec` timed out.
4. **Flaky test:** `repo-locks-test.sh` failed 5 of 9 runs on oros, 3 of 5 without the guard and 2 of 4 with it, so the guard isn't the cause. I did not fix it.

**Needs the maintainer**
- Find what uses the roughly 300 GiB outside the garden tree on the Mac.
- Decide whether to add `TasksMax` to `garden-worker@.service.in`. It would cap a runaway like this one, but a low limit could break large test runs.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/oros-health-checkup-20261103-180510.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 70 tokens (3474797 cached reads)
- Output: 47668 tokens
- Cost: $2.7663194000000004
- Wall-clock: 3335s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
