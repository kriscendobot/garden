Implemented and pushed commit `89aa679f9a` to `main2`.

- Candidate-gate suites now capture a configurable 16 KiB stdout/stderr tail.
- Failed-suite diagnostics persist under host-local deploy state with restricted permissions.
- Error reports name the exact diagnostic path, host, exit code, and capture bound.
- Added regression coverage for stdout/stderr capture, truncation, persistence, and report references.
- Verified `deploy-garden-test.sh`: 130 passed, 0 failed.
- Verified all six production candidate-gate suites pass.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-deploy-candidate-gate-diagnostics.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 259s

<!-- garden-usage-end -->
