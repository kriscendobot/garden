Clean stage for endojs/endo-but-for-bots#1497 is done. Nothing needed changing, so I pushed nothing.

- **The PR:** "design(daemon-agent-tools): re-sweep and scope the next slice (sandbox shell engine)". It's a draft, open, with head `design/daemon-agent-tools-next-slice` at `9b712791f7` and base `llm-ca5aaef`.
- **Coverage and dead code:** the diff touches only Markdown (`designs/README.md` +2/−2, `designs/daemon-agent-tools.md` +242/−13). With no source or test files changed, there's nothing to measure coverage on and no orphaned code to remove. I didn't create a project checkout.
- **CI:** `ci-wait-merge.sh endojs/endo-but-for-bots 1497 --no-merge` returned rc=0, CI GREEN: all 30 checks finished with 0 failures. Lint, zizmor and change-detection passed. The build and test jobs were skipped because the change is docs-only.

No follow-ups for this stage.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1497-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (120842 cached reads)
- Output: 979 tokens
- Cost: $0.3867484
- Wall-clock: 17s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
