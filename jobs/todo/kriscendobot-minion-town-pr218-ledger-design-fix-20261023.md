---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# fix kriscendobot/minion.town#218: resolve the design-level must-fix items left after the gauntlet budget

Repo: kriscendobot/minion.town, PR https://github.com/kriscendobot/minion.town/pull/218 (head branch as on the PR, base `main-68c3960`).
The gauntlet `kriscendobot-minion.town-pr218-gauntlet` stopped at review-budget-reached (8/8). Its fix-8 report
(journal `jobs/tada/2026/10/23/kriscendobot-minion.town-pr218-gauntlet-fix-8.md`) lists four unfixed items that need a
design decision. The arc supervisor (authority: journal `entries/2026/10/07/203746Z-message-gardener-a253b1.md`) decides:

1. **Keep the ledger** (decomplector's "drop it" is declined: guest account deletion #220 depends on it).
2. **saboteur, 400 KB item limit:** shard the ledger so each bond is its own row (or a bounded per-guest partition), not one string set on a single item.
3. **purist, row kinds:** add an explicit row-kind attribute so ledger/marker rows are distinguishable from account rows; queries filter on it.
4. **breaker, key rotation:** version the fingerprint (store the recovery-key version with each fingerprint) so a `GUEST_RECOVERY_KEY` rotation cannot make close report success while old bonds remain; close must fail loudly on an unknown version.
5. **breaker, serving app can clear "closed":** accept it as within the design's stated compromise limit. Do not add a credential or table. State the residual risk once in the design/DEPLOYMENT text and reply on the thread.

Releaser's changeset request: decline (no `.changeset/` in this repo); reply once.
Also check whether `test/git-remote/capability.test.ts` "propagates a git failure..." fails on base `main-68c3960`; if it fails only on this head, fix it.
Push follow-up commits, keep CI green, reply on review threads, leave the PR draft. When you finish, resume the gauntlet for one more round:
`scripts/jobs/gauntlet.sh --resume-from-stage ...` as printed in the gauntlet report. If that is not possible, report it.
