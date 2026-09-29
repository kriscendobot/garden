Implemented and pushed commit `cded71d6fad` to `main2`.

- Issue-source transient/quota failures now return rc 75 with diagnostics, without emitting `FATAL`.
- Issue-inbox watcher owns cooldown handling and emits one diagnostic warning.
- Primary-quota failures arm the full REST cooldown window.
- Added regression coverage for primary quota and transient HTTP 503 failures.
- Verification: Bash syntax and diff checks passed; issue-inbox suite passed 64/64.
- Self-improvement: nothing this time.
- Follow-ups: none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-issue-source-quota-degrade.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 413s

<!-- garden-usage-end -->
