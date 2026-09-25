**Completion report: self-heal-fix-garden-comment-watcher-endojs-endo-but-for-bots-verify-clone-timeout-fatal**

A journal VERIFY-clone timeout no longer crashes the watchers. They now skip the tick quietly (exit 75) instead of dying with a FATAL error that triggers a self-heal escalation. The fix is pushed to `main2` as `86c94ab973d`.

**What changed:**
- **`comment-watcher.sh` `verify_fetch()`**: the locked-subshell call now uses `ensure_clone_or_latch_outage "$VERIFY" comment-watcher-verify` instead of the raw `ensure_clone`. The existing unlock-and-re-raise wrapper around it is kept, so the clone lock is still released before the exit code is passed on. I added a short comment explaining why.
- **The same swap in the seven other scripts the job listed**, each with its own latch tag:
  - `ci-watcher.sh`
  - `issue-inbox-watcher.sh`
  - `mention-watcher.sh` (the journal allowlist read)
  - `approval-reconciler.sh`
  - `dependabot-watcher.sh`
  - `pages-watcher.sh`
  - `backfill-dropped-review-comments.sh`

**Checks:**
- **Timeout failure:** I stubbed the clone to reproduce the captured tail (`clone of … timed out` followed by `FATAL: clone of … failed`, rc=1). The wrapper recognised it as an outage, set the host cooldown and returned 75. `self-heal-run.sh` already treats 75 as a quiet skip.
- **Auth failure:** the stubbed `fatal: Authentication failed` case still exits loudly with rc=1 and prints its error, so real faults are not hidden.
- **Existing tests:** the suites for all seven watchers pass, 0 failures:

| Suite | Passed |
|---|---|
| comment-watcher | 384 |
| ci-watcher | 75 |
| dependabot-watcher | 53 |
| mention-watcher | 41 |
| approval-reconciler | 18 |
| pages-watcher | 16 |
| issue-inbox-watcher | all |

**Follow-ups:** None needed. There's no dedicated test yet that a VERIFY-clone timeout yields exit 75; one could be added to `comment-watcher-test.sh` if we want a guard against regressions.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-comment-watcher-endojs-endo-but-for-bots-verify-clone-timeout-fatal.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (692894 cached reads)
- Output: 5846 tokens
- Cost: $0.6698348000000002
- Wall-clock: 151s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
