---
kind: error
role: deploy-garden
host: endolin-garden2-5bcdff64
at: 2026-09-19T00:29:53Z
---
kind: error

# Deploy candidate test gate rejected main2

candidate: `024f3a012a53f761565e6d81718e7a18291800a8`
failing suites: scripts/jobs/test/terminal-handler-failure-reap-test.sh(rc=124; diagnostic=/home/kris/garden2/.garden-state/deploy/candidate-gate-diagnostics/024f3a012a53f761565e6d81718e7a18291800a8/03-scripts_jobs_test_terminal-handler-failure-reap-test.sh.log), scripts/jobs/test/retry-narrowing-test.sh(rc=124; diagnostic=/home/kris/garden2/.garden-state/deploy/candidate-gate-diagnostics/024f3a012a53f761565e6d81718e7a18291800a8/04-scripts_jobs_test_retry-narrowing-test.sh.log), scripts/jobs/test/policy-refusal-quarantine-test.sh(rc=124; diagnostic=/home/kris/garden2/.garden-state/deploy/candidate-gate-diagnostics/024f3a012a53f761565e6d81718e7a18291800a8/07-scripts_jobs_test_policy-refusal-quarantine-test.sh.log), scripts/jobs/test/codex-policy-refusal-resume-test.sh(rc=124; diagnostic=/home/kris/garden2/.garden-state/deploy/candidate-gate-diagnostics/024f3a012a53f761565e6d81718e7a18291800a8/08-scripts_jobs_test_codex-policy-refusal-resume-test.sh.log), total-wall-clock

Each executed failing suite above names its bounded stdout/stderr diagnostic. Diagnostics
are host-local on `endolin-garden2-5bcdff64` and retain at most
`16384` bytes of output per suite.

The deployed tree was left in place. Set `GARDEN_DEPLOY_TEST_OVERRIDE=1` only
for a deliberate emergency deploy after assessing this failure.
