---
title: A design contract preserved against what shipped
source: notes/optional-fields.md
source_repo: dialog-db/dialog-db
source_commit: ebd8f73989dd785697e58d31495dbb056c9f6c8b
source_date: 2026-07-01
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query]
status: current
---

> Abstract: `notes/optional-fields.md` is Dialog's "Optional Fields & Type System: v2" design, written as a design *contract* before implementation and then annotated in place once the implementation took a smaller path than the contract proposed. The document splits into **what shipped** — the set-widening type system, the unifier-backed rule-level type inference, the `Resolution` policy, and the `Coalesce` constraint, now in `rust/dialog-query/` — and **what didn't ship** — rank-1 polymorphic *formulas* with `TypeScheme`/`SchemeBody`/`SchemeType` and their `instantiate`/`generalize` operations, deferred for want of a concrete consumer. The rest of the note is the original contract, preserved so the historical intent stays visible, with each section carrying a "✅ Shipped as" note pointing at the real type or a "⚠️ Not shipped" note; the reader is warned that names like `TypeScheme`, `SchemeBody`, `SchemeType`, and `SchemeDefinite` do **not** exist in code. This makes the note a rare worked example of a design doc kept honest against its own outcome rather than deleted or left stale.

This document was written as a *design contract* before implementation. The implementation took a smaller path than the contract proposed. The doc has been split:

- **What shipped**: the set-widening type system, the unifier-backed rule-level type inference, the `Resolution` policy, and the `Coalesce` constraint. These are now in code under `rust/dialog-query/`. The shipped pipeline is documented in `notes/rule-pipeline.md`; the type-system shape is in `src/type_system.rs` and `src/type_system/unifier.rs`.

- **What didn't ship**: rank-1 polymorphic *formulas* with `TypeScheme`/`SchemeBody`/`SchemeType`, and the `instantiate` / `generalize` operations that go with them. The schemes were the design's answer to "generic formulas like `math/sum`"; there was no concrete consumer that needed them, so the work was deferred to a follow-up.

The remainder of the document is the original design contract, preserved so the historical intent is visible. **Names like `TypeScheme`, `SchemeBody`, `SchemeType`, and `SchemeDefinite` do not exist in code.** Where a section maps onto something that did ship, an "✅ Shipped as" note points at the real type. Where a section described an unshipped piece, a "⚠️ Not shipped" note marks it.

This ✅/⚠️ annotation discipline is the note's distinguishing feature: rather than rewriting the contract to match reality (losing the design intent) or deleting it (losing the record), each proposed type is annotated with its real fate, so the doc doubles as a design record and a map from proposed names to shipped names.

Source: [notes/optional-fields.md](https://github.com/dialog-db/dialog-db/blob/ebd8f73989dd785697e58d31495dbb056c9f6c8b/notes/optional-fields.md) at commit `ebd8f739`.
