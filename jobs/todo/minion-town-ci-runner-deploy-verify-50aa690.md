---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
The ci.minion.town self-hosted runner work from PR #145 has landed on kriscendobot/minion.town main. The range 76bb27628e..50aa690f87 contains the commits from 9e1daaa through 73746f4: panel rounds 1–6, the snapshot-based scrub, the minter-owned name stamps and the public-repo prune.
Task: check that the deployed runner matches the merged code, and redeploy any piece that has drifted.
1. Compare the running host's controller with the merged deploy/aws/ci-runner/host/ci-runner-controller.sh, bootstrap.sh and ci-runner.service. Read them over SSM, using the recipe in the minion.town deployed-topology notes. If any of them differ, run deploy/aws/ci-runner/deploy-ci-runner-host.sh.
2. Compare the deployed JIT-minter Lambda code with the merged deploy/aws/ci-runner/lambda/index.mjs. If it differs, update it through the provisioner's documented path in DEPLOYMENT.md § CI runner. Do not re-provision the VPC or IAM.
3. Confirm that the maintainer-created secret minion/ci-runner-github-token exists. Check only that it exists and never read its value. If it is missing, stop and report it to the maintainer.
4. Dispatch .github/workflows/ci-runner-selftest.yml against main. Confirm that the verify job finds none of the planted residue (/tmp/.X11-unix probe, the systemd-private decoy, the named volume, cron and /run/lock) and that the red-result job is actually red.
5. Confirm that test.yml runs land on the ci-minion-town label, which needs the CI_RUNS_ON repo variable set. Also confirm that no orphaned ci-minion-town-* registrations are left after the 10-minute prune sweep.
Report the result to the maintainer: in sync or redeployed, the selftest run URL, and any open operator item. Do not change the code itself. Any defect you find becomes a separate fix job.
