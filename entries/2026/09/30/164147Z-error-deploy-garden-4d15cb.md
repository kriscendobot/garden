---
kind: error
role: deploy-garden
host: oros-studio-garden-ce242c49
at: 2026-09-30T16:42:12Z
---
kind: error

# Deploy candidate test gate rejected main2

candidate: `64dde114ce6ab3fd8a4a336900fdcafdf5a5ae07`
failing suites: scripts/jobs/test/terminal-handler-failure-reap-test.sh(rc=124; diagnostic=/Users/dom/garden/.garden-state/deploy/candidate-gate-diagnostics/64dde114ce6ab3fd8a4a336900fdcafdf5a5ae07/attempt2-01-scripts_jobs_test_terminal-handler-failure-reap-test.sh.log), scripts/jobs/test/retry-narrowing-test.sh(rc=124; diagnostic=/Users/dom/garden/.garden-state/deploy/candidate-gate-diagnostics/64dde114ce6ab3fd8a4a336900fdcafdf5a5ae07/attempt2-02-scripts_jobs_test_retry-narrowing-test.sh.log)

Each executed failing suite above names its bounded stdout/stderr diagnostic. Diagnostics
are host-local on `oros-studio-garden-ce242c49` and retain at most
`16384` bytes of output per suite.

The deployed tree was left in place. Set `GARDEN_DEPLOY_TEST_OVERRIDE=1` only
for a deliberate emergency deploy after assessing this failure.
