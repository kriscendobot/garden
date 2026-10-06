Implemented and pushed commit `ecdd48e8916` to `main2`.

- Added host-scoped consecutive source-timeout strikes with exponential shared cooldowns.
- Reset strikes only after a successful source sweep.
- Preserved cursor freezing and single-warning behavior.
- Added regression coverage for persistence, backoff growth, reset, and warning behavior.
- Validation: syntax, diff checks, and error-level ShellCheck passed. All new timeout/backoff assertions passed; the broader suite reported 447 passes and one unrelated quote-reply failure.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-comment-source-timeout-backoff.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1015s

<!-- garden-usage-end -->
