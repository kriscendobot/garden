---
source: compile-binder.js
source_repo: kriskowal/frb
source_commit: 5a0203b2eaac938c4e446e235381579b46105a37
source_date: 2013-07-31
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
section_count: 2
status: current
---

> Abstract: `compile-binder.js` is the `frb/compile-binder` module: it compiles the left-hand side of a binding, asking "how do I write a value back through this expression" where the observer compiler asks "what value does this expression watch." Two sections cover it. The first is the small invertible-roots table (`property`, `get`, `has`, `only`, `rangeContent`, `mapContent`, `reversed`, `and`, `or`) plus the simple per-type cases (`default` unwrap, null-`literal` no-op, `defined`, the terminal `"Can't compile binder"` throw) — showing the invertible set is already broader than the README's "must be a property for now." The second covers the algebraic binders: `equals`, `if`, and the `and`/`or`/`everyBlock` forms that call `algebra.js`'s `solve` to rotate a target expression into a bindable half and an observable half. That `solve` routine (with its `!!x→x`, `""+x→toString(x)`, De Morgan `some→!every!` simplifiers) is the literal mechanism behind the README's "automatic algebraic inversion."

| Section | Topics | Status |
|---------|--------|--------|
| [invertible-roots-and-binder-table](../sections/frb--compile-binder--invertible-roots-and-binder-table.md) | reactive-bindings | current |
| [algebraic-binders-equals-if-and-or](../sections/frb--compile-binder--algebraic-binders-equals-if-and-or.md) | reactive-bindings | current |
