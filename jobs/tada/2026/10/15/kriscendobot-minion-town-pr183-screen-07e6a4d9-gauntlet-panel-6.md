I ran panel round 6 on kriscendobot/minion.town PR #183. `panel.sh` exited 0 with a **must-fix** verdict, and I posted it to the PR as a COMMENTED review.

**What I did**
- **Checkout:** made an isolated checkout of the PR head (`kriscendobot/minion.town` `build/inference-phase3-secrets`, head `e376aae2b520bdd3fc54c4cd9134f0869049433d`) in `scratch/project-wt-kriscen-8fc7958d43ad-50ebdcbf`.
- **Panel run:** ran `GARDEN_PANEL_SINGLE_ROUND=1 scripts/jobs/gardening/panel.sh <wt> 183 origin/main-bc11010` against frozen base `main-bc11010` (`bc110102b6`). My first start was stopped on purpose before it finished because its 10-minute background limit might have killed it. The rerun finished with rc=0, and its last line was `code-panel single-round — must-fix`.
  - The decomplector was given its "is it needed?" question because the same mechanism had come back must-fix again.
  - All 34 seats returned:
    - **request-changes (7):** archivist, migrator, purist, wire-watcher, integrator, pruner, decomplector
    - **approve (9)**
    - **comment-only (18)**
- **Review:** posted to the PR as https://github.com/kriscendobot/minion.town/pull/183#pullrequestreview-5531097168. It has the same "Panel verdict — round 16 … **must-fix**" layout the earlier rounds used. The request-changes seats are in full, and the others are included until the size limit. 17 seats were left out for length, listed at the end of the review.
  - GitHub refused a request-changes review because the bot opened this PR itself, so it went up as COMMENTED, as round 15 did.
  - The fleet's `gh` wrapper blocked two plain `#183` mentions because the review also names `endojs/endo-but-for-bots`. I changed both to `kriscendobot/minion.town#183`.
- I made no changes to the garden repo or the PR branch.

**Findings to note for the fix stage**
- **archivist:** the `WHERE IT LIVES` paragraph in `credential-vault.ts` is now wrong, because the live store is `@secrets`.
- **migrator:** the move from the old vault to `@secrets` is one-way, and nothing documents what happens on rollback. Facet `infer` also now returns `needs-containment` with no type error to warn callers, and the PR doesn't say that this breaks existing behavior.
- **decomplector:** for the third round running, it says the refusal exists in two places (an optional `refuse` method on `ClaudeProvider` plus a refusing exo that production never reaches) and nobody has addressed it.

Run artifacts are in `/Users/dom/garden/scratch/panel-run-pr183-r6/` (`round-1.md` is the full aggregate, `review-body.md` is what was posted).

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr183-screen-07e6a4d9-gauntlet-panel-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1218519 cached reads)
- Output: 7059 tokens
- Cost: $0.9528918000000001
- Wall-clock: 1529s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
