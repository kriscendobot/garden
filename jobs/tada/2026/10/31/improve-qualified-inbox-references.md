Implemented and pushed commit `9640492b5bc` to `main2`.

- `inbox-send.sh` now normalizes bare `#N` references using the recipient directive’s unique canonical GitHub repository.
- Ambiguous or unresolved repositories remain fail-closed.
- Added CI-covered regression tests for successful normalization and ambiguous rejection.
- Focused tests, syntax checks, and targeted ShellCheck passed.
- GitHub Actions remains red from pre-existing unrelated ShellCheck warnings, also present on the prior `main2` run.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-qualified-inbox-references.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 364s

<!-- garden-usage-end -->
