Clean stage for endojs/endo-but-for-bots PR #1431 ("docs(designs): record the encapsulation revision of the hardened text codecs"): nothing needed changing, and CI is green.

- **PR state:** open draft, head `45c49139f2`, base `llm-fda1ff5`. The only file it touches is `designs/hardened-text-codecs-shim.md`.
- **Coverage and dead-code pass:** skipped, because the change is documentation only. It touches no package source, so there is nothing to cover and no orphaned code to remove. I made no checkout, commits or pushes.
- **CI:** `ci-wait-merge.sh --no-merge` returned rc 0, with all 28 checks finished and none failed. Lint, zizmor and the change-detection checks passed. The other checks were skipped by change detection, as expected for a docs-only change.

Follow-ups: none from this stage. The gauntlet moves on to the panel stage.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1431-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (112930 cached reads)
- Output: 856 tokens
- Cost: $0.355042
- Wall-clock: 12s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
