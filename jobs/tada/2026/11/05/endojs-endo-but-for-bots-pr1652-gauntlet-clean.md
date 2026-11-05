Clean stage for endojs/endo-but-for-bots PR #1652: **no-op, CI green.** Nothing was changed or pushed.

- **Scope:** the PR adds 647 lines and deletes none, and only touches `designs/README.md` and `designs/unified-virtual-filesystem.md`. It has no package source or tests, so I didn't run coverage and there is no orphaned code to remove. I also didn't create a project checkout, because nothing needed editing.
- **CI:** `ci-wait-merge.sh endojs/endo-but-for-bots 1652 --no-merge` returned rc 0 at head `22a475e7ff8e`, with 31 checks and 0 failed. Most code-test jobs, including `test` and `cover`, were skipped by change detection; `lint`, `zizmor` and `android` passed.
- **PR state:** still open and draft; un-drafting belongs to a later stage.
- **Inbox:** drained, no messages.
- **Follow-ups:** none; the gauntlet can move on to the panel stage.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1652-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (114084 cached reads)
- Output: 1431 tokens
- Cost: $0.3813488
- Wall-clock: 63s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
