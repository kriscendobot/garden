Clean stage for kriscendobot/minion.town#182 (fix(probe): run production checks on configured CI runner): nothing needed changing, and CI is green.

- **Head:** `17e4d3c63fcd` on `kriscendobot:fix/prod-probe-ci-runs-on`. The PR is open and still a draft.
- **What the PR changes:** only `.github/workflows/prod-probe.yml`. Both `runs-on: ubuntu-latest` lines (the `probe` job and the job after it) become `${{ fromJSON(vars.CI_RUNS_ON || '["self-hosted","ci-minion-town"]') }}`.
- **Coverage pass:** not applicable. The change touches no code, so there are no packages to cover and nothing left unused.
- **Changes:** none, so I didn't make a project checkout and pushed nothing.
- **CI:** `ci-wait-merge.sh kriscendobot/minion.town 182 --no-merge` returned rc=0. All 3 checks passed: `test`, `Claude harness (amd64)` and `Claude harness (arm64)`.

Follow-ups: none from this stage. The gauntlet continues to the panel review.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr182-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (172023 cached reads)
- Output: 1091 tokens
- Cost: $0.3934246
- Wall-clock: 22s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
