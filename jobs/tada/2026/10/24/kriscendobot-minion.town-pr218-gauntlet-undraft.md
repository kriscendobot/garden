PR #218 in kriscendobot/minion.town ("feat(accounts): add the guest bond ledger and backfill") is now out of draft and ready for review, at the same commit the panel passed.

**Head check before un-drafting:** right before the change, the PR was open, still a draft, and its head commit was exactly `e01c98807b0b8270a04dd4e89059609187644aef`. I then ran `gh pr ready`. A fresh check afterwards shows it is no longer a draft and the head is still `e01c988…`.

**Advisory appellate pass:** I ran a light `claude -p` review of the full diff. It is advisory only, so it did not hold up the un-draft. Points a human reviewer may want to weigh:
- **IAM permissions:** `ForAllValues:StringEquals` passes when the key is missing from the request. There are also two separate Allow statements on `UpdateItem`. Together these may grant broader `UpdateItem` access, including to the ledger partition, than intended. The tests use their own model of IAM evaluation, so they can't catch a difference from real AWS behavior; it should be checked with the IAM policy simulator or a real probe.
- **Ledger rows can be deleted:** the app has `DeleteItem` on the whole ledger partition. A compromised app could erase a bond row, and account deletion would then silently miss that bond.
- **Rollout windows:** during the backfill and the final scan, an old (pre-ledger) app instance can still create bonds that never get a ledger row. Nothing in the diff reads the reconciliation marker to stop deletion from relying on an incomplete ledger. Separately, two operator runs at the same time could delete each other's marker files.
- **Legacy bonds:** marking old bonds as `UNVERSIONED_BONDS_KEY=current` cannot be verified. If the key was rotated before, those rows land under the wrong version.
- **Smaller points:**
  - The backfill does a full-table scan with no resume and no retry on throttling errors.
  - The `accountKey` format changed, so check that nothing else builds that key by string concatenation.
  - The preflight probe only avoids writing to production because of its `attribute_exists(iss)` condition; a unit test does pin that expression.

No follow-up jobs were posted; these are for the maintainer's review of the PR.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr218-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (175111 cached reads)
- Output: 1542 tokens
- Cost: $0.41547019999999996
- Wall-clock: 41s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
