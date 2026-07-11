In `scripts/jobs/triager.sh`, the guard at line 32 `[ -d "$BARE" ] || die "no bare clone at $BARE (clone the repo first)"` makes every triager unit for a repo whose bare clone this host has never held (all of `repos/` is empty here) exit 1 on every tick — observed as `garden-triager@kriscendobot-cosgov` FATAL `no bare clone at /home/kris/garden2/repos/kriscendobot-cosgov.git`, plus the failed sibling units for agoric-3-proposals, minion.town, ocapn, vattr97.

This is a documented-but-unimplemented behavior: `scripts/jobs/common.sh:442-446` and `scripts/jobs/clone-keeper.sh:152-155` both assert that "triager.sh self-provisions a watched repo whose clone this host has never held" using the shared `is_own_git_repo` / `derive_clone_url` / `bounded_clone` helpers — but triager.sh never calls them; it just `die`s.

Fix: replace the bare `die` with a self-provision block that, when `$BARE` is missing (use `is_own_git_repo "$BARE"` — a present-but-corrupt dir must still be surfaced as STALE and NOT clobbered, exactly as `clone-keeper.sh`'s `keep_clone` does), derives the fork URL from the slug via `derive_clone_url "$BARE"` (basename `kriscendobot-cosgov.git` → `https://github.com/kriscendobot/cosgov.git`; owner is always `kriscendobot`, so the first-`-` split is unambiguous for all 8 slugs including `agoric-3-proposals` and `minion.town`), runs `bounded_clone "$src" "$BARE"`, then sets `git -C "$BARE" config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'` before falling through to the existing `git --git-dir="$BARE" fetch`. On a re-clone failure keep the `die`/retry semantics (leave cursor, let systemd retry) rather than advancing state. Mirror clone-keeper.sh's precedence and logging (`provisioned missing clone <slug> from <src>`). Verify with a deterministic offline test that a missing `repos/<slug>.git` triggers a bounded_clone against the derived URL and that a present-but-non-repo dir is refused, not clobbered.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  claimed_at: 2026-07-11T01:54:35Z
