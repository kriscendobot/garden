Implemented and pushed commit `a78fb723aa8` to `main2`.

- Captures soft clone-lock give-ups and suppresses per-clone warnings.
- Emits one coalesced busy-clone summary per maintenance tick.
- Preserves real diagnostics and reports non-contention failures.
- Added regression coverage for contention coalescing and repack failures.
- Checks passed: new regression test, `clone-keeper-test.sh` (47/47), Bash syntax, ShellCheck, and `git diff --check`.

Follow-ups: none.
Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-silent-namespace-clone-lock-contention.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 252s

<!-- garden-usage-end -->
