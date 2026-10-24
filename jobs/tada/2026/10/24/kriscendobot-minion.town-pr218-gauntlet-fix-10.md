I applied the round 9 panel's must-fix items to kriscendobot/minion.town PR #218 (head `split/pr216-ledger`) and pushed. CI is green on the new head `036a8477`. One must-fix needs a maintainer decision, so I escalated it instead of fixing it.

**Source:** there was no pre-pass block, so I worked from the latest panel verdict, comment review 5636498274 (round 9, "Must-fix before merge").

**Commits pushed** (with `safe-push-pr-head.sh`, adding to the head from `4b2707eb`):
- **`e262aeec` fix(accounts): return both store facets from either backend.**
  - `buildAccountStore` in `src/http.ts` now returns `{ accountStore, guestBondAdmin }` for both the in-memory and DynamoDB backends. This covers curator 2 (should-fix).
  - The `GuestBondAdmin` JSDoc names guest account deletion (#220) as the facet's consumer. The `makeDynamoAccountStore` JSDoc notes its breaking return-shape change. This covers curator 1 and decomplector 1 (must-fix).
- **`036a8477` docs(accounts): say why the bond ledger is not a secondary index.** This is a new paragraph in design § 2, covering decomplector 2 (must-fix):
  - A secondary index on the fingerprint can only be read eventually consistently, so a close could miss a bond committed just before it.
  - An index also gives the bond's transaction no item to check the closed flag on.
  - A consistent `Scan` would read the whole table on every deletion and would give the serving role `Scan` over account rows.

**PR body and comments:**
- The PR body has two new sections: "Consumer and surface changes" (#220 is the consumer; the factory's return shape is a breaking change) and "Maintainer decision needed" (the IAM widening).
- I posted a follow-up summary comment: https://github.com/kriscendobot/minion.town/pull/218#issuecomment-6379177298

**Escalated:** decomplector 3 asks for maintainer confirmation of the wider app-role grants: two attribute-restricted `UpdateItem` grants, plus `Query` and `DeleteItem` on the ledger partition. I sent this to the maintainer inbox (msg-kriscendobot-minion.town-pr218-gauntlet-fix-10-325da0fa0abf). My first send failed because I passed the text as a file path; the second, through stdin, was delivered. The PR stays draft until a maintainer answers.

**Not done (should-fix, design-level):** I didn't change the code for these. They're listed in the follow-up comment for the next round or #220:
- Saboteur and breaker both found that after a key rotation, the leftover `key-version` row blocks every close, for all guests.
- A rotated key reopens closed guests.
- A rollback leaves the reconciled marker stale.
- `bondGuest` errors are mapped differently, and `GuestBondsClosedError` has no HTTP mapping.
- The pruner's prose cuts.

**Checks:** `tsc --noEmit` passes, the account, deploy-accounts-store and endo-guest-http tests pass (106), and the pre-push gates passed. `ci-wait-merge` returned rc 0 (green); this host's token can't read the full check rollup, so that result comes from the one Actions run.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr218-gauntlet-fix-10.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1430587 cached reads)
- Output: 11952 tokens
- Cost: $1.0734614
- Wall-clock: 1189s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
