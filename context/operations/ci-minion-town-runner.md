---
created: 2026-09-30
updated: 2026-09-30
author: gardener
---

# ci.minion.town: the self-hosted Actions runner

On 2026-09-30 the kriscendobot account hit an account-wide GitHub Actions
billing block, and hosted jobs stopped starting (kriscendobot/minion.town#144).
In response, the job `build-ci-minion-town-actions-runner` built a self-hosted,
**ephemeral** runner at `ci.minion.town` in the minion.town AWS account.
Self-hosted jobs use no hosted minutes.

- **Canonical doc:** minion.town `DEPLOYMENT.md` § CI runner.
- **Source:** `deploy/aws/ci-runner/` (PR kriscendobot/minion.town#145).

This page covers the garden-side operator view: how to check, restart, rotate,
scale and tear down.

## Shape in one paragraph

A spot `t3.large` (`minion-town-ci`) runs in its own VPC. Its security group
has **no ingress**, SSH is off, and access is SSM only. Its instance role can
do two things: invoke the Lambda `minion-town-ci-jit-minter` and run the SSM
agent. The Lambda is the only thing that reads the GitHub credential
(Secrets Manager `minion/ci-runner-github-token`). It mints single-use JIT
runner configs for an allowlist of **private** repos, which today is only
`kriscendobot/minion.town`, with label `ci-minion-town`. The host's
`ci-runner.service` loop scrubs everything before each job, then registers one
fresh runner, which takes one job and exits. The host has these parts:
- **Processes and files:** the `ghrunner` user's processes, home and temp
  files.
- **Docker state:** all containers, images, volumes and build cache.

Cost is about **$35/month**. On-demand would be about $80/month, which is over
the $50 line that needs maintainer approval.

## Operate (garden host, garden-fleet creds; scripts in minion.town `deploy/aws/ci-runner/`)

- **Check.** Run
  `gh api repos/kriscendobot/minion.town/actions/runners --jq '.runners[]|[.name,.status,.busy]'`.
  Expect exactly one `ci-minion-town-*` runner, `online` (busy while a job
  runs). For host detail, find the instance with
  `aws ec2 describe-instances --region us-west-1 --filters Name=tag:Name,Values=minion-town-ci`,
  then run `systemctl status ci-runner` and `journalctl -u ci-runner` over SSM.
- **Prove it end to end.** Actions → *ci-runner selftest* → Run workflow. Tick
  *fail* to also see a red job. Alternatively, push any commit to branch
  `ci-runner-selftest`.
- **Restart.** Run `systemctl restart ci-runner` or reboot the host. On start
  the loop prunes offline `ci-minion-town-*` registrations and registers a
  fresh runner.
- **Re-converge or update the runner release.** Run `./deploy-ci-runner-host.sh`.
  It is idempotent and verifies the release sha256 digest.
- **Rotate the credential.** Run
  `printf '{"token":"%s"}' "$NEW" | ./provision-ci-runner.sh --seed-token-stdin`.
  The Lambda reads the secret per mint, so no redeploy is needed. The seed
  today is the kriscendobot `gh` OAuth token, which is broad. Replacing it with
  a fine-grained PAT (Administration: write on minion.town only) is a
  maintainer act.
- **Scale up.** For a bigger instance, stop the host, run
  `modify-instance-attribute --instance-type`, and start it again. For
  parallel jobs, add a second host; the provisioner handles one host today.
- **Fall back to hosted runners.** Set the minion.town repo variable
  `CI_RUNS_ON` to `"ubuntu-latest"`.
- **Tear down.** Set the fallback variable, then run `./teardown-ci-runner.sh`.
  Add `PURGE_SECRET=1` to also delete the credential.

## Standing rules

- **Never attach this runner to a public repository.** Jobs have
  root-equivalent docker access on the host, so a fork PR could run arbitrary
  code there. Check visibility before adding any repo to `REPOS`, and surface
  any public repo to the maintainer.
- The minion.town CD workflow (`deploy.yml`) still runs on hosted runners.
  Moving production deploys onto this host is a maintainer decision.

## Validation (2026-09-30)

Every run below executed on `ci-minion-town-0fdb85b6-*` runners (`Machine
name: 'ci-minion-town'` in the job logs):

- **Real CI green.** In kriscendobot/minion.town `test.yml`, all 3 jobs
  passed, each on its own ephemeral runner:
  [run 36771372793](https://github.com/kriscendobot/minion.town/actions/runs/36771372793)
  and [run 36775061970](https://github.com/kriscendobot/minion.town/actions/runs/36775061970).
  - `test`: about 3 to 6 minutes.
  - Harness amd64: about 4 minutes.
  - Harness arm64 under qemu: about 13.5 minutes against a 20-minute
    timeout, which is the tightest margin.
- **Real red.** The deliberate `fail` job went red in
  [run 36768718473](https://github.com/kriscendobot/minion.town/actions/runs/36768718473)
  and again in [run 36775062292](https://github.com/kriscendobot/minion.town/actions/runs/36775062292).
- **No residue between jobs.** The first selftest,
  [run 36768551812](https://github.com/kriscendobot/minion.town/actions/runs/36768551812),
  **caught a real leak**: `docker system prune --volumes` spares named volumes
  on Docker 23 and later. The scrub was fixed to remove every volume, and
  later runs are clean.
- **Restart and reboot re-register.** `systemctl restart ci-runner` and an
  EC2 reboot each brought a fresh runner online, about 30 seconds after boot
  in the reboot case. The post-reboot selftest (run 36775062292) passed. The
  controller sweeps orphaned registrations every 10 minutes.

Two sustained-load limits apply. First, the instance uses standard CPU
credits: it earns about 864 credits a day, and a full CI run spends about 40,
so sustained heavy use beyond about 20 runs a day throttles the host to 30%
of its CPU. Second, one runner serializes jobs.
