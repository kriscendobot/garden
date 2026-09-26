Implemented and pushed commit `fc1d98037d` to `main2`.

- Added bounded clone and journal-sync retries with stage-specific diagnostics.
- Preserved fail-open behavior after retry exhaustion.
- Added recovery/exhaustion regression coverage and stabilized test isolation.
- Verified post-rebase: deadline-nudge suite passes all 46 tests.
- No follow-ups required.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-deadline-nudge-sync-retry.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 751s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
