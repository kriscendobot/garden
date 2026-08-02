# rate-card.md — this instance's wallclock rate card

Dollars-per-second per `(provider, model, thoughtfulness)` arm, used by the
**wallclock cost proxy**: when a provider CLI reports no per-call dollars,
`rep_agentic_dollars` fails open to `censored` and the arm would be priced by
nothing — so `reputation-reduce.sh` prices that event at `proxy_secs x` the rate
below instead. That wallclock is measured by the garden rather than reported by a
provider, so unlike a dollar figure it can never be censored: it is
`duration_secs` for the attempt that reached tada, PLUS
`min(interval, GARDEN_REP_ATTEMPT_CAP_SECS)` for each EARLIER attempt of a requeued
job, read back from the claim commits in this journal's own log
(`reputation.sh` § `rep_wallclock_index`).

**The rates below are all measured on that ONE basis** — the capped proxy
wallclock, not raw `duration_secs`. A row and its basis move together:
**re-measure, never rescale.** Pricing the wider proxy basis at a narrower rate
would inflate every censored arm in proportion.

**2026-08-02 — the attempt cap is now IMPLEMENTED and every row is on the proxy
basis.** Until this date two things were broken together: (1) the
`min(interval, GARDEN_REP_ATTEMPT_CAP_SECS)` cap existed only in prose — the
identifier appeared nowhere in code, so `rep_wallclock_index` billed the *whole*
first-claim-to-tada span, swallowing days of idle queue time between a reap and the
next claim (the 2026-07-29 backlog inflated one Fireworks base's proxy **72x**); and
(2) because of that, the `moonshot/kimi-k3` and `fireworks/*` rows had to be measured
against raw `duration_secs` (a `[duration basis]` exception) to stay comparable. The
cap is now real (`GARDEN_REP_ATTEMPT_CAP_SECS`, default 2490 s — the default reap
floor; earlier attempts are clamped to it, the final attempt is uncapped, and the
idle reap→reclaim gap is excluded entirely). With the proxy trustworthy again, the
Anthropic, Moonshot, and Fireworks rows have ALL been re-measured on the capped proxy
basis and the exception is **retired**.

**This file is journal data and outranks the tracked seed**
(`scripts/jobs/rate-card-defaults.md` on `main2`). Correcting a rate here needs **no
deploy and no code change**: the reducer re-reads this card every tick and
re-derives the estimate for **every historical event** from the new number, without
rewriting a single event. That is the whole point of a coarse proxy — land a rough
rate now, sharpen it when better evidence arrives.

Resolution order is this card > the tracked seed > `GARDEN_REP_DEFAULT_RATE_PER_SEC`
(`scripts/jobs/reputation.sh`). Within a table the **most specific matching row wins**
(provider 4 > model 2 > thoughtfulness 1); a key cell is an **exact value or `*`** —
not a glob, so every host resolves identically, which the auction's determinism
invariant requires. A **non-positive or absent** rate means "no wallclock proxy for
this arm": its events stay `censored`, it accrues no cost posterior, and it bids the
wide cold prior. It never means `$0.00`.

An estimate never impersonates a measurement. The event keeps its raw
`agentic_dollars: censored` and gains a separate `cost_source:` /
`estimated_dollars:`; the arm projection keeps its raw `censored:` count — which
never shrinks — beside a new `estimated:` count, so an arm can always report how much
of its cost evidence is real; and the Thompson draw widens in proportion to the
estimated fraction of an arm's cost pool (`GARDEN_REP_ESTIMATE_SD_MULT`), because a
proxy is weaker evidence than an invoice.

## Rates

| provider | model | thoughtfulness | dollars_per_second | price_basis | source | measured_at |
| --- | --- | --- | --- | --- | --- | --- |
| anthropic | * | * | 0.000069 | measured (amortized fixed cost) | flat $400/mo subscription (2 accounts x $200 Max 20x); $66.67 true cost over the 5-day 07-28..08-02 window / 970566 s capped-proxy Anthropic wallclock (262 events) — see Derivations | 2026-08-02 |
| moonshot | kimi-k3 | * | 0.001338 | measured | maintainer-authoritative $50.00 / 37381 s capped-proxy wallclock, 27 completed kimi-k3 engagements (see Derivations) | 2026-08-02 |
| local | * | * | 0.000081 | amortized | ~$0.29 per busy hour of the local box (hardware + power; see Derivations) | 2026-07-29 |
| openai | * | * | 0.005154 | provisional | fleet default — no published gpt-5.x API price is recorded and the ChatGPT plan meters no per-token dollars (see Derivations) | 2026-07-29 |
| fireworks | * | * | 0.000509 | measured | maintainer-authoritative $57.00 / 111908 s capped-proxy wallclock, 42 Fireworks engagements (see Derivations) | 2026-08-02 |
| * | * | * | 0.005154 | provisional | conservative fleet default for an unknown arm — ~Anthropic Opus API list price, deliberately high so a never-measured arm cannot win on false cheapness (see Derivations) | 2026-08-02 |

## Derivations

**`anthropic` — a FLAT subscription, amortized; NOT the notional list price it used
to carry (2026-08-02).** Until today the Anthropic rows (per-model, pooled at
$0.005154/s) were derived from `total_cost_usd` in `journal/usage/*.jsonl`. On a
**Claude Max** subscription that field is what the same tokens *would* cost at API
list price — **it is not money that was ever charged.** The fleet runs two instances
(`endolin-garden-ece02cb4`, `endolin-garden2-5bcdff64`), each on a **separate**
Anthropic account, each a Max 20x plan at **$200/month**: **$400/month FLAT**, which
the maintainer confirms is not exceeded (no overage component to model). That is
**$13.33/day**, and **$66.67** over the 5-day metered window 2026-07-28 → 2026-08-02.

The card's job is to price a *second of engagement*, and the reducer multiplies each
censored event's **capped proxy wallclock** by the rate. So the true rate is the flat
cost **amortized over the measured Anthropic proxy wallclock**, on the very basis the
reducer applies: `66.67 / 970566 s = 0.000069 $/s`, where 970566 s is the summed
capped-proxy wallclock of the 262 Anthropic reputation events completed in the window.

- **Why $/s at all, for a cost that is not metered per second?** A subscription's
  *marginal* cost per job is ~0 until the plan limit, then overage-or-refusal — so a
  `$/s` rate is a **modelling convenience, not a marginal price.** We keep the `$/s`
  shape because it is what the auction's cost proxy consumes and because a
  wrong-but-consistent number beats today's wrong-and-inconsistent one; but the figure
  is an **amortization of a fixed cost over measured wallclock**, and must be read as
  such. (`hasExtraUsageEnabled` differs between the hosts — `true` on garden, `false`
  on garden2 — so the two accounts behave differently *at* the limit; neither is
  modelled here because the maintainer states the flat budget is not exceeded.)
- **Why not $0.000707/s?** Dividing the same $66.67 by the usage ledger's summed
  `elapsed_s` (94240 s of pure model-call time, all-time) gives $0.000707/s — the
  figure the arming note cited. It is correct *on the elapsed-seconds basis*, but that
  is **not** the basis the reducer prices on. The card's proxy is **engagement
  wallclock including capped requeues** (970566 s), ~10.3x the pure model-call time
  (145531 s of `duration_secs`, and 94240 s of `elapsed_s`), because a job's handler
  runs git/tests/etc. around the model call and a requeued job burns several attempts.
  Pricing at $0.000707/s while the reducer multiplies the 10.3x-larger proxy would
  over-attribute Anthropic cost ~10x. The wall-clock basis is the whole point of
  "re-measure, never rescale": the $/s figure only means anything paired with its
  denominator's basis.
- **Why one pooled row, no per-model rows?** A flat subscription does not price
  per model — every model draws the same $400/mo pool. Amortizing the single flat cost
  per model would give every model the *same* $/s anyway (`flat x model_s/total_s /
  model_s = flat/total_s`), so the retired `claude-default` / `claude-fable-5` /
  `claude-opus-4-8` / `claude-sonnet-4-6` rows carried a false implication of distinct
  marginal prices. The pooled row is the honest representation.

**`moonshot` / `kimi-k3` — re-measured on the capped proxy basis (2026-08-02).**
The maintainer-authoritative total is unchanged: **$50.00** for all Kimi work to
date. What changed is the denominator: previously this was divided by raw
`duration_secs` (18036 s, the `[duration basis]` workaround) because the uncapped
proxy was broken. With the cap implemented the same 27 completed engagements' proxy
wallclock is **37381 s** (final attempts + capped requeues), giving
`50.00 / 37381 = 0.001338 $/s`. The 61 Kimi events with no completion span in the log
contribute no seconds and no dollars. The append-only
`kimi-k3-total-correction-20260801` adjustment batch is unaffected — it allocates the
same $50.00 per-job and is orthogonal to this per-second rate.

**`fireworks` — re-measured on the capped proxy basis (2026-08-02).** The
maintainer-authoritative total is unchanged: **$57.00** for all completed Fireworks
work (42 events: 24 `glm-5p2`, 10 `deepseek-v4-pro`, 8 `fireworks-unconfigured`, all
present in `jobs/tada/`). Previously divided by raw `duration_secs` (30271 s); the
same events' capped proxy wallclock is **111908 s**, giving
`57.00 / 111908 = 0.000509 $/s`. Still a **pooled** provider-level row: the $57.00 is
a single aggregate and cannot be split per model without further evidence. The
`fireworks-total-correction-20260801` allocation batch is unaffected.

**`local` — amortized, not invoiced.** Local inference has no per-token invoice, only
electricity and amortized hardware, and pricing it at literally $0 would make one
lucky local success look infinitely efficient and starve exploration of the paid arms
it should be measured against (`designs/provider-model-catalog.md` §2.5). Per that
section's figures: a ~$2,000 box over a 3-year life at ~30% duty is
`2000 / (3 x 8760) / 0.30 = $0.254` per *busy* hour; power at ~120 W and $0.30/kWh
adds $0.036/hr; total ~$0.29/hr `= $0.000081/s`. Both inputs are illustrative — swap
in the measured box price, the real duty cycle, and `amd-smi` power draw when known.
(This row is not yet on the capped-proxy basis; it is an independent hardware
amortization, priced per busy *hour* of the box rather than per engagement second.)

**`openai` — the fleet default, deliberately.** The two ledger-priced codex events
report `$0.000000`: the ChatGPT plan meters no per-token dollars
(`designs/provider-model-catalog.md` §2), so that zero is a *missing* measurement
wearing a number's clothes, not a free run. Taking it at face value would hand every
codex arm a $0 cost posterior and let it win every auction on price. The design's
answer is to price such tokens at the provider's public API list rate; **no published
gpt-5.x price is recorded anywhere in the garden**, so rather than invent one this row
carries the conservative fleet default and says so. Replace it with a real list-price
derivation, dated, when one is recorded.

**`* * *` — the conservative fleet default.** An arm with no matching row is priced at
$0.005154/s, ~Anthropic Opus API list price. This was formerly documented as "the
pooled measured Anthropic rate"; that pooled row was the *notional* list-price rate,
now retired, so the default is decoupled from it and re-cast as a deliberately **high
ceiling**: a never-measured arm must not win the auction on false cheapness. It is a
prior to be replaced by a measured default, not a claim about any real arm.

## Relative arm ordering (what this correction reverses)

Before today the card implied Anthropic was the **most expensive** paid arm
(pooled $0.005154/s) and Kimi materially cheaper ($0.002772/s). On the true-cost
basis that ordering **reverses**: Anthropic is now the **cheapest** paid arm at
$0.000069/s — ~19x below Kimi ($0.001338/s) and ~7x below Fireworks ($0.000509/s).
This confirms the arming note's claim. **Caveat:** the reversal is realized in the
rate CARD, but not yet fully in the auction's cost posterior, because 217 of 1109
Anthropic events still carry a non-censored `agentic_dollars` copied from the notional
usage ledger, which the reducer consumes directly and the rate card cannot touch. See
Open follow-ups — neutralizing that notional ledger is the remaining step to make the
reversal bite end-to-end.

## Calibration anchor (maintainer-supplied, 2026-07-28)

> **$0.20365** spent as of **2026-07-28T06:39Z**, over roughly **18 minutes**
> (~1090s) of a liaison session — approximately **$0.000187/second** (~$0.67/hour).

Kept because it is a real, independently-sourced datapoint, and recorded with its
provenance so a better aggregate measurement **supersedes** it rather than silently
coexisting with it. It calibrated an **Anthropic Opus liaison session** priced at
**API list rate** — i.e. it is a *notional* figure of the same kind this correction
just removed from the table, and an interactive session is idle-heavy besides. It is
therefore doubly unfit as a worker-arm rate and is not used as one. Note the true
subscription rate now on the table ($0.000069/s of engagement wallclock) is far
*below* even this notional anchor, exactly as a flat subscription amortized over heavy
autonomous use should be.

## Open follow-ups

- **Neutralize the notional Anthropic ledger — the highest-value remaining fix.**
  217 of 1109 Anthropic reputation events carry a numeric `agentic_dollars` copied
  from `usage/*.jsonl`'s `total_cost_usd`, which on a Max subscription is API
  list price, **not money charged**. The reducer prefers a non-censored ledger over
  the proxy, so those 217 events price the Anthropic arm at ~8.7x its true cost no
  matter what this card says — the rate card only governs the 892 *censored*
  Anthropic events. Making the true-cost basis bite end-to-end means treating
  Anthropic (and any subscription/unmetered provider) `total_cost_usd` as censored so
  every Anthropic event routes through this amortized proxy. That is a reducer/
  `complete-job` behavior change, out of scope for this rate-card correction; it is the
  natural next child of `garden-budget-attribution`.
- **`duration_secs` records only the FINAL attempt.** The proxy now recovers earlier
  attempts from the claim commits (capped), but `duration_secs` itself — the fallback
  when the log yields no span — still clocks only the final attempt, so an event with
  no journal history under-amortizes its requeues. The journal log retains the spans;
  this is only the fallback path.
- **Per-token pricing.** The design (`designs/cleric-worker-bid-auction-reputation.md`
  §4.4) intends this file to also carry per-provider *per-token* prices and the
  human-review inference constants once the token-cost ledger reaches every provider.
  They are not here yet; the wallclock table is what the reducer reads today.
