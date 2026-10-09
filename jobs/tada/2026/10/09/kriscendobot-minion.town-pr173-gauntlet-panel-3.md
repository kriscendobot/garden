Panel round 3 on kriscendobot/minion.town#173 (the design on branch `design/ocap-site-crawler-leak-rotation`) came back **must-fix**. I posted the verdict to the PR as a review.

**What I did**
- Got an isolated checkout of the PR head at `/home/kris/garden/scratch/project-wt-kriscen-53c59e587b96-b9a39f6e`.
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <wt> 173 origin/main-50aa690`. It exited 0 and returned `design-panel single-round — must-fix`. The ownership-map pre-pass flagged ATTENTION, so the decomplector lens was forced on. Nine seats reported: copyeditor, critic, decomplector, ergonomist, novice, orthographer, pedant, skeptic and thesaurus.
- Posted the aggregate (`round-1.md` from the panel run dir, under a "Panel verdict — round 3: must-fix" heading) as a review. A request-changes review was rejected because the bot can't request changes on its own PR. I posted it as a COMMENT review instead (2026-10-09T13:50:45Z), with the must-fix verdict stated in the body. If the next-stage heuristic only recognizes a request-changes review as a must-fix verdict, it won't count this one. On a bot-authored PR a COMMENT review is the only form that can be posted.

**Main must-fix finding:** the design specifies the full rotation machinery (saga, tombstones, intent log, compensation, circuit breaker, degraded mode) as committed work. But its own gate 5 may turn that machinery into dead code. The panel asks to cut the design to units 1–3 and move rotation into a separate follow-up design, written only if gate 5 passes. The other seats raised several should-fix items about readability and density.

I made no fixes and did not un-draft, as this stage requires.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr173-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 18 tokens (447893 cached reads)
- Output: 2495 tokens
- Cost: $0.5053106
- Wall-clock: 206s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
