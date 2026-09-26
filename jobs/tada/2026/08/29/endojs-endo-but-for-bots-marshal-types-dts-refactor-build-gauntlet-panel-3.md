The round-3 panel verdict is posted. Job complete.

---

**Completion report**

**Stage:** Gauntlet PANEL round 3 for `endojs/endo-but-for-bots` PR #1061 (`refactor(marshal): move public types to declarations`).

**What I did:**
1. Resolved the PR head (`endojs:refactor/marshal-types-declaration-module`, head `37200386`, base `master-8c402ee`) and obtained an isolated project worktree keyed to this job base.
2. Ran the panel in single-round mode (`GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <wt> 1061 master-8c402ee`). It fanned **29 code seats** and decided **must-fix** (exit 0 — a clean decision, not an error).
3. Synthesized the per-seat aggregate into a round-3 verdict and posted it as a `gh pr review --comment` on PR #1061 (posted as COMMENTED, not request-changes, because the PR author is `kriscendobot` and GitHub blocks self-review request-changes — matching rounds 1 and 2).

**Verdict:** must-fix. One seat (**prover**) returned request-changes; several corroborating should-fix items cluster on one theme — the round-2 tuple/object `expectType` pins in `types.test-d.ts` still do not redden under member-drop mutation (`expectType` is one-directional assignability), and this package's CI runs no real `tsd` CLI, so the header comment overclaims. Fix path: bidirectional `Equal<A,B>` idiom or wire an actual `tsd` step. Should-fix corroboration from breaker (widening not caught), corner-prober (missing negative/default-generic corners), and spec-keeper (now-vacuous `Exclude<PartialComparison, NaN>` cast in `rankOrder.js:333`). ~24 seats approve the port as faithful.

**Follow-ups:** none from this stage — the gauntlet's fix-loop stage owns the must-fix items. I did not fix, un-draft, or loop, per the single-stage contract.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-marshal-types-dts-refactor-build-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1298548 cached reads)
- Output: 12052 tokens
- Cost: $1.59663
- Wall-clock: 862s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
