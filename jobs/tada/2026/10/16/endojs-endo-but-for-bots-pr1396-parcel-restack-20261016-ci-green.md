PR #1396 CI is green at head `9a9ac8c6f0fdc6f73dea6f5aca222c1d86368b21`.

Changes pushed:

- `16bb8a11b4`: install the Parcel shim before Ironhorse lockdown, fixing worker-delivery hangs.
- `9a9ac8c6f0`: update `yarn.lock` for `@endo/parcel`.

All five workflows succeeded: CI, IronHorse oracle sanitizers, OCapN Guile interop, project mutual dependency versions, and workflow security audit.

GitHub reports no branch-protection-required checks. The complete rollup is terminal: 26 SUCCESS and 9 SKIPPED. Successful checks include lint, zizmor, build, familiar-bundle, all four Node test matrix legs, both coverage legs, both viable-release legs, sandbox-drivers, test-async-hooks, test-hermes, test-xs, build-xsnap, test-thixotrope-ironhorse, test-ironhorse-oracle, test-ocapn-python, test-ocapn-guile-interop, check-action-pins, and four change-detection checks. Skipped checks: ironhorse-oracle-sanitizers, format-ironhorse, matrix.check, test-ironhorse-calibration, fuzz-ironhorse, cross-target-ironhorse, build-wasm, build-ironhorse-wasm, and compare-ironhorse-math.

Local reproduction confirmed the original Ironhorse timeouts and the fix cleared those scenarios. The full local suite later encountered the container’s no-exec `/tmp` restriction; the complete GitHub-hosted suite passed.

Posted completion summary: https://github.com/endojs/endo-but-for-bots/pull/1396#issuecomment-6209283196

Follow-ups: none. Self-improvement: nothing this time.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `be6579730c891aa155280e651bd926878da8947f`; this job presented `9a9ac8c6f0fdc6f73dea6f5aca222c1d86368b21`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer review docket received a deduplicated re-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1396-parcel-restack-20261016-ci-green.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 2946s

<!-- garden-usage-end -->
