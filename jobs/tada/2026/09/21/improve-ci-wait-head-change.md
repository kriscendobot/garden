Implemented and pushed commit `b5a3c48fae` to `main2`.

- CI wait now exits immediately with code 4 and an explicit `ci-head-changed … re-enqueue` outcome when the live PR head differs from the post-rebase head.
- Added regression coverage for an authorized concurrent force-push, including both head OIDs and ensuring no merge occurs.
- Verified: `ci-wait-merge-test.sh` passes all 66 assertions; ShellCheck and `git diff --check` pass.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-ci-wait-head-change.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 188s

<!-- garden-usage-end -->
