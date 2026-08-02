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


---

## AMENDED 2026-08-02 by the liaison — read this before you start

Child 1 (`garden-budget-ratecard`) has landed. Read
`jobs/tada/garden-budget-ratecard.md` in full first; two of its results change
this job's scope.

### 1. The true-cost reversal is NOT yet in the auction — and that is yours

Child 1 re-based the rate card (Anthropic pooled at **0.000069 $/s**, now the
*cheapest* paid arm, ~19x below kimi-k3). But it reported that the reversal
**does not yet reach the auction posterior**:

> 217 of 1109 Anthropic events still carry a numeric `agentic_dollars` copied
> from the notional usage ledger, which the reducer **prefers** over the proxy;
> the card only governs the 892 *censored* Anthropic events.

So the auction is still being fed notional list-price dollars for a fifth of the
Anthropic evidence. Child 1 scoped the fix out deliberately and named it as
likely belonging here: **on a flat subscription, a per-call `total_cost_usd` is
not money and should be recorded as `censored`**, so the reducer falls through to
the true-costed rate card.

Do this as part of your work — it is the same code you are already touching
(`complete-job.sh` writes the reputation event; `reputation-reduce.sh` chooses
ledger-vs-proxy). Decide and document whether existing numeric Anthropic events
are rewritten, superseded by an append-only adjustment (the
`reputation/adjustments/` mechanism already used for the kimi/fireworks
corrections), or left alone with the reducer changed to ignore them. **Do not
rewrite raw events in place** — the adjustment mechanism exists precisely so
evidence and correction stay separately auditable.

### 2. Do not reuse the liaison's 0.000707 figure

The original brief cited ~0.000707 $/s as an expected true Anthropic rate. **That
figure was wrong for this purpose** and child 1 correctly refused it: it divides
the subscription cost by the usage ledger's `elapsed_s` (pure model-call time),
whereas the reducer multiplies the *capped proxy wallclock*, ~10.3x larger.
Pricing at 0.000707 would over-attribute Anthropic by ~10x. The landed figure is
**0.000069 $/s**. If your work needs a rate, take it from the card, not from
prose.

### 3. Inherited context that still stands

The coverage defect is unchanged and remains the headline: **357 metered runs
against 4,128 completed jobs (8.6%)**. Also note child 1 left two pre-existing
test failures on `main2` (`gardener arm wrong`, `reducer churned a
wallclock-estimated event set`) — it verified they reproduce on unmodified
`main2` and are unrelated. Do not attribute them to your change, and do not
"fix" them blind; if your work touches that surface, say what you found.
