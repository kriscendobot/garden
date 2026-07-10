The per-repo triager FATAL-loops (`triager.sh:32`, "no bare clone at <root>/repos/<slug>.git") for every armed repo, e.g. `kriscendobot-agoric-sdk`. Root cause: `scripts/jobs/triager.sh:25` (and the identical `scripts/jobs/comment-watcher.sh:179`) default `GARDEN_REPOS` to `$GARDEN_ROOT/repos`, but standing bare clones live under `$GARDEN_ROOT/worktrees/<owner>-<repo>.git` (canonical per CLAUDE.md § Layout, `clone-keeper.sh`, WORKTREES.md). The `repos/` directory does not exist; `worktrees/kriscendobot-agoric-sdk.git` exists and is a valid bare repo (HEAD=master). The `garden-triager@.service` unit exports only `GARDEN_ROOT`, so the wrong default always wins. Fix: change the `GARDEN_REPOS` default in both `triager.sh` and `comment-watcher.sh` from `$GARDEN_ROOT/repos` to `$GARDEN_ROOT/worktrees` (the two must stay consistent — comment-watcher only hides the bug behind its non-fatal note at line 312, so it too is silently not using the local clone). Verify by running `scripts/jobs/triager.sh kriscendobot-agoric-sdk` and confirming it resolves the bare clone and reaches the fetch/cursor logic instead of dying. This is a fleet-wide fix affecting all 8 armed triagers, not just agoric-sdk.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 15
  claimed_at: 2026-07-10T22:53:23Z
