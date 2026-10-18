# Completion report: minion-town-ci-runner-recover-20261018

**Root cause: the runner wasn't down; it was saturated.** The single self-hosted runner runs one job at a time, and it was busy the whole period. That's why the runs looked stuck. I did not restart, reboot or re-converge anything, because that would only have killed the job in flight.

**What I checked:**
- **Runners list:** one runner, `ci-minion-town-0fdb85b6-20261018T081311Z`, is `online` and `busy`.
- **Instance:** `i-0fdb85b6bbc081acb` (spot, us-west-1) is running. It was launched 2026-10-13 and has been up 5 days, so there was no spot reclamation. The `ci-runner` service has been active since 2026-10-15 06:05Z.
- **Runner log over SSM (02:30Z–08:13Z):** jobs ran back to back with no idle gaps. Each `Claude harness (arm64)` buildx build takes about 17 minutes under emulation, and amd64 harness and `test` jobs take about 5–10 minutes. That window held 13 runs, many with several jobs each. The only fault was three "could not mint a JIT config" retries at 05:16–05:18Z, which cost about 3 minutes and fits the known rate-limit pattern of the shared-token JIT minter.
- **The reported runs all finished green:**
  - feat/guest-coupons `test`: created 02:41Z, passed at 06:09Z.
  - PR #197 (feat/clip-live-frame): the browser gate passed at 05:30Z and `test` passed at 06:44Z.
  - Two runs are still queued (ci/harness-path-gate, feat/beta-home-splash-waitlist), and the runner is working through them.

**What changed:** I pushed `05d833a236a` to main2. It adds a step to the Operate section of `context/operations/ci-minion-town-runner.md` on telling saturation from an outage before restarting, using the `Running job` / `completed with result` journal lines. This is so the next report of "queued, no runner" doesn't lead to a needless restart.

**Follow-ups (not posted; for the maintainer to decide):**
- Queue-to-done wall time hit 3–4 hours during this burst, and that is what's slowing the minion.town gauntlets. The options are:
  - a second runner host (the runbook's "Scale up", parallel jobs);
  - a bigger instance;
  - path-gating or dropping the emulated arm64 harness build on per-push runs;
  - temporarily switching to hosted runners with `CI_RUNS_ON` (skill minion-town-ci-runner-switch).
- Minor: each very short job, such as `changes` or `report`, is followed by an idle 60-second "exited after Ns; retrying in 60s" backoff.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-ci-runner-recover-20261018.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (435576 cached reads)
- Output: 4301 tokens
- Cost: $0.6238872
- Wall-clock: 84s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
