Updated `assert-producer-pr-draft.sh` to exempt canonical review/attention jobs when their completion report names the same existing PR cited by the job. Different newly produced PRs remain gated, and quoted feedback-like headings cannot bypass detection.

Added regression coverage for review, attention, mismatched-PR, and heading-spoof cases. The focused test suite and syntax/diff checks pass.

Committed and pushed to `main2` as `57806d881c`.

Follow-ups: None.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-producer-draft-gate-feedback.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 158s

<!-- garden-usage-end -->
