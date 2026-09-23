---
kind: error
role: deploy-garden
host: endolin-garden-ece02cb4
at: 2026-07-29T22:08:51Z
---
kind: error

# Deploy candidate test gate rejected main2

candidate: `1415a839e18f9ca1813f923cc14c618b4d478852`
failing suites: scripts/jobs/test/signal-kill-classifier-test.sh(rc=1)

The deployed tree was left in place. Set `GARDEN_DEPLOY_TEST_OVERRIDE=1` only
for a deliberate emergency deploy after assessing this failure.
