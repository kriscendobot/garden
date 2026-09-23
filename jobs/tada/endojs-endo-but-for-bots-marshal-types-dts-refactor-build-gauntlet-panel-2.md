The review posted (04:08:52Z, COMMENTED, this round's verdict). Stage complete.

## Completion report

**Job:** Gauntlet PANEL round 2 for endojs/endo-but-for-bots PR #1061 (`refactor(marshal): move public types to declarations`).

**What I did:**
1. Resolved the PR head (`endojs:refactor/marshal-types-declaration-module`, base `master-8c402ee`, head `67bafbe0`) and set up an isolated project worktree keyed to this job's base.
2. Ran the panel in single-round mode (`GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <worktree> 1061 master-8c402ee`). All 29 seats returned cleanly (`ok`); the panel's aggregate decider returned **must-fix**.
3. Composed a faithful panel-verdict body from the run-dir aggregate (`round-1.md`) and posted it to PR #1061. A `--request-changes` review was rejected (bot is the PR author — "cannot request changes on your own pull request"), so I posted it as a **comment review** with an explicit `Disposition: must-fix` header, the same shape the panel uses for self-authored PRs.

**Verdict:** must-fix. Blocking findings: (1) prover — new function-shaped `expectType` pins don't pin parameter arity (mutation-verified on `ConvertSlotToVal`/`ToCapData`); (2) `EncodingUnion` coverage is a 6-of-11 subset, `hilbert`/`NaN`/etc. unpinned (mutation-verified silent-drop); (3) integrator — misleading `(#475)` baked into the first commit title. Should-fix: nonexistent-`spell-out-exempt` markers, and a missing completion-summary comment after the round-1 push. Comment-only: minor tsd corner gaps, changeset consensus (none needed), unverifiable c8 coverage.

**Review posted:** kriscendobot COMMENTED at 2026-08-29T04:08:52Z on PR #1061.

**Follow-ups:** none from this stage — I did not fix, loop, or un-draft (single-round contract). The gauntlet's next stage (fixer) owns the must-fix items.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-marshal-types-dts-refactor-build-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1027113 cached reads)
- Output: 7564 tokens
- Cost: $1.3780675
- Wall-clock: 511s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
