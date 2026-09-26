The panel review is posted (review `5057063519`, COMMENTED with the must-fix body). This stage is complete — exactly one round, verdict posted, no fix/un-draft.

panel round 4 — endojs/endo-but-for-bots PR #1061 (`refactor(marshal): move public types to declarations`)

**What I did:**
- Resolved the PR head (endojs fork, branch `refactor/marshal-types-declaration-module`, base `master-8c402ee` = `8c402ee89`) and got an isolated project worktree at the PR head `923b23fd6`.
- Ran `panel.sh` in `GARDEN_PANEL_SINGLE_ROUND=1` mode against that worktree. It fanned the full code panel and returned disposition **must-fix**.
- Posted the aggregate verdict as a `gh pr review` on #1061. `--request-changes` is blocked by GitHub on a self-authored (bot) PR, so per `skills/panel-review` § fallback I posted `--comment` with a canonical **"Must-fix before merge"** heading the next-stage-owed heuristic keys on.

**Verdict:** must-fix. Two seats block; the large majority approve (faithful mechanical JSDoc→`.d.ts` migration, no runtime delta).
- **prover (must-fix):** `EncodingUnion` (`types.test-d.ts:24-103`) is still pinned only one-directionally (`expectAssignable` + narrow `@ts-expect-error`), not the bidirectional `Equal<...>` used for every other exported type; mutation-verified that adding a new union arm leaves `tsc` green. Fix: add an `Equal<EncodingUnion, …>` pin.
- **scribe (must-fix):** no completion-summary comment followed the round-3 fix push `923b23fd6`; issue comments still stop at the round-2 summary. Post a round-3 fix summary per `skills/pr-completion-summary-comment`.

**Follow-ups (for the fixer stage, not this stage):** address the two must-fix items above. Advisory-only notes (PartialComparison `NaN`→`number` widening; no c8 coverage report) are non-blocking.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-marshal-types-dts-refactor-build-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1172098 cached reads)
- Output: 8096 tokens
- Cost: $1.321965
- Wall-clock: 638s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
