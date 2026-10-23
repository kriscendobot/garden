**Completion report: kriscendobot-minion.town-pr218-gauntlet-fix-8 (fix round 8, kriscendobot/minion.town#218)**

I fixed the mechanical findings from the round-8 panel. I did not fix four must-fix items, because each one needs a scope or design decision from the maintainer. CI is green on the new head.

The job had no pre-pass block, so I worked from the latest panel verdict, review 5634577892 on head `c93ffd7`. I pushed one follow-up commit, `b55257a9`, to `split/pr216-ledger` through `safe-push-pr-head.sh`. The push moved the head forward from `c93ffd76`.

**Fixed:**
- **locksmith and purist (shared facet):** `makeDynamoAccountStore` now returns two separate runtime objects, `{ accountStore, guestBondAdmin }`. `src/http.ts` keeps only `accountStore`, so serving code can no longer call `closeGuestBonds` or `unbondGuest`. The two test files merge both facets through a small `makeBothFacets` helper.
- **corner-prober:** the DynamoDB test model now keys rows by the `[iss, sub]` pair, not the space-joined string. A new adapter test bonds and closes `("a b", "c")` next to `("a", "b c")` and checks that each keeps its own row and ledger entry.
- **fast-checker:** added a property test with 200 runs. Distinct arbitrary `iss`/`sub` pairs each provision, bond and recover their own guest.
- **stylist:** renamed `id` to `formulaIdentifier` and `s` to `statement`.
- **pruner:** deleted the `runScript` JSDoc from the backfill test.

**Not fixed (explained in the PR follow-up comment, issuecomment-6375052794):**
- **decomplector (must-fix):** remove the guest-bond ledger, which no production code calls yet. Doing so would undo the PR's purpose, so it is the maintainer's call.
- **saboteur (must-fix):** one item holds every bond in a single string set, which can hit DynamoDB's 400 KB item limit. Bounding it means sharding the ledger.
- **breaker (must-fix):** the serving app's own permissions can clear the "guest closed" flag, so a compromised app could reopen a deleted guest's bonds. The design already accepts this as within its stated compromise limit, but the reviewer disagrees. Fixing it needs a separate credential or table.
- **breaker (should-fix):** replacing `GUEST_RECOVERY_KEY` changes every guest's fingerprint, so closing a guest would report success while its old bonds remain. Fixing it needs fingerprint versioning or a separate key.
- **purist (should-fix):** ledger and marker rows can't be told apart from account rows. Fixing it needs a row-kind field.
- **releaser:** asks for a changeset, but this repo has no `.changeset/` setup. The ordered rollout is documented in `DEPLOYMENT.md`.

**Checks:**
- `tsc --noEmit` passes.
- The four touched test files pass.
- The full `npm test` run had one failure, in `test/git-remote/capability.test.ts` ("propagates a git failure rather than reporting the ref absent"). This PR doesn't touch that area, but I did not confirm whether it also fails on the previous head.
- `ci-wait-merge.sh --no-merge` returned 0: all 4 checks green, none failed.

**Follow-up:** the next panel will probably raise the four unfixed must-fix items again, and the gauntlet already reported reaching its review budget after round 6. The maintainer needs to decide whether to keep the ledger (decomplector) and, if so, how to bound its size and protect the "closed" flag.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr218-gauntlet-fix-8.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1660506 cached reads)
- Output: 11167 tokens
- Cost: $1.2049372
- Wall-clock: 1127s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
