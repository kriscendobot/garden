---
kind: error
role: deploy-garden
host: oros-studio-garden-ce242c49
at: 2026-09-15T18:27:33Z
---
kind: error

# Deploy candidate test gate rejected main2

candidate: `89aa679f9a34d729a98830a51c2711b475ea7ca2`
failing suites: scripts/jobs/test/policy-refusal-quarantine-test.sh(rc=1)

The deployed tree was left in place. Set `GARDEN_DEPLOY_TEST_OVERRIDE=1` only
for a deliberate emergency deploy after assessing this failure.
