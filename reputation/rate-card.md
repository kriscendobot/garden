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

**EXCEPTION, 2026-08-01 — the two rows marked `[duration basis]`.** The
`moonshot/kimi-k3` and `fireworks/*` rows are measured against **raw
`duration_secs`**, not the proxy wallclock, and are therefore *not* on the same
basis as the Anthropic rows. This is deliberate and is a workaround, not a
correction: the documented `min(interval, GARDEN_REP_ATTEMPT_CAP_SECS)` cap on
earlier attempts **is not implemented in code** — the string appears only in the
prose of `scripts/jobs/rate-card-defaults.md`, and `rep_wallclock_index` /
`rep_proxy_secs` take the uncapped first-claim-to-tada span. During the 2026-07-29
board backlog that span swallowed days of *idle* queue time between requeues,
inflating the proxy basis 11.6x (kimi) and 72.1x (fireworks) over compute time —
e.g. `endojs-endo-but-for-bots-pr730-review-27278ba1`, 106 duration_secs against a
155684 s span across four reap/reclaim cycles. Measuring the authoritative totals
against that basis would have priced fireworks at $0.000026/s, ~200x below every
other row, handing it a near-free cost posterior that wins every auction on price
— the same trap the `openai` row documents below. The duration basis keeps both
rows comparable to the measured Anthropic rows until the cap is implemented and
ALL rows can be re-measured together. See Open follow-ups.

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
| moonshot | kimi-k3 | * | 0.002772 | measured [duration basis] | maintainer-authoritative $50.00 over 18036 duration_secs, 62 kimi-k3 engagements (see Derivations) | 2026-08-01 |
| local | * | * | 0.000081 | amortized | ~$0.29 per busy hour of the local box (hardware + power; see Derivations) | 2026-07-29 |
| openai | * | * | 0.005154 | provisional | fleet default — no published gpt-5.x API price is recorded and the ChatGPT plan meters no per-token dollars (see Derivations) | 2026-07-29 |
| fireworks | * | * | 0.001883 | measured [duration basis] | maintainer-authoritative $57.00 over 30271 duration_secs, 42 Fireworks engagements (see Derivations) | 2026-08-01 |
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

**`moonshot` / `kimi-k3` — measured from a maintainer-authoritative total
(2026-08-01).** This row was previously a *price ratio* (0.6 x the measured
opus-4-8 rate) applied because no kimi run had ever carried a dollar figure. The
maintainer has now supplied the collective cost of all Kimi work to date:
**$50.00**. Across the 62 `kimi-k3` reputation events that figure covers, raw
`duration_secs` totals **18036 s**, giving `50.00 / 18036 = $0.002772/s` — close to
the retired 0.003002 provisional, which is a mild independent check on the old
price-ratio derivation. The same $50.00 is allocated per-job, token-weighted, as
the append-only `kimi-k3-total-correction-20260801` adjustment batch over the 27 of
those engagements still present in `jobs/tada/`; that batch supersedes
`kimi-k3-credit-exhaustion-20260730` ($58.84 across 24 bases) without rewriting it
or any raw event. Note the basis exception above: this rate is per second of
*compute*, not per second of proxy wallclock.

**`fireworks` — measured from a maintainer-authoritative total (2026-08-01).**
Previously the fleet default with "one event of history". The maintainer has
supplied the collective cost of all completed Fireworks work to date: **$57.00**,
covering all 42 Fireworks reputation events (24 `glm-5p2`, 10 `deepseek-v4-pro`, 8
`fireworks-unconfigured`), every one of which is present in `jobs/tada/`. Raw
`duration_secs` totals **30271 s**, giving `57.00 / 30271 = $0.001883/s`. This is a
**pooled** provider-level row: the $57.00 is a single aggregate and cannot be split
per model without further evidence, so no per-model Fireworks row is asserted. The
correction is large — the prior fleet-default rate against the live proxy basis
implied **$130.08** for the same work, more than double the truth — so Fireworks
was being materially over-priced in its cost posterior. The same $57.00 is
allocated per-job as the `fireworks-total-correction-20260801` batch, weighted by
`duration_secs` (only 3 of the 42 carry usable token counts, so token weighting was
not available).

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

- **The attempt cap is documented but not implemented — this is the highest-value
  fix in this file.** `rate-card-defaults.md` describes the proxy wallclock as the
  final attempt "plus `min(interval, GARDEN_REP_ATTEMPT_CAP_SECS)` for each EARLIER
  attempt", but that identifier exists nowhere in code: `rep_wallclock_index`
  (`scripts/jobs/reputation.sh`) emits the raw first-claim-to-tada span and
  `rep_proxy_secs` returns it unmodified. Every second a job spends idle in the
  queue between reap and reclaim is therefore billed as engagement wallclock. On a
  healthy board the error is small (the ~1.4x the header cites); during the
  2026-07-29 backlog it reached **72x** for Fireworks. Because the reducer
  multiplies EVERY censored arm's span by its rate, all proxy-priced arms are
  currently over-estimated by whatever their share of queue idle was. Implementing
  the cap and then re-measuring every row **together** would let the two
  `[duration basis]` rows rejoin the proxy basis and retire the exception above.

- **`duration_secs` records only the FINAL attempt.** 255 of 1514 events (~17%) have
  `attempts > 1`, so wallclock burned on requeued attempts is missing from the proxy,
  and cost-per-accepted under-amortizes those failures. The journal commit log does
  retain the spans (`claim(<base>)` -> `tada(<base>)`), so the data exists; harvesting
  it is a separate job.
- **Per-token pricing.** The design (`designs/cleric-worker-bid-auction-reputation.md`
  §4.4) intends this file to also carry per-provider *per-token* prices and the
  human-review inference constants once the token-cost ledger reaches every provider.
  They are not here yet; the wallclock table is what the reducer reads today.
