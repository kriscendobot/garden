`journal_remote()` in `scripts/jobs/common.sh:490` resolves the journal remote URL *only* from `git -C "$GARDEN_ROOT/journal" config --get remote.origin.url`, and `die`s fleet-wide if that config key is missing. This turned a single missing-origin condition on one worktree into 157 FATALs and 74 gardener claim failures over ~6.7h (every producer/consumer/watcher/orchestrate tick routes through this function). Harden it: the first time the URL resolves successfully, persist it to a host-local state file (e.g. `$GARDEN_STATE/journal-remote.url`); when both `$JOURNAL_REMOTE` is unset and the worktree config read fails, fall back to that persisted URL (and, if the persisted URL is present, opportunistically `git -C "$GARDEN_ROOT/journal" remote add origin <url>` to re-heal the worktree in place) instead of `die`. A secondary fallback is to read `remote.origin.url` from any existing per-instance clone under `$GARDEN_STATE`. This converts a fleet-wide FATAL cascade into a self-heal.

---
claim:
  host: endolinbot2
  gardener: 8
  claimed_at: 2026-07-04T03:22:04Z
