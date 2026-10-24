---
role: designer
tier: mentor
arc: unallocated
---
<!-- garden-promoted-from-plan: gate=deferred priority=normal at=2026-10-24T03:04:29Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Design recursively partitioned and attenuated DynamoDB capabilities

Repo context: `kriscendobot/minion.town`, with the reusable capability likely
belonging in Endo. Route this work to a designer. Open the resulting design on
the appropriate bot-fork review surface; do not build it in this job.

Origin: kriskowal's review of minion.town PR #144, comment
https://github.com/kriscendobot/minion.town/pull/144#discussion_r4332668779.

Design a generic object-capability mechanism that can recursively partition and
attenuate DynamoDB authority, then delegate a narrow database capability to a
confined caplet. The design must settle:

- how a parent capability derives a child restricted to a table, partition/key
  prefix, item shape, and operation set;
- how a child can attenuate again without recovering the parent's authority;
- how conditional writes, transactions, queries, pagination, and error shapes
  preserve those restrictions;
- which component holds AWS credentials and how confined code receives only the
  derived facet;
- revocation, restart/reincarnation, audit, and least-authority tests; and
- how `designs/guest-coupons.md` can replace its coupon-specific injected ledger
  facet with the generic attenuator without widening the issuer's powers.

Start by inventorying existing DynamoDB adapters and Endo attenuation patterns.
Name why none already provides recursive partitioning before introducing a new
surface. Include an ownership map and an explicit migration path for the guest
coupon design.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-24T03:23:18Z
