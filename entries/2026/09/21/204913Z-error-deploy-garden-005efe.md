---
kind: error
role: deploy-garden
host: endolin-garden-ece02cb4
at: 2026-09-21T20:49:16Z
---
kind: error

# Deploy candidate test gate rejected main2

candidate: `7070fc7e9c786255915e5f93cdc10455ec785d5b`
failing suites: scripts/jobs/test/signal-kill-classifier-test.sh(rc=1; diagnostic=/home/kris/garden/.garden-state/deploy/candidate-gate-diagnostics/7070fc7e9c786255915e5f93cdc10455ec785d5b/02-scripts_jobs_test_signal-kill-classifier-test.sh.log), scripts/jobs/test/retry-narrowing-test.sh(rc=1; diagnostic=/home/kris/garden/.garden-state/deploy/candidate-gate-diagnostics/7070fc7e9c786255915e5f93cdc10455ec785d5b/04-scripts_jobs_test_retry-narrowing-test.sh.log), scripts/jobs/test/provider-cooldown-test.sh(rc=1; diagnostic=/home/kris/garden/.garden-state/deploy/candidate-gate-diagnostics/7070fc7e9c786255915e5f93cdc10455ec785d5b/09-scripts_jobs_test_provider-cooldown-test.sh.log)

Each executed failing suite above names its bounded stdout/stderr diagnostic. Diagnostics
are host-local on `endolin-garden-ece02cb4` and retain at most
`16384` bytes of output per suite.

The deployed tree was left in place. Set `GARDEN_DEPLOY_TEST_OVERRIDE=1` only
for a deliberate emergency deploy after assessing this failure.
