# rate-card.md — this instance's wallclock rate card

Dollars-per-second per `(provider, model, thoughtfulness)` arm, used by the
**wallclock cost proxy**: when a provider CLI reports no per-call dollars,
`rep_agentic_dollars` fails open to `censored` and the arm would be priced by
nothing — so `reputation-reduce.sh` prices that event at `duration_secs x` the rate
below instead. That wallclock is measured by the garden rather than reported by a
provider, so unlike a dollar figure it can never be censored: `duration_secs`
(present on **100% of reputation events**) times the attempt that reached tada, plus
`min(interval, GARDEN_REP_ATTEMPT_CAP_SECS)` for each EARLIER attempt of a requeued
job, read back from the claim commits in this journal's own log.

**The rates below are measured on that basis**, not on `duration_secs` alone. The two
differ by ~1.4x in aggregate (354 of 1545 events were requeued), so a row and its
basis move together: re-measure, never rescale. Pricing the wider basis at the
narrower basis's rate would inflate every censored arm by that ratio.

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
| anthropic | claude-default | * | 0.005139 | measured | 62 ledger-priced fleet events, $283.29 over 55124 wallclock s | 2026-07-29 |
| anthropic | claude-fable-5 | * | 0.007661 | measured | 17 ledger-priced fleet events, $55.58 over 7254 wallclock s | 2026-07-29 |
| anthropic | claude-opus-4-8 | * | 0.005003 | measured | 18 ledger-priced fleet events, $99.45 over 19877 wallclock s | 2026-07-29 |
| anthropic | claude-sonnet-4-6 | * | 0.001549 | measured | 5 ledger-priced fleet events, $5.10 over 3290 wallclock s | 2026-07-29 |
| anthropic | * | * | 0.005154 | measured | pooled: 103 ledger-priced fleet events, $451.54 over 87611 wallclock s | 2026-07-29 |
| moonshot | kimi-k3 | * | 0.003002 | provisional | 0.6 x the measured claude-opus-4-8 rate, from Moonshot's provisional list price ratio (see Derivations) | 2026-07-29 |
| local | * | * | 0.000081 | amortized | ~$0.29 per busy hour of the local box (hardware + power; see Derivations) | 2026-07-29 |
| openai | * | * | 0.005154 | provisional | fleet default — no published gpt-5.x API price is recorded and the ChatGPT plan meters no per-token dollars (see Derivations) | 2026-07-29 |
| fireworks | * | * | 0.005154 | provisional | fleet default — no Fireworks price recorded; one event of history | 2026-07-29 |
| * | * | * | 0.005154 | measured | fleet default for an unknown arm = the pooled measured rate above | 2026-07-29 |

## Derivations

**The measured Anthropic rows are the strongest evidence in this file.** They come
from the only arms that carry a real dollar ledger: the 103 of 1545
`reputation/events/*.md` whose `agentic_dollars` is a number rather than `censored`,
each divided into its own proxy wallclock. That is a direct measurement of exactly the
quantity this card supplies, taken on autonomous fleet workers doing real jobs.

**Why these numbers moved down (2026-07-29).** They were first measured against
`duration_secs` alone, which times only the attempt that reached tada — so a requeued
job's dollars (the ledger sums every attempt) were divided by one attempt's seconds,
and the rate came out high: $0.0072/s pooled. Charging the earlier attempts too
restates the same $451.54 over 38% more seconds: $0.0052/s. Same dollars, wider
denominator, both honest — what would be wrong is mixing them.

