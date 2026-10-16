Clean stage for endojs/endo-but-for-bots#1480 is done. Nothing needed changing and CI is green, so this stage was a no-op.

- **What the PR touches:** "docs(designs): specify the op:start-session extraction from OCapN core" is still a draft. The head is `endojs:design/ocapn-tcp-for-test-extraction` @ `d1c0d55c`, based on `llm-61cd656`. It changes only two markdown files: `designs/ocapn-tcp-for-test-extraction.md` and `designs/README.md`.
- **Coverage and dead code:** There is no code in the diff, so there was nothing to measure and nothing the change could have orphaned. I didn't create a project checkout and pushed nothing.
- **CI:** `ci-wait-merge.sh --no-merge` returned rc 0 ("rollup-terminal total=30 failed=0 → CI GREEN"). Lint, zizmor and change-detection passed. The other checks were skipped because they don't run on docs-only changes.
- **Follow-ups:** None. The panel stage can go ahead.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1480-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (116946 cached reads)
- Output: 912 tokens
- Cost: $0.3686932
- Wall-clock: 15s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
