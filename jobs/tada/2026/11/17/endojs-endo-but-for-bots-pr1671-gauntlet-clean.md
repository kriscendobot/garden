Clean stage for endojs/endo-but-for-bots PR #1671 is done. Nothing needed changing, so I pushed nothing.

- **Coverage:** no coverage pass to run. The PR ("design(endopi): concrete prompt-template format and Pi argument grammar") is a draft that only changes three Markdown files: `designs/README.md`, `designs/endopi.md` and `designs/endopi-prompt-templates.md`. There's no package code to test and no dead code left behind.
- **CI:** green at head `b765de9f`. `ci-wait-merge.sh --no-merge` returned rc 0 with 31 checks and 0 failures: 7 passed and 24 were skipped, which you'd expect for a docs-only change.
- **Follow-ups:** none. The next gauntlet stage (panel review) can go ahead.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1671-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (127846 cached reads)
- Output: 962 tokens
- Cost: $0.4046012
- Wall-clock: 24s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
