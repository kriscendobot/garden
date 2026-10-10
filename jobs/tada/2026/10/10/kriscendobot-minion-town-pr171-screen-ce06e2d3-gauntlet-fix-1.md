# Gauntlet fix round 1: kriscendobot/minion.town#171

I fixed the must-fix items from panel review 5478363891 and pushed one commit to `feat/claude-arc-prod-validation`, moving the head from `ce06e2d` to `0d30097`. CI is green: `ci-wait-merge` returned rc 0 with 3 of 3 checks passed and none failed.

**Changes in commit `0d30097`:**
- **Stylist (renames):** in `deploy/aws/scripts/deploy-cd-iam.mjs`, I renamed `PROBE_TRUST_DOC` to `PROBE_TRUST_DOCUMENT`, `PROBE_SUB` to `PROBE_SUBJECT`, and `trustDocument(sub)` to `trustDocument(subject)`. The OIDC claim key `${OIDC_HOST}:sub` is unchanged.
- **Migrator (rollout order):** the "One-time provisioning" section of `DEPLOYMENT.md` is now an ordered checklist:
  1. Run the IAM script.
  2. Create the `prod-probe` GitHub environment.
  3. Check that the role ARN matches.
  4. Merge. The deploy ships the observer.

  Steps 1–3 come before the merge, so the strict scheduled run is no longer set up to fail. The first post-deploy run is the first one that can pass.
- **Pruner:** the long security comment in `.github/workflows/prod-probe.yml` is now a one-line pointer to the "AWS/SSM" section of `DEPLOYMENT.md`.

**PR body (integrator and pruner):** I rewrote it with `gh pr edit`.
- It no longer says the PR "stays draft".
- `Closes #172` is now a `Refs` link, so #172 stays open until a live run passes.
- I removed the unfinished "Gaps:" line.
- The Verification section now names the exact commands.
- A new Stack section gives #166's current state: open, draft, no review decision, head `86ea2d7`.
- I cut the defensive prose.

**No change needed:**
- **Decomplector:** `claude-harness.mjs:218` already matches `"InvocationDoesNotExist"` at `ce06e2d`. The `includes("")` the seat flagged was missing its string in the diff the panel was shown, not in the code.
- **Saboteur #1:** the directory mask is already `0o022`, which matches the error message.

**Local checks:** `node --test deploy/probe/prod-objectives.test.mjs` passed 33 of 33 and `npm run typecheck` passed.

**Completion summary comment:** https://github.com/kriscendobot/minion.town/pull/171#issuecomment-6096012740

**Follow-ups:**
- **Should-fix items left open:**
  - Saboteur #2–#6:
    - report observer read errors as data instead of crashing
    - pin `job_workflow_ref` in the probe role's trust
    - have the observer's own hash checked
    - assert the observer file is present in `deploy-app.sh`
    - have `awsOk` report why a call failed
  - Integrator #4–#6:
    - move the `DEPLOYMENT.md` heading reflow out of this PR
    - rewrap a long line
    - squash the commits
- **Before merge:** this PR still has to be rebased onto wherever #166 lands.
- **Panel round 2** is not run here; the driver re-posts it.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr171-screen-ce06e2d3-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1793865 cached reads)
- Output: 10507 tokens
- Cost: $1.216257
- Wall-clock: 858s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
