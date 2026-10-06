Implemented and pushed commit `42ca0ec2d87` to `main2`.

- Deadmail now stops the tick after the first post returning 124 or 75, logs once, preserves queued mail, and exits 75.
- Item-specific nonzero failures still continue.
- Added CI-covered regression tests for both transient codes and ordinary failures.
- Focused tests, schedule carry-forward tests, shellcheck, and syntax checks pass.
- CI reached and passed the new test; the workflow remains red from the same unrelated maintainer-inbox gate failure present on the parent commit.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-deadmail-tempfail-short-circuit.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 582s

<!-- garden-usage-end -->
