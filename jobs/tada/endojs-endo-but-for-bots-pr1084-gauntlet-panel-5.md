The comment review posted. The panel decided **must-fix** and the aggregate is on the PR.

Panel round 5 for endojs/endo-but-for-bots PR #1084 (`docs: Design adaptive exo-stream pacing and buffer control`) ran in single-round mode and completed.

**What I did:**
- Resolved the PR head (endojs/endo-but-for-bots @ `design/exo-stream-adaptive-pacing`) and got an isolated project worktree.
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <wt> 1084 059e18d07c...` (real merge-base SHA, since the PR bases on upstream `llm`). Eight design-panel seats fired: critic, skeptic, ergonomist, pedant → request-changes; copyeditor, novice → comment-only; decomplector → approve.
- Panel disposition: **must-fix**.
- Posted the aggregate to PR #1084. `--request-changes` is impossible on the bot's own PR (GitHub rejects it), so posted it as a `--comment` review with the must-fix disposition stated in the header. The authoritative stage signal is the marker below.

**Key blocking findings (must-fix):** em-dash-ban violations (12×, pedant); `beta` default asserted yet re-opened in Open Questions (skeptic); the `now()` clock-injection contract contradicts the closed descriptor key-set (critic); "settles/pins at BDP" prose contradicts the state-machine's growth guard (skeptic/critic).

**Follow-up:** the next gauntlet stage (fix-loop) owns remediation. This stage does not fix or un-draft.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1084-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 27 tokens (679805 cached reads)
- Output: 4495 tokens
- Cost: $0.9197155
- Wall-clock: 284s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
