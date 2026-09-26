The panel round-4 verdict is posted. Verification confirms a fresh COMMENTED review from kriscendobot at 2026-09-04T21:48:30Z.

---

## Completion report

**Job:** Gauntlet PANEL stage, round 4 — endojs/endo-but-for-bots PR #695 (`design(sturdy-refs): agent provide/accept surface`).

**What I did:**
1. Resolved the PR head (`endojs:design/sturdy-refs-agent-surface`, base `llm` @ `7746c21f9cf32ab2060dbcace8bcea3fee146725`) and provisioned an isolated project worktree keyed to this job base.
2. Ran the design panel in single-round mode (`GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <wt> 695 <base-sha>`). It fanned 8 seats (critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice), aggregated, and printed disposition: **must-fix**.
3. Posted the aggregate as a `gh pr review` on PR #695. Because the PR is self-authored by the bot identity (`kriscendobot`), GitHub only permits COMMENT reviews — so it went up as a COMMENTED review carrying the must-fix disposition in its header (`## Design panel — round 4 (must-fix)`), mirroring the round-3 shape the next-stage-owed heuristic recognizes.

**Panel outcome (must-fix highlights):**
- **critic:** Phase 2's confined-facet stripping of `lookupByLocator` conflicts with the shipped mail-attachment mechanism (which delivers locators to confined guests); design must reconcile before Phase 2 is implementable.
- **skeptic:** the "single-turn" render-map boundary has no named turn-clear event in the actual long-lived agent loop (`inbox-loop.js`), silently producing the un-investigated cross-turn retention the design defers.
- **decomplector/ergonomist/pedant:** handle sub-sigil left as an "e.g." rather than pinned; two hand-written regexes across packages with no shared tested constant; nine em-dash violations of the no-em-dash rule.

**Scope note:** This stage ran exactly one panel round, posted the verdict, and stopped — no fix, no un-draft, no loop, per the staged-gauntlet contract.

**Follow-ups:** The gauntlet supervisor owns the next stage (fix loop) given the must-fix disposition; nothing further owed from this stage.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr695-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (833149 cached reads)
- Output: 5715 tokens
- Cost: $1.0889775000000002
- Wall-clock: 318s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
