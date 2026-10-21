## Completion report: self-heal-fix-garden-monk-complete-job-inbox-rm-local-mods

`complete-job.sh` now force-removes the finished job's own paths, so a completion no longer crashes garden-monk on this error. The fix, a regression test and one test repair are pushed to main2 as **91030eca6d6**. The stranded panel-4 job has been completed.

**Cause.** The `.gitkeep` files were never really changed. `claim-job.sh:581` commits them empty, and `inbox-read.sh` only moves message files with `git mv`. The real cause is a filesystem timing race. The worker clone (`.garden-state/monks/<id>/journal`) is on the virtiofs mount. There, a file that `sync_clone`'s `git reset --hard` has just rewritten shows up as modified for about a second (the same effect as the known virtiofs rebase race). I reproduced it on that mount by resetting to a commit that adds `inbox/x/{read,unread}/.gitkeep` and then running `git rm -rq inbox/x`:
- **Without `-f`:** 10 of 200 runs failed with the exact production error ("the following files have local modifications").
- **With `-f`:** 0 of 200 failed.

Commit 82fc050e032 probably made it show up more often, but the race lives in the reset-then-rm sequence itself.

**Changes**
- **`scripts/jobs/complete-job.sh`:** all four `git rm` lines now use `-f`: the doin file, `work/<base>`, the bid dir and `inbox/<base>`. A comment explains why. The doin and work lines (279–280 in the job spec) had the same exposure. These paths belong only to this job and their durable copy is on origin/journal2, so forcing the removal loses nothing.
- **New test, `scripts/jobs/test/complete-job-inbox-rm-force-test.sh`:** the race can't be reproduced on tmpfs, so the test injects it reliably. A `GARDEN_REAL_GIT` shim writes into the work-tree copies just before any `git rm`. The test then checks that the completion exits 0, pushes the tada report, and removes the doin, work and inbox paths. It passes 6/6 with the fix and fails 6/6 on the old code with the production error.
- **`scripts/jobs/test/foreman-edge-kick-test.sh`:** this test was already failing on main2 before my change. Its `verify_tada` looked for a flat `jobs/tada/<base>.md`, but tada reports are now stored in dated subfolders. It now searches the folder tree and passes 7/7.

**Stranded job `endojs-endo-but-for-bots-pr1524-gauntlet-panel-4`.** It was stuck in `jobs/doin` (claimed by monk-1 on this host). Its report and completion marker had survived in `/tmp`, so I re-ran its completion with the fixed script. It landed as journal commit 07e2e23b9, rc=0, and I deleted the leftover `/tmp` files. The gauntlet driver on endolin then posted retry 2 of that panel stage (623846307), as designed for a panel error.

**Follow-up.** The retried panel-4 job has no `requires: host=…` line, so this host could claim it again. That attempt would fail the same way: this host's bot token gets a 403 when posting reviews on endojs, which is what the original round hit. Restricting the retried panel stage to a host whose token can write reviews (e.g. `requires: host=endolin-garden-ece02cb4`) would stop the retry budget being wasted. I didn't change that job, since it's outside this task.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-monk-complete-job-inbox-rm-local-mods.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 94 tokens (3635975 cached reads)
- Output: 22457 tokens
- Cost: $1.899543
- Wall-clock: 1928s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
