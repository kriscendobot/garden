I applied panel round 12's must-fix items to kriscendobot/minion.town #218 and pushed them as follow-up commit `ab7b627d` to `split/pr216-ledger`. CI is green on that head (4/4 checks).

**Must-fix items from panel review 5637124260:**
- **Archivist 1:** the design doc now says every row the store *creates* carries a `row_kind`. It also says that when `bondGuest` updates an older account row, it doesn't add one.
- **Integrator 1:** the design's reader-interface paragraph now lists `bondGuest` and `recoverGuest` on `AccountStore`, and names the separate `GuestBondAdmin` facet.
- **Decomplector 1:** I added a design paragraph explaining why bonds are erased at deletion rather than checked lazily at recovery time. Deleting an account (#220) has to remove every bond to the deleted guest when the deletion completes, and a lazy check gives a bond racing the deletion nothing to be refused by. This doesn't reopen the supervisor's earlier decision to keep the ledger in #218; it only adds the missing reasoning.

**Wording fixes I also made (should-fix, all about claims that didn't match the code):**
- **Archivist 2:** the `deploy-accounts-store.sh` comment now excludes the retired marker, which does survive a failed run.
- **Archivist 3:** the `accountKey` comment now mentions the `withTtlCache` cache and drops the wrong claim about stored outputs.
- **Archivist 4:** DEPLOYMENT.md step 2 now names the one-item `TransactWriteItems` probe.
- **Archivist 5:** the design's cost paragraph now names all the rows a bond writes.
- **Archivist 6:** `src/http.ts` has a note that `guestBondAdmin` is unused until the guest-deletion path lands.

Typecheck passed locally, and I posted a follow-up summary comment on the PR: https://github.com/kriscendobot/minion.town/pull/218#issuecomment-6381143905

**Deferred, as the supervisor directed for should-fix items:**
- **Breaker 1–2:** bond transactions that hit a write conflict aren't retried, and a key rotation blocks every later guest close.
- **Wire-watcher 1–3:** after a key rotation, a guest that was already closed can be bonded again. This one breaks a stated guarantee, so it's the most worth picking up next. The other two are rotation blocking closes and whether anything stops redeploying a pre-ledger app.
- **Typographic churn** (`→` to `->` and similar), plus the pruner and integrator requests to restructure prose.

I left the supervisor-acceptance sentence in the design even though the pruner asked to remove it, because the supervisor added it on purpose in the previous commit. Panel 13 may flag these items again.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr218-gauntlet-fix-12.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1501161 cached reads)
- Output: 8946 tokens
- Cost: $1.0713761999999998
- Wall-clock: 2235s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
