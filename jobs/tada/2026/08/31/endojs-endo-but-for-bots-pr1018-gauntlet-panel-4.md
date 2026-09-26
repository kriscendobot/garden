The panel round 4 verdict is posted. Job complete.

## Completion report

**Job:** Gauntlet PANEL round 4 — endojs/endo-but-for-bots PR #1018 (`design(ironhorse): panic mechanism and message-embargo contract`).

**What I did:**
1. Resolved the PR head: `endojs/endo-but-for-bots` @ `design/ironhorse-panic`, base `llm` (base SHA `92148f20ff45`, head `875737517`).
2. Got an isolated project worktree keyed to this job base.
3. Ran the design panel in single-round mode (`GARDEN_PANEL_SINGLE_ROUND=1`) against the worktree, passing the real base merge-base SHA (not the bare `llm` branch name, per the origin-only-normalization gotcha). Panel disposition: **must-fix**.
4. Posted the aggregate seat blocks as a `gh pr review`. The bot authors this PR, so GitHub rejects `--request-changes` on our own PR (as in rounds 1–3); posted as a **COMMENT** review with a prominent `**Disposition: must-fix.**` header — the same shape prior rounds used and the next-stage-owed heuristic recognizes.

**Verdict summary:** 4 of 8 seats requested changes (critic, skeptic, ergonomist, novice); decomplector and pedant comment-only; copyeditor approve. Core must-fixes: an internal contradiction over whether an uncaught `Throw` is retryable (three artifacts disagree); Verification section omits an acceptance test for the FFI `catch_unwind` guard it names as a live-code fix; `is_panic()` asserted as settled in the body but re-litigated in Open Questions; and several founding-term glosses missing.

**Stopped here** as instructed — no fix, no un-draft, no loop.

**Follow-ups:** next gauntlet stage (fix-loop) owed on the must-fix verdict.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1018-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (617760 cached reads)
- Output: 4382 tokens
- Cost: $0.874149
- Wall-clock: 432s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
