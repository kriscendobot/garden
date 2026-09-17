Implemented and pushed commit `a692b719b7` to `main2`.

- Preserved `split-indivisible-reason` during plan-to-todo promotion as a safely quoted YAML scalar.
- Added expanded-window regression coverage confirming the promoted child remains acceptable to the overrun-split completion gate.
- Verification: `retry-narrowing-test.sh` passed 16/16; `run-test.sh` passed 386/386; ShellCheck reported informational findings only.
- Follow-up: standalone `promote-plan-doom-reset-test.sh` has two unrelated reaper-fixture failures predating the changed promotion path.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-overrun-split-metadata-promotion.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 316s

<!-- garden-usage-end -->
