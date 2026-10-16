---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-10-16T20:14:59Z
job: improve-build-job-budget-inference
claim: 51a78fa68731b750
---
Implemented automatic builder-budget inference in scripts/jobs/post-job.sh.

- Automatic basenames ending in -build or -build-<n> now receive handler-budget-role: builder when no leading role, handler-budget-role, or positive handler-timeout already declares an execution budget.
- Explicit execution metadata and manual/canary dispatches remain unchanged.
- Added a hermetic regression suite covering both suffixes, near misses, explicit overrides, the effective 7200s budget, and manual exclusion.
- Pushed commit 7ff6f44ce68f97d871e02146bc4704814cff4159 to origin/main2.
- Tests passed: post-job-build-budget-test.sh (7/7), post-job-template-role-test.sh (5/5), build-handler-budget-test.sh (32/32), job-frontmatter-validation-test.sh (20/20), producer-body-hang-test.sh (34/34), and tests/checks/run.sh (13 suites).
- The broad scripts/jobs/test/run-test.sh baseline reported 387 passes and 24 unrelated failures in existing gardener-scaler, follow-up, foreman, and plan/unblock cases.

Self-improvement: nothing this time.
