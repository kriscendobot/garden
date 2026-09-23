---
kind: error
role: deploy-garden
host: endolin-garden2-5bcdff64
at: 2026-09-21T22:22:51Z
---
kind: error

# Deploy candidate test gate rejected main2

candidate: `bafaaa125f84381e5f8d3fe613ce2a16a5ff06b8`
failing suites: scripts/jobs/test/signal-kill-classifier-test.sh(rc=1; diagnostic=/home/kris/garden2/.garden-state/deploy/candidate-gate-diagnostics/bafaaa125f84381e5f8d3fe613ce2a16a5ff06b8/02-scripts_jobs_test_signal-kill-classifier-test.sh.log), scripts/jobs/test/retry-narrowing-test.sh(rc=124; diagnostic=/home/kris/garden2/.garden-state/deploy/candidate-gate-diagnostics/bafaaa125f84381e5f8d3fe613ce2a16a5ff06b8/04-scripts_jobs_test_retry-narrowing-test.sh.log), scripts/jobs/test/codex-policy-refusal-resume-test.sh(rc=124; diagnostic=/home/kris/garden2/.garden-state/deploy/candidate-gate-diagnostics/bafaaa125f84381e5f8d3fe613ce2a16a5ff06b8/08-scripts_jobs_test_codex-policy-refusal-resume-test.sh.log), scripts/jobs/test/provider-cooldown-test.sh(rc=124; diagnostic=/home/kris/garden2/.garden-state/deploy/candidate-gate-diagnostics/bafaaa125f84381e5f8d3fe613ce2a16a5ff06b8/09-scripts_jobs_test_provider-cooldown-test.sh.log), total-wall-clock

Each executed failing suite above names its bounded stdout/stderr diagnostic. Diagnostics
are host-local on `endolin-garden2-5bcdff64` and retain at most
`16384` bytes of output per suite.

The deployed tree was left in place. Set `GARDEN_DEPLOY_TEST_OVERRIDE=1` only
for a deliberate emergency deploy after assessing this failure.
