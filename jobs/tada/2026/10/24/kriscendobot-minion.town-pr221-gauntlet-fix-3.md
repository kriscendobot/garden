Fix round 3 is done for kriscendobot/minion.town#221 ("design: recursively attenuated DynamoDB capabilities"). The fix commit `2e8f3018` was pushed to the PR head, and CI finished green (`ci-wait-merge` rc 0, 3 of 3 checks, 0 failed). No checks beyond CI were run on the doc.

**Input:** The job had no pre-pass block, so I worked from the latest panel verdict, review 5636807076 (posted against `d65ac219`). It had 9 must-fix items from six jurors (critic, skeptic, decomplector, ergonomist, copyeditor, novice). I also applied the three should-fix items. Only `designs/recursive-dynamodb-capabilities.md` changed.

**What changed in the doc:**
- **critic: `update` couldn't check the guard on the item as it would be after the write.** Writes are now compiled per guard term:
  - A field the patch sets or removes is checked before the call to AWS (`send()`).
  - A field the patch leaves alone has its guard term added to the DynamoDB condition, so it is checked atomically in one call. This also holds when the update creates the item.
  - A numeric add or set-add/delete on a guarded field is rejected as `invalid-request`.
  - `delete` puts the whole guard into its condition.
  - There is no read-then-write step.
- **critic + skeptic: the index backfill could lose live writes.** The single backfill is replaced by four phases, each verified before the next starts:
  1. The old adapter starts writing `queue`, `due` and the promoted attributes on every write.
  2. The backfill writes only where `attribute_not_exists(queue)`, so it can't overwrite a newer write.
  3. A convergence check compares `Scan` results with the index until two passes agree.
  4. Readers cut over to the index.

  A race test is added, and follow-up 3 now lands phase 1 in its own PR first.
- **skeptic: guard order vs projection was inconsistent.** Every grant's guard and key space are now checked on the item before any fields are hidden, then the item is trimmed once. A child's guard may only name fields its parent can read, so a guard can't reveal hidden values.
- **decomplector: two layers owned durable grants.** A supervisor-owned `GrantStore` port (`record`/`tombstone`) is now the single owner of recipes and tombstones. The broker only asks it to commit and waits for acknowledgment; it keeps nothing durable itself. The ownership map has a new row for this, and named grants are always roots.
- **ergonomist (two items):**
  - Facet methods never reject. A new `settle()` helper turns a CapTP disconnect into a retryable `unavailable` result, and the coupon wrapper uses it.
  - A new `cursor-invalid` result covers expired, stale, foreign and forged cursors. Each result type now names its recovery action.
- **novice: how the host learns a child's grant id.** The doc now traces who holds each id. The deriver keeps it; the host revokes a subtree through its own ancestor grant, and can also get a child's id if the caplet reports it or from the audit trail.
- **copyeditor (two items):** exo and CapTP are defined at first use. The `queue` query wording now says it does not name the base table's `pk`.
- **Should-fix items:**
  - The recount's "as it does today" was wrong: `guest-coupons.md` §12 defers the recount, so it is now stated as new required behavior with a version check.
  - Grant recipes now record a table-identity digest, and a mismatch on restart fails closed.
  - Section 9 has new tests for guards, the never-reject contract, cursors, and the grant store.

No follow-ups from this stage; the driver posts panel-4.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr221-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1453019 cached reads)
- Output: 19881 tokens
- Cost: $1.3742478
- Wall-clock: 588s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
