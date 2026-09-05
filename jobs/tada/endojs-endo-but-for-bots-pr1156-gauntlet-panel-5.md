Review posted and verified. Panel round 5 complete.

## Completion report

**Job:** Gauntlet PANEL round 5 for endojs/endo-but-for-bots PR #1156 (`docs(pass-style): design a Node-condition-gated reified-symbol variant`).

**What I did:**
1. Resolved the PR head (endojs/endo-but-for-bots @ `design-pass-style-symbol-condition`, base `llm`) and set up an isolated project worktree keyed to this job.
2. Ran the panel in single-round mode (`GARDEN_PANEL_SINGLE_ROUND=1`) against the worktree with the real base merge-base SHA `e84a4c83c049f1b113436c0fcceddfb5be9be9a4`.
3. Panel disposition: **must-fix**. Nine seats reported (design-panel set): critic and skeptic request-changes with substantive findings (unscheduled syrup-layer break in Rollout; an in-tree property-key counterexample in `@endo/far`; two ungrepped `nameForPassableSymbol` reader-side consumers in `workflow` and `patterns` that falsify the "transitive swap" exhaustiveness claim; an eighth `passableSymbolForName` call site in marshal test data). ergonomist request-changes (four vocabularies for one axis; bare-string world query vs. predicate idiom). decomplector/copyeditor/pedant/novice comment-only (test-file split recommendation; voice/tense/grammar nits; **16 em-dash violations** flagged must-fix by the pedant per `skills/em-dash-style`). orthographer approve.
4. Posted the aggregate to PR #1156. The bot authored the PR, so GitHub rejected a `--request-changes` review ("Can not request changes on your own pull request"); posted as a `--comment` review with an explicit `must-fix` disposition header instead (standard garden fallback). Verified it attached as author `kriscendobot`, state `COMMENTED`.

**Stopped here** as instructed — no fix, no un-draft, no loop.

**Follow-ups:** The next gauntlet stage (fix-loop) owns the must-fix remediation; the most actionable items are the em-dash cleanup (called out as uncaught across four prior rounds), the reader-side grep gap (`nameForPassableSymbol` consumers in `workflow`/`patterns`), and the Rollout syrup-break scheduling.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1156-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (620720 cached reads)
- Output: 4417 tokens
- Cost: $0.897804
- Wall-clock: 419s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
