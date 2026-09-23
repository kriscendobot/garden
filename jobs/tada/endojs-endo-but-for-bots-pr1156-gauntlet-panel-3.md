Round 3 panel review posted. The stage is complete.

## Completion report

**Job:** Gauntlet PANEL round 3 for endojs/endo-but-for-bots PR #1156 (`docs(pass-style): design a Node-condition-gated reified-symbol variant`).

**Re-derived state on clean start:** PR #1156 is OPEN, non-draft, head `endojs:design-pass-style-symbol-condition`, base `llm`. Rounds 1 (2026-09-04) and 2 (2026-09-05) were already posted as COMMENTED panel reviews, both must-fix. No round-3 review existed yet, so I ran it.

**What I did:**
- Set up an isolated project worktree of the PR head.
- Ran the single-round design panel (`GARDEN_PANEL_SINGLE_ROUND=1 panel.sh`) against the head, passing the real base merge-base SHA `e84a4c83c04...` (not the bare `llm` branch, per the upstream-base normalization caveat). Panel disposition: **must-fix**.
- Posted the aggregate as a `gh pr review` on #1156. `--request-changes` is rejected on our own bot-authored PR ("Can not request changes on your own pull request"), so — matching rounds 1 and 2 — I posted it as a **COMMENTED** review titled "Design panel — round 3 (must-fix)". Verified it landed (submitted 2026-09-05T18:23:23Z).

**Panel findings (still must-fix):** critic flags the cross-package type-resolution claim (consumer `customConditions` cannot re-select a dependency's already-emitted `.d.ts`) and a mis-cited `hardenIsNoop` precedent; skeptic flags an incomplete `passableSymbolForName` call-site count (missing the two `marshal-justin.js` sites) plus test-catalog gaps.

**Stop point:** Per stage contract, I ran exactly one panel round, posted the verdict, and stopped — no fix, no un-draft, no loop.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1156-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s)
- Input: 26 tokens (560628 cached reads)
- Output: 3778 tokens
- Cost: $0.787219
- Wall-clock: 470s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
