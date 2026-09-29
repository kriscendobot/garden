The round 5 panel on kriscendobot/minion.town#120 finished and came back **must-fix**. All 33 seats ran, `panel.sh` exited 0, and I posted the verdict to the PR.

**How it ran**
- Isolated checkout of `kriscendobot/minion.town@claude-agents-delegate` at head `484cfc3`, compared against base `origin/main-c815041` (`c815041`).
- `GARDEN_PANEL_SINGLE_ROUND=1 scripts/jobs/gardening/panel.sh … 120 origin/main-c815041` exited 0 with disposition `must-fix`.
- The phase/evidence pre-pass came back BLOCKED (`non-deliverable-probe`, `probe-must-remain-draft`), which forces the integrator seat to run and binds the result to must-fix. This is the fifth round in a row blocked on this gate. It needs endojs/endo-but-for-bots#1015 merged and the production canaries run on a live deploy, so no code fix can clear it.

**What I posted**
- A summary review on #120, in the same shape as round 4. It went up as a COMMENTED review, not request-changes, because GitHub refuses request-changes on the bot's own PR (round 4 hit the same thing).
- The per-seat reports as two follow-up comments, because the 84 KB aggregate is over GitHub's review size limit. They were posted in the order 2/2 then 1/2: the gh wrapper first refused part 1 for bare `#1015`/`#120` references, so I rewrote those as fully qualified links and reposted it.

**Must-fix items**
1. The phase/evidence gate: keep the PR as a draft.
2. `infer` does not re-check `live()` after its `await context.credentials.status()`.
3. The PR description is stale: it still describes `Far` from `@endo/far` instead of `guardedFar`/exo, and it's written as a round-by-round changelog.
4. The parameter `p` in the new test mocks should be named `prompt`.

**Should-fix highlights**
- Child facets (`list`/`dismiss`/`models`) keep working after `revoke`; the assessor reproduced it.
- The teardown claim has a microtask gap that lets two callers both claim; the engine-realist reproduced it.
- The per-grant status facet and the naming of the `Far` seam.
- A repeat `delegate` drops its `canceled` argument.
- The inbox rate window uses `Date.now()`.
- The commits need regrouping, and the fix commits still have no completion-summary comment.

Round 4's two code must-fix items (the failed-`create` rollback and `revoke` making agents inert) are no longer flagged at this head.

I made no garden changes.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr120-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1056547 cached reads)
- Output: 7421 tokens
- Cost: $0.8603134
- Wall-clock: 854s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
