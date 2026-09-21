---
kind: error
role: deploy-garden
host: endolin-garden2-5bcdff64
at: 2026-09-21T21:30:37Z
---
kind: error

# Deploy candidate test gate rejected main2

candidate: `5fdb7e915855bc679d81e071f43ae3c56b938e9e`
failing suites: scripts/jobs/test/signal-kill-classifier-test.sh(rc=1; diagnostic=/home/kris/garden2/.garden-state/deploy/candidate-gate-diagnostics/5fdb7e915855bc679d81e071f43ae3c56b938e9e/02-scripts_jobs_test_signal-kill-classifier-test.sh.log), scripts/jobs/test/retry-narrowing-test.sh(rc=1; diagnostic=/home/kris/garden2/.garden-state/deploy/candidate-gate-diagnostics/5fdb7e915855bc679d81e071f43ae3c56b938e9e/04-scripts_jobs_test_retry-narrowing-test.sh.log), scripts/jobs/test/provider-cooldown-test.sh(rc=1; diagnostic=/home/kris/garden2/.garden-state/deploy/candidate-gate-diagnostics/5fdb7e915855bc679d81e071f43ae3c56b938e9e/09-scripts_jobs_test_provider-cooldown-test.sh.log)

Each executed failing suite above names its bounded stdout/stderr diagnostic. Diagnostics
are host-local on `endolin-garden2-5bcdff64` and retain at most
`16384` bytes of output per suite.

The deployed tree was left in place. Set `GARDEN_DEPLOY_TEST_OVERRIDE=1` only
for a deliberate emergency deploy after assessing this failure.
