Work complete. Both test suites pass (56 + 25, all green) and the change is pushed to main2.

## Completion report

**Job:** Harden `journal-worktree-keeper.sh` to self-heal a *dangling journal-worktree link*, and add a keeper test.

**Finding:** The core dangling-gitdir repair the job describes was already landed by prior commits (`ce4b94831`, `b208fb932`, `d4b231773`): `jw_repair_gitdir()` runs `git -C $GARDEN_ROOT worktree repair $JW` before any fetch, and `jw_rebuild_dangling_worktree()` handles the owning-checkout-deleted case. Comparing against this job's exact spec, two gaps remained, which I closed:

**What I changed** (`scripts/jobs/journal-worktree-keeper.sh`):
1. **Repair success now gated on origin resolving too.** The prior success gate checked only `rev-parse --git-dir`, but the failure this job targets surfaces as *both* the gitdir dying *and* the downstream `FATAL: no JOURNAL_REMOTE set and no origin on $GARDEN_ROOT/journal` (from `journal_remote`, which can no longer derive origin off a broken worktree). `jw_repair_gitdir`'s post-`worktree repair` gate now requires **both** `rev-parse --git-dir` **and** `config --get remote.origin.url` before declaring the heal done, and logs a `REPAIRED:` line on success (per spec).
2. **Opening guard in `keep_journal_worktree()`** now applies the same dual check — it skips the tick (WARN) only if gitdir *or* origin is unresolved after repair, so a re-link that leaves origin unreadable is not mistaken for repaired.
3. Header comment updated to document the dual gate and the `REPAIRED:` line.

**Test** (`scripts/jobs/test/journal-worktree-keeper-test.sh`): the existing "DANGLING GITDIR — `.git` points at a defunct path" case already stubs a `$JW` whose `.git` points at a nonexistent gitdir and asserts repair-not-skip. I strengthened it to also assert (a) origin resolves through the worktree post-repair and (b) a `REPAIRED:` line was logged.

**Verification:** `journal-worktree-keeper-test.sh` → 56 passed / 0 failed; `journal-worktree-relink-test.sh` (common.sh sibling) → 25 passed / 0 failed. `bash -n` clean.

**Optional deploy belt-and-suspenders — intentionally skipped.** The job flagged adding `worktree repair` to `deploy-garden.sh` as optional. I examined it: its `atomic_advance_tree` advances the root tree **in place** and never re-homes/moves `$GARDEN_ROOT`, so the failure window (a moved/deleted owning checkout) does not open through a normal deploy — the re-home is a manual/container operation. Adding a repair call there would be a no-op for the actual failure mode and misleadingly imply coverage. The keeper's ~30m tick is the correct deterministic closer, which this change hardens.

**Follow-ups:** none.
