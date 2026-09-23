---
title: Polarity — related settled points (`Absent`, negated optionals, negation placement)
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

> Abstract: Three settled points around negation polarity. **`Absent` matches nothing** in any scalar slot, in both polarities: in positive position this is filter-by-default semantics, and under negation it makes "Bob has no nickname" *pass* "unless the nickname is banned" rather than being treated as having every banned nickname. **`unless` over a `maybe` premise is rejected at analysis** (`NegatedOptional`) because the optional lookup always yields a row for a bound entity, so its negation is vacuously false. **Negation placement is structural, not a cost accident:** a negation's named variables are hard requirements in its schema, so it is feasible only after its binders have run.

## Related settled points

- `Absent` matches nothing in any scalar slot, in both polarities. In positive position this is the filter-by-default semantics; under negation it makes "Bob has no nickname" pass "unless the nickname is banned" instead of being treated as having every banned nickname in the store.
- `unless` over a `maybe` premise is rejected at analysis (`NegatedOptional`): the optional lookup always yields a row for a bound entity, so its negation is vacuously false.
- Negation placement is structural, not a cost accident: a negation's named variables are hard requirements in its schema, so it is feasible only after its binders have run.

Source: [notes/polarity-and-negation.md](https://github.com/dialog-db/dialog-db/blob/ebd8f73989dd785697e58d31495dbb056c9f6c8b/notes/polarity-and-negation.md) at commit `ebd8f739`.
