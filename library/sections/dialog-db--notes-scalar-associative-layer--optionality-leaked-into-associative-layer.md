---
title: The root cause — optionality leaked into the associative layer
source: notes/scalar-associative-layer.md
source_repo: dialog-db/dialog-db
source_commit: ebd8f73989dd785697e58d31495dbb056c9f6c8b
source_date: 2026-07-01
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query]
status: current
---

> Abstract: An investigation note mapping the boundary for a restructure: the associative (raw EAV / triple) layer should operate on **scalars only** (`the(of, is)` with a present value) and all optionality (`Option`, `Absent`, set-widening) belongs in the **semantic** (concept) layer, composed from scalar scans. The root cause behind the #348 bug and the unplannable standalone-optional query is that optionality leaked *down* into the associative `AttributeQuery`: the concept layer pushes a set-widened (`Option`-kinded) `is` term into a raw triple scan and the scan itself implements the `Absent` fallback. That entanglement causes #348 (an optional scan with an unbound entity correctly suppresses its `Absent` fallback — "absent for whom?" needs a known entity — but still leads the scan, silently dropping entities lacking the fact), the unplannable query (`the!("person/name").of(?this).maybe(?name)` standalone asks a scalar lookup to express "every entity, set-widened," which a triple scan cannot soundly do), and feasibility awkwardness ("can an optional scan lead?" is a question that only exists because the associative layer knows about optionality — remove it and the question vanishes). The fix is layering, not a planner heuristic: the associative layer is scalar; the semantic layer set-widens. What the associative layer carries today and must remove (all in `src/attribute/query/`): the `Resolution` enum (`Required`/`Optional`), `resolution()` derived from `is.is_optional()`, the `Absent` fallback in evaluation (`all.rs` ~L266-307, `entity_known = of.is_constant()`, `bind_absent`, the `!produced && is_optional && entity_known && …` guard), the optional-widening of the `is`/`cause` schema/content-type, and the `of`-is-required #348 patch (a symptom to revert). After: `AttributeQuery` is a scalar triple lookup — `is` is always present, no `Resolution`, no `Absent`, no `entity_known` guard, uniform feasibility.

The associative (raw EAV / triple) layer should operate on **scalars only** (`the(of, is)` with a present value) and all optionality (`Option`, `Absent`, set-widening) belongs in the **semantic** (concept) layer, composed from scalar scans. This is the real root cause behind the #348 bug and the unplannable standalone-optional query.

## The problem (root cause)

Optionality leaked *down* into the associative `AttributeQuery`. The concept layer pushes a set-widened (`Option`-kinded) `is` term into a raw triple scan, and the scan itself implements the `Absent` fallback. That entanglement causes:

- **#348:** an optional scan with an unbound entity suppresses its `Absent` fallback (correctly, "absent for whom?" needs a known entity) but still leads the scan, silently dropping entities lacking the fact.
- **The unplannable query:** `the!("person/name").of(?this).maybe(?name)` standalone — a scalar lookup is being asked to express "every entity, set-widened," which a triple scan cannot soundly do.
- **Feasibility awkwardness:** "can an optional scan lead?" is a question that only exists because the associative layer knows about optionality. Remove optionality from it and the question vanishes.

**The fix is layering, not a planner heuristic:** the associative layer is scalar; the semantic layer set-widens.

## What the associative layer carries today (to remove)

`Resolution` (28 refs across 4 files) + the Absent-fallback machinery (~30 refs), all in `src/attribute/query/`:

- `Resolution` enum (`Required` / `Optional`): `attribute/query.rs`.
- `resolution()` derived from `is.is_optional()`: `all.rs`, `only.rs`, `dynamic.rs`.
- The `Absent` fallback in evaluation (`all.rs` ~L266-307): `entity_known = of.is_constant()`, `bind_absent(is)`, `bind_absent(cause)`, the `!produced && is_optional && entity_known && …` guard.
- The optional-widening of the `is` (and `cause`) schema/content-type for optional queries.
- The `of`-is-required change made for #348: a symptom patch that should be reverted; with a scalar layer there is no optional scan to special-case.

After: `AttributeQuery` is a scalar triple lookup. `is` is always a present value (or a variable bound to one). No `Resolution`, no `Absent`, no `entity_known` guard. The schema's `is`/`of`/`cause` are plain required/grouped slots; the feasibility model is uniform (every attribute scan is a normal scan).

Source: [notes/scalar-associative-layer.md](https://github.com/dialog-db/dialog-db/blob/ebd8f73989dd785697e58d31495dbb056c9f6c8b/notes/scalar-associative-layer.md) at commit `ebd8f739`.
