---
title: Polarity, Direction 2 — positive narrowing does not flow into negated subqueries
source: notes/polarity-and-negation.md
source_repo: dialog-db/dialog-db
source_commit: ebd8f73989dd785697e58d31495dbb056c9f6c8b
source_date: 2026-07-01
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query]
status: current
---

> Abstract: **Direction 2 (implemented via `apply_types` rewriting positive premises only, but a judgment call rather than a theorem):** positive narrowing does not flow into negated subqueries. The case for keeping it out (the current choice): a negated subquery is a hypothetical evaluated against its own slots, and typing it from the surrounding rule makes its meaning depend on context its author cannot see; today narrowed kinds affect behavior only through optional-lookup demotion and a `Maybe` cannot appear under `unless` (rejected by the analyzer), so stamping positive kinds into negations is inert — pure hygiene risk that creates the appearance of a dependency; and under future *checked* execution (dialog-db-48+) a stamped kind inside a negation would become load-bearing, so keeping negations self-typed keeps their failure mode singular. The case for letting it flow in (the road not taken): matching is by equality, so a proven positive kind is sound to stamp and could enable a tighter inner index range. Resolution for now: soundness does not require the flow, hygiene mildly argues against it, and the optimization does not exist yet; revisit when checked binds or index-range narrowing make it matter — the change is localized to `apply_types`.

## Direction 2: positive narrowing does not flow into negated subqueries

Implemented (`apply_types` rewrites positive premises only), but this direction is a judgment call rather than a theorem, and is worth revisiting when checked execution lands.

The case for keeping it out (the current choice):

- A negated subquery is a hypothetical question evaluated against its own slots; typing it from the surrounding rule makes its meaning depend on context that its author cannot see at the premise level.
- Today, narrowed kinds influence behavior only through the optional lookup demotion, and a `Maybe` cannot appear under `unless` (the analyzer rejects it), so stamping positive kinds into negations has no behavioral effect. Inert rewrites are pure hygiene risk: they create the appearance that something depends on them.
- Under future *checked* execution (kinds enforced at bind time, dialog-db-48 and beyond), a stamped kind inside a negation would become load-bearing: "no matching row" could turn into a type error path inside the inner query depending on what the positive body happened to prove. Keeping negations self-typed keeps their failure mode singular.

The case for letting it flow in (the road not taken, for now):

- Matching is by equality. If the positive body proves `?x : String` in every surviving row, then any fact the negated lookup matches against `?x` necessarily holds a `String` value, so stamping `String` onto the negated slot is sound and could let a future optimizer pick a tighter index range for the inner probe.
- The asymmetry ("the negation sees the variable's *bindings* at evaluation time but not its *type* at analysis time") is real and slightly odd. Evaluation already leaks the positive context into the negation through the row itself.

Resolution for now: soundness does not require the flow, hygiene mildly argues against it, and the optimization it would enable does not exist yet. Revisit when checked binds or index-range narrowing make the inner typing matter; the change is localized to `apply_types`.

Source: [notes/polarity-and-negation.md](https://github.com/dialog-db/dialog-db/blob/ebd8f73989dd785697e58d31495dbb056c9f6c8b/notes/polarity-and-negation.md) at commit `ebd8f739`.
