Applied panel must-fixes to PR #970 and pushed follow-up commits through `062b78929`.

Changes include strict-mode/hang reporting fixes, parser negative handling, catchable native TypeErrors, coherent coercion dispatch, regression coverage, and honest global descriptor aliasing classification.

Verification:
- Rust package suites passed.
- Targeted regressions: 5/5 passed.
- Language slice: 20,603 cases; 6,142 covered; 0 Ironhorse failures.
- Exact-meter corpus: 1,712 covered; 0 failed.
- PR body and completion summary updated.
- CI green: 25/25 checks.

No follow-up required before the driver reposts panel-3.
<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-js-01-lexer-parser-negatives-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 4562s

<!-- garden-usage-end -->
