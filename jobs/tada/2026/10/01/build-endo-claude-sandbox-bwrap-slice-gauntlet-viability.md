I checked PR #1408. It is open and still a draft, with no reviews and no comments, and nothing has replaced it. It can proceed to the gauntlet. I spent no clean, panel, fix, CI-wait or un-draft budget.

Deciding question: On the current `llm` branch, can the confined `claude` tree still reach the daemon socket by path, with no other kernel slice landed in `@endo/claude` to stop it?

Answer: yes.

Evidence:
- **The work was asked for.** The PR (opened 2026-10-01) is follow-up 3 from #1371's live-turn findings. The maintainer requested it in the "conduct and build" review on #1371 (pullrequestreview-5375148317). #1371 merged to `llm` at 2026-10-01T08:37Z.
- **Nothing on `llm` does this yet.** `packages/claude/src` there has no `bwrap-slice.js` or any other sandbox wiring. The last commits to `packages/claude` are #1371's own (93f63e4b90 and the two before it, at 07:23Z). Nothing newer touches that package.
- **The gap is still open on `llm`.** The `llm` README § Known gaps still lists "Kernel-level confinement of the `claude` tree" as not yet done. It says making the daemon socket structurally unreachable is still the job of a slice that wraps `claudePath`, which is exactly what this PR adds.
- **No competing PR.** Searching endo-but-for-bots PR titles for "bwrap" finds only this PR and #78, the merged `@endo/sandbox` driver work it builds on.
- **Base is current.** The PR is based on a snapshot of `llm`, `llm-d4124e6`, which already includes #1371.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-claude-sandbox-bwrap-slice-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (173285 cached reads)
- Output: 1456 tokens
- Cost: $0.42244899999999996
- Wall-clock: 35s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
