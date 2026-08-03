# Costing an issue end to end, and evaluating a (model, harness, memory) triple

| Created | 2026-08-02 |
| Author  | assayer (job `garden-budget-triple`, Budget 4/5 of `garden-budget-attribution`) |
| Status  | Accepted (maintainer-commissioned; the budget-attribution chain, child 4/5) |

This is the read-side method that sits on top of the true-cost machinery the first
three budget children built. It answers two maintainer questions:

1. **What does an *issue* cost the garden, end to end** — machine time *and* the
   human review it induces?
2. **How do two `(model, harness, memory)` triples compare** on that cost, on real
   journal data?

The one-line answer, stated up front because it governs everything below:

> On a flat $400/month subscription the machine half of an issue is close to noise
> — a merged PR costs the garden a **few cents to a few dollars** of true machine
> time. The dominant cost is **human review rounds**: 1–3 passes of maintainer
> attention per merged PR, worth **$20–$115** at any plausible rate. A triple that
> halves machine cost while adding even *half* a review round per PR is a **worse**
> triple. Optimise the number of review rounds to acceptance first; treat machine
> cost as a tiebreaker.

Read alongside: [`token-cost-ledger.md`](token-cost-ledger.md) (the per-job ledger),
[`cleric-worker-bid-auction-reputation.md`](cleric-worker-bid-auction-reputation.md)
(the arm keying), and `reputation/rate-card.md` on `journal2` (the true-cost rates
and the maintainer calibration anchor). Tools: `scripts/jobs/cost-by-pr.sh` (machine
half, built by Budget 3) and `scripts/jobs/review-rounds.sh` (human half, built here).

## The method

```
Cost(issue) = MachineCost + HumanReviewCost

MachineCost      = Σ over the issue's contributing jobs of
                   capped_proxy_wallclock(job) × rate_card[arm(job)]
                   # exactly what cost-by-pr.sh computes, rolled to the merged PR.

HumanReviewCost  = R_h × t_r × w
                   # R_h = human review rounds the PR consumed   (MEASURED)
                   # t_r = maintainer minutes per round           (PARAMETER)
                   # w   = fully-loaded maintainer $ per minute   (PARAMETER)
```

**The unit of a delivered issue is the merged pull request** — the maintainer's
"Gimix escrow oracle" (Budget 3). Everything is costed by rolling per-job cost up to
the PR the jobs served.

### MachineCost — reuse Budget 3, do not rebuild

`cost-by-pr.sh` joins each priced reputation event's base to a PR (via the
`jobs/index` directive identity plus PR-shaped, PR-set-validated base tokens) and
prices it on the true-cost basis: **capped proxy wallclock × the journal rate card**,
*not* the notional `total_cost_usd` from `usage/*.jsonl` (which on a flat plan is API
list price and overstates ~8.7×). Two rules inherited from Budget 3 and kept here:

- **The `openai`/unknown CEILING column is not money.** The ChatGPT plan meters $0;
  the card prices those arms at a deliberately-high provisional $0.005154/s so an
  unmeasured arm cannot win the auction on false cheapness. That figure is a
  modelling ceiling — kept out of every dollar total published as spend.
- **Absolute lifetime totals do not reconcile and must not be published as spend.**
  Budget 3's measured all-time total is **$247**, against a true subscription spend
  of **$517.70** over the journal's 39-day life. The gap is join coverage (29%) plus
  a rate calibrated on a 5-day window applied all-time. *Relative per-PR ranking is
  sound; the absolute total is not.* When an issue-cost estimate needs an absolute
  figure, re-derive the rate over the period being costed, or state the gap.

### HumanReviewCost — measure the rounds, parameterise the price

`review-rounds.sh` counts, per merged bot PR, the number of **human** review
submissions (a "round" = one maintainer pass over the diff that ended in
approve/request-changes/comment). Bot reviews — the panel's own summary posts, other
fleet bots — are **excluded**; they are machine review and already sit on the machine
side of the ledger.

The round *count* is measured from GitHub and is trustworthy. The two multipliers are
**not measured anywhere in the journal** and are deliberately left as caller
parameters:

- `t_r` (minutes per round): a substantive code-PR review pass is plausibly 5–30 min.
- `w` ($/minute): a fully-loaded senior-maintainer rate.

