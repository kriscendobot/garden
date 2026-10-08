Implemented and pushed commit `3c15e2200aa` to `main2`.

- GraphQL cooldown now skips only optional PR metadata reads while allowing REST terminal-comment delivery.
- Terminal comment failures are captured and classified; primary REST quota exhaustion opens the shared cooldown before persisting the pending receipt.
- Added regression coverage for both quota paths.
- Verification: gauntlet suite passed, 81/81; shell syntax, ShellCheck, and `git diff --check` passed.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-gauntlet-quota-aware-terminal-receipt.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 330s

<!-- garden-usage-end -->
