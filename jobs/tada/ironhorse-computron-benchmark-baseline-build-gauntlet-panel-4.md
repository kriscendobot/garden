Verdict posted. Panel round 4 complete.

## Completion report

**Job:** Panel stage, round 4, of the `ironhorse-computron-benchmark-baseline-build-gauntlet` against endojs/endo-but-for-bots **PR #1283** (`design(ironhorse): benchmark-established computron baseline regime`, draft, base `llm`).

**What I did:**
1. Resolved the PR head (endojs/endo-but-for-bots, branch `design/ironhorse-computron-benchmark-baseline`) and base SHA `65902a8f8c2e5f198d479ff0d9a77eb25a7c36d3`.
2. Got an isolated project worktree keyed to this job's base.
3. Ran `panel.sh` in `GARDEN_PANEL_SINGLE_ROUND=1` mode. It **exited 0** (genuine verdict), all 8 seats returned `ok` (critic, skeptic, decomplector, ergonomist, novice, orthographer, pedant, copyeditor), decider clean. `record-meta`: `disposition=must-fix, exit_code=0`.
4. Posted the aggregate as a `gh pr review` on #1283. Request-changes was rejected by GitHub (`Can not request changes on your own pull request` — the PR is bot-authored), so I posted it as a **COMMENTED** review carrying `disposition: **must-fix**` in the header, matching the convention of rounds 1–3 on this same PR.

**Disposition:** must-fix. Headline seat findings (should be addressed by a following fix stage): gate-3 fidelity band per-record vs. roster-aggregate cardinality ambiguity (critic); frozen absolute-median cross-host comparison violating the sibling `benches/README.md` "not comparable across machines" rule (skeptic); a `collection_find`-attribution misclaim for named-property insertion (skeptic); scoped-determinism keyed by `label` alone (decomplector); provenance-tag vs. structural-nesting left undecided (decomplector); plus ergonomist/novice/pedant terminology/vocabulary/list-parallelism fixes. Orthographer approved (no British spellings).

**Stopped here** per single-round mandate — no fix, no un-draft, no loop.

**Follow-ups:** the gauntlet driver owns re-dispatch of the fix stage on this must-fix.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-computron-benchmark-baseline-build-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (757932 cached reads)
- Output: 5605 tokens
- Cost: $1.009555
- Wall-clock: 391s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
