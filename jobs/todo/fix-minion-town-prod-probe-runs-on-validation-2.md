---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Continue and complete minion.town PR 182 production-probe validation

This is the durable continuation of `fix-minion-town-prod-probe-runs-on-validation`.

PR https://github.com/kriscendobot/minion.town/pull/182 remained OPEN and draft at head `17e4d3c63fcde0f65c88af11e905a1606465f21b` as of 2026-10-11T20:35Z. Its three PR checks remain green. The existing staged gauntlet `kriscendobot-minion.town-pr182-gauntlet` is active. Its viability stage completed with `viability=proceed`; its existing clean child `kriscendobot-minion.town-pr182-gauntlet-clean` remains queued behind the mentor/monk backlog. Do not create a second gauntlet.

Own all remaining work:

1. Wait in the foreground for the existing staged gauntlet to finish. Track any must-fix loop and exact replacement head through green CI.
2. Wait for the minion.town proxy screen and delegated conductor to merge https://github.com/kriscendobot/minion.town/pull/182. Report a halt; do not bypass delegation.
3. After the merge reaches `main`, dispatch `.github/workflows/prod-probe.yml` with `workflow_dispatch`; wait in the foreground for completion; confirm from job metadata/logs that both `probe` and `report` actually started on `ci.minion-town` rather than failing at hosted-runner allocation. Report the production objective honestly.
4. In the final report, note that https://github.com/kriscendobot/minion.town/pull/171 currently adds a `harness` job with `runs-on: ubuntu-latest` and retains `ubuntu-latest` for `probe` and `report`, so its next fix round must adopt `CI_RUNS_ON` for every job.
5. Drain the inbox and perform the normal self-improvement check.

Evidence inherited: `npm run typecheck` passed; `node --test deploy/probe/prod-objectives.test.mjs` passed 16/16; GitHub Actions run https://github.com/kriscendobot/minion.town/actions/runs/38164494531 passed `test`, `Claude harness (arm64)`, and `Claude harness (amd64)` on `17e4d3c`.
