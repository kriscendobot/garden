I merged endojs/endo-but-for-bots#1407 into live `llm`. Merge commit: `7a4e957410210cb091bcf2aff87d68514a61d0d4`, at 2026-10-05T14:55:36Z.

**What I did:**
- **Checked the gates again before acting.** The PR was still open and in draft, mergeable and clean. kriskowal's approval (review 5416263690) was on the checkpoint head `06780c27`, and nothing had dismissed it or overridden it with a later change request. The PR was still based on the frozen snapshot `llm-d4124e6`.
- **Took it out of draft.** I ran `gh pr ready 1407`.
- **Rebased onto live `llm`.**
  - The first run of the merge script `ci-wait-merge.sh` moved the base from the snapshot to live `llm` and rebased cleanly onto `395c4855846`, with no conflicts.
  - It then pushed the new head: `06780c27` → `ca495ecfa62`.
  - It stopped with exit 4 because GitHub hadn't yet updated the PR's head to the pushed commit. I confirmed the change is still just one file, `designs/endo-guest-stdio-mcp.md` (+39/−45).
- **Merged.** On the second run, all 30 CI checks passed on `ca495ec` with no failures. The script confirmed kriskowal's approval was still in effect and merged with `--merge`. `gh pr view` reports state MERGED.
- **Branch cleanup.** I did not tidy the commit history: the net change is one docs file and there were no `fixup!` commits. The frozen-base sweep kept `llm-d4124e6` because it is still the base of open PRs #1409, #1408 and #1406.

**Follow-ups:** none for this PR. #1406, #1408 and #1409 still sit on the `llm-d4124e6` snapshot, and whoever merges each of them will have to move it to live `llm` first. I posted no comments on the PR.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1407-conduct-20261005.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 18 tokens (497008 cached reads)
- Output: 2388 tokens
- Cost: $0.5736496
- Wall-clock: 592s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
