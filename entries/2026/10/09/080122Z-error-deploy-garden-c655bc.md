---
kind: error
role: deploy-garden
host: oros-studio-garden-ce242c49
at: 2026-10-09T08:01:37Z
---
kind: error

# Deploy candidate test gate rejected main2

candidate: `b46afcb258a8bfdf40c530a115fa968eb2bdc8af`
failing suites: scripts/jobs/test/terminal-handler-failure-reap-test.sh(rc=124; diagnostic=/Users/dom/garden/.garden-state/deploy/candidate-gate-diagnostics/b46afcb258a8bfdf40c530a115fa968eb2bdc8af/attempt1-03-scripts_jobs_test_terminal-handler-failure-reap-test.sh.log), scripts/jobs/test/retry-narrowing-test.sh(rc=124; diagnostic=/Users/dom/garden/.garden-state/deploy/candidate-gate-diagnostics/b46afcb258a8bfdf40c530a115fa968eb2bdc8af/attempt1-04-scripts_jobs_test_retry-narrowing-test.sh.log), scripts/jobs/test/triager-pacing-test.sh(rc=124; diagnostic=/Users/dom/garden/.garden-state/deploy/candidate-gate-diagnostics/b46afcb258a8bfdf40c530a115fa968eb2bdc8af/attempt1-05-scripts_jobs_test_triager-pacing-test.sh.log), scripts/jobs/test/provider-cooldown-test.sh(rc=124; diagnostic=/Users/dom/garden/.garden-state/deploy/candidate-gate-diagnostics/b46afcb258a8bfdf40c530a115fa968eb2bdc8af/attempt1-09-scripts_jobs_test_provider-cooldown-test.sh.log), total-wall-clock

Each executed failing suite above names its bounded stdout/stderr diagnostic. Diagnostics
are host-local on `oros-studio-garden-ce242c49` and retain at most
`16384` bytes of output per suite.

The deployed tree was left in place. Set `GARDEN_DEPLOY_TEST_OVERRIDE=1` only
for a deliberate emergency deploy after assessing this failure.
