---
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-08T21:36:50Z cleared=none -->

---
requires: aws
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Synchronize the ci.minion.town JIT runner Lambda

This is the first operational slice of `minion-town-ci-runner-redeploy-50aa690-split`.
Work against `kriscendobot/minion.town` main at exactly
`50aa690f87` (merged PR #145, range `76bb27628e..50aa690f87`). Do not change
project code.

1. Read the repository's `DEPLOYMENT.md` CI-runner procedure and deployed-topology
   notes before acting.
2. In `us-west-1`, confirm Secrets Manager secret
   `minion/ci-runner-github-token` exists with
   `aws secretsmanager describe-secret`. Never call `get-secret-value`. If it is
   missing, stop, notify the maintainer with
   `scripts/jobs/message-user.sh minion-town-ci-runner-lambda-sync-50aa690`, and
   finish with the orchestration failure signal.
3. Inspect the deployed `minion-town-ci-jit-minter` with
   `aws lambda get-function`, download its deployment zip, and compare its
   `index.mjs` with `deploy/aws/ci-runner/lambda/index.mjs` at the target commit.
4. If different, update only the Lambda through the provisioner's documented
   CI-runner path. Do not re-provision the VPC or IAM. Lambda synchronization is
   the sole deployment scope of this child.
5. Record concrete comparison and deployment evidence in the completion report,
   including whether the Lambda was already in sync or was updated.

If the required Lambda state is not achieved after all in-scope attempts, end
the report with these exact lines:

`<<<GARDEN-ORCHESTRATION-FAILED>>>`
`<<<GARDEN-JOB-COMPLETE>>>`

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-08T21:36:59Z
