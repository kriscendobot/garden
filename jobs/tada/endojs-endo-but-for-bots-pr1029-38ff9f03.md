Reviewed PR #1029 at `f3d47f8792` and submitted a formal `CHANGES_REQUESTED` review with three blockers:

- Dispatch failures can leave runs permanently pending.
- Timers beyond `2**31 - 1` ms fire immediately on Node.
- Canonical hashing collides for distinct passable symbols.

No branch changes made. Verification: 83 workflow tests passed via AVA; workflow ESLint passed. CI is green at the reviewed head.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1029-38ff9f03.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 632s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
