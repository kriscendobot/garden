---
kind: error
role: deploy-garden
host: endolin-garden2-5bcdff64
at: 2026-09-27T02:49:00Z
---
kind: error

# Deploy candidate test gate rejected main2

candidate: `1570aa85a47b1c3cd636fd52aff9552c04beaa21`
failing suites: scripts/jobs/test/triager-pacing-test.sh(rc=1; diagnostic=/home/kris/garden2/.garden-state/deploy/candidate-gate-diagnostics/1570aa85a47b1c3cd636fd52aff9552c04beaa21/attempt2-01-scripts_jobs_test_triager-pacing-test.sh.log)

Each executed failing suite above names its bounded stdout/stderr diagnostic. Diagnostics
are host-local on `endolin-garden2-5bcdff64` and retain at most
`16384` bytes of output per suite.

The deployed tree was left in place. Set `GARDEN_DEPLOY_TEST_OVERRIDE=1` only
for a deliberate emergency deploy after assessing this failure.
