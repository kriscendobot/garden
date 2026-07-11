Fix the systemic triager crash `FATAL: no bare clone at <root>/repos/<slug>.git` that is failing/restart-looping every `garden-triager@*` instance on this host (finbot, endo, agoric-sdk, minion.town, cosgov, agoric-3-proposals, ocapn, vattr97). Root cause is a half-applied refactor: `scripts/jobs/common.sh` (uncommitted working-tree diff, +90 lines) and `scripts/jobs/clone-keeper.sh` moved the shared clone helpers into `common.sh` and their comments promise "triager.sh self-provisions with the same logic," but `scripts/jobs/triager.sh` was never updated.

Two changes to `scripts/jobs/triager.sh`:
1. Point it at the canonical clone location. Line 25 defaults `GARDEN_REPOS` to `$GARDEN_ROOT/repos`, but standing bare clones live under `worktrees/<owner>-<repo>.git` (see `clone-keeper.sh` GARDEN_TRACKED_CLONES and CLAUDE.md § Layout). Change the default to `$GARDEN_ROOT/worktrees` so `BARE=$GARDEN_REPOS/$slug.git` resolves to the existing `worktrees/<slug>.git`. This alone un-breaks finbot/endo/agoric-sdk/minion.town/vattr97, whose clones already exist there.
2. Replace the hard `die` at line 32 with self-provision, completing the promised refactor: source the now-shared `common.sh` helpers (`is_own_git_repo`, `is_remote_location`, `derive_clone_url`, `bounded_clone`) and, when `$BARE` is missing, derive the upstream URL (via `derive_clone_url "$BARE"`, `<owner>-<name>.git` → `$GARDEN_CLONE_URL_BASE/<owner>/<name>.git`) and `bounded_clone "$url" "$BARE"`. On an unreachable/underivable source, `log` and `exit 0` (graceful skip like `comment-watcher.sh:312` / clone-keeper's "left for next tick"), NOT `die` — so a transient network failure doesn't restart-loop the unit.

Also update `scripts/jobs/comment-watcher.sh:179` GARDEN_REPOS default to `$GARDEN_ROOT/worktrees` to match, keeping the two watchers' clone-path resolution identical.

Verify with the existing `scripts/jobs/test/comment-watcher-test.sh` (which overrides GARDEN_REPOS explicitly, so the default change is safe) and add/adjust a triager test covering (a) an existing `worktrees/<slug>.git` being found, and (b) a missing-clone self-provision path. Confirm `common.sh` and `clone-keeper.sh` changes get committed together with the triager change so the deployed tree is consistent (the fix currently only lands once these uncommitted edits + the triager update ship together via the deliberate deploy).

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 7
  claimed_at: 2026-07-11T00:54:25Z
