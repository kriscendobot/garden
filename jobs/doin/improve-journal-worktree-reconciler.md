Add a deterministic reconciler that keeps the shared `/home/kris/journal` worktree fast-forwarded to `origin/journal2`, modeled on the existing `scripts/jobs/clone-keeper.sh` + `scripts/systemd/garden-clone-keeper.service` pair. The worktree currently drifts unbounded (observed 2331 commits behind, 3 unpushed local-only "aborted" commits) because the scripted pipeline works only in per-instance clones / `$GARDEN_SCRATCH` and `common.sh` intentionally never touches it — so every agent (e.g. the scholar in result-scholar-a0a1c7) that encounters it pays a detect-and-route-around tax and the worktree stays a `reset --hard` foot-gun (see stored feedback feedback_journal_reset_clobbers_garden / feedback_journal_poll_daemon_race). The new `scripts/jobs/journal-worktree-keeper.sh` must be conservative to respect the autostash/clobber hazards: bounded `git fetch` (reuse the `GARDEN_FETCH_TIMEOUT`/retry helpers in `common.sh`), then advance only via `git -C "$GARDEN_ROOT/journal" merge --ff-only origin/journal2` **and only when** `git status --porcelain` is empty AND `git rev-list --count origin/journal2..HEAD` is 0; if the tree is dirty or has unpushed/divergent commits, do NOT reset or pull — instead emit a single throttled `alert_maintainer`-style report naming the divergence and leave the worktree untouched. Ship a matching `scripts/systemd/garden-journal-worktree-keeper.{service,timer}` on the same cadence as clone-keeper, and a `scripts/jobs/test/journal-worktree-keeper-test.sh` covering the three cases (clean+behind → fast-forwarded; dirty → untouched+alert; local-ahead → untouched+alert).

<!-- garden-reaped: 1 -->

---
claim:
  host: endolinbot
  gardener: 36
  claimed_at: 2026-06-27T14:10:39Z
