---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo: kriscendobot/minion.town. The range 50aa690f87..39867df787 landed PR #169, "fix(deploy): preflight guest recovery secret", including all of its gauntlet fix rounds. With this change, `deploy/aws/scripts/deploy-app.sh` runs a fail-closed step 4.0 preflight before restarting the app. The preflight uses `systemd-run --wait --pipe -p EnvironmentFile=/etc/minion-mcp/account.env` to check that `GUEST_RECOVERY_KEY` is set and has at least 32 base64/base64url characters. The shipped `minion-mcp.service` pins `ACCOUNT_STORE=dynamodb`, so DEPLOYMENT.md now treats this key as a requirement on every CD host and adds a one-time rollout step for it.

Task: check that the first CD deploy from main at or after 39867df passed the preflight and did not abort.
1. Find the `deploy.yml` run for main at or after 39867df. Skip `[skip deploy]` runs when you pick the baseline. Report whether it is green, and if it is red, which step failed.
2. Over SSM (recipe in the minion.town deployed-topology notes), confirm that the prod instance's `/etc/minion-mcp/account.env` passes the same check the preflight runs. Run the check the way `deploy-app.sh` does, with `systemd-run --wait --pipe` and a length test. **Never print or log the key value.** Also confirm that minion-mcp is active, that `NRestarts` is stable, and that the healthz check is green.
3. If the key is missing or invalid, do NOT create or rotate it. `minion/guest-recovery-key` cannot be reversed: rotating it orphans the stored ciphertext. Write a maintainer message that names the one-time step from DEPLOYMENT.md (run `deploy-account-endpoint-secret.sh`) and gives the deploy run URL. Then mark the job `orchestration-failed: true`.
4. If everything is green, write a short tada report with the run URL and the health evidence. Do not include any secret material.
