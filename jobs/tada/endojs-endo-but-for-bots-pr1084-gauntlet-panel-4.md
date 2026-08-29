The round 4 panel verdict is posted. Stage complete.

Panel round 4 for endojs/endo-but-for-bots PR #1084 (`designs/exo-stream-adaptive-pacing.md`) ran in single-round mode against base `origin/llm`. Seven design seats fanned out; the aggregate disposition was **must-fix**.

**What I did**
- Resolved the PR head (endojs/endo-but-for-bots @ `design/exo-stream-adaptive-pacing`) and got an isolated project worktree.
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <worktree> 1084 llm`; it exited cleanly with terminal line `design-panel single-round — must-fix`.
- Posted the full seat aggregate as a `gh pr review` on #1084.

**Verdict detail**
- request-changes: critic, skeptic, decomplector, ergonomist, copyeditor
- comment-only: pedant, novice

Recurring must-fix themes across seats: the epoch-counter/`Filling`-state spec split between the mermaid diagram and prose; no construction-time range validation for load-bearing numeric knobs (`min>=1`, `alpha>0`, `beta` range); the headline "settles at BDP" claim contradicting the Limits section's producer-bound case; `alpha` braiding growth-rate and delay-budget; and the widened `buffer` type surface diverging from sibling APIs.

**Note**: The review was posted as a `COMMENTED` review, not `--request-changes` — GitHub forbids requesting changes on your own PR (the head is authored by the bot). This matches how rounds 1–3 were posted; the `must-fix` disposition is carried in the review-body text, which the next-stage-owed heuristic keys on.

Stopped here per single-round contract — no fix, no un-draft, no loop.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1084-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 31 tokens (841376 cached reads)
- Output: 5154 tokens
- Cost: $1.0572160000000002
- Wall-clock: 353s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
