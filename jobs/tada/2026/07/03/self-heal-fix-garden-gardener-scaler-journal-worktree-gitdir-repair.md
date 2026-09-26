Both parts complete and confirmed durable. My commit `ef323fc4a` is in origin/main2's history and the hardening is present in `origin/main2:scripts/jobs/common.sh`. Sibling jobs converged complementary fixes (the keeper now also self-heals a dangling gitdir rather than reverting it).

---

## Completion report

**Job:** Fix the stale journal worktree gitdir link and harden `common.sh` against recurrence.

**What I did**

1. **Repaired the live state.** Ran `git -C /home/kris/garden2 worktree repair /home/kris/garden2/journal`. It rewrote both the dangling worktree `.git` file (was `gitdir: /home/kris/.git/worktrees/journal` → now `/home/kris/garden2/.git/worktrees/journal`) and the admin back-pointer. Verified end-to-end: `git -C .../journal rev-parse --git-dir` exits 0, `remote.origin.url` resolves, and sourcing the deployed `common.sh` with `GARDEN_ROOT=/home/kris/garden2` makes `journal_remote` return `git@github.com:kriskowal/garden.git`. Confirmed `/home/kris/garden2` is canonical (systemd units set `GARDEN_ROOT=/home/kris/garden2`; `/home/kris` is the stale pre-move location).

2. **Hardened `journal_remote()`** in `scripts/jobs/common.sh`: before reading the origin, if `git -C "$GARDEN_ROOT/journal" rev-parse --git-dir` fails, it runs `git -C "$GARDEN_ROOT" worktree repair` once and retries. If the origin still can't be read, it now distinguishes a **broken worktree** (dies naming the dangling gitdir target parsed from `journal/.git`) from a **genuinely missing origin** (unchanged message), so the misleading "no origin" text stops masking a dangling-gitdir failure. Tested all four paths in isolation (healthy / repairable-and-self-heals / missing-origin / unrepairable-broken) — all behave correctly.

**What changed**

- `scripts/jobs/common.sh` — `journal_remote()` self-heal + accurate error classification. Commit `ef323fc4a`, pushed to `origin/main2` (verified present in history; sibling commits landed on top).

**Notes / follow-ups**

- **Push mechanics:** my own job worktree was itself dangling (unregistered in `garden2/.git`, admin metadata dir absent — the same class of post-move breakage, but for a job worktree, which `git worktree repair` can't fix without the admin dir). I worked around it by creating a fresh registered worktree off `origin/main2`, re-applying the identical change, and pushing from there. The **job-worktree creation path** (harness / `ensure-project-worktree`) surviving a garden-root move is a separate follow-up, out of this job's scope.
- **Root cause breadth:** the stale `/home/kris/.git` still holds competing worktree admin entries, and ~5 concurrent sibling "self-heal … dangling gitdir" jobs (deadmail, follow-up, comment-watcher, issue-inbox, orchestrate) were racing the same repair — one of them briefly reverted my first repair. Those consumers are covered by their own sibling jobs; notably `journal-worktree-keeper` was hardened in parallel (`ce4b94831`, `b208fb932`) to repair rather than revert a dangling gitdir, which removes the reverter. A broader cleanup of the stale `/home/kris` git metadata would be worth a dedicated job.
