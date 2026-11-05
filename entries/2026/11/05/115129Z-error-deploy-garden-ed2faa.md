---
kind: error
role: deploy-garden
host: endolin-garden-ece02cb4
at: 2026-11-05T11:51:31Z
---
kind: error

# Deploy candidate test gate rejected main2

candidate: `024425a0ee04e9f320f131b426efa6eba63f1330`
failing suites: scripts/jobs/test/signal-kill-classifier-test.sh(rc=1; diagnostic=/home/kris/garden/.garden-state/deploy/candidate-gate-diagnostics/024425a0ee04e9f320f131b426efa6eba63f1330/attempt2-01-scripts_jobs_test_signal-kill-classifier-test.sh.log)

Each executed failing suite above names its bounded stdout/stderr diagnostic. Diagnostics
are host-local on `endolin-garden-ece02cb4` and retain at most
`16384` bytes of output per suite.

The deployed tree was left in place. Set `GARDEN_DEPLOY_TEST_OVERRIDE=1` only
for a deliberate emergency deploy after assessing this failure.
