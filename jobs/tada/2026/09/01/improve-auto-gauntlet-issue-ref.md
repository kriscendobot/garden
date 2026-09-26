Completed `improve-auto-gauntlet-issue-ref`.

- Confirmed the runtime fix skips gauntlet inspection only for GitHub’s definitive “Could not resolve to a PullRequest” response while retaining retries for transient failures.
- Added regression coverage for `kriscendobot/garden#58`, including successful issue-citation handling and a failing HTTP 503 case.
- Extended the GitHub stub to simulate lookup errors.
- Tests passed: `auto-gauntlet-handoff-test.sh`, `design-pr-gauntlet-bypass-test.sh`, `completion-signal-test.sh`, and `followup-posted-gate-test.sh`.
- Pushed commit `d5eb68ae6b` to `main2`.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-auto-gauntlet-issue-ref.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 5 on 2 host(s) (1 unmetered)
- Input: 43 tokens (961275 cached reads)
- Output: 10512 tokens
- Cost: $2.1048595 (1 engagement(s) unpriced)
- Wall-clock: 318s
- Model(s): claude-opus-4-8 ×4

<!-- garden-usage-end -->
