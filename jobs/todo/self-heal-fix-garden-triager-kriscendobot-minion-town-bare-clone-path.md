`scripts/jobs/triager.sh` dies at line 32 with `FATAL: no bare clone at $GARDEN_ROOT/repos/<slug>.git` on every tick, crash-looping `garden-triager@*`. The standing bare clones the fleet maintains (clone-keeper.sh, ensure-project-worktree.sh) live under `worktrees/<owner>-<name>.git`, NOT `repos/` — the `repos/` name is the journal watch-set marker dir, and `$GARDEN_ROOT/repos` does not exist. `worktrees/kriscendobot-minion.town.git` (and every other watched slug) already exists there.

Fix in `scripts/jobs/triager.sh`:
1. Change the `GARDEN_REPOS` default (line 25) from `$GARDEN_ROOT/repos` to `$GARDEN_ROOT/worktrees`, matching the canonical standing-clone location.
2. Replace the bare `die` on a missing clone (line 32) with self-provisioning, as `common.sh:442-446` already documents triager should do: derive the URL with `derive_clone_url "$BARE"` and clone with `bounded_clone` (the shared helpers), falling back to `die` only when the source is underivable/unreachable. This makes a host that has never held a watched repo's clone self-heal instead of crash-looping.

Also fix the same wrong default in `scripts/jobs/comment-watcher.sh` (line 179, `GARDEN_REPOS:=$GARDEN_ROOT/repos` → `$GARDEN_ROOT/worktrees`) so its opportunistic bare-clone reuse (line 311) actually finds the clone; it degrades gracefully today but logs a spurious "no bare clone" note on every tick. Update the test harness references (`comment-watcher-test.sh`, which passes `GARDEN_REPOS="$TR/norepos"`) as needed. Verify against the existing standing clones under `worktrees/` for all slugs in `journal/repos/`.

<!-- garden-reaped: 1 -->
