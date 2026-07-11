`scripts/jobs/triager.sh` fails on every tick with `FATAL: no bare clone at $GARDEN_ROOT/repos/<slug>.git (clone the repo first)` because its default clone dir is wrong. Line 25 sets `: "${GARDEN_REPOS:=$GARDEN_ROOT/repos}"`, but the garden's canonical bare-clone location is `worktrees/<owner>-<repo>.git` (see WORKTREES.md, CLAUDE.md § Layout, `clone-keeper.sh` `GARDEN_TRACKED_CLONES`, and `common.sh` lines 452/477). There is no `repos/` directory in the garden root at all, while `worktrees/kriscendobot-agoric-sdk.git` (and the other watched clones) exist. Fix: change the default in `scripts/jobs/triager.sh:25` from `$GARDEN_ROOT/repos` to `$GARDEN_ROOT/worktrees` so `BARE="$GARDEN_REPOS/$slug.git"` resolves to the real clone. Apply the same fix to the identical stale default in `scripts/jobs/comment-watcher.sh:312` for consistency (its path only feeds a cosmetic note today, but should match). This affects all triager instances, not just agoric-sdk — `ocapn`, `vattr97`, and `agoric-3-proposals` are already in `failed` state for the same signature. Verify after: a triager tick for a repo with an existing `worktrees/*.git` clone should proceed past the bare-clone check to `git fetch` and cursor diff instead of dying.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 8
  claimed_at: 2026-07-11T00:53:22Z
