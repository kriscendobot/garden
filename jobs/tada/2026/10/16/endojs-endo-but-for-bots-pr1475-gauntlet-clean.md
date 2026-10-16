Clean stage for endojs/endo-but-for-bots PR #1475 is done: I changed nothing on the PR, and CI is green.

- **Nothing to clean:** the PR (draft, open, head `kriscendobot:design/ocapn-noise-cryptographic-review` on base `llm-61cd656`) only touches three markdown files: `designs/README.md`, `designs/ocapn-noise-cryptographic-review.md` and `designs/ocapn-noise-network.md`. With no code in it, there was nothing for a coverage pass to test and no orphaned dead code to remove, so I did not create a project checkout or push anything.
- **CI:** I ran `ci-wait-merge.sh endojs/endo-but-for-bots 1475 --no-merge`, which returned rc 0. All 30 checks finished with 0 failures, at head `453413b83d`.
- **Follow-ups:** none. The gauntlet can move on to the panel stage.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1475-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (104677 cached reads)
- Output: 981 tokens
- Cost: $0.31712339999999994
- Wall-clock: 59s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
