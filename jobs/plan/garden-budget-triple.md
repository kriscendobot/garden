---
gate: orchestrated
orchestrated_by: garden-budget-attribution
priority: normal
role: assayer
posted_by: producer
posted_at: 2026-08-02T21:05:40Z
---

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
