Done. All work is complete and durably landed on `origin/main2`.

## Completion report

**Job:** Upgrade `journal-worktree-keeper.sh`'s gitdir guard from WARN-and-skip into an autonomous, lossless rebuild so a dangling `$GARDEN_ROOT/journal/.git` self-heals instead of wedging every journal consumer.

**Context discovered:** This was a *live, host-wide* incident — `/home/kris/.git/worktrees/` had been deleted entirely, so the journal worktree **and my own job worktree** both failed with `fatal: not a git repository`. The fleet was working the whole class concurrently; peers had already landed the `journal_remote()` common.sh hardening (a0ddbce, cdd3410) and a first keeper `jw_repair_gitdir` — but **all of those only ran `git worktree repair`, which fails outright when the owning checkout is gone** (no admin entry to re-link, exactly as I confirmed live). This job's rebuild path was the missing piece.

**What I did (commit `d4b231773` on `origin/main2`):**
- Extended `jw_repair_gitdir`: STEP 1 (`worktree repair` + always-`prune`, preserving peer cdd3410's intent, gated on the linkage actually resolving) → on failure, STEP 2 `jw_rebuild_dangling_worktree`.
- Added `jw_rebuild_dangling_worktree`: prune → lossless backup of every file still under `$JW` → remove stale dir → `git worktree add --force` off `$JOURNAL_BRANCH` (falling back to `origin/$JOURNAL_BRANCH` when the local branch is absent) → fall through to the normal fetch/reconcile. **Hard-guarded** to only ever act on `$GARDEN_ROOT/journal`, only after `$GARDEN_ROOT` is confirmed a repo-with-origin, and only removes the dir after a completed backup. Pages only for genuinely uncapturable WIP or a failed re-add.
- Added `jw_backup_raw_tree`: byte-copies the tree (git is inoperable, so format-patch/ls-files can't run), `find -print0` to handle dotfiles/odd names, skips the broken `.git`.
- Added two keeper tests (owning-checkout-deleted rebuild + the guard-refuses-non-canonical-path case) using real git fixtures. **55/55 pass**, including all peer cases; the tests drive actual `worktree add`/`prune`/`repair` end-to-end.

**Merge handling:** rebased twice through concurrent peer pushes; resolved a conflict in `jw_repair_gitdir` by keeping the peer's always-prune alongside my STEP-1 gate and STEP-2 call.

**Prior-job consolidation:** Both per-service jobs are already off the active board — `self-heal-fix-garden-gardener-scaler-journal-worktree-gitdir-repair` is in `tada/` (its report explicitly notes the keeper now self-heals a dangling gitdir), and `self-heal-fix-garden-gardener-journal-worktree-dangling-gitdir-repair` was completed/consolidated by peers (absent from `todo/doin/tada/plan`). Nothing left to close; this keeper fix is the shared hardening covering the whole recurring class.

**Live state:** `/home/kris/journal` is now healthy (on `journal2`) — peers emergency-repaired the incident. My fix ensures the keeper heals this autonomously going forward once deployed (deployment is a separate deliberate `deploy-garden.sh` step, out of scope).

**Follow-up (out of scope):** The *job-worktree* creation/repair path surviving a garden-root move — a broken job worktree can't be fixed by `git worktree repair` alone (I worked around it via a fresh registered worktree) — remains worth a dedicated job; and the stale `/home/kris` vs canonical `/home/kris/garden2` git-metadata split noted in the scaler report.
