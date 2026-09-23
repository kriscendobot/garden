The requested source fix is already present in `origin/main2` — no code change was needed.

## Report

**Investigation.** The job asks to change the stale `GARDEN_REPOS` default from `$GARDEN_ROOT/repos` to `$GARDEN_ROOT/worktrees` in `scripts/jobs/triager.sh` and `scripts/jobs/comment-watcher.sh`. On inspection, that fix is **already committed to `origin/main2`** (this worktree's base):

- `scripts/jobs/triager.sh:38` → `: "${GARDEN_REPOS:=$GARDEN_ROOT/worktrees}"`
- `scripts/jobs/comment-watcher.sh:191` → `: "${GARDEN_REPOS:=$GARDEN_ROOT/worktrees}"`

Landed by commit `118f7384fc` *"fix(jobs): triager/comment-watcher default bare-clone dir to worktrees/"*, then extended by the self-provision work in `2c76c8cd92` / `4c0e275b0b`. So `BARE="$GARDEN_REPOS/$slug.git"` now resolves to the real `worktrees/<owner>-<repo>.git` clones. The line numbers in the job spec (25 / 312→179) are the **deployed** stale copy's line numbers, not main2's.

**Verification.** Ran the triager test suite (`scripts/jobs/test/triager-test.sh`): **62 passed, 0 failed**, including the dedicated "case I" test that locks the default `GARDEN_REPOS` to `$GARDEN_ROOT/worktrees` and explicitly asserts it does **not** resolve under the un-provisioned `repos/` (the original bug). A default-path tick proceeds past the bare-clone check for a repo with an existing `worktrees/*.git` clone, exactly as the job's verification step requires.

**Root cause of the still-failing units.** The deployed garden root `/home/kris/garden2` is at HEAD `688e6174c8`, **behind** `main2`, and its `triager.sh:25` / `comment-watcher.sh:179` still carry the stale `/repos` default. That is why the `agoric-sdk` / `ocapn` / `vattr97` / `agoric-3-proposals` triagers keep failing. The remedy is a **deliberate deploy** (`deploy-garden.sh` via the deploy-on-upgrade Monitor), not a source edit — outside a gardener's mandate.

**Actions taken.**
- No source change committed (the fix is already in `main2`; nothing to add).
- Messaged the maintainer (via `message-user.sh`) that the fix is landed and that a deploy of the root checkout is what will clear the still-failing deployed triager units.

**Follow-up.** Maintainer/liaison to run the deliberate deploy so the deployed root picks up `main2` and the four failing triager instances recover.
