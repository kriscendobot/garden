The PR is already MERGED and not a draft. This stage is a no-op.

PR #234 is already **MERGED** (`isDraft: false`, `state: MERGED`). The un-draft stage is a NO-OP per its idempotence check — the PR is neither draft nor OPEN, so there is nothing to un-draft. No advisory pass or `gh pr ready` is warranted on a merged PR.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr234-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 4 tokens (49553 cached reads)
- Output: 326 tokens
- Cost: $0.33677650000000003
- Wall-clock: 9s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
