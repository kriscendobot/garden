---
handed-off: merge-minion-town-175-deploy-on-ci-runner-20261009
deliverable-complete: false
---
The workflow change is open as a draft PR, but nothing has deployed yet. Merging it, checking the deploy and confirming the delegation resumes are now with the successor job `merge-minion-town-175-deploy-on-ci-runner-20261009`.

**What's done**
- **The PR:** https://github.com/kriscendobot/minion.town/pull/175 (draft, normal gauntlet), on branch `ci/deploy-runs-on-switch` with frozen base `main-39867df`.
  - `deploy.yml` now picks its runner the same way `test.yml` does: `runs-on: ${{ fromJSON(vars.CI_RUNS_ON || '["self-hosted","ci-minion-town"]') }}`.
  - I reused `CI_RUNS_ON` instead of adding a `DEPLOY_RUNS_ON` variable. CI and CD are blocked for the same reason, so one variable flip back after the reset moves both, and CD can't be left behind on the runner.
  - I added an "Ensure AWS CLI" step that installs the AWS CLI into `$RUNNER_TEMP` only if the runner doesn't have it. On hosted runners it does nothing.
- **Runner checks:**
  - The online runner is X64 (`self-hosted,Linux,X64,ci-minion-town`), the same architecture as `ubuntu-latest`. The node build and the ARM64 emulator step should behave as they do on hosted runners.
  - The OIDC trust in `deploy-cd-iam.mjs` only checks `sub = repo:kriscendobot/minion.town:ref:refs/heads/main` (plus the audience). Nothing in it depends on the runner, so the self-hosted runner can assume the deploy role.
- **Skill update (pushed to main2):** `skills/minion-town-ci-runner-switch/SKILL.md`
  - The "CD is separate" note is replaced by "CD follows the same switch", with the authorization and these runner details.
  - The switch-back-to-hosted procedure now includes confirming, or manually starting, a `main` deploy on a hosted runner.
- **Progress reply** on garden#58 (left open): https://github.com/kriscendobot/garden/issues/58#issuecomment-6077248261

**Not checked, and the main risk**
- I couldn't confirm the runner has Docker (the emulator step needs it) or `unzip` (the AWS CLI install needs it). If the first deploy fails on either, the successor job is told to fix it in a follow-up PR.

**Handed off to `merge-minion-town-175-deploy-on-ci-runner-20261009` (conductor job, posted):**
- Merge #175 after the gauntlet; the delegation is paused, so the proxy screen won't.
- Confirm the `main` deploy runs on `ci-minion-town` and succeeds, so #169 / 39867df reaches production.
- Check that the screener resumed the paused delegation.
- Reply on garden#58 with the result.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-deploy-on-ci-runner-20261009.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (740661 cached reads)
- Output: 8454 tokens
- Cost: $0.7525002000000002
- Wall-clock: 118s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
