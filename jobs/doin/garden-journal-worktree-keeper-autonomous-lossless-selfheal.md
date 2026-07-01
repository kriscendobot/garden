# journal-worktree-keeper: autonomously self-heal a diverged worktree (lossless) + fix the root cause
Garden-infra reliability bug. The `journal-worktree-keeper` has paged the maintainer inbox **hourly for
11+ hours** about the SAME diverged `/home/kris/journal` worktree (3 superseded local-ahead commits from
2026-06-25/26, 6000+ behind, ~6 dirty paths), leaving it UNTOUCHED each time. The maintainer already
established the opposite principle for the watchman (autonomous, lossless wedge resolution — never page);
apply it here. A watchdog that pages hourly for a self-resolvable lossless wedge is the defect.

## Part 1 — Autonomous LOSSLESS self-heal (replace the hourly page for the common case)
Make the keeper resolve a diverged worktree itself, with strong safeguards:
1. **Back up** the local-ahead commits (`git format-patch origin/journal2..HEAD`) and every dirty path to
   a host-local backup dir (outside the worktree).
2. **Verify losslessness:** (a) NO active writer — dirty-file mtimes stable across a short window AND no
   process has the worktree as cwd; (b) each local-ahead commit's content and each dirty tracked file is
   **already present/superseded on origin/journal2** (or safely captured in the backup). Untracked new
   files (e.g. a stray `entries/…` result) are backed up and cleared.
3. If lossless-safe → `git reset --hard origin/journal2` + `git clean` the backed-up untracked files, so
   the worktree returns to current. Log what it backed up.
4. **Page the maintainer ONLY** when it detects GENUINE unpreservable WIP (a local commit or dirty change
   NOT on origin and not safely backupable) — the rare real case. Never page for the lossless case again.

## Part 2 — Root cause: stop writes landing in the shared /home/kris/journal worktree
The worktree keeps getting re-dirtied because some path writes library sections / `entries/*` **directly
into `/home/kris/journal`** instead of an isolated producer clone (observed: captp `finalize.js` sections
at 03:43; a stray `195620Z-result-gardener-*.md` entry at 19:56). Trace which producer/role writes to
`/home/kris/journal` directly (vs the `$GARDEN_STATE/.../journal` producer clones the job scripts use) and
fix it so nothing mutates the shared read worktree — eliminating the divergence at the source.

Tests: (a) a diverged-but-superseded worktree with no active writer is auto-healed (not paged);
(b) genuine unpushed WIP is preserved + paged, never clobbered; (c) an active writer aborts the heal.
Land on `main2` via an isolated worktree off origin/main2. Files: `journal-worktree-keeper` script (+ its
timer), and whatever producer path Part 2 identifies.

---
claim:
  host: endolinbot2
  gardener: 16
  claimed_at: 2026-07-01T14:47:30Z
