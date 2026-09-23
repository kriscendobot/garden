The remote already has the complete, equivalent fix landed by a peer. Both `triager.sh:38` and `comment-watcher.sh:191` now default `GARDEN_REPOS` to `$GARDEN_ROOT/worktrees`, the header comment is updated, and there's even a bonus predecessor commit (`e33d0b71ba`) adding a graceful skip when a host holds no bare clone. My commit is a pure duplicate that adds nothing, so I'm discarding it rather than force-pushing over the peer's work.

---

**Completion report**

**Job:** Fix `triager.sh` failing every tick with `FATAL: no bare clone at $GARDEN_ROOT/repos/<slug>.git`.

**What I found & did:**
- Made the prescribed fix in my worktree: changed the `GARDEN_REPOS` default from `$GARDEN_ROOT/repos` to `$GARDEN_ROOT/worktrees` in both `scripts/jobs/triager.sh` (line 36) and `scripts/jobs/comment-watcher.sh` (line 191), and updated the triager line-7 header comment accordingly.
- Verified the fix: slug `kriscendobot-endo` → `$GARDEN_REPOS/kriscendobot-endo.git` = `$GARDEN_ROOT/worktrees/kriscendobot-endo.git`, which exists in the deployed root. Both files pass `bash -n`. The `triager-test.sh` suite passed 37/37 (tests set `GARDEN_REPOS` explicitly, so the default change is inert to them; `comment-watcher-test.sh` is pre-existingly flaky on the baseline, unrelated to this change).
- On push, discovered a **peer gardener had already landed the identical fix** on `origin/main2` as commit `118f7384fc` ("fix(jobs): triager/comment-watcher default bare-clone dir to worktrees/"), preceded by `e33d0b71ba` ("fix(triager): graceful skip when the host holds no bare clone"). The remote already has both `GARDEN_REPOS` defaults pointing at `worktrees/`, the header comment updated, and equivalent test coverage.

**Outcome:** The job's objective is fully satisfied on `main2` by the peer's landed commits. I aborted my rebase and discarded my duplicate local commit — nothing to push. No follow-ups needed.

**Changed on main2 (by peer, not me):** `scripts/jobs/triager.sh`, `scripts/jobs/comment-watcher.sh` (+ graceful-skip robustness and triager-test additions).
