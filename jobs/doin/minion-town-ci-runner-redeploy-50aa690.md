---
requires: aws
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Redeploy the ci.minion.town self-hosted runner to match kriscendobot/minion.town main @ 50aa690f87 (PR #145 merged; range 76bb27628e..50aa690f87, commits 9e1daaa..73746f4). This is the AWS half of `minion-town-ci-runner-deploy-verify-50aa690`, which was claimed on a host without AWS credentials and handed off here.

Evidence from the predecessor that the live runner is drifted:
- Runner names are `ci-minion-town-0fdb85b6`, with no `-YYYYMMDDTHHMMSSZ` stamp. The merged Lambda (`deploy/aws/ci-runner/lambda/index.mjs`, `name = PREFIX + label + '-' + stampOf(now())`) always appends one. So the deployed minter is older than afa1a2d, and its prune cannot recognize minter-owned names.
- The fix-5 and fix-6 gauntlet reports for build-ci-minion-town-actions-runner state that the live host still runs the old controller and minter.
- A baseline selftest on the old code, https://github.com/kriscendobot/minion.town/actions/runs/37833162084, had probe and verify green. That is a pre-redeploy baseline only.
- test.yml runs on main already land on `self-hosted,ci-minion-town`, so CI_RUNS_ON is unset or self-hosted. The oros-studio PAT gets a 403 on the variables and runners APIs.

Task (do not change the code; any defect found becomes a separate fix job):
1. Confirm that the Secrets Manager secret `minion/ci-runner-github-token` exists (`aws secretsmanager describe-secret`, never get-secret-value). If it is missing, stop and message the maintainer.
2. Compare the deployed Lambda `minion-town-ci-jit-minter` code (`aws lambda get-function`, download the zip and diff index.mjs) with the merged `deploy/aws/ci-runner/lambda/index.mjs`. If it differs, update it through the provisioner's documented path in DEPLOYMENT.md § CI runner. Do not re-provision the VPC or IAM. **Lambda first.**
3. Over SSM (recipe: minion.town DEPLOYMENT.md deployed-topology notes; instance tag Name=minion-town-ci, us-west-1), compare the host's ci-runner-controller.sh, bootstrap.sh and ci-runner.service with the merged `deploy/aws/ci-runner/host/`. If any differ, run `deploy/aws/ci-runner/deploy-ci-runner-host.sh`, then reboot the host so the snapshot-based scrub takes a fresh snapshot (per fix-6).
4. Dispatch `.github/workflows/ci-runner-selftest.yml` on main with fail=true (`gh workflow run ci-runner-selftest.yml -R kriscendobot/minion.town --ref main -f fail=true`). Confirm that verify finds none of the planted residue (/tmp/.X11-unix probe, systemd-private decoy, named volume, cron, /run/lock), that the `fail` job is red, and that the job log's Runner name now carries the minter's timestamp stamp.
5. With an identity that can read the variables and runners APIs, confirm CI_RUNS_ON is unset or self-hosted. Wait at least 10 minutes after the restart, then confirm that no orphaned or offline `ci-minion-town-*` registrations remain after the prune sweep.
Report to the maintainer (scripts/jobs/message-user.sh): in sync or redeployed, the selftest run URL, and any open operator item.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-08T20:49:02Z
