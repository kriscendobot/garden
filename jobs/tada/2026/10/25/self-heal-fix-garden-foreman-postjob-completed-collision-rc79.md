Implemented and pushed commit `e73321c723e` to `main2`.

- Foreman now treats completed-job collision rc 79 as a healthy no-op, preserves `LAST_STEP`, logs and records the decision, and sends one deduplicated maintainer notice.
- Other `post-job.sh` failures still exit nonzero.
- Handler guidance now skips completed bases or date-suffixes genuinely recurring work.
- Added a hermetic regression test covering exit 0, no repost, preserved state, decision logging, and one-time notification.
- Verification: all seven foreman test suites passed; directive identity suite passed 30/30; ShellCheck passed for the new test; `git diff --check` passed.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-foreman-postjob-completed-collision-rc79.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 310s

<!-- garden-usage-end -->
