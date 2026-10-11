---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Fix: kriscendobot/minion.town prod-probe workflow never runs (hosted-runner billing block)

Repo: kriscendobot/minion.town, branch `main` (merged in https://github.com/kriscendobot/minion.town/pull/166, merge 4bd13c82956e).

The first post-deploy run of `.github/workflows/prod-probe.yml` (run 38156664210, 2026-10-11T16:43Z) failed in 7s without starting:
"The job was not started because recent account payments have failed or your spending limit needs to be increased."
Both jobs in that workflow (`probe` line ~26, `report failure` line ~87) use `runs-on: ubuntu-latest`. Every other workflow (test.yml, deploy.yml) routes through
`runs-on: ${{ fromJSON(vars.CI_RUNS_ON || '["self-hosted","ci-minion-town"]') }}` (introduced by #175 for the billing block), and those runs succeed.

Do: switch both prod-probe.yml jobs to the same `CI_RUNS_ON` expression (check the probe's steps work on the self-hosted ci.minion.town runner: node setup, any tools it assumes), open a PR via ensure-pr.sh against `main`, and let the gauntlet run (minion.town delegation is active; the proxy screen merges). After merge, confirm a prod-probe run actually executes (trigger via workflow_dispatch if the workflow has it, else wait for the post-deploy workflow_run) and report its result — a probe failure on a real objective is a finding to report, not to paper over.
Also: open PR https://github.com/kriscendobot/minion.town/pull/171 edits prod-probe.yml too; if it still adds `ubuntu-latest` jobs, note it in the report so its next fix round adopts CI_RUNS_ON.

Supervisor: minion-town-arc-press (kriscendobot/garden#58).

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-11T18:33:36Z
