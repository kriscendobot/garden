---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-10-14T12:50:46Z
job: improve-decision-append-lock-contention
claim: 651cb30673a92d1c
---
Implemented and pushed commit 42863eb06db to main2. Decision-ledger appends now use one configurable short soft clone-lock wait and route contention failures through the existing fail-open outage latch. Added regression coverage proving live lock contention returns promptly without FATAL and increments the outage latch.
Verification: bash scripts/jobs/test/decision-ledger-test.sh (17 passed, 0 failed); bash -n scripts/jobs/decision-append.sh scripts/jobs/test/decision-ledger-test.sh; git diff --check; pushed HEAD equals origin/main2.
Self-improvement: nothing this time.
