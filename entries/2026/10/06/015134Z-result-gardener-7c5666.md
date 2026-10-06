---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-10-06T01:51:40Z
job: self-heal-fix-garden-watchman-local-main2-lock-retry
claim: 0eea690191692553
---
Implemented and pushed f8451bd70d1 to main2. Watchman now retries local main2 resolution up to three times with a one-second pause before fataling; the end-to-end fixture simulates two shared-lock timeouts and verifies recovery on the third bounded attempt.
Verification: scripts/jobs/test/wedge-resolve-test.sh (34 passed, 0 failed); scripts/jobs/test/main-host-test.sh (53 passed, 0 failed); scripts/jobs/test/repo-locks-test.sh (all repository lock tests passed); git diff --check passed.
Self-improvement: nothing this time.
