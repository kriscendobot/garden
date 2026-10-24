## Completion report: kriscendobot/minion.town #221 un-drafted

**Result:** PR #221 ("design: recursively attenuated DynamoDB capabilities") is now ready for review. Its head is `35bb0c3b394bf6738339ab67099542bd1e097da3`, the exact head the passing panel covered.

**Steps:**
1. **Pre-mutation check:** `gh pr view` returned state OPEN, `headRefOid` equal to the panel-passed SHA, and `isDraft: true`.
2. **Un-draft:** `gh pr ready` succeeded.
3. **Post-mutation check:** `isDraft: false`, and `headRefOid` still equals `35bb0c3b394bf6738339ab67099542bd1e097da3`.

**Advisory appellate pass (does not block the un-draft):** I ran `claude -p` with Sonnet over the 1047-line diff. These are the design issues it thinks the panel may have missed, worth looking at in maintainer review:
- **Ambiguous commits on retry:** a `retryable: true` `unavailable` result can hide a commit whose response was lost. Blindly retrying a non-idempotent `update` (for example, a numeric add on the POOL counters) can double-apply. The design needs an "outcome unknown" result.
- **Reconcile compares names only (§6.2):** if a root's restriction is narrowed but its name kept, the old, broader live grant stays in force.
- **Oracle on unreadable fields (§3.3):** nothing enforces that `conditionFields` and `filterFields` are a subset of `readFields`. A holder could learn the value of a field it cannot read.
- **`fixed` attributes are not ownership:** a child can still overwrite other items within its key range.
- **Shared idempotency tokens (§4):** two sibling grants with identical restrictions produce the same `ClientRequestToken`, so one caplet's request can be deduplicated against the other's.
- **Smaller points:**
  - **Index re-check (§3.2):** the base-key re-check reads and bills items the holder cannot see. That gives a holder a way to burn capacity and learn from timing.
  - **Counter audit (§8.1):** its drift model ignores rows that are counted twice or missed mid-audit.
  - **Withdraw window (§6):** a supervisor crash between reconcile and withdraw can leave a withdrawn grant live for up to 5 minutes, which contradicts "withdraw closes at once".
  - **Rate limits (§3.4, §6):** in-memory token buckets reset when the broker restarts.
  - **Item-size limit (§3.4):** `limits.itemBytes` can't be enforced on `update` without a read.

**Follow-ups:** none were posted. These findings are advisory and are recorded here for whoever reviews #221.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr221-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (174821 cached reads)
- Output: 2019 tokens
- Cost: $0.4248242
- Wall-clock: 68s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
