Implemented and pushed commit `87e184bad9` to `main2`.

- Added fully-qualified issue/PR reference instructions to the proxy ANSWER prompt.
- Isolated answer-delivery failures per question, with logging, a deduplicated maintainer deferral note, and continued digest processing.
- Added regression coverage proving a failed delivery does not block the next question.
- Verification: targeted proxy suite passed 19/19; syntax and diff checks passed.
- Full job suite: 376 passed, 1 unrelated issue-inbox stderr assertion failed.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-proxy-bare-issue-ref-reply.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 353s

<!-- garden-usage-end -->
