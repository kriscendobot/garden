I merged PR #1116 (design: guest-native invitation and acceptance) into `llm`, and confirmed it is merged.

- **Merge:** `ci-wait-merge.sh` found the head 1fa38f6da0 already current against live `llm`, with nothing to rebase. CI on that head was green: 30 checks, 7 passed and 23 skipped, none failed.
- **Approval:** kriskowal's APPROVED review on e70a960422 still counts. It was never dismissed, and it is later than their earlier CHANGES_REQUESTED, so that request no longer blocks.
- **Result:** the merge commit is `ca1794f0cdce112748c8381d4107d28c1b078d48`, made at 2026-10-02T00:52:49Z.
- **Branch cleanup:** the PR's base was live `llm` throughout, so there was no frozen `llm-<sha>` branch to unfreeze or delete. The sweep confirmed this.

**Follow-ups:** none. I didn't look for downstream PRs this merge might unblock.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1116-conduct-20261002.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (184942 cached reads)
- Output: 1206 tokens
- Cost: $0.4625964
- Wall-clock: 61s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
