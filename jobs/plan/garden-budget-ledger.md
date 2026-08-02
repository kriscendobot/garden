---
gate: orchestrated
orchestrated_by: garden-budget-attribution
priority: normal
role: builder
posted_by: producer
posted_at: 2026-08-02T21:05:30Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
handler-timeout: 10800

# Budget 2/5 — implement the attributed per-job cost ledger

Second child of orchestration `garden-budget-attribution`. Runs after
`garden-budget-ratecard`. Repository: https://github.com/kriscendobot/garden —
land on `main2`, no PR. Do **NOT** run git in `$GARDEN_ROOT`.

## This is already designed and accepted — implement it, don't redesign it

**Read `designs/token-cost-ledger.md` in full first.** Status: *Accepted
(maintainer-commissioned 2026-07-10, routed from the `scholar-ingest-unum`
library ingest; builder follow-up expected)*. It has never been built — no
ledger script exists under `scripts/jobs/`. It is the authoritative scope.

Supporting library material on `journal2` (read, don't re-derive):
`library/concepts/cost-ledger.md`, `library/sections/unum--token-cost-ledger.md`,
`library/sections/unum--cost-attribution-and-aggregation.md`. Also read
`designs/tada-token-accounting.md` (Accepted 2026-07-09, also unbuilt) — the
ledger design says the two should be built together and widens its single
integer into unum's attributed `CostRecord`.

## Why it matters more than the design could know

The maintainer has established the true cost basis: **$400/month flat**, two
Claude Max subscriptions on **separate accounts**, no overage. Measured against
that, the fleet's real cost is about **$0.125 per completed job** over its
lifetime (4,128 jobs, 39 days) — roughly **8.7x cheaper** than the notional
figure in `journal/usage/*.jsonl`.

Two consequences for your implementation:

1. **Attribution must carry the host**, because host ⇒ account ⇒ subscription.
   The two accounts are separate budgets; a fleet-wide total that cannot be split
   per account is not usable for the maintainer's purpose.
2. **Coverage is the headline defect.** The current ledger metered **357 runs
   against 4,128 completed jobs — 8.6%**. Whatever you build must either cover
   substantially all engagements or report its own coverage honestly on every
   surface. A ledger that silently samples 8.6% of the work and presents a total
   is worse than no ledger. Find out *why* coverage is that low (which handlers
   stamp usage and which do not) and say so in the report even if you cannot fix
   every path.

## Definition of done

The ledger built per the accepted design, with per-record host/account
attribution and an explicit coverage metric; regression coverage under
`scripts/jobs/test/`; a `tada/` report naming measured coverage before and after,
and listing any execution path that still does not stamp a record.
