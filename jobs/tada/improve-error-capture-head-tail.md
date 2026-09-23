Implemented and pushed commit dc23bc133d to main2.

Error captures now retain bounded head and tail slices with an explicit middle-omission marker. Updated documentation and regression coverage.

Verification:
- Targeted test: 9 passed, 0 failed.
- Shellcheck and git diff checks passed.
- Full suite: 378 passed, 1 unrelated issue-inbox stderr test failed.

Follow-ups: none.
Self-improvement: updated the relevant skill documentation to reflect the new capture behavior.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-error-capture-head-tail.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 280s

<!-- garden-usage-end -->
