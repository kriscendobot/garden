Implemented and pushed commit `55420ae7f19` to `main2`.

- Issue-inbox watcher now quietly honors an existing attributed primary-quota cooldown before classifying synthetic admission-refusal text.
- Preserves the original cooldown owner/deadline and prevents duplicate warnings while freezing the cursor.
- Added race regression coverage.
- Verified: syntax checks passed; `issue-inbox-watcher-test.sh` passed all 68 cases.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-issue-inbox-collateral-primary-quota.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 309s

<!-- garden-usage-end -->
