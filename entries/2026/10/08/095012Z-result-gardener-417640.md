---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-10-08T09:50:16Z
job: improve-comment-source-quota-probe
claim: 32b9e0f40cd26de4
---
Fixed comment-source review quota admission so a failed rate_limit probe keeps and classifies stderr while the group admission lock is held. A primary-quota refusal now freezes the cursor, records a primary-quota cooldown, and prevents the review-metadata canary from firing.

Added regression coverage for probe-side exhaustion and updated the late-quota expectation to require zero review-metadata requests.

Verification: bash -n scripts/jobs/handlers/comment-source-gh.sh scripts/jobs/test/comment-watcher-test.sh; env GARDEN_ROOT="$PWD" scripts/jobs/test/comment-watcher-test.sh (478 passed, 0 failed).

Delivered: c185ee5f97bc0e7923791130f5f9cbd1867e9942 on origin/main2.

Self-improvement: nothing this time.
