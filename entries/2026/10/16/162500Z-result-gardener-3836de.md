---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-10-16T16:25:03Z
job: improve-review-docket-rollup-permission-fallback
claim: 5292820dcb43d5d6
---
Implemented a permission-aware review-docket metadata fallback: when GraphQL rejects statusCheckRollup with a non-rate-limit 403, the handler re-reads head/state/review metadata without the forbidden field and derives CI from Actions workflow runs for that exact head. Added a hermetic GraphQL-403 regression test and wired it into focused CI.

Changed: scripts/jobs/handlers/review-docket-pr-gh.sh, scripts/jobs/test/review-docket-pr-gh-test.sh, .github/workflows/checks.yml.

Verification: scripts/jobs/test/review-docket-pr-gh-test.sh passed; scripts/jobs/test/review-docket-test.sh passed; bash -n and shellcheck -S warning passed for the changed shell scripts; git diff --check passed. Commit b8abbe64412 is pushed to origin/main2.

Self-improvement: nothing this time.