**`moonshot` / `kimi-k3` — derived, not measured.** No kimi run has ever carried a
dollar figure, so its rate is a *price ratio* applied to a measured arm.
`designs/provider-model-catalog.md` §2.6 records Moonshot's provisional list price as
$0.30 / $3.00 / $15.00 per MTok (cached input / fresh input / output); the Anthropic
catalog §1 prices `claude-opus-4-8` at $5 / $25 per MTok. The ratio is 0.6 on both the
input and the output leg, so `0.6 x 0.005003` (the measured opus-4-8 row)
`= 0.003002`. **This
assumes kimi generates tokens at roughly opus's rate** — if kimi is materially faster
or slower per token, its dollars-per-*second* scales with that and this row is wrong
in that proportion. The underlying list price is itself marked `[provisional,
unverified]` upstream. Replace this row the moment a kimi run carries a real ledger.

**`local` — amortized, not invoiced.** Local inference has no per-token invoice, only
electricity and amortized hardware, and pricing it at literally $0 would make one
lucky local success look infinitely efficient and starve exploration of the paid arms
it should be measured against (`designs/provider-model-catalog.md` §2.5). Per that
section's figures: a ~$2,000 box over a 3-year life at ~30% duty is
`2000 / (3 x 8760) / 0.30 = $0.254` per *busy* hour; power at ~120 W and $0.30/kWh
adds $0.036/hr; total ~$0.29/hr `= $0.000081/s`. Both inputs are illustrative — swap
in the measured box price, the real duty cycle, and `amd-smi` power draw when known.

**`openai` — the fleet default, deliberately.** The two ledger-priced codex events
report `$0.000000`: the ChatGPT plan meters no per-token dollars
(`designs/provider-model-catalog.md` §2), so that zero is a *missing* measurement
wearing a number's clothes, not a free run. Taking it at face value would hand every
codex arm a $0 cost posterior and let it win every auction on price. The design's
answer is to price such tokens at the provider's public API list rate; **no published
gpt-5.x price is recorded anywhere in the garden**, so rather than invent one this row
carries the fleet default and says so. Replace it with a real list-price derivation,
dated, when one is recorded.

## Calibration anchor (maintainer-supplied, 2026-07-28)

> **$0.20365** spent as of **2026-07-28T06:39Z**, over roughly **18 minutes**
> (~1090s) of a liaison session — approximately **$0.000187/second** (~$0.67/hour).

Kept because it is a real, independently-sourced datapoint, and recorded with its
provenance so a better aggregate measurement **supersedes** it rather than silently
coexisting with it. It is deliberately **not** used as a rate in the table above, for
three reasons the maintainer stated when supplying it:

- It calibrates an **Anthropic Opus liaison session**, and nothing else. It is not a
  Moonshot rate; applying it to kimi-k3 would invent a number for a provider it never
  measured.
- An **interactive liaison session is idle-heavy** — its wallclock includes time
  waiting on a human, which inflates the denominator and *depresses* the dollars per
  second. It is an upper bound on idleness, hence a **lower bound** on the rate of an
  autonomous worker grinding a build, and only a weak prior for any worker arm.
- The maintainer's own framing: *"a coarse calibration if we have better aggregate
  tracking later."*

The fleet's own 79 ledger-priced events **are** that better aggregate tracking, and
they turned out to already be on hand: the measured autonomous rate is $0.0072/s,
~39x the anchor. The two are consistent — they measure different things, and the gap
is the idle time — so the anchor is superseded here as evidence about *worker* arms
while remaining on record as the only measurement the garden has of a *liaison*
session.

## Open follow-ups

- **`duration_secs` records only the FINAL attempt.** 255 of 1514 events (~17%) have
  `attempts > 1`, so wallclock burned on requeued attempts is missing from the proxy,
  and cost-per-accepted under-amortizes those failures. The journal commit log does
  retain the spans (`claim(<base>)` -> `tada(<base>)`), so the data exists; harvesting
  it is a separate job.
- **Per-token pricing.** The design (`designs/cleric-worker-bid-auction-reputation.md`
  §4.4) intends this file to also carry per-provider *per-token* prices and the
  human-review inference constants once the token-cost ledger reaches every provider.
  They are not here yet; the wallclock table is what the reducer reads today.
