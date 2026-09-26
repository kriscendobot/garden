The review is posted. The panel stage is complete.

## Completion report

**Job:** Gauntlet PANEL round 1 for endojs/endo-but-for-bots PR #1013 (`design: relative routing for CapTP/OCapN locator hints`).

**What I did:**
- Resolved the PR head (endojs/endo-but-for-bots, branch `design/relative-routing`) and obtained an isolated project worktree.
- Confirmed the base is a clean merge-base (`eb6da1602`); the diff is a design-doc PR: new `designs/relative-routing.md` (+342) and a `designs/README.md` index update.
- Ran `panel.sh` in `GARDEN_PANEL_SINGLE_ROUND=1` mode against the worktree. Two prior attempts were reaped because the non-loop gardener process was torn down whenever I yielded the turn to a background wait; this attempt I kept the turn alive with a foreground block-poll until the process exited. The design panel fanned 7 seats (copyeditor, critic, decomplector, ergonomist, novice, pedant, skeptic).
- **Disposition: must-fix.** All 7 seats returned `request-changes`.

**Notable findings (must-fix):**
- Leaked tool-call markup `</content>` / `</invoke>` committed at the file tail (lines 341–342).
- Em-dashes and Unicode ellipsis `…` in prose (project style rules: `em-dash-style`, `typist-friendly-code-points`).
- Design self-contradiction: case 6 (gateway-relayed introduction) is unreachable under the design's own `selectRoutes` scope-filter rule; case 5 needs a two-tag scope the single-`scope` encoding can't express; `LocalScope.tags` asserts an "innermost-first" order no operation consumes (duplicated by a separate `costOf` table); `makeLocalScope` constructor never specified.

**What changed:** Posted the aggregated 7-seat verdict to PR #1013. `gh pr review --request-changes` is rejected on the bot's own PR, so I posted it as a `--comment` review (state `COMMENTED`, author kriscendobot) whose body states the must-fix disposition explicitly. The gauntlet driver transitions on the stage-result marker below, not the review state.

**Follow-ups:** Next gauntlet stage (fix) is owed on this must-fix verdict. Several seats proposed a standing pre-land lint for leaked `</invoke>`/`</content>` artifacts in AI-authored design docs — worth considering as a garden pre-push gate, but out of scope for this stage.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1013-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 68 tokens (1926467 cached reads)
- Output: 14592 tokens
- Cost: $2.4134835
- Wall-clock: 580s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
