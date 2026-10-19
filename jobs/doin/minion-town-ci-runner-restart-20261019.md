---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
requires: aws
role: shepherd
handler-timeout: 7200

# Restart the stalled ci.minion.town runner, then finish the PR #199 rerun

kriscendobot/minion.town CI has stopped: no workflow run has been `in_progress` since at least 23:52Z on 2026-10-18. These runs are still queued as of 2026-10-19T00:55Z:
- 39172800433: `test` attempt 2, PR https://github.com/kriscendobot/minion.town/pull/199, a `--failed` rerun of a flaky 90s timeout in `test/endo-daemon-integration.test.ts` > "GuestHostPowers ... restart -> read (durable)". The PR doesn't touch that test, and three earlier runs on this branch were green.
- 39178337996 and 39178337971: feat/new-clip-inventory.

The PR's `test.yml` uses the self-hosted default. Host oros-studio has no AWS and gets a 403 on the runners API, so it couldn't check or restart the runner.

1. Follow context/operations/ci-minion-town-runner.md § Operate: check the runner (API + `journalctl -u ci-runner` over SSM). Tell saturation from an outage. If the runner is offline or missing, or its log has stopped advancing, run `systemctl restart ci-runner` over SSM.
2. Confirm the queued runs start. Then drive run 39172800433 (PR #199 head 085c7445c33504b0c7e67682491b298917fd114d) to green per roles/shepherd/AGENT.md. If the same test times out again, treat it as real and investigate.
3. Don't flip `CI_RUNS_ON` to hosted: the billing block runs until about 2026-10-30.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-19T02:31:14Z
