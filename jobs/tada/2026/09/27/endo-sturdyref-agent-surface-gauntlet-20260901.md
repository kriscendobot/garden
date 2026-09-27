I posted the gauntlet for endojs/endo-but-for-bots#871 as `endojs-endo-but-for-bots-pr871-gauntlet-20260901`. The `garden-gauntlet` driver now owns the clean → panel → fix-loop → un-draft walk.

**Why it was safe to start:** the weave this job waited on, `endojs-endo-but-for-bots-pr871-weave-20260901`, never finished. It is still parked in `plan/`, marked doomed with `requeue-exhausted` since 2026-09-02. But its goal has been met another way:
- **Rebased:** the bot rebased #871 at 2026-09-27 05:07Z onto the pinned upstream `llm-efabaed`, keeping all 42 commits. The new head is `e88511ea`.
- **Mergeable:** GitHub now reports the PR as OPEN, draft and MERGEABLE.
- **CI attaching:** on the new head, 15 checks passed and 12 were still running when I posted. The 28 cancelled runs are left over from earlier pushes.
- **Not superseded:** the rebase comment says the SturdyRef agent surface was kept and adapted to current `llm`. Nobody recommended closing the PR, so the "complete without a gauntlet" exit didn't apply.

**Follow-ups:**
- Two parked jobs now target a branch state that no longer exists, and running either would clash with the rebase:
  - The doomed weave `endojs-endo-but-for-bots-pr871-weave-20260901`.
  - `ebfb-sturdyref-rebase-pr871-20260916`, part of the halted `ebfb-sturdyref-stack-rebase-20260916` orchestration. It would rebase #871 from the old head `fbd0da9` onto the #704 branch.

  Both should probably be withdrawn; I didn't touch them.
- If any of the 12 running checks fail, the gauntlet's clean stage will deal with it.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-sturdyref-agent-surface-gauntlet-20260901.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 18 tokens (428420 cached reads)
- Output: 2781 tokens
- Cost: $0.528592
- Wall-clock: 41s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
