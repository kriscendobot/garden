Repaired endojs/endo-but-for-bots#1174 and pushed two commits:

- `016e1e4f4`: replaced the flaky codex quarantine test’s wall-clock sleeps with deterministic audit synchronization and corrected its audit callback argument.
- `aed0180f0`: widened the sandbox test’s AVA deadlock guard while preserving its independent 25 ms timeout assertion.

Diagnosis: no better-sqlite3 lifecycle regression. A v13 open/query/close probe exited without native handles; the “Failed to exit” messages were fail-fast teardown noise after timing-test failures.

Verification: codex-sandbox passed 110 tests; the focused race passed 20 consecutive runs; sandbox timeout coverage passed under all four SES configurations; type lint, ESLint, and pre-push gates passed. GitHub CI is green: 25/25 checks on `aed0180f0d454a05d3d10cfbacd0b248b9661a6e`.

Posted the completion summary on the PR and durably notified `dependabotany-recheck-endo-but-for-bots` for the MERGE-NOW rerender.

Self-improvement: reported the project warm-cache `.bin` restoration defect to the liaison.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-endo-daemon-better-sqlite3-v13-ci.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 5380s

<!-- garden-usage-end -->
