---
gate: orchestrated
orchestrated_by: garden-budget-attribution
priority: normal
role: builder
posted_by: producer
posted_at: 2026-08-02T21:05:25Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
handler-timeout: 7200

# Budget 1/5 — put the rate card on a TRUE-cost basis

First child of orchestration `garden-budget-attribution`. Land directly on
`main2` / `journal2` as appropriate — no PR (garden convention). Do **NOT** run
git in `$GARDEN_ROOT`; use your per-job worktree.

## The defect

`journal/reputation/rate-card.md` currently mixes two incompatible bases, and the
auction's Thompson draw consumes the result:

    anthropic/*       0.005154 $/s   <- NOTIONAL (API list price, from usage/*.jsonl)
    moonshot/kimi-k3  0.002772 $/s   <- TRUE (maintainer-authoritative $50 total)
    fireworks/*       0.001883 $/s   <- TRUE (maintainer-authoritative $57 total)

The Anthropic rows are derived from `total_cost_usd` in `journal/usage/*.jsonl`.
On a **Claude Max subscription** that field is what the same tokens *would* cost
at API list price — it is not money that was ever charged. The Kimi and Fireworks
rows were corrected to true cost on 2026-08-01; the Anthropic rows were not.

## The authoritative figures (maintainer, 2026-08-02)

- Two instances, `endolin-garden-ece02cb4` and `endolin-garden2-5bcdff64`, each
  on a **separate** Anthropic account (confirmed by garden2 over the bus,
  `msgs/broadcast/20260802T203952Z-22ee71.md`).
- Each is a Claude Max 20x plan at **$200/month**. Total **$400/month, FLAT** —
  the maintainer states the budget is not exceeded, so there is no overage
  component to model.
- Derived: **$13.33/day**, **$0.000154/s** of wall-clock time, fleet-wide.

Measured against the 5-day metered window (07-28 → 08-02): Anthropic wall-clock
was 94,240 s and notional spend $583.12, against a true subscription cost of
$66.67 for the same window — the notional basis overstates by **8.7x**, implying
a true Anthropic rate near **0.000707 $/s**. Re-derive this yourself rather than
copying it; the window and the wall-clock basis both matter (see the card's own
"re-measure, never rescale" rule and the `[duration basis]` exception already
recorded there).

## The harder question — answer it, don't paper over it

A subscription is **not** metered. Marginal cost per job is ~0 until the plan
limit, then it is either overage or refusal — and the two hosts differ:
`hasExtraUsageEnabled` is `true` on garden, `false` on garden2. So a `$/second`
rate is a modelling convenience, not a fact about how the money behaves.

Decide and document: does the rate card keep a `$/s` shape for Anthropic (with
the fixed cost amortized over measured wall-clock), or does it need a distinct
representation for a fixed-cost rate-limited arm? A wrong-but-consistent number
is better than today's wrong-and-inconsistent one, but say plainly which you
chose and why. If you keep `$/s`, note in the card that the figure is an
amortization of a fixed cost, not a marginal price.

## Also fix

The **attempt-cap defect** already recorded in the card's Open follow-ups:
`GARDEN_REP_ATTEMPT_CAP_SECS` appears only in prose (`rate-card-defaults.md`),
never in code — `rep_wallclock_index` / `rep_proxy_secs` take the uncapped
first-claim-to-tada span, so queue idle is billed as engagement wallclock. This
inflated the proxy basis 11.6x (kimi) and 72.1x (fireworks) during the 07-29
backlog. Implement the cap, then re-measure ALL rows on one basis and retire the
`[duration basis]` exception.

## Definition of done

Rate card rows on one documented basis; the attempt cap implemented with
regression coverage under `scripts/jobs/test/`; the card's Derivations and Open
follow-ups updated. A `tada/` report stating the new Anthropic figure, how it was
derived, and what it changes about relative arm ordering (a true Anthropic rate
makes Anthropic **cheaper** than Kimi, reversing the card's current implication —
confirm or refute that).
