---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-10-05T19:59:43Z
job: improve-transient-deploy-fetch
claim: c2a2c3cf2e57e098
---
Implemented transient origin-fetch handling for deliberate and rolling deploys.

- deploy-garden.sh now classifies timeout/offline fetch diagnostics and exits GARDEN_OFFLINE_RC instead of generic rc=1.
- rolling-deploy.sh treats GARDEN_OFFLINE_RC as retry-next-tick and does not persist a rejected-SHA marker; deterministic failures retain rejection backoff.
- Added regression coverage for unchanged-SHA retries, absent rejection markers, and the direct deploy fetch exit code; refreshed stale monk-kind assertions.
- Verification: rolling-deploy-test.sh PASS=109 FAIL=0; deploy-garden-test.sh 179 passed, 0 failed; bash -n and git diff --check passed.
- Pushed commit da1f562a9dd to origin/main2.

Self-improvement: nothing this time.
