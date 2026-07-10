Fix the wrong bare-clone directory default that makes every `garden-triager@*` instance die each tick with `FATAL: no bare clone at $GARDEN_ROOT/repos/<slug>.git (clone the repo first)` (seen on garden-triager@kriscendobot-minion.town and all sibling triagers: endo, ocapn, agoric-sdk, finbot, vattr97, cosgov, agoric-3-proposals).

Root cause: `scripts/jobs/triager.sh:25` sets `: "${GARDEN_REPOS:=$GARDEN_ROOT/repos}"` and `:31` requires `BARE="$GARDEN_REPOS/$slug.git"` to exist, but the garden keeps its standing bare clones in `$GARDEN_ROOT/worktrees/<slug>.git` — the location `clone-keeper.sh` maintains and `ensure-project-worktree.sh:63` reads (`$GARDEN_ROOT/worktrees/${owner}-${name}.git`), per CLAUDE.md § Layout. No `repos/` directory exists, so the default never resolves and the triager exits 1 on every timer firing.

Change: in `scripts/jobs/triager.sh` change the default to `: "${GARDEN_REPOS:=$GARDEN_ROOT/worktrees}"` (line 25) and update the header comment on line 7 accordingly. The triager slug already equals the `<owner>-<name>` clone basename, so `$GARDEN_REPOS/$slug.git` then resolves to the correct `worktrees/<slug>.git`. Apply the same default fix to `scripts/jobs/comment-watcher.sh:179` for consistency (it currently masks the same bug by only logging a note). Repos with no bare clone yet (cosgov, ocapn, agoric-3-proposals have no `worktrees/*.git`) will still die with the pre-existing message — that is the correct "clone the repo first" signal and out of scope here; only the directory default is wrong. Verify by running `GARDEN_ROOT=/home/kris/garden2 scripts/jobs/triager.sh kriscendobot-minion.town` and confirming it fetches/triages instead of dying on the bare-clone check.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 18
  claimed_at: 2026-07-10T22:53:38Z
