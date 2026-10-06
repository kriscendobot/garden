---
kind: error
role: deploy-garden
host: endolin-garden2-5bcdff64
at: 2026-10-06T04:04:38Z
---
kind: error

# Deploy candidate test gate rejected main2

candidate: `1574472ecab2be69b9d1ca1700bc35dd1a7dec67`
failing suites: scripts/jobs/test/triager-pacing-test.sh(rc=1; diagnostic=/home/kris/garden2/.garden-state/deploy/candidate-gate-diagnostics/1574472ecab2be69b9d1ca1700bc35dd1a7dec67/attempt2-01-scripts_jobs_test_triager-pacing-test.sh.log)

Each executed failing suite above names its bounded stdout/stderr diagnostic. Diagnostics
are host-local on `endolin-garden2-5bcdff64` and retain at most
`16384` bytes of output per suite.

The deployed tree was left in place. Set `GARDEN_DEPLOY_TEST_OVERRIDE=1` only
for a deliberate emergency deploy after assessing this failure.
