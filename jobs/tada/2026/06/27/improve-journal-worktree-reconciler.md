Inbox empty. The job is complete.

---

## Completion report

**Job:** `improve-journal-worktree-reconciler` — added a deterministic reconciler that keeps the shared `/home/kris/journal` worktree fast-forwarded to `origin/journal2`.

**What I did / what changed** (4 new files, committed `3ed55eec3` and pushed to `origin/main2` via an isolated worktree off `origin/main2` per the garden-infra discipline):

- **`scripts/jobs/journal-worktree-keeper.sh`** — modeled on `clone-keeper.sh`. Per tick: bounded fetch of `origin/journal2` (reuses common.sh's `journal_fetch` → `GARDEN_FETCH_TIMEOUT`/retry/backoff helpers), then advances **only** via `git merge --ff-only origin/journal2`, and **only when** `git status --porcelain` is empty **and** `git rev-list --count origin/journal2..HEAD` is `0`. A dirty or local-ahead/divergent worktree is left **exactly as found** (never reset/pull/stash) and surfaced through a single throttled `alert_maintainer` report naming the divergence (counts of local-ahead, behind, and dirty paths, plus the by-hand reconciliation commands). Offline fetch and a missing worktree both log-and-skip; every path returns 0 so a hiccup never marks the tick Failed.
- **`scripts/systemd/garden-journal-worktree-keeper.service`** + **`.timer`** — same shape and cadence as clone-keeper (`OnActiveSec=10m`, `OnUnitActiveSec=30m`), wrapped in `self-heal-run.sh`. Auto-enabled by `install-units.sh`'s present-units derivation (non-template `.timer` with `WantedBy=timers.target`); no hand-list edit needed.
- **`scripts/jobs/test/journal-worktree-keeper-test.sh`** — hermetic (throwaway bare `origin` on `journal2` + a real checkout standing in for `journal/`; `alert_maintainer` captured via `GARDEN_ALERT_CMD`, no network/inbox touched). Covers the three required cases plus fresh/no-op: **clean+behind → fast-forwarded (no alert)**, **dirty → untouched + alert**, **local-ahead → untouched + alert**. **21/21 pass**, including against the clean-base copy in the build worktree.

**Notes / follow-ups:**
- The keeper is conservative by design — it will **not** auto-clear the currently-observed real-world divergence on `endolinbot`'s `journal/` (2331 behind + 3 stray local commits); it will instead start emitting a throttled maintainer alert each cadence until a human rebases/pushes or discards those 3 commits. That escalation is the intended behavior, but the existing drift still needs a one-time manual reconciliation to go quiet.
- The new test is standalone (run directly, like `clone-keeper-test.sh`); there is no aggregating `*-test.sh` runner in the repo to register it with.
