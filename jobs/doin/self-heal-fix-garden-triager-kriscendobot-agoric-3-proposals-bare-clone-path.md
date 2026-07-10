In `scripts/jobs/triager.sh`, fix the bare-clone resolution that makes every triager tick die (`triager.sh:32`, signature: `FATAL: no bare clone at $GARDEN_ROOT/repos/<slug>.git (clone the repo first)`).

Two changes:

1. **Correct the default path.** Line 25 defaults `GARDEN_REPOS` to `$GARDEN_ROOT/repos`, but the canonical standing-bare-clone location used by `ensure-project-worktree.sh:63`, `clone-keeper.sh`, and `WORKTREES.md:12` is `$GARDEN_ROOT/worktrees`. `$GARDEN_ROOT/repos` is never provisioned by anything, so no triager can ever find its clone. Change the default to `$GARDEN_ROOT/worktrees` (`BARE="$GARDEN_REPOS/$slug.git"` then resolves to `worktrees/<slug>.git`, matching the one clone that exists, `kriscendobot-agoric-sdk.git`). Apply the identical default-path fix to `comment-watcher.sh:179` for consistency, since it shares the same wrong default.

2. **Skip cleanly instead of dying when the clone is genuinely missing.** After the path fix, `worktrees/kriscendobot-agoric-3-proposals.git` still does not exist (the repo was armed in `journal/repos/` without a bare clone ever being cut). A missing clone is a config-level condition no systemd restart can cure, yet `die` (exit 1) makes the unit flap and re-triggers self-heal every tick. Follow the already-landed precedent at `comment-watcher.sh:312`: replace the `die` at `triager.sh:32` with a `log` warning and a clean `exit 0` (the triager needs the bare clone to diff refs, so it cannot proceed, but it must not fail). Optionally alert the maintainer once (dedup like `clone-keeper.sh`'s `alert_maintainer`) so the un-provisioned clone surfaces to a human to either `git clone --bare` it (per `worktrees/<owner>-<repo>.git` + fetch-refspec setup in `WORKTREES.md:44`) or remove `kriscendobot-agoric-3-proposals` from `journal/repos/` if it should not be commit-watched. Update the triager unit test in `scripts/jobs/test/` to assert the missing-clone path exits 0 with a warning rather than exit 1.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 20
  claimed_at: 2026-07-10T22:54:04Z
