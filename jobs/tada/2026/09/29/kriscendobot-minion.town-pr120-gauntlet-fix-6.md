**Gauntlet fix round 6 on kriscendobot/minion.town#120: one code must-fix pushed and CI is green. The other must-fix can't be closed from this branch, so the PR stays draft.**

**Round-6 panel review (request-changes, 2 must-fix items):**
1. **Phase/evidence gate (integrator):** no code change on this branch can clear it. It needs endojs/endo-but-for-bots#1015 to merge and the production-sequence canaries to run against a live deploy. I left the PR in **draft**. The panel says every later round will keep returning must-fix until those steps land. This is the sixth round in a row blocked on this gate.
2. **`iface` abbreviation (stylist):** fixed in commit `fef901e`. The parameter is now `interfaceTag` in `guardedFar` (`guards.ts`), the `Far` seams in `agents.ts` and `wiring.ts`, and `test/claude-delegation.test.ts`. I left the older `site-registry-exo.ts`, which predates this PR, unchanged.

**Should-fix item also done:** I shortened the two over-long comments the pruner seat flagged. The delegation comment in `wiring.ts` is now four lines that point to the design doc, and the load-order comment in `guards.ts` is one line.

**Checks:**
- `tsc --noEmit` is clean and the full `vitest run` passes (521 passed, 7 skipped).
- I pushed with `safe-push-pr-head.sh`, moving the head from `4222c44` to `fef901e`.
- `ci-wait-merge.sh --no-merge` returned rc 0: all 3 checks green.

**PR comment:** I posted a summary comment (issuecomment-5883316824) that maps round 6's fixes to `fef901e`. It also backfills the summary the scribe seat has asked for over five rounds: round 1's items were closed by `fd52dca`, and round 3's items 2–5 by `5cd384a` and `eaebbf9`. That comment says CI was still pending, because I posted it before the CI result came in.

**Not done this round (should-fix or comment-only, listed in the PR comment):**
- A repeat `delegate`/`create` should return the same object each time.
- A repeat `delegate` silently ignores changed options.
- A `revoke` that faults can leave an orphaned grant hidden from `listDelegations()`.
- Dismissing a child doesn't immediately make its descendants inert.
- Inert handles disagree on results (`create` says `needs-auth`, `infer` says `unavailable`).
- The `passable` wrapper is duplicated.
- Missing tests for concurrent same-label `delegate()` and a zero-size pool.
- Before un-draft: fix the title and regroup the commits.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr120-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (725961 cached reads)
- Output: 5159 tokens
- Cost: $0.7093802
- Wall-clock: 312s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
