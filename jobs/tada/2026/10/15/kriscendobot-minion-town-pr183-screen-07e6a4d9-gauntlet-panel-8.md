I ran panel round 8 for minion.town PR #183, and the verdict is **must-fix**. I did not post a new review because an earlier claimant of this same job had already posted the round-8 verdict on the current head.

- **Checkout:** I used an isolated checkout of `kriscendobot/minion.town` branch `build/inference-phase3-secrets` at head `3b4ce5c` ("fix(claude): address panel round 17 findings"), compared against base `main-bc11010`.
- **Panel run:** `GARDEN_PANEL_SINGLE_ROUND=1 scripts/jobs/gardening/panel.sh <wt> 183 origin/main-bc11010` exited 0 with disposition `must-fix`. It found a stored record of the previous claimant's panel run on this head (record `4736a8178352`) and reused it, so the 34 seats were not run again.
- **Review:** Review 5536165490 ("Panel verdict — gauntlet …, panel iteration 8: **must-fix**") was posted at 2026-10-15T16:06:01Z on commit `3b4ce5c`, which is still the PR head. It matches the aggregate in `$GARDEN_PANEL_RUNDIR/round-1.md`, so posting it again would only have duplicated it. It was posted as a comment review, like earlier rounds on this PR, not a request-changes review.
- **What the panel found:**
  - Seven seats asked for changes: archivist, saboteur, breaker, purist, integrator, pruner and decomplector. Sixteen were comment-only and eleven approved.
  - The pre-check of phases and evidence is blocked by `missing-design:designs/claude-agents-capability.md`, which forces the verdict to must-fix.
  - Three files keep drawing must-fix findings across heads: `secrets-credential-vault.ts`, `types.ts` and `vendor-endo-claude.sh`.
  - Main findings:
    - The comments in `credentials.ts` contradict each other about where production stores the credential.
    - The token can leak into error and log messages when migration or `createBlob` fails.
    - The breaker seat also flagged that a rejecting `mintInferExo()` escapes `makeRootAuthoredInfer` in its round-7 review on `fb68d7f`; it isn't among this round's 20 itemised findings.

Following the stage rules, I made no fixes, did not un-draft the PR, and made no garden changes. The gauntlet driver will take it from here into the fix loop.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr183-screen-07e6a4d9-gauntlet-panel-8.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 46 tokens (1115883 cached reads)
- Output: 7803 tokens
- Cost: $1.1496445999999998
- Wall-clock: 525s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
