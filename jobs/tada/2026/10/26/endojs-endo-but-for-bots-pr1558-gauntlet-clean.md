Clean stage for endojs/endo-but-for-bots PR #1558 ("design: capability-scoped durable child-agent factory") is done: CI is green and nothing needed changing.

- **What the PR touches:** it is a draft whose head is `endojs:design/endo-child-agent-factory` at `8faeb579` and whose base is the pinned branch `llm-d5ac419`. It changes only two markdown files, `designs/README.md` and `designs/endo-child-agent-factory.md`.
- **Coverage and dead code:** with no source code in the diff, there was nothing to run coverage on and no orphaned code to remove. I made no changes, so I did not create a project checkout and pushed nothing.
- **CI:** `ci-wait-merge.sh --no-merge` exited with rc 0 (GREEN). Of the 30 checks, 0 failed: 6 passed and 24 were skipped, which is expected for a docs-only change.

Follow-ups: none from this stage. The gauntlet moves on to panel review.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1558-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (120718 cached reads)
- Output: 865 tokens
- Cost: $0.38101959999999996
- Wall-clock: 19s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
