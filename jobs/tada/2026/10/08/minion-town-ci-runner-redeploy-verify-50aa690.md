Validated `kriscendobot/minion.town` main at `50aa690f87bab73cadc83eaeb39806b60913f054`.

- Lambda and host were already synchronized; neither was redeployed, and the host was not rebooted.
- Fresh SSM evidence showed boot at `2026-10-08 20:23:32 UTC` and `ci-runner.service` active since `20:23:40 UTC`, exceeding the ten-minute window.
- Dispatched and observed selftest: https://github.com/kriscendobot/minion.town/actions/runs/37849209480
- `probe` and `verify` passed; verification found none of the planted filesystem, X11, systemd-private, Docker, cron, workspace, or `/run/lock` residue.
- The intentional `fail` job failed as expected.
- Job logs showed timestamp-suffixed runner names, including `ci-minion-town-0fdb85b6-20261008T214954Z` and `ci-minion-town-0fdb85b6-20261008T215307Z`.
- `CI_RUNS_ON` is unset, selecting the self-hosted runner.
- After the prune window, the runners API showed exactly one timestamp-suffixed, online registration and no orphaned or offline registrations.
- Notified the maintainer with the evidence and conclusions. Open operator items: none.
- No project code changed.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-ci-runner-redeploy-verify-50aa690.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 518s

<!-- garden-usage-end -->
