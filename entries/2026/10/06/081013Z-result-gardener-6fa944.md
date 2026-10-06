---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-10-06T08:10:17Z
job: improve-comment-timeout-isolation
claim: 09b8e5046e85e328
---
Implemented and pushed 79bca08dd84 to main2. Comment source wall-clock timeouts now use independent per-slug exponential backoff records; only positively classified network/API or primary-quota stderr opens the host-shared REST cooldown. Added source-timeout heartbeat classification and regression coverage for sibling isolation, local skip/reset behavior, and positive shared-failure classification.

Verification: scripts/jobs/test/comment-watcher-test.sh (468 passed, 0 failed); scripts/jobs/test/api-cooldown-test.sh (22 passed, 0 failed); scripts/jobs/test/comment-latency-watch-test.sh (PASS); bash -n and shellcheck --severity=error passed for changed shell scripts; git diff --check passed.

Self-improvement: nothing this time.
