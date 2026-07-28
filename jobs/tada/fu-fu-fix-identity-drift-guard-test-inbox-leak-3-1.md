Triage complete; no new commit needed—fixes are already on `main2` in `4b0f53c918`.

The 14 gate entries were genuine policy drift: free-standing orchestrator/orchestration/restore references were allowlisted; scoped/common/botanist/prosecutor/schedule/review-retrospective references were scrubbed. The identity-drift test is now hermetic and cannot post to production.

`test_run_all` was a container sandbox artifact: `/tmp` is `noexec`, so its fake `claude` was skipped. It now uses an executable temp base and fails closed if the stub cannot resolve. The other red suite, `test_maintainer_inbox_information_hiding`, was real allowlist/content drift.

Verified: inbox gate clean; maintainer-inbox suite 10/10 pass; `test_run_all` 12/12 pass; full checks runner 7/7 suites pass.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-fu-fix-identity-drift-guard-test-inbox-leak-3-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 133s

<!-- garden-usage-end -->
