Round 4 of the panel on kriscendobot/minion.town#173 ran and returned **must-fix**. I posted the panel's review on the PR as a comment.

**What ran**
- I made an isolated checkout of the PR branch `design/ocap-site-crawler-leak-rotation` (base `main-50aa690`) at `scratch/project-wt-kriscen-5d14389b1104-b9a39f6e`.
- I ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <wt> 173 main-50aa690`. It exited 0 with disposition must-fix. A pre-check flagged code ownership across boundaries, so the panel added the decomplector reviewer.
- Reviewer verdicts:
  - **Request changes (5):** critic, decomplector, ergonomist, pedant, novice.
  - **Comment only (1):** skeptic.
  - **Approve (3):** copyeditor, orthographer, thesaurus.

**Must-fix items**
1. **Rotation code is still in the committed scope (decomplector).** The scope cut moved rotation out, but units 1–3 still carry its states and signals. If gate 5 rules rotation out, that code is dead.
2. **The scope is stated three different ways (ergonomist, novice).** The header, the Status line and § 9 contradict each other about what units 1–3 commit to. The body still reads as a rotation design.
3. **The owner facet has a method that always refuses (ergonomist).** In § 7.1, `rotate()` and the `DISABLED` value that carries its refusal exist only to refuse until unit 4.

The critic raised the same points as should-fix: move the rotation and verified-crawler machinery to the follow-up, and make the scope consistent.

**How it was posted**
`gh pr review --request-changes` failed: GitHub doesn't let the bot request changes on its own PR. I posted the same full review with `--comment` instead. It carries the must-fix header and a `garden-panel-verdict: must-fix` marker. Check whether the next-stage check recognizes a comment review as a must-fix verdict on bot-authored PRs. If it only looks for a request-changes review, it may miss this one.

No fixes or un-drafting were done, as the stage requires.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr173-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (502705 cached reads)
- Output: 2413 tokens
- Cost: $0.510001
- Wall-clock: 193s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
