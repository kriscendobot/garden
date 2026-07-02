Done. Committed and pushed to `main2` (rebased cleanly onto `1bfbc1087`).

## Completion report

**Job:** `improve-clone-keeper-reclone-missing` — repair a tracked bare clone that disappears instead of re-warning about it forever.

**What I did**

In `scripts/jobs/clone-keeper.sh`, `keep_clone()` previously logged `WARN: … missing or not a git repo … skipping` and returned for a vanished clone, so `worktrees/endojs-endo.git` (gone at 09:30 and 10:00 on 2026-07-02) was re-warned every tick and never repaired. I added a repair path:

- **Missing + source known** → re-clone via a new bounded `bounded_clone()` (`git clone --bare`, wrapped in `timeout` + retry/backoff mirroring `bounded_fetch`), log a `REPAIRED:` line, then fall through to the normal fetch + fast-forward.
- **Missing + unreachable source** → falls back to the existing skip (no re-clone loop; next ~30m tick retries), and any partial tree a killed clone leaves behind is scrubbed so the missing-vs-corrupt discrimination stays accurate.
- **Missing + bare remote name** (e.g. `origin`) → cannot be resolved once the repo is gone, so it skips rather than guessing a URL.
- **Present-but-corrupt dir** → surfaced as `STALE` for manual reconciliation, never clobbered (may hold un-pushed state).

Two supporting changes:
- Added `is_own_git_repo()` and replaced the plain `rev-parse --git-dir` presence check. Because tracked clones live under `worktrees/` *inside* the garden repo, the old check walked up and false-positived against the garden repo for a missing/corrupt dir; the new predicate requires the resolved absolute git-dir to equal the tracked path.
- Changed the default endo entry to track by URL (`https://github.com/endojs/endo.git`) so it is actually repairable when it vanishes — the source is now the same location the keeper fetches from (`git fetch <url> master` behaves identically to the old named-remote fetch). Header/config comments updated accordingly.

**Tests:** Added hermetic `RECLONE`, `CORRUPT`, `MISSING+UNREACHABLE`, and `MISSING+BARE-NAME` cases to `scripts/jobs/test/clone-keeper-test.sh`. Full suite: **26 passed, 0 failed**. shellcheck shows only pre-existing style patterns, none introduced by this change.

**Follow-ups:** If the deployed endo bare clone's `origin` used a non-public URL (ssh/mirror), a maintainer may want to confirm the public-https default is acceptable for the read-only fetch — it is for the public `endojs/endo` repo, so no action expected.
