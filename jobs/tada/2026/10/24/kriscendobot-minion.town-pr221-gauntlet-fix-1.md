**Fix round 1: kriscendobot/minion.town PR #221 (recursively attenuated DynamoDB capabilities design)**

I applied all four must-fix items from the panel-1 review (5636699758) as one follow-up commit, `680172f7`. I pushed it to `design/recursive-dynamodb-capabilities` with `safe-push-pr-head.sh`, which moved the head forward from `7eca8b82`. CI is green: 3 checks, 0 failed (`ci-wait-merge` rc 0).

**Must-fix items applied** (all in `designs/recursive-dynamodb-capabilities.md`):
- **skeptic 1, replacing `Scan`:** §8 now has a new subsection, "Access patterns without `Scan`". It is based on the actual PR 199 adapter, whose table has only a `pk` key and no sort key, and whose two `Scan` callers are `list()` and `listBooks()`.
  - It adds a sparse index named `queue`, keyed by status (`COUPON#<status>` or `BOOK`), with a numeric sort key `due`.
  - A table maps each caller to a bounded `query`: the expire pass, the stale-lease pass, the bind pass, the remove-names pass, the daily recount, and `listBooks`.
  - It explains why this fits the §3 key-space rules, and why the busy single-status index key is acceptable: pool capacity caps the number of coupons, and a bucket fan-out is the fallback if that ever stops holding.
  - The adapter promotes `couponId` and `nameRemovedAt` to top-level attributes so queries can filter on them.
  - Creating the index and backfilling existing rows is listed as new follow-up 3, done by the operator, since no capability can change the table itself. This also covers critic finding 4.
- **copyeditor, the `conflict` outcome:** added a `Failure` type (`none`, `condition-failed`, `conflict`, `unavailable`) and stated that `conflict` appears only per transaction member.
- **copyeditor, who holds revocation:** sections 2, 6 and 7 now agree. The caller that derives a grant keeps its `cancelled` rejector, and the host control keeps `withdraw(grantId)` for named grants.
- **copyeditor, the "either path" sentence:** rewritten as "two events close a grant's live gate".

**Should-fix items also fixed, since they were cheap:**
- A prefix now has to end with its delimiter, so `COUPON#1` is not treated as one coupon's key (critic 3, first bullet).
- One canonical way to narrow a prefix to an exact value (ergonomist 3).
- The root grant's check, not an "outermost wrapper", sends the AWS command.
- `DynamoResult` renamed to `Result<T>`.
- "Validates" changed to "projects and checks".
- The vague "this increment" wording in the git-remote paragraph is replaced.
- The file is still all ASCII.

**Still open, for panel-2 or the maintainer:** the other should-fix items:
- where each wrapper runs and its per-call cost
- choosing one main revocation mechanism
- type sketches for `Restriction` and the options
- error shape for `derive`
- a cursor-expired tag
- idempotency tokens across restart
- tests for transaction limits and number round-tripping
- adding a glossary and an `## Open questions` section

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr221-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (1027881 cached reads)
- Output: 9188 tokens
- Cost: $0.9693682
- Wall-clock: 433s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
