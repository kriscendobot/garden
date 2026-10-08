Panel round 5 on endojs/endo-but-for-bots#1431 came back **must-fix**. I posted the verdict to the PR as a review; it went up as a comment, not a request-changes review (details below).

**What I did**
- Got the head owner and branch from `gh pr view`: endojs, `design/hardened-text-codecs-encapsulation`, head `ecf10b2d31e4`. Made an isolated checkout with `ensure-project-worktree.sh`.
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 scripts/jobs/gardening/panel.sh <wt> 1431 fda1ff55233b…`, passing the PR's base commit rather than the possibly stale `origin/llm-fda1ff5`. It ran as a design panel and all 9 seats returned ok: critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice, orthographer, thesaurus. Its final line was `design-panel single-round — must-fix`, and it recorded the run at `panel-runs/endojs-endo-but-for-bots-1431/87632b4ace0c.md`.
- I started `panel.sh` detached with `setsid`, so I could not read its exit code. I'm treating it as exit 0 because:
  - it printed a pass/must-fix result as its last line;
  - every seat status is ok;
  - the decider's stderr is empty;
  - it recorded the run.
- Posted the aggregate (`round-1.md` plus a summary header and the job marker) to the PR at 2026-10-08T03:08:11Z. GitHub refused a request-changes review because the bot owns this PR, so it went up as a comment. Earlier rounds on this PR posted the same way, so the next-stage check should still recognize it.

**What the verdict says**
- **Request-changes seats:** decomplector and pedant. Critic, skeptic, ergonomist, copyeditor and novice left comments only; orthographer and thesaurus approved.
- **The only must-fix (pedant, Chicago 6.60):** in "Summary of the remedy:", the clause after the colon is a full sentence, so its first word should be capitalized.
- **Main should-fix items for the fix-loop:**
  - **Decomplector:** keep the shared maker pure. Move the global-binding write and the idempotence `WeakSet` into the codec taming, and say which module owns the `WeakSet`.
  - **Critic:** the case for replacing the constructor everywhere, rather than only where the host constructor is affected, is weak. The design also depends on the unfinished `URLSearchParams`/`%InitialURL%` follow-up.
  - **Skeptic:** the Chrome measurements were taken on headless shells only. Throwing when the prototype is already frozen before taming is a new regression risk on engines the bug doesn't affect.

I made no fixes, did not un-draft, and changed nothing in the garden repo.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1431-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (840180 cached reads)
- Output: 4118 tokens
- Cost: $0.7092280000000003
- Wall-clock: 710s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
