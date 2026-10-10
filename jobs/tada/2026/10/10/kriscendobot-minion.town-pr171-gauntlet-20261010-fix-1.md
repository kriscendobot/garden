# Gauntlet fix round 1: kriscendobot/minion.town PR #171

I applied all three of the panel's must-fix items and the cheaper should-fix items, and pushed them as `cf86259..b53b3f0` on `feat/claude-arc-prod-validation`. CI is green on all 3 checks (`ci-wait-merge.sh` rc=0). The PR's own live-evidence section now says plainly that the landed design has not been run in production yet.

**Must-fix items:**
- **Locksmith: the probe and deploy roles shared one trust policy.** A probe token could be swapped for the deploy role.
  - `deploy-cd-iam.mjs` now gives each role its own trust document. The probe role accepts only tokens from `repo:kriscendobot/minion.town:environment:prod-probe`, and the deploy role keeps its `ref:refs/heads/main` trust, which those tokens never match.
  - The `harness` job in `prod-probe.yml` now runs in the `environment: prod-probe` GitHub environment.
  - `aws-actions/configure-aws-credentials` in that job is pinned to commit SHA `7474bc46…` (v4).
- **Saboteur: the SSM `update-document` call swallowed every failure.** It now keeps the error output and stops the script on anything except `DuplicateDocumentContent`.
- **Integrator: the PR description named the wrong base.** It now names `f432a51`, not `55299f0`.

**Should-fix items:**
- **Integrator: old evidence.** The "Production evidence" section now says live evidence for the landed design is pending, and that the 2026-10-08 runs used a replaced design and don't count.
- **Purist / integrator: duplicated constants.** `deploy-cd-iam.mjs` now imports `OBSERVE_DOCUMENT` and `OBSERVER_PATH` from `deploy/probe/claude-harness.mjs` instead of copying them.
- **Pruner: over-long table row and repeated rationale.** The harness row in DEPLOYMENT.md's checks table is now one line, and the detail moved into a new prose section below it. I updated the AWS/SSM section of DEPLOYMENT.md for the separate trust, and removed the repeated "why a runtime observer" rationale from the PR description.
- The probe suite passes locally (26/26).

**A change outside the code:** I created a `prod-probe` GitHub environment on kriscendobot/minion.town that only `main` can deploy to. A workflow that names an environment creates it automatically, but with no branch limit, so I set it up first with the limit.

**Not done:**
- **Locksmith should-fix:** running the observer as an unprivileged user instead of root.
- **Saboteur should-fix:** an SSM retry inside the harness check.
- **Purist should-fix:** the unused `clientName` parameter and `server` field. Both may be meant for #167.
- **Comment-only items:** none applied.

**Follow-ups:**
- The new trust only takes effect after a maintainer re-runs `node deploy/aws/scripts/deploy-cd-iam.mjs`. Until then the harness check fails with "AWS credentials unavailable" and the other checks still run.
- After that, one `prod-probe.yml` run on `main` should replace the pending evidence section before the PR leaves draft.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr171-gauntlet-20261010-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (1944256 cached reads)
- Output: 13503 tokens
- Cost: $1.3276472000000001
- Wall-clock: 1791s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
