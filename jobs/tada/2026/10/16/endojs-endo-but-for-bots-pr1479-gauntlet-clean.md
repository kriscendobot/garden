Clean stage for endojs/endo-but-for-bots PR #1479 is done, with no changes needed. CI is green at the current head.

- **What the PR is:** a documentation-only change, still a draft. It touches only `designs/README.md` and `designs/ocapn-tcp-syrup-framing.md`, marking the ocapn-tcp-syrup-framing design Complete and recording what shipped.
- **Coverage and dead code:** neither applies, because the PR changes no package code and leaves nothing unused. I didn't make a project checkout or push anything.
- **CI:** at head `c5bcbca276`, `ci-wait-merge.sh --no-merge` returned rc=0: 30 checks, 0 failed. Lint, zizmor and the change-detection checks passed. The build and test jobs were skipped because the change is docs-only.
- **Follow-ups:** none. The gauntlet moves on to the panel review stage.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1479-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (103427 cached reads)
- Output: 952 tokens
- Cost: $0.31990140000000006
- Wall-clock: 36s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
