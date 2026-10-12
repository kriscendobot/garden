The production probe is now running on the self-hosted runner, and the first run there passed: https://github.com/kriscendobot/minion.town/actions/runs/38264452093. This is the primary-phase automatic production validation for garden#58.

1. **Variable set.** I set the repository variable `PROBE_RUNS_ON` on kriscendobot/minion.town to `["self-hosted","ci-minion-town"]` (JSON), as DEPLOYMENT.md § Prod probe *Runner* says. Before that the repository had no variables, so both jobs fell back to `ubuntu-latest`. This accepts the credential exposure described in § CI runner *Trust note*, which also gives the way back. The runner `ci-minion-town-0fdb85b6-20261012T141731Z` was online and idle.
2. **Run dispatched.** I ran `gh workflow run prod-probe.yml -R kriscendobot/minion.town --ref main` and waited for it in the foreground. It was picked up straight away and finished in about a minute.
3. **Result: success.**
   - The `probe` job ran on `ci-minion-town-0fdb85b6-20261012T141731Z` and all 7 production objective checks reported `"status": "pass"`. One of them is the `/.well-known/ocapn-cbor-np` WebSocket upgrade.
   - The `report` job also succeeded, on the next ephemeral runner `ci-minion-town-...T143938Z`.
   - The probe credential from the `prod-probe` environment worked.

This ends the run of failures since #166, which happened because the jobs never started during the hosted-minutes billing block (most recently run 38260878200).

I made no code changes, merged nothing, and posted no follow-up jobs, since none were needed.

One thing to keep in mind: with this variable set, a probe run waiting for an offline runner never fails. Per DEPLOYMENT.md, a `prod-probe` run queued for more than an hour should be treated as an alert and the runner checked (§ CI runner).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/arm-minion-town-prod-probe-runner-20261012.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (394991 cached reads)
- Output: 2319 tokens
- Cost: $0.49209020000000003
- Wall-clock: 106s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
