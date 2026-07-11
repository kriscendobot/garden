Inbox empty. Work complete.

## Completion report

**Job:** Self-heal the triager so a missing/broken bare clone never hard-`die`s and crash-loops `garden-triager@<slug>`.

**What I found:** The bulk of this job was already landed on `main2` (commits `2c76c8cd92` "self-provision a missing bare clone" and `4c0e275b0b` "make self-provision opt-in") before I claimed it — the `is_own_git_repo`/`is_remote_location`/`derive_clone_url`/`bounded_clone` helpers are committed in `common.sh`, `triager.sh` already self-provisions (opt-in) or skips cleanly, and test cases H (missing-clone: default skip / opt-in provision / unreachable / underivable) and I (default `GARDEN_REPOS` → `worktrees/`) cover the never-held-clone path the job asked me to confirm.

**The one remaining gap I fixed:** The clone-less guard still used `[ ! -d "$BARE" ]`, so a **present-but-corrupt** `$BARE` (a half-populated clone, a leftover dir, or a plain file — anything that exists but isn't its own bare git repo) skipped the self-provision branch and fell through to `git fetch`, which hard-`die`s every tick and crash-loops the unit — the exact failure mode this job targets. The job explicitly called for mirroring `keep_clone`'s `! is_own_git_repo` + present-but-corrupt handling, which was not yet done.

**Changes:**
- `scripts/jobs/triager.sh`: switched the guard from `[ ! -d "$BARE" ]` to `! is_own_git_repo "$BARE"` (mirroring `clone-keeper.sh`'s `keep_clone`), and added a present-but-corrupt branch that surfaces the dir (STALE log + throttled `alert_maintainer`, consistent with the triager's existing provision-failed/nourl escalation paths) and **never clobbers it with a re-clone** (it may hold un-pushed local state), skipping cleanly (`exit 0`) instead of dying. The genuinely-missing paths are unchanged.
- `scripts/jobs/test/triager-test.sh`: added **case J** covering the corrupt-dir path — asserts exit 0, STALE log, contents survive (no clobber), no re-clone, handler never runs, and the `triager-clone-corrupt-` escalation is recorded (run even with `GARDEN_TRIAGE_SELF_PROVISION=1`, proving even an opted-in host won't clobber).

**Verification:** Full suite `bash scripts/jobs/test/triager-test.sh` → **68 passed, 0 failed**. `bash -n` clean on both files; no new shellcheck warnings (the lone SC2034 on `GARDEN_TAG` is pre-existing, consumed by `common.sh`'s `log`).

**Pushed:** `372e5e7584` to `origin/main2` (rebase CAS, landed first attempt).

**Follow-ups:** None required. Note the self-provision remains **opt-in** by default (`GARDEN_TRIAGE_SELF_PROVISION=1`) per the prior `4c0e275b0b` decision, so `garden-triager@kriscendobot-finbot` on a clone-less host cleanly skips rather than auto-cloning unless the host opts in or holds the clone.
