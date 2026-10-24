I applied the panel-4 fixes to PR #221 (`kriscendobot/minion.town`), pushed them as commit `1087ba1a`, and CI came back green: 3 checks, 0 failed, `ci-wait-merge` rc 0.

**Input.** The job had no deterministic pre-pass block, so I worked from the latest panel verdict, the "Must-fix before merge" comment review 5636863229 on head `2e8f3018`. It has four jurors: critic, skeptic, copyeditor and pedant. I applied the one must-fix and every should-fix to `designs/recursive-dynamodb-capabilities.md`, and most of the comment-only items too.

**What changed in the design:**
- **Must-fix (copyeditor):** the self-contradicting sentence is now "`derive()` is the only method that returns a DynamoDB capability, and no method returns an SDK object."
- **Index projection:** an index must use `ALL` projection. The catalog records each index's projection type, and any other type is refused when the catalog loads or at `derive`.
- **Recount and index lag (critic and skeptic):** the design now explains why the per-row sweep writes are safe and the recount is the exception. The recount now reads `version` strongly consistently, waits a configurable settle margin, counts twice, and writes only if the two counts agree, `version` is unchanged and the drift is within a tolerance. Otherwise it writes nothing and raises an alert. The `version` rule is now stated once: any write that moves a coupon row between `queue` partitions increments `version` on `POOL`, including leasing and retirement.
- **`couponId`:** the design now says where it is written. The root driver writes it at bind time through `recordIdentifier`, so the bind filter does the same job as the old `Scan`.
- **Named grants:** `cancelled` is now rejected (`invalid-request`) on a named grant, so a named grant can only be revoked by `withdraw`. The code sample, the revocation table and the tests are updated to match.
- **Tombstoned names:** a tombstoned name can never be reused, because `record` refuses it.
- **Rate limits:** a request takes a token from its own grant's bucket and from every ancestor's, so siblings share their parent's rate.
- **Root-guard oracle:** the "reveals nothing" claim now applies only to guards a child writes. For a root guard on a hidden field, the doc states the one-bit-per-key leak and how the host should limit it.
- **Check-then-send:** the request is split into an async preparation phase (only cursor unsealing) and a single synchronous dispatch turn, and "turn" is defined. The grant store and audit sink are kept off the gate path.
- **Phase-1 version check:** a `rowSchema = 2` stamp now lets phase 3 catch any leftover legacy writer.
- **Build scope (critic 3):** the doc now says that coupons don't exercise caplet-side `derive`, guards or per-child revocation. Follow-up 1 is split: the first build ships only what coupons use, and those three features wait until a named consumer needs them.
- **Copyedits:** numbered the §6.1–6.4 and §8.1 subsections, linked `guest-coupons.md`, and defined "petname", "root driver" and the `CouponDaemon` port. Also replaced "view", reworded "Every path closes the same gate", changed "method" to "operation", reflowed the long line, rewrote the sentence that opened with a lowercase "minion.town", reworded "only narrow or stay the same", and named the subject in follow-up 3.

**Follow-up for the maintainer:**
- **Build-scope split:** this is a scope decision I made rather than one the panel prescribed, and the next panel round or the maintainer may want to override it.

Not changed: the pedant's comment-only note about mixing "section N" and "§" references, which I left as is. The PR is still a draft; panel-5 is next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr221-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (1143510 cached reads)
- Output: 13446 tokens
- Cost: $1.2049340000000002
- Wall-clock: 470s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
