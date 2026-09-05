Panel round 4 complete. Verdict posted to the PR.

## Completion report

**Job:** endojs-endo-but-for-bots-pr1157-gauntlet-panel-4 (PANEL stage, round 4)

Re-derived state from a clean requeue: PR #1157 (`docs: design indelible registry in every guest inventory`, head `design/npm-registry-indelible-guest-inventory`, base `llm`) is an OPEN draft. Journal showed clean + fix-1/2/3 + panel-1/2/3 all in `tada/`; panel rounds 1–3 had posted must-fix reviews, and no panel-4 review existed yet — so this round was genuinely unrun.

What I did:
- Created an isolated project worktree of the PR head (`c30031a43`).
- Fetched and confirmed the base SHA `e84a4c83c049…` (the same base rounds 2/3 used).
- Ran `panel.sh` in `GARDEN_PANEL_SINGLE_ROUND=1` mode. All 8 seats (critic, skeptic, decomplector, ergonomist, novice, pedant, copyeditor, orthographer) completed cleanly. Terminal disposition: **must-fix**.
- Posted the aggregate as a `gh pr review` on #1157. Request-changes was rejected (bot can't request-changes on its own PR, as in prior rounds), so posted as a **COMMENTED** review — same shape rounds 1–3 used, carrying the explicit `disposition: must-fix` header the next-stage heuristic reads.

Outstanding findings driving must-fix (design-level, for the next fix stage): unstated fresh-guest↔migrated-guest formula-convergence mechanism; Goal 4 over-claims a sibling design's tree contract; migration failure-isolation granularity unstated; aggregate-exposure bound is prose not a tracked obligation; plus two orthography summary-fixes (`cancelled`→`canceled` L336, `cancelling`→`canceling` L354).

Stopped here per single-round contract — no fix, no un-draft, no loop.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1157-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 30 tokens (687557 cached reads)
- Output: 5084 tokens
- Cost: $0.9229865
- Wall-clock: 436s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