Any point estimate of HumanReviewCost inherits these parameters' uncertainty, so this
document never publishes one as fact — it publishes the **round count** (which a worse
triple inflates) and shows the *dominance* conclusion holds across the entire
plausible parameter range. Fabricating a minutes-per-round number would be the least
defensible figure in the whole budget; we refuse it on purpose.

> The maintainer's own calibration anchor (`rate-card.md` § Calibration anchor) is a
> *liaison session* priced at $0.000187/s **machine** cost — it is not a human wage
> and is explicitly not reused as one. It is noted here only so a future reader does
> not mistake it for the `w` this method needs.

## The measurement (endojs/endo-but-for-bots, the garden's densest real corpus)

All figures below are from the live journal + GitHub on 2026-08-02, `main2` HEAD
`c879177dd2`. `endo-but-for-bots` is the only repo with enough merged bot PRs to say
anything; every number is scoped to it and to bot-authored (`kriscendobot`) merged
PRs.

**Machine cost per merged PR** (`cost-by-pr.sh`, true-cost basis, 68 joined merged
PRs):

| stat | measured machine $/merged PR |
| --- | --- |
| mean | **$0.59** |
| median | **$0.16** |
| max (ebfb #882) | **$5.17** |
| 57 of 68 joined merged PRs | **< $1.00** |

These are **lower bounds** — at 29% job→PR join coverage most contributing jobs of an
older PR were never joined, so a PR's true machine cost is higher than shown. But the
ceiling is bounded: even a fully-joined heavy PR is a few dollars, consistent with
Budget 3's ~$0.125/job × 4–9 jobs/PR.

**Human review rounds per merged PR** (`review-rounds.sh`, 190 merged bot PRs — a far
larger and more complete sample than the machine join):

| stat | human review rounds/merged PR |
| --- | --- |
| mean | **1.75 – 2.41** (depending on which reviewers count as "the maintainer") |
| median | **1.0** |
| p90 | **4 – 5** |
| max | **12 – 27** |
| PRs with ≥1 human review | **88–91%** |
| PRs with zero human review | **9–12%** |

**The dominance, priced illustratively** at 12 min/round and $150/hr (= $30/round):

| | per merged PR |
| --- | --- |
| MachineCost (median / mean / max) | $0.16 / $0.59 / $5.17 |
| HumanReviewCost (median 1 round / mean ~2.3 rounds) | **$30 / ~$69** |
| **Human ÷ machine** | **~50–190× at the median, ~13× at the costliest PR** |

The ratio holds across the whole parameter box: even at a floor of 5 min/round and
$100/hr ($8.33/round), a single median review round ($8.33) still dwarfs the median
machine cost ($0.16) by ~50×. **There is no plausible `(t_r, w)` at which machine cost
is the thing to optimise.**

## Comparing two triples on real data

A `(model, harness, memory)` triple is a fleet *configuration*. The journal keys
reputation arms by `(provider, model, thoughtfulness)` (the **model** axis) × `kind`
(the **harness**) — so two of the three axes are observable. The comparison below is
of the two triples that actually have enough merged-PR data to compare; every other
arm is too thin (see the confidence table).

Holding **memory constant** (see the gap below) and both at journal-recall memory:

| axis | **Triple A** | **Triple B** |
| --- | --- | --- |
| model | anthropic / claude-default | openai / gpt-5.6-terra |
| harness | `gardener` | `cleric` |
| memory | journal-recall | journal-recall |
| reputation events | 501 | 602 |
| acceptance rate | ~100% | ~100% |
| mean attempts/job (rework proxy) | 1.37 | 1.33 |
| machine $/s (rate card) | 0.000069 (flat, amortised) | unmeasured → priced at ceiling |
| **merged PRs joined** | **25** | **24** |
| **mean HUMAN review rounds/PR** | **1.88** (median 1) | **1.96** (median 1) |

**Finding: on the dominant axis the two triples are indistinguishable.** 1.88 vs 1.96
human review rounds, both median 1 — well inside noise at n≈25. The machine-cost
difference between them is real on paper but (a) is dwarfed by the shared ~2 review
rounds, and (b) is not even a real-money difference, because gpt-5.6-terra's cost is
*unmeasured* (metered $0, priced at the ceiling), not cheap. **So there is no
defensible basis in current data to prefer either triple** — the thing that would
justify a choice (fewer human review rounds) does not separate them.

### The one arm that clearly loses — and why it is not a triple result

**moonshot/kimi-k3** under the `mystic` harness has a **31% acceptance rate** across
88 reputation events — i.e. ~69% of Kimi engagements produce rejected work that never
becomes a PR, a ~3× rework multiplier *before* any review round. Combined with its
rate-card price of $0.001338/s (~19× Anthropic's amortised $0.000069/s), Kimi loses
on machine efficiency decisively. **But its merged-PR sample is only n=3**, far too
thin to measure its human-review burden — so this is an *arm-acceptance* finding, not
a costed-triple finding. It says "Kimi wastes machine work," not "Kimi costs more
human review." Do not upgrade it past what the sample supports.

### Machine review that buys no verdict is real cost, too

The `panel` harness (the gauntlet's review segment) spends ~28 juror-seat LLM calls
per run. Of 54 recorded panel runs, **31 terminated in an error state and only 5
passed** — panel machine cost that returned no usable verdict is a real charge against
the same budget, and it is *harness* cost, not model cost. It is folded into the
supervising gardener event's wallclock rather than billed as 28 separate arms, so
`cost-by-pr.sh` already captures it inside the PR's machine total; it is called out
here so a triple that swaps the harness is understood to move this cost with it.

## The memory axis has no data — a hard gap, stated not papered over

The third axis of the triple — **memory** (journal recall, the context library,
per-agent MEMORY files) — has **zero variation** in the corpus. Every reputation
event was recorded under the same journal-recall memory configuration; nothing in the
event schema records a memory mode, and no A/B of memory configurations was ever run.
**Therefore the memory axis of a `(model, harness, memory)` triple cannot be evaluated
from journal data at all.** Any claim that memory config X costs more or fewer review
rounds than Y would be fabricated. To make this axis measurable, a future change must
(a) record the memory mode on each engagement, and (b) run at least two memory modes
against comparable work — neither exists today.

## Confidence of each figure — and what is too thin to act on

| figure | value | confidence | act on it? |
| --- | --- | --- | --- |
| Machine cost per merged PR, *relative ranking* | #882 $5.17 > #713 $5.07 > … | **moderate–high** (deterministic join, lower bounds) | yes, for ranking |
| Machine cost per merged PR, *absolute* | mean $0.59 / median $0.16 | **moderate** (29% join, lower bounds) | as a floor only |
| Garden *lifetime* machine spend | $247 measured vs $517.70 true | **low** — do NOT publish $247 as lifetime cost | no |
| Human review rounds/merged PR | mean ~2, median 1, p90 ~5 | **high** (direct GitHub count, n=190) | yes |
| HumanReviewCost in dollars | $20–$115/PR | **parameter-bound** (rounds solid; $/min & min/round unmeasured) | as a range, never a point |
| Human review ≫ machine cost | ~50–190× at median | **high** (robust across the whole parameter box) | **yes — the load-bearing conclusion** |
| Triple A vs Triple B on review rounds | 1.88 vs 1.96 | **sufficient to say "indistinguishable," insufficient to prefer either** | no preference |
| Kimi acceptance | 31% over 88 events | **moderate** (clear at the arm level) | yes, as "Kimi wastes machine work" |
| Kimi's *human-review* cost | — | **insufficient** (n=3 merged PRs) | no |
| Any memory-axis comparison | — | **no data** | no — fabrication risk |

## How to set a budget from this

1. **Do not set a machine-token budget as if it were the constraint.** At ~$0.125/job
   true cost the fleet cannot exhaust $400/month on machine time in the way naive
   list-price accounting (~$247–$3,900 of notional/ceiling dollars) suggests. The
   binding constraint is the flat subscription's *rate limit* (the existing
   `usage-meter.sh` quota gate), not a dollar ledger.
2. **Budget the scarce input: maintainer review rounds.** ~2 rounds/merged PR × the
   merge rate is the real spend of the operation. Track review-rounds/PR over time
   with `review-rounds.sh`; a triple or process change *pays for itself only if it
   lowers that number*, and *costs* if it raises it — regardless of machine savings.
3. **Choose triples to minimise review rounds to acceptance, machine cost as
   tiebreaker.** Today the data does not separate the two viable triples on review
   rounds, and cannot see memory at all — so the honest recommendation is: *keep the
   cheapest-machine viable arm (Anthropic, amortised $0.000069/s) and instrument the
   review-round and memory axes before spending effort chasing a machine-cost
   difference that is already noise.*
