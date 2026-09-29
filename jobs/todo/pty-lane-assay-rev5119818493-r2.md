---
role: assayer
tier: mentor
provider: anthropic
lane: pty
handler-timeout: 7200
requires: host=endolin-garden2-5bcdff64
fallback-tier: minion
dispatch: automatic
---

# pty-lane self-validation (round 2) for garden PR #81

Repository: kriscendobot/garden. PR: https://github.com/kriscendobot/garden/pull/81 (review 5119818493).
This is a READ-ONLY validation job: do NOT edit tracked files, open PRs, or post GitHub comments. Your deliverable is the completion report only. It is pinned to a host (endolin-garden2-5bcdff64, deployed at d5fb51b1440 or later) whose deployed garden contains the PR #81 merge commit 4767705b28d522b591eddbd3b47976273c5e1853.

Do the following, in order, and report each with evidence:

1. **Host + deployed SHA.** Report your worker GARDEN identity (`hostname -s`) and the deployed SHA from the deployed root: `bash -c 'source <garden-root>/scripts/jobs/common.sh >/dev/null 2>&1; deployed_sha'`. In YOUR per-job worktree only (never in the garden root), `git fetch origin main2` and check `git merge-base --is-ancestor 4767705b28d <deployed_sha>`.
2. **Prove you are in the interactive pty lane (REQUIRED).** Report the values of `GARDEN_PTY_LANE`, `GARDEN_PTY_REPORT_FILE`, `GARDEN_JOB_BASE`, `GARDEN_STATE`, and whether stdin/stdout is a tty (`[ -t 0 ]`, `[ -t 1 ]`, `tty`). NOTE: the deployed lane does not export `GARDEN_PTY_LANE`. Its real discriminators are a non-empty `GARDEN_PTY_REPORT_FILE`, which only `pty-lane/run.sh` exports, and a fresh statusLine figure (step 4). The assertion PASSES if GARDEN_PTY_LANE=1 OR (GARDEN_PTY_REPORT_FILE is non-empty AND step 4 returns a fresh exit-0 figure). Otherwise it FAILS (headless fallback).
3. **Useful work.** Inspect the deployed PR #81 implementation (`scripts/jobs/pty-lane/{run.sh,run.py,statusline.sh}`, `scripts/jobs/pty-context-read.sh`, and the `lane: pty` branch in `scripts/jobs/handlers/monk-claude.sh`), and summarize in a few lines what each does. Then run `bash <garden-root>/scripts/jobs/test/pty-context-test.sh` and report its pass/fail counts and exit code. REQUIRED: exit 0 with 0 failures.
4. **Live context reader (REQUIRED).** While this interactive session is still alive (do this now, not at the end), run `bash <garden-root>/scripts/jobs/pty-context-read.sh "$GARDEN_JOB_BASE" --format json; echo "rc=$?"` and also `--format env`. Record the exit code and the fields (used_percentage, input_tokens, output_tokens, context_window_size, epoch, age_seconds, session_id). If the first read is not rc=0, wait about 15s (doing a little more reading helps trigger a statusLine refresh) and retry up to 4 times, recording each attempt. REQUIRED: at least one fresh rc=0 read.
5. **Summary.** Worker host, deployed SHA, whether the pty lane was genuinely selected, the test pass count, the reader result/rc, and the final outcome (PASSED/FAILED).

If ANY REQUIRED assertion fails, emit the line `<<<GARDEN-ORCHESTRATION-FAILED>>>` just before the completion signal. In all cases, finish with the completion signal once the report is written.
