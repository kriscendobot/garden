The panel round 4 is complete. The disposition is must-fix and the aggregate verdict has been posted to the PR.

## Report

**Job:** Gauntlet PANEL round 4 for endojs/endo-but-for-bots PR #989 (`design(worker): embargo outbound until a worker quiesces after delivery`).

**What I did:**
1. Resolved the PR head (`endojs:design/worker-quiescence-embargo`, base `llm`) and got an isolated project worktree at `0ef115678d`.
2. Ran `panel.sh` in single-round mode (`GARDEN_PANEL_SINGLE_ROUND=1`). It fanned all seats (critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice) over the design-only diff and decided **must-fix**. Exit was clean (a decision was reached).
3. Posted the aggregate as a `gh pr review` on #989. A request-changes review was rejected by GitHub (bot cannot request-changes on its own PR), so — matching the convention of rounds 1–3 on this PR — I posted it as a **COMMENTED** review whose body headline states the `must-fix` disposition.

**Verdict summary:** All seats returned request-changes. Recurring must-fix themes: the envelope taxonomy omits control envelopes that crank exclusivity would starve (debug/suspend inbound deadlock); Decision 9's "XS is bounded" premise fails for the sync case Decision 5 introduces; the failure-atomicity rationale rests on a nonexistent retry; Decision 4's timer-parity claim is structurally (not clock-) divergent; the Node seam complects worker crank discipline with shared connection dispatch; plus an 8th-positional-parameter ergonomics issue and a standing typist-friendly-code-points violation (U+2192 at line 479).

**Stop point:** Per the stage contract I ran exactly one round, posted the verdict, and stopped — no fix, no un-draft, no loop.

**Follow-ups:** The gauntlet's next stage (fix-loop) owns addressing the must-fix items; this stage owes only the verdict, which is posted.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr989-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 27 tokens (648898 cached reads)
- Output: 4203 tokens
- Cost: $0.884351 (1 engagement(s) unpriced)
- Wall-clock: 309s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
