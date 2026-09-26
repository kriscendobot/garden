Implemented and pushed commit `fb77e25a80` to `main2`.

- Terminal Codex policy refusals during resume now skip the wasteful fresh-session retry.
- The original refusal diagnostic remains intact for gardener classification and quarantine.
- Added a captured Codex refusal fixture and full handler regression test.
- Verified: resume regression 7/7 passing; quarantine tests 3/3 passing; mutation check failed as expected before restoration.
- Broader suite: 378 passed, with one unrelated issue-inbox stderr assertion failure.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-codex-policy-refusal-retry.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 482s

<!-- garden-usage-end -->
