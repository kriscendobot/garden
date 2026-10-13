Implemented and pushed commit `dbaad2307c5` to `main2`.

- Added persistent per-PR/stage probe cooldowns, capped at one hour.
- Timed-out probes no longer block later PRs; live cooldowns skip only the affected probe.
- Successful probes clear cooldown markers; expired orphan markers are pruned.
- Added deterministic regression coverage for repeated slow probes and suffix progress.
- Verification: `approval-reconciler-test.sh` passed all 30 checks; Bash syntax, focused ShellCheck, and `git diff --check` passed.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-approval-probe-timeout-backoff.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 320s

<!-- garden-usage-end -->
