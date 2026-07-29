---
kind: error
role: deploy-garden
host: endolin-garden-ece02cb4
at: 2026-07-29T22:06:13Z
---
kind: error

# Deploy candidate test gate rejected main2

candidate: `aed30a441971e71451d871b1a8615b8f5b50c642`
failing suites: scripts/jobs/test/signal-kill-classifier-test.sh(rc=1)

The deployed tree was left in place. Set `GARDEN_DEPLOY_TEST_OVERRIDE=1` only
for a deliberate emergency deploy after assessing this failure.
