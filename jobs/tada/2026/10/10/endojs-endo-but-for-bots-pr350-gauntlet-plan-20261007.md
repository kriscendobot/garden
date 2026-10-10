I posted the gauntlet for endojs/endo-but-for-bots#350 ("docs: Various touch-ups (mirror of endojs/endo#2948)", head `mirror/2948-docs-touch-up` → base `master`).

- **Precondition check:** the PR is still open and not a draft, so the job was not a no-op.
- **Action:** I ran `scripts/jobs/post-gauntlet.sh --arc unallocated endojs-endo-but-for-bots-pr350-gauntlet-20261007 https://github.com/endojs/endo-but-for-bots/pull/350`. It recorded gauntlet `endojs-endo-but-for-bots-pr350-gauntlet-20261007` as a feature gauntlet, with max_iterations=6, max_resumes=6 and max_stage_retries=2.
- **Changes:** nothing in the garden library changed. The only write was the gauntlet record on the journal board, made by the script.
- **Follow-ups:** none. The gauntlet machinery now runs clean → panel → fix-loop → un-draft.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr350-gauntlet-plan-20261007.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (116047 cached reads)
- Output: 654 tokens
- Cost: $0.35951340000000004
- Wall-clock: 25s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
