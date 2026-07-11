Fix the bare-clone path mismatch that makes every `garden-triager@*` instance die at `scripts/jobs/triager.sh:32` with `FATAL: no bare clone at $GARDEN_ROOT/repos/<slug>.git (clone the repo first)`.

Root cause: `scripts/jobs/triager.sh:25` sets `: "${GARDEN_REPOS:=$GARDEN_ROOT/repos}"`, but the garden's standing bare clones live under `$GARDEN_ROOT/worktrees/<owner>-<repo>.git` (see `scripts/jobs/ensure-project-worktree.sh:63` `bare="$GARDEN_ROOT/worktrees/${owner}-${name}.git"` and `scripts/jobs/clone-keeper.sh`, which provisions/freshens clones there). `$GARDEN_ROOT/repos` does not exist, and the systemd template `scripts/systemd/garden-triager@.service` injects only `GARDEN_ROOT`, so the wrong default is always used. The correct clone (e.g. `worktrees/kriscendobot-vattr97.git`) is present and valid.

Fix: change the `GARDEN_REPOS` default in `scripts/jobs/triager.sh:25` from `$GARDEN_ROOT/repos` to `$GARDEN_ROOT/worktrees`, so `BARE="$GARDEN_REPOS/$slug.git"` (line 31) resolves to the real standing clone. Apply the same one-line default fix to `scripts/jobs/comment-watcher.sh:179` for consistency (it currently silently misses its bare clone and falls back to gh-only polling on line 311-312). Verify no other caller depends on the old `repos/` default (grep shows only these two scripts plus their tests, which pass `GARDEN_REPOS` explicitly). Update the header comment in triager.sh (line 6-7, "under $GARDEN_REPOS/<slug>.git") if it names the old path, and confirm the fix against the deployed root by re-running one triager tick (e.g. `garden-triager@kriscendobot-vattr97`) to green.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 16
  claimed_at: 2026-07-11T01:56:16Z
