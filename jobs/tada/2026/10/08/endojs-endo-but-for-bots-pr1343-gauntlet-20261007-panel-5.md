**Panel round 5: endojs/endo-but-for-bots PR #1343 — must-fix**

**What I did**
- I made an isolated checkout of the PR head (`kriscendobot/endo-but-for-bots`, branch `issue982-build-special-names`, commit `12f5331c5`).
- I ran `panel.sh` in single-round mode against the PR's base commit `5feadaeac` (the PR's `baseRefOid`), not the moving base branch. It exited 0 with the disposition `must-fix`. All 34 seats returned `ok`, and the decider's stderr was empty. The run was recorded at `panel-runs/kriscendobot-endo-but-for-bots-1343/099d3dadb46a.md`.
- I posted the full aggregate as a two-part `gh pr review` (reviews 5451077538 and 5451077657). They post as COMMENTED because this is the bot's own PR, which matches rounds 2–4.

**Verdict:** 5 of 34 seats requested changes: curator, breaker, purist, integrator and changeset-auditor. All other seats approve or are comment-only. The main must-fix items:
- **integrator:** the PR description says `@endo/cli` gets a `patch` bump, but the changeset at head says `minor`. The body was not updated after commit `12f5331c5`.
- **integrator:** two fixup commits should be folded into the commits they fix (`5f0311ed8` into `aa1aaa9cc`, `12f5331c5` into `166b9f15b`).
- **curator:** the changeset and type-coverage notes on `introducedNames` and `GuestFormula.specialNames`.
- **breaker, purist, changeset-auditor:** the remaining findings are in the posted review.
- **typist (comment-only, should-fix):** `resolveSpecialEndowment` returns `Promise<string>` where the branded `FormulaIdentifier` is expected, which is likely to fail `lint:types`.

I did not fix anything or un-draft the PR; this stage only runs the review.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1343-gauntlet-20261007-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (919459 cached reads)
- Output: 4470 tokens
- Cost: $0.6995157999999999
- Wall-clock: 341s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
