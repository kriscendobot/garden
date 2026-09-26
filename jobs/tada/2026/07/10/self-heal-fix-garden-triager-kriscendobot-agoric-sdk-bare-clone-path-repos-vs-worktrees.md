The fix is already landed on `origin/main2` — a peer landed the identical change (commit `118f7384fc`) while I was working. My commit was correctly dropped as redundant by the rebase CAS. Both files now carry the corrected default, and my read-only verification confirmed it resolves the bare clone.

## Completion report

**Job:** Self-heal the per-repo triager FATAL-loop (`"no bare clone at <root>/repos/<slug>.git"`) affecting all 8 armed triagers.

**Root cause (confirmed):** `scripts/jobs/triager.sh` and `scripts/jobs/comment-watcher.sh` defaulted `GARDEN_REPOS` to `$GARDEN_ROOT/repos`, but standing bare clones live under `$GARDEN_ROOT/worktrees/<owner>-<repo>.git`. The `garden-triager@.service` unit exports only `GARDEN_ROOT`, so the wrong default always won. Verified `repos/` does not exist and `worktrees/kriscendobot-agoric-sdk.git` is a valid bare repo (HEAD=master).

**What I did:**
- Changed the `GARDEN_REPOS` default from `$GARDEN_ROOT/repos` to `$GARDEN_ROOT/worktrees` in both `triager.sh:36` and `comment-watcher.sh:191` (kept consistent, as required).
- Verified read-only against the real bare clone: with the new default, `BARE` resolves (die at line 46 does not fire), `fetch` succeeds, `ref=master`, and `new_sha=37a4fa31…` is a valid 40-hex SHA — i.e. execution reaches the fetch/cursor logic instead of dying. `bash -n` passed on both scripts.
- Committed with explicit pathspecs and pushed to `main2` via the rebase CAS loop.

**What changed:** Net-zero from my worktree — a peer gardener landed the byte-identical fix as `118f7384fc` ("fix(jobs): triager/comment-watcher default bare-clone dir to worktrees/") concurrently, so my commit was dropped by the rebase as "patch contents already upstream." I confirmed `origin/main2` now has `GARDEN_REPOS:=$GARDEN_ROOT/worktrees` in both files. A related peer commit `e33d0b71ba` ("fix(triager): graceful skip when the host holds no bare clone") is also present.

**Outcome:** The fleet-wide fix is in place on `origin/main2`. No follow-ups.
