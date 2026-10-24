I applied the panel-6 must-fix items to PR #221, pushed them, and CI passed (`ci-wait-merge` rc 0, 3 checks, 0 failed).

**Source:** there was no pre-pass block, so I worked from the latest panel verdict, review 5636951987 on head 012ffb8d. All changes are in `designs/recursive-dynamodb-capabilities.md`, in one follow-up commit (`35bb0c3b`) pushed with `safe-push-pr-head.sh` (012ffb8d → 35bb0c3b).

**Must-fixes**
- **Decomplector, the `queue` index:** the design now says why an index is needed. The coupon table has no sort key, so a base-table `Query` returns at most one item and DynamoDB allows `begins_with` only on a sort key. Status-keyed items in the base table would still each need a `Scan`. Adding a sort key means recreating the table and copying every row. A sparse index is the smallest change that turns listing a family into a `Query`.
- **Decomplector and skeptic, the recount:** I replaced the recount that rewrote the counters with a daily counter audit that never writes.
  - The `POOL` counters are treated as authoritative, and the audit alerts on drift in either direction.
  - It reads `POOL` strongly consistently before and after counting and compares each count with the range between the two reads, so normal activity doesn't fail the audit.
  - The drift tolerance defaults to the larger of 1 and 1% of pool capacity, and can't be set below 1.
  - The design now states the index-lag assumption and that DynamoDB documents no upper bound. The audit uses the index's `WriteThrottleEvents` metric as the lag signal and reports "inconclusive" when throttling occurred.
  - Repair is manual: pause issuance and count with a `Scan` under the table-control role.
  - I removed the old version-increment rule and dropped `version` from `conditionFields`. The design notes that this changes guest-coupons § 4, and follow-up 2 updates that file.

**Should-fixes also applied**
- **Idempotency is now defined per method.** Only `transactWrite` takes an idempotency key, which becomes a `ClientRequestToken` of at most 36 characters. The token is built from the grant's lineage (its declaration name plus restriction digests), which stays the same across broker restarts, so a retry after a restart keeps its token. `put`, `update` and `delete` rely on the caller's own conditions.
- **Withdrawal window:** the declaration is still edited first. A new `control.listRoots` lets the supervisor reconcile on start and every 5 minutes, withdrawing any live grant the declaration no longer names. I added tests for this and for idempotency.
- **`derive`:** marked as left out of the first build in § 2 and § 6.3. § 10 now explains why a coupon-specific facet wasn't chosen instead of the generic package.
- **Revocation test:** the design now says what the test covers and that a revocation inside the SDK's asynchronous middleware is treated as prospective.
- **Copyedits:** "four phases" is now "five", the sibling-bucket sentence is narrowed to parents that have a bucket, the `withdraw` wording no longer contradicts itself, the validation sentence is reworded, "deriver-held cancellation" is now explained, two unclear antecedents are named, and "eventual-send" is spelled out.

**Not changed:** two comment-only items: the critic's `redeemedArchived` rolled-up counter and the skeptic's note that the bind sweep's read cost depends on pool capacity. Panel-7 will be posted by the driver.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr221-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (898045 cached reads)
- Output: 14080 tokens
- Cost: $1.161209
- Wall-clock: 453s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
