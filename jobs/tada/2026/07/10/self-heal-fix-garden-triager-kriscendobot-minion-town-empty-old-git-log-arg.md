The job's fix is already fully landed on `origin/main2` — no new work was needed. The job was posted just before the fix commits merged (`d486643cf` → `c14da9355`), so I verified rather than re-implemented.

**Findings:**
- `scripts/jobs/handlers/triager-claude.sh:46` already uses the correct revision form `"${old:+$old..}$new"` (mirroring the `range=` line at :26), so an empty `old` yields `$new` alone, not `""`. Commit `d486643cf` made this change; `c14da9355` refined it further (swapped the `| head -400` cap for `sed -n '1,400p'` so a large first-triage diff can't SIGPIPE-abort under pipefail, without a stderr-swallowing `|| true`).
- Reproduction confirms the diagnosis: `git log --no-merges --stat ""` exits **128**, while `git log --no-merges --stat "$new"` exits **0**.
- The regression test `scripts/jobs/test/triager-claude-handler-test.sh` (commit `35db0c0a7`) already exercises the empty-`old` cold-start path (CASE 1), the >400-line SIGPIPE path (CASE 2), and the normal range (CASE 3). I ran it: **PASS=7 FAIL=0**.
- The optional suggestions from the spec are effectively covered: the fresh-repo history is capped (at 400 lines via `sed`, rather than `-n 50`), and git's stderr is no longer blanket-swallowed on that line.

**Changes made:** none — the worktree is clean and no commit/push was required since the fix is already on `main2`.

**Follow-ups:** none. This job can be closed as already-resolved.
