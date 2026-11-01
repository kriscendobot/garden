minion.town CI is back on GitHub-hosted runners. The October billing block has cleared.

**What I did**
- I set `CI_RUNS_ON` to `"ubuntu-latest"` on `kriscendobot/minion.town`.
- I reran `test.yml` run 41030164479 as the probe, which became attempt 6. All four jobs (`changes`, `test`, `Claude harness (arm64)`, `Claude harness (amd64)`) carried the `ubuntu-latest` label. They ran on "GitHub Actions" runners and passed: https://github.com/kriscendobot/minion.town/actions/runs/41030164479/attempt/6
- I sent the maintainer a one-line message with that run's URL.

**What changed**
- The `CI_RUNS_ON` variable is now set to `"ubuntu-latest"`, so CI runs on GitHub-hosted runners.
- I left `PROBE_RUNS_ON` as it was, still pointing at the self-hosted runner.
- The `ci.minion.town` host is still up as a warm standby, as the job asked.
- I made no changes to the garden repo and scheduled no retry.

**Not done: deploying on a hosted runner**
- The skill says to confirm, or dispatch, a `deploy.yml` run on a hosted runner, and I did not. A saved note says production runs code that is newer than `main` in places (for example `guest.{js,html}`). Deploying `main` on demand could roll that back.
- The latest deploy (2026-10-26) predates the switch, so no deploy has run on a hosted runner yet. The next push to `main` will trigger the first one, and it should be checked when it happens.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-ci-runner-to-hosted-202610-retry2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 18 tokens (463208 cached reads)
- Output: 2605 tokens
- Cost: $0.5181015999999999
- Wall-clock: 642s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
