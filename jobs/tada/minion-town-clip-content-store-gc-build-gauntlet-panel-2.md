The review is posted. The panel round 2 disposition is **must-fix**, verdict recorded on PR #93.

## Completion report

Ran gauntlet stage **panel round 2** for kriscendobot/minion.town PR #93 (`feat(gateway): collect orphaned clip content`).

**What I did:**
- Resolved the PR head (`kriscendobot:feat/clip-content-store-gc`) and base (`main-b83741a` → SHA `b83741a3543cc598cdd7fe513243c35df24ba5db`), got an isolated project worktree, and confirmed the diff scope (23 files, +1806/−50, coherent GC feature).
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <wt> 93 <base-sha>`. All 30+ seats fanned and aggregated; the terminal disposition was **must-fix**.
- Posted the aggregate verdict as a `gh pr review` on PR #93. Note: `--request-changes` is rejected by GitHub on a self-authored PR (the bot owns the PR), so I posted it as a `--comment` review with the disposition (`must-fix`) stated explicitly at the top; the deterministic gauntlet signal is the stage-result marker below.

**Key findings driving must-fix** (full per-seat detail in the panel run dir):
1. `unpublish` "safely retried on a later unpublish" comment is false — deregister-before-cleanup ordering permanently leaks the guest `clip-*` pet name on a transient CapTP failure (cross-confirmed by 4 seats).
2. `primaryWorkerName`'s `catch (e instanceof Error)` narrowing contradicts its documented "any rejection → MAIN" contract; non-Error CapTP rejections rethrow.
3. Design doc § B.10 still says Part B is "not yet implemented" — contradicts the shipped code.
4. **Integrator duplicate-strand hazard**: #93 near-duplicates open draft #92, and #83 attacks the same gap — a maintainer decision to pick one strand and close/rebase the others.

Plus should-fix items: excision race/strictness asymmetry, cross-tenant GC blast radius, write-then-register grace-interlock gap, triplicated vhost predicate, missing PR summary comment, DEPLOYMENT.md durability leaks, and a U+2192 code-point.

**Follow-ups for later stages:** the fix-loop stage owns items 1–3 and 5–11; item 4 (the #92/#93/#83 duplication) is a maintainer disposition and should be surfaced to the maintainer, since it cannot be resolved by a code fix within this PR.

I stopped after posting the verdict — did not fix, un-draft, or loop, per the single-round contract.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-clip-content-store-gc-build-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1127719 cached reads)
- Output: 10439 tokens
- Cost: $1.6398185000000005
- Wall-clock: 683s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
