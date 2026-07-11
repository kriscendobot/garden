Pushed to `origin/main2` as `83e0eb0f41` on the first CAS attempt.

## Completion report

**Job:** Fix the bare-clone path mismatch that FATALs the triager (`repos/` vs `worktrees/`), and prevent the two watcher defaults from drifting.

**What I found:** The defaults themselves were already corrected on `main2` by an earlier commit (`118f7384fc`, reachable from HEAD): both `triager.sh` and `comment-watcher.sh` already resolved `GARDEN_REPOS` to `$GARDEN_ROOT/worktrees`, and the triager header comment (lines 7–8) already pointed at `worktrees/`. So the FATAL is already gone. The one part of the job not yet done was the **drift-prevention shared resolver**.

**What I changed:**
- **`scripts/jobs/common.sh`** — added a single `bare_clone_dir <slug>` helper in the standing-bare-clone section. It returns `${GARDEN_REPOS:-$GARDEN_ROOT/worktrees}/<slug>.git`, so the `worktrees/` default now lives in exactly one place while still honoring the `GARDEN_REPOS` override the test harness uses for the missing-clone path.
- **`scripts/jobs/triager.sh`** — removed its own `: "${GARDEN_REPOS:=$GARDEN_ROOT/worktrees}"` line; `BARE` now comes from `bare_clone_dir "$slug"`.
- **`scripts/jobs/comment-watcher.sh`** — same: dropped the duplicate default line, `BARE` now from `bare_clone_dir "$slug"` (still degrades to gh-polling when the clone is absent).

The two watchers can no longer diverge, because neither carries its own default anymore.

**Verification:**
- `bash -n` clean on all three scripts.
- `triager-test.sh`: 62/0, including **case I** (default resolves under `worktrees/`, never `repos/`).
- `comment-watcher-test.sh`: 213/0.
- Direct resolver check for the job's exact slug: `bare_clone_dir kriscendobot-vattr97` → `$GARDEN_ROOT/worktrees/kriscendobot-vattr97.git` by default, and `/tmp/norepos/kriscendobot-vattr97.git` under a `GARDEN_REPOS` override — confirming resolution to the clone-keeper location and exit-0 behavior. Test harness `norepos` overrides were left untouched.

**Out of scope (noted in commit):** repos with no clone on any host (`agoric-3-proposals`, `cosgov`, `ocapn`) remain a separate arming/clone-provisioning gap, not addressed here.

**Follow-ups:** none required.
