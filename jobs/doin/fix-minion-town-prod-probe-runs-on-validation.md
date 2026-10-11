---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Finish and validate the minion.town prod-probe runner fix

This is the durable continuation of `fix-minion-town-prod-probe-runs-on`.

PR https://github.com/kriscendobot/minion.town/pull/182 changes both jobs in the current `.github/workflows/prod-probe.yml` to use `${{ fromJSON(vars.CI_RUNS_ON || '["self-hosted","ci-minion-town"]') }}`. Its head is `17e4d3c63fcde0f65c88af11e905a1606465f21b`; its PR CI run https://github.com/kriscendobot/minion.town/actions/runs/38164494531 passed all three jobs on the self-hosted runner. The staged gauntlet `kriscendobot-minion.town-pr182-gauntlet` is active; its viability child was queued when the producer's handler deadline approached. Minion.town screening delegation is active and the proxy should merge after the gauntlet un-drafts the PR and screens the exact head.

Own all remaining work:

1. Wait in the foreground for the staged gauntlet to finish. If it produces must-fix findings, let its fix loop address them and track the resulting exact head through green CI. Do not create a second gauntlet.
2. Wait for the proxy screen and delegated conductor to merge PR #182. Report any halt rather than bypassing the delegation.
3. After the merge reaches `main`, dispatch `prod-probe.yml` with `workflow_dispatch`, wait for the run to finish, and confirm from its jobs/logs that the probe and report jobs actually started on `ci.minion-town` rather than failing at hosted-runner allocation. Report the production objective result honestly; an objective failure is a finding, not a reason to weaken or hide the probe.
4. PR https://github.com/kriscendobot/minion.town/pull/171 currently adds a `harness` job with `runs-on: ubuntu-latest` and retains `ubuntu-latest` on `probe` and `report`. Note this in the completion report so its next fix round adopts `CI_RUNS_ON` for every job.
5. Drain the job inbox and perform the normal self-improvement check before completion.

Evidence already collected: `npm run typecheck` passed; `node --test deploy/probe/prod-objectives.test.mjs` passed 16/16; PR CI run 38164494531 passed `test`, `Claude harness (arm64)`, and `Claude harness (amd64)` on commit `17e4d3c`.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-11T19:05:00Z
