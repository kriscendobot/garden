---
provider: anthropic
lane: pty
role: assayer
tier: mentor
handler-timeout: 7200
fallback-tier: minion
dispatch: automatic
---

# PR #81 pty-lane live validation test (kriscendobot/garden#81, review 5119818493)

Repository: kriscendobot/garden
Pull request: https://github.com/kriscendobot/garden/pull/81

This is a TEST job for the experimental `lane: pty` merged in PR #81. It is read-only:
do NOT edit, commit, or push anything, and do NOT comment on GitHub. The orchestrator
that posted you writes the maintainer report from your durable completion report.
Never run git in the deployed garden root (/home/kris/garden2); read files there only.

Do each step and record exact commands, outputs and exit codes in your report:

1. **Lane proof.** Record `hostname`, `echo GARDEN_PTY_LANE=$GARDEN_PTY_LANE`,
   `echo GARDEN_PTY_REPORT_FILE=$GARDEN_PTY_REPORT_FILE`, `echo GARDEN_JOB_BASE=$GARDEN_JOB_BASE`,
   `[ -t 0 ] && echo stdin-tty || echo stdin-not-tty`, and the process ancestry
   (walk `/proc/$PPID/..` via `ps -o pid,ppid,args -p <pid>` up to pid 1) looking for
   `pty-lane/run.py`. REQUIRED assertion A1 (interactive lane, not headless fallback):
   PASS iff `GARDEN_PTY_LANE=1`, OR (GARDEN_PTY_REPORT_FILE is non-empty AND
   `pty-lane/run.py` appears in the ancestry). Note explicitly whether GARDEN_PTY_LANE
   was set — the deployed run.sh exports GARDEN_PTY_REPORT_FILE and GARDEN_JOB_BASE
   but may not export GARDEN_PTY_LANE; report that fact, do not invent it.
2. **Deployed SHA.** `bash -c 'source /home/kris/garden2/scripts/jobs/common.sh >/dev/null 2>&1; deployed_sha'`.
   REQUIRED A2: it is non-empty.
3. **Useful work.** Read the deployed implementation
   (`/home/kris/garden2/scripts/jobs/pty-lane/{run.sh,run.py,statusline.sh}`,
   `scripts/jobs/pty-context-read.sh`, the `lane: pty` branch of
   `scripts/jobs/handlers/monk-claude.sh`) and summarize in 3–6 bullets how the lane
   is selected and how completion is recorded. Then run
   `bash /home/kris/garden2/scripts/jobs/test/pty-context-test.sh` (use a writable
   TMPDIR under /home/kris/garden2/scratch if /tmp is noexec) and record its pass/fail
   counts and exit code. REQUIRED A3: the test exits 0 with zero failures.
4. **Live context reader.** While THIS session is still alive, run
   `/home/kris/garden2/scripts/jobs/pty-context-read.sh` (defaults to $GARDEN_JOB_BASE),
   then `... --format json`. Record the exit code and every field (used_percentage,
   epoch, job_base, session_id, etc.). If the first call exits 2, wait ~10s and retry up
   to 3 times (the statusLine may not have fired yet). REQUIRED A4: exit 0 with a
   fresh figure whose job_base equals $GARDEN_JOB_BASE.
5. **Report** worker host, deployed SHA, each assertion A1–A4 as PASS/FAIL with
   evidence, and final outcome. If ANY of A1–A4 fails, emit the orchestration-failure
   signal line immediately before the completion signal line; otherwise emit only the
   completion signal. Follow the pty-lane completion protocol appended to your prompt
   (write the final report to the signal file too).

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-28T23:31:13Z
