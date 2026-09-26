Done. Panel round 3 completed, verdict posted. Round 2's review was also `COMMENTED` (same self-authored-PR fallback), confirming this is the established shape for this PR.

## Completion report

**Stage:** gauntlet `panel`, iteration 3 — endojs/endo-but-for-bots PR #717 (`design/promise-debug-view`, design-only, base `origin/llm`).

**What I did:**
1. Resolved head (endojs/`design/promise-debug-view`) and got an isolated project worktree at HEAD `d545e9e0fd`.
2. Ran `panel.sh` in `GARDEN_PANEL_SINGLE_ROUND=1` mode against base `origin/llm`. Design-panel fanned 7 seats (critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice) — **all 7 returned request-changes**. Recorded disposition: `must-fix`.
3. Posted the aggregate verdict on PR #717 as a `gh pr review`. GitHub forbids `--request-changes` on a self-authored PR (the bot `kriscendobot` is the PR author, error: *"Can not request changes on your own pull request"*), so I posted it as a `--comment` review — the same fallback round 2 used. Submitted 2026-09-04T05:41:53Z.

**Verdict:** must-fix. Load-bearing must-fix items converged across seats:
- The weak-reachability premise is **falsely attributed to the parent** `pass-style-promise.md` — the parent never states carrier edges are weak, and its canonical producer keeps the resolver in a long-lived table, so a live producer plausibly pins its carrier and the headline `forever-pending` case may never fire (critic, skeptic).
- Snapshot/`entries` field doesn't state which internal structures (`retained` vs `ring`) project into it — the flagship `unlistened-rejection` may be invisible until GC (ergonomist).
- Dead cross-reference: cites parent's "Open Question 3 / Fire-once settlement" but the parent has Resolved Decision 3 "Fire-once listener lifecycle" (copyeditor); hyphen line-break renders "never -listened" (pedant, copyeditor).

**Follow-ups:** none from me — this is one stage; the gauntlet driver will route to the fix stage off the `must-fix` marker below. No code/garden changes; nothing to commit.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr717-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (1241136 cached reads)
- Output: 7543 tokens
- Cost: $1.42262825
- Wall-clock: 989s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
