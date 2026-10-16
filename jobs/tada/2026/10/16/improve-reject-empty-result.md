Implemented and pushed commit `79cde1aaa0d` to `main2`.

- `journal-entry.sh` now rejects empty or whitespace-only `result` bodies before any journal write.
- Added stdin/file regression coverage while preserving empty non-result entries.
- Added the regression test to CI.
- Verified: 32 tests passed; ShellCheck and `git diff --check` passed.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-reject-empty-result.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 165s

<!-- garden-usage-end -->
