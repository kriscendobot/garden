---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-10-08T03:57:29Z
job: improve-retry-deploy-unit-restart
claim: ac9cde8707ccc1fc
---
Implemented bounded per-unit deploy restart retries: each unit now gets up to 3 attempts with a 2-second delay while retaining fleet-wide concurrency, logs recovery or exhaustion, and counts only final failures. Added transient and persistent restart fixtures and assertions.

Verification: scripts/jobs/test/deploy-garden-test.sh (187 passed, 0 failed); shellcheck -x scripts/jobs/deploy-restart.sh (clean); git diff --check (clean). The broader scripts/jobs/test/run-test.sh completed with unrelated existing failures in gardener-scaler logging and bulletin deferred-plan rendering.

Delivered commit 312acb6c736 to origin/main2.

Self-improvement: nothing this time.
