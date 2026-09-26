Panel round 1 complete. Posting the verdict as a comment review (GitHub blocks `--request-changes` on the bot's own PR) with the must-fix disposition prominently stated.

Completion report:

## Panel round 1 — endojs/endo-but-for-bots PR #1016

**Disposition: must-fix**

What I did:
- Resolved the PR head (`endojs:design/ironhorse-rejection-handling`, base `llm`) and created an isolated project worktree of the head.
- Ran the design panel in single-round mode (`GARDEN_PANEL_SINGLE_ROUND=1`) against that worktree with the **real base SHA** `71e9fcf7d022ec6e891baff455af92b650128ec0` (from `gh api pulls/1016 --jq .base.sha`, per the base-normalization gotcha) rather than the bare branch name.
- Panel fanned 7 design seats and aggregated to disposition **must-fix**. Seat verdicts: critic approve; skeptic, ergonomist, pedant, novice request-changes; decomplector & copyeditor should-fix/comment-only.
- Posted the aggregate to the PR as a `gh pr review`. `--request-changes` was rejected by GitHub ("Can not request changes on your own pull request" — the bot authored PR #1016), so I posted it as a **comment review** whose body leads with `disposition: **must-fix**`. The fix stage reads the must-fix items from this review body regardless of the review's request-changes/comment state, and the gauntlet driver keys off the stage-result marker below (not the PR review state).

What changed: one panel review comment on PR #1016. No code or garden-repo changes; single-round panel does not fix or un-draft.

Key must-fix themes for the fixer: (1) pedant — pervasive em-dash use and non-ASCII arrow glyphs (`→`/`⇒`) in prose need conversion per em-dash-style / typist-friendly skills; (2) skeptic & decomplector — §2's recommendation to retire the always-on rejection-timeout safety net relies on an opt-in/on-demand panic mechanism, an inference gap the doc's own §2 argument undercuts; state the always-on-vs-opt-in coverage difference explicitly; (3) ergonomist — inconsistent attribution spec across the two debugger panels, and carry the "unwatched" (not "unhandled") vocabulary into Open Question 1; (4) novice — "Ironhorse", "Halt", and "XS" used undefined; (5) copyeditor — inconsistent coined-term spelling and undefined "TDZ"/"row" referents.

Follow-ups: none for this stage — the gauntlet driver advances to `endojs-endo-but-for-bots-pr1016-gauntlet-fix-1` on the must-fix marker.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1016-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (670078 cached reads)
- Output: 4916 tokens
- Cost: $0.9367089999999998
- Wall-clock: 381s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
