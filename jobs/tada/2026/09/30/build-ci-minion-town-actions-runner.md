The self-hosted runner at `ci.minion.town` is deployed and minion.town's CI runs green on it; every validation check passed. The workflow change is in draft PR [kriscendobot/minion.town#145](https://github.com/kriscendobot/minion.town/pull/145), waiting for you to run the gauntlet. The garden-side ops note is on `main2`.

**Infrastructure** (scripts in `deploy/aws/ci-runner/`, all idempotent):
- **Host:** spot `t3.large` (`i-0fdb85b6bbc081acb`, x86_64, 8 GiB, 50 GB encrypted disk), Ubuntu 24.04. `ci.minion.town` points at its Elastic IP `54.67.46.86`.
- **Isolation from production:**
  - It has its own VPC with no peering to prod, and its firewall has no inbound rules.
  - SSH is disabled; access is through SSM only. Automatic security updates are on.
  - The only production DNS record touched is `ci.minion.town`.
- **Least privilege:** the host's IAM role can do two things: invoke one Lambda and run the SSM agent. It has no access to secrets, S3, DynamoDB or Route53, and it is not the prod role.
- **Credential:** the GitHub token is stored only in Secrets Manager (`minion/ci-runner-github-token`). Only the Lambda can read it. The Lambda hands out single-use runner registrations, and only for `kriscendobot/minion.town` with the label `ci-minion-town`. The host never holds the token.
- **One fresh runner per job:** a systemd service (auto-restart, starts at boot) wipes everything before each job. That covers the runner user's processes, home and temp files, and all docker containers, images, volumes and build cache. It then registers one single-use runner, which takes a single job and exits.
- **Cost:** about **$35/month** (spot instance ≈ $26, disk ≈ $4.80, IP $3.65, secret $0.40). On-demand pricing would be about $80/month, over your $50 line, so I kept spot.

**Workflow change (PR #145):** both `test.yml` jobs now run on `[self-hosted, ci-minion-town]`. To switch back to GitHub-hosted runners, set the repo variable `CI_RUNS_ON` to `"ubuntu-latest"`. I also added a `ci-runner-selftest` workflow and a "CI runner" section in `DEPLOYMENT.md`.

**Validation:** all runs executed on `ci-minion-town-0fdb85b6-*` runners, and the job logs show `Machine name: 'ci-minion-town'`.
- **Real CI green:** all three jobs passed in [36771372793](https://github.com/kriscendobot/minion.town/actions/runs/36771372793) and again at the PR head in [36775061970](https://github.com/kriscendobot/minion.town/actions/runs/36775061970). The first run, [36768963783](https://github.com/kriscendobot/minion.town/actions/runs/36768963783), failed because one harness step expects `node` to be preinstalled; the workflow now installs it.
- **Real red:** the deliberately failing job went red in [36768718473](https://github.com/kriscendobot/minion.town/actions/runs/36768718473) and [36775062292](https://github.com/kriscendobot/minion.town/actions/runs/36775062292).
- **No residue between jobs:** the first selftest, [36768551812](https://github.com/kriscendobot/minion.town/actions/runs/36768551812), caught a named docker volume surviving the cleanup. I fixed the cleanup, and later runs are clean.
- **Restart and reboot:** both re-registered a fresh runner, about 30 seconds after boot for the reboot. The selftest after the reboot passed. Stale registrations left by a restart are now cleaned up every 10 minutes (the first version missed them).

**Garden:** `context/operations/ci-minion-town-runner.md` and its index entry are on `main2` (42eb171ea1c). It covers check, restart, rotating the credential, scaling, switching back to hosted runners, teardown, and the rule never to attach the runner to a public repo.

**Decisions for you:**
- **The stored token is broad.** I seeded it with the kriscendobot `gh` OAuth token (scopes `repo`, `workflow`, `gist`, `read:org`), because a narrower token can only be created by a person. Please replace it with a fine-grained PAT that has only Administration: write on minion.town. Rotation is one command, in the doc.
- **Jobs can act as root on the runner host.** The runner user is in the `docker` group, which one of the CI jobs needs. That is bounded by the host's isolation and by the repo being private. The runner must never be attached to a public repo.
- **CD still uses hosted runners.** `deploy.yml` is unchanged, so it is still blocked by billing. Moving it onto this host would put the production deploy role there, and I couldn't test it without deploying to prod, so that's your call.
- **The slowest job is close to its timeout.** The arm64 harness build takes about 13.5 of its 20 minutes. There is one runner, so jobs run one at a time, and the host's CPU throttles to 30% after roughly 20 full CI runs a day. If that bites, raise the timeout or use a bigger host.
- **No other repos were added.** Only the private `kriscendobot/minion.town` is attached.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-ci-minion-town-actions-runner.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 106 tokens (5545794 cached reads)
- Output: 55348 tokens
- Cost: $3.2566068
- Wall-clock: 5107s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
