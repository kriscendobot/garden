---
handed-off: minion-town-ci-runner-redeploy-50aa690
deliverable-complete: false
---
**Completion report: minion-town-ci-runner-deploy-verify-50aa690**

**Result:** the runner at ci.minion.town is still running pre-merge code. I could not redeploy it from this host, so I posted the redeploy as a new job.

This host (oros-studio-garden-ce242c49) has no AWS CLI and no AWS credentials. Its GitHub token also gets a 403 on the minion.town Actions variables and runners APIs. My job had no `requires: aws` header, which is why it landed here.

**What I confirmed from here:**
- **The deployed code is older than the merge.** The runner is named `ci-minion-town-0fdb85b6`. The merged minter Lambda (`deploy/aws/ci-runner/lambda/index.mjs`) always adds a `-YYYYMMDDTHHMMSSZ` timestamp to the names it mints, so the running Lambda predates commit afa1a2d. The fix-5 and fix-6 reports from the earlier build also say the live host still runs the old controller and minter.
- **Selftest (step 4):** dispatched on main with the failing job included: https://github.com/kriscendobot/minion.town/actions/runs/37833162084
  - `probe` was green and planted every residue; crontab was not refused.
  - `verify` was green and found none of it: the /tmp/.X11-unix probe, the systemd-private decoy, the named volume, cron and /run/lock were all gone.
  - The deliberate `fail` job ended red (failure).
  - This run tested the **old** code, so it only shows the current host is clean. It does not verify the merged code.
- **CI routing (step 5, first half):** `test.yml` runs on main (for example run 37830503037) land on `self-hosted,ci-minion-town`, so `CI_RUNS_ON` is in effect unset or self-hosted.

**Not done here, handed to the successor job:**
- Step 1: comparing the host's controller, `bootstrap.sh` and `ci-runner.service` over SSM, and redeploying the host.
- Step 2: comparing and updating the minter Lambda.
- Step 3: checking that the secret `minion/ci-runner-github-token` exists.
- Step 5, second half: checking for orphaned `ci-minion-town-*` registrations.

**What I posted:**
- **Successor job `minion-town-ci-runner-redeploy-50aa690`:** on `origin/journal2` in `jobs/todo/` with `requires: aws`. It carries the evidence above and steps 1–5 in the order the fix-6 report requires: Lambda first, then the host, then a reboot, then the selftest. After that it re-runs the selftest, checks for the timestamped runner name and checks for orphaned registrations.
- **Maintainer message:** this summary, with the selftest URL and the open items.
- **Memory note:** this host has no AWS access, so AWS jobs need a `requires: aws` header.

I made no code changes and found no code defect, so there is no fix job.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-ci-runner-deploy-verify-50aa690.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 68 tokens (2205494 cached reads)
- Output: 13281 tokens
- Cost: $1.2704148
- Wall-clock: 2210s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
