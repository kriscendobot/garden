---
role: assayer
handler-timeout: 7200
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-08-02T22:29:52Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
handler-timeout: 7200

# Budget 4/5 — human-review cost and the (model, harness, memory) triple

Fourth child of orchestration `garden-budget-attribution`. Runs after
`garden-budget-prs`; read its `tada/` report first. If per-PR attribution did not
land with defensible coverage, report that and stop.

## Goal

With machine cost per merged PR established, add the **heuristic cost of human
review** so the garden can evaluate a **(model, harness, memory) triple** and
estimate **the cost of an issue**.

## Inputs already in the journal

- `journal/reputation/` — arms are already keyed `(kind, provider, model,
  thoughtfulness)` × work-class × target. That is most of the *model* axis and
  part of *harness*.
- `journal/review-misses/` — 172 records with `missed_by:`, `category:`,
  `severity:`. The evaluator-failure signal; note 134 of 172 are
  `category: new-direction` (a maintainer changing course, **not** an evaluator
  failure), so the usable quality signal is roughly 20 records. Do not quote 172
  as if it were all defect data.
- `journal/panel-runs/` — 54 runs. Note **31 of 54 terminated in an error state**
  (`seat-error` / `error` / `decider-error`); only 5 passed. Panel cost that buys
  no verdict is a real charge against the budget and belongs in the model.
- PR review threads on GitHub — the human-review signal itself.

## The human-review heuristic

The maintainer's own calibration anchor is recorded in
`journal/reputation/rate-card.md` § Calibration anchor. Human review time is the
scarce input the garden cannot buy with the $400/month, so a triple that halves
machine cost while doubling review rounds is a **worse** triple. Make that
tradeoff explicit in whatever metric you propose; do not optimize machine cost
alone.

## Definition of done

A documented method for costing an issue end to end (machine + heuristic human
review), a comparison of at least two (model, harness, memory) triples on real
journal data, and a `tada/` report stating the confidence of each figure and
which are too thin to act on. Prefer "insufficient evidence" over a number you
cannot defend — the maintainer is setting a budget from this.


---

## AMENDED 2026-08-02 by the liaison — children 1-3 have landed

Read all three tada reports first: `garden-budget-ratecard`,
`garden-budget-ledger`, `garden-budget-prs`.

### Two traps the liaison already walked into — do not repeat them

**1. `cost.sh`'s dollar column is NOTIONAL.** The liaison's amendment to child 3
told it to aggregate through `cost.sh`. Child 3 correctly **refused**: `cost.sh`
sums raw `total_cost_usd` from `usage/*.jsonl`, which on a flat subscription is
API list price (an Opus job reads $6.35 against ~$0.20 of real cost). Use
`cost.sh` for coverage, shape, and grouping — **never for money**. Price the way
child 3 did: each reputation event's **capped proxy wallclock x the journal rate
card** (`rep_estimated_dollars`), over `reputation/events/` (1910 events — far
better coverage than the 456 usage rows, and it carries provider/model/duration).

**2. The cap is landed but NOT DEPLOYED.** Child 3 found the deployed root still
runs the *pre-cap* `rep_wallclock_index` — one PR's span reads 1,918,858 s (22
days of reap idle) against 7,008 s capped. So the **live reducer is still pricing
on inflated spans**. Source the worktree's capped version as child 3 did, and do
not trust numbers produced by the deployed reducer. The liaison will deploy at
the end of this chain.

### What child 3 established, and its honest limits

- **`scripts/jobs/cost-by-pr.sh`** — deterministic base→PR join via the
  `jobs/index` directive identity plus PR-shaped tokens validated against the
  repo's real PR set. Reuse it; do not rebuild the join.
- **Join coverage 29.0%** (553 of 1910 priced bases) → 182 PRs, 77 merged.
- **Measured total $247 all-time**; top merged PRs ebfb #882 $5.17, #713 $5.07,
  #848 $4.86, #723 $3.02.
- **CEILING column $3,929** (openai/unknown) is deliberately **not money** — the
  ChatGPT plan meters $0 and the card prices it high so an unmeasured arm cannot
  win on false cheapness. Keep it out of any total you publish.
- **Unattributed: 1357 jobs**, $138 measured.

### A reconciliation gap you should address head-on

Child 3's measured all-time total is **$247**. The true subscription spend over
the journal's 39-day life is **$517.70**. These do not reconcile, for two reasons
child 3 named: join/pricing coverage is partial, and child 1's anthropic $/s was
calibrated on a **5-day window** but is being applied all-time, so it drifts from
the flat $13.33/day.

Relative per-PR ranking is sound; the absolute total is not. If your issue-cost
estimate needs an absolute figure, either re-derive the rate over the period you
are costing, or state the gap explicitly. **Do not present a number that implies
the garden's lifetime cost is $247.**

### Your own scope, unchanged

Human review time is the scarce input the $400/mo cannot buy. A triple that
halves machine cost while doubling review rounds is **worse**. At ~$0.125/job
true cost, machine spend is close to noise against human attention — say so if
the evidence supports it, rather than optimizing the cheap side of the ledger.

Prefer "insufficient evidence" to a number you cannot defend. Recall the usable
quality signal is ~20 of 172 review-misses (134 are `new-direction`, not
defects), and 31 of 54 panel runs bought no verdict at all.
