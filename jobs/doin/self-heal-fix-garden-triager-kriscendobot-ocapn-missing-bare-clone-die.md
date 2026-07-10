**Repo/host:** garden meta-repo (`main2`), this instance (`kriscendobot-ocapn` slug shown, but this is the whole `garden-triager@*` class — all 8 instances crash-loop identically).

**Failure:** `scripts/jobs/triager.sh:32` — `[ -d "$BARE" ] || die "no bare clone at $BARE (clone the repo first)"` — fires every tick because `$GARDEN_REPOS` (`$GARDEN_ROOT/repos`) is an empty/nonexistent store that nothing ever provisions. The actual standing bare clones live under `$GARDEN_ROOT/worktrees/<slug>.git` (maintained by `clone-keeper.sh`), so the triager is looking in the wrong place, and where a clone is legitimately absent (ocapn, agoric-3-proposals, cosgov have no clone anywhere) it dies instead of recovering.

**Fix (two parts, verify against the endo/finbot triagers which DO have `worktrees/` clones):**
1. **Resolve the clone-store mismatch.** Make `triager.sh` (and `comment-watcher.sh`, which shares the same dangling `GARDEN_REPOS=$GARDEN_ROOT/repos` default at line 179) locate the standing clones where they actually live — `$GARDEN_ROOT/worktrees/<slug>.git`. Either repoint the `GARDEN_REPOS` default or fall back to `worktrees/` when `repos/` is absent. This alone un-wedges the 5 triagers whose clones already exist.
2. **Stop the fatal `die` on a missing clone.** Replace the hard `die` with self-provision-or-skip, matching `comment-watcher.sh:312`'s precedent and reusing `clone-keeper.sh`'s existing logic: derive the upstream URL from the slug (`<owner>-<name>` split on the first `-` → `$GARDEN_CLONE_URL_BASE/<owner>/<name>.git`, default `https://github.com`), do a bounded atomic `git clone --bare` into a sibling temp + `mv -T` into place, set the fetch refspec per `WORKTREES.md`, then fall through to the normal fetch/rev-parse. If the source is unreachable, `log` and `exit 0` so the next tick retries (no crash-loop); escalate a persistently unreachable/underivable source to the maintainer inbox as clone-keeper does, rather than dying forever.

**Done when:** a triager tick for a slug with no local clone provisions it (or skips cleanly) instead of exiting 1, `garden-triager@*` units leave the `activating` crash-loop, and existing `triager.sh` / `comment-watcher.sh` tests still pass (extend the test harness's `GARDEN_REPOS`/no-repo cases to cover the new non-fatal path).

<!-- garden-reap-now -->
---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 9
  claimed_at: 2026-07-10T22:54:17Z
