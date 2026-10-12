---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Arm the minion.town production probe on the self-hosted runner, then prove a passing run

Repo: kriscendobot/minion.town (authority: issue kriscendobot/garden#58 standing order, journal
`entries/2026/10/07/203746Z-message-gardener-a253b1.md`, "everything, no escalations" for this repo).

kriscendobot/minion.town#182 merged 2026-10-12T13:51Z and deployed, but `prod-probe.yml` still runs on
hosted `ubuntu-latest` because the repository variable `PROBE_RUNS_ON` is unset. During the hosted-minutes billing block, neither the
`probe` job nor the `report` job starts. Every run since #166 landed has failed this way, most recently
https://github.com/kriscendobot/minion.town/actions/runs/38260878200. The `prod-probe` environment secrets exist.

1. Set the repo variable `PROBE_RUNS_ON` to `["self-hosted","ci-minion-town"]` (JSON) per DEPLOYMENT.md
   § Prod probe *Runner* / § CI runner *Trust note*. That trust note records this as the accepted exposure.
2. `gh workflow run prod-probe.yml -R kriscendobot/minion.town --ref main` and wait for it IN THE FOREGROUND.
3. If it passes: report the run URL as the primary-phase automatic production validation for garden#58.
   If it fails on a real objective check, or on the probe credential, diagnose it. Then post the
   matching fix/build job against minion.town (deterministic basename) and report.
   If it sits queued for over an hour, the runner is offline. Check it per DEPLOYMENT.md § CI runner.
Do not merge anything by hand. The proxy screen owns merges.
