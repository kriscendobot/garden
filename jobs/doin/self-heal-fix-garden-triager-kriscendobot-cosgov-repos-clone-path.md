The entire `garden-triager@*` fleet is down. Every instance dies with `FATAL: no bare clone at /home/kris/garden2/repos/<slug>.git (clone the repo first)` from `scripts/jobs/triager.sh:32`, because `scripts/jobs/triager.sh:25` (and identically `scripts/jobs/comment-watcher.sh:179`) default `GARDEN_REPOS` to `$GARDEN_ROOT/repos` — a directory that does not exist and is never provisioned. The garden's canonical standing bare clones live under `$GARDEN_ROOT/worktrees/<owner>-<repo>.git` (see `scripts/jobs/clone-keeper.sh:4-5`, `scripts/jobs/common.sh:442-477`, WORKTREES.md); `clone-keeper` maintains them there and nothing ever populates `repos/`.

Fix: change the `GARDEN_REPOS` default in both `scripts/jobs/triager.sh:25` and `scripts/jobs/comment-watcher.sh:179` from `${GARDEN_REPOS:=$GARDEN_ROOT/repos}` to `${GARDEN_REPOS:=$GARDEN_ROOT/worktrees}` so the watcher fleet reads the standing bare clones where they actually live. Verify against the present clones: after the change, `triager.sh kriscendobot-endo` (and finbot/agoric-sdk/minion.town/vattr97, all of which have `worktrees/<slug>.git`) must find `$GARDEN_ROOT/worktrees/<slug>.git` and proceed past the `[ -d "$BARE" ]` guard instead of dying. Update the `# under $GARDEN_REPOS/<slug>.git` header comment in triager.sh accordingly, and check the `comment-watcher.sh` tests (`GARDEN_REPOS="$TR/norepos"` in `scripts/jobs/test/comment-watcher-test.sh`) still pass since they override the default explicitly.

Note (do NOT fix in this job — out of scope): after the path fix, three enabled instances — `kriscendobot-cosgov`, `kriscendobot-ocapn`, `kriscendobot-agoric-3-proposals` — will still fail because they have no standing clone under `worktrees/` at all. Resolving those (provisioning clones via the clone-keeper tracked set, or disabling the instances) is a separate decision that also intersects the CLAUDE.md § Monitoring safety watch-set authorization requirement; flag it to the maintainer rather than silently arming new watched repos.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 19
  claimed_at: 2026-07-11T00:54:29Z
