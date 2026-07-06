---
title: Inference in an open world — soundness without closed-world knowledge
source: notes/guide.md
source_repo: dialog-db/dialog-db
source_commit: 3cd6607aa9e6f70d65bafe7692e1a52b953e1faf
source_date: 2026-07-01
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query]
status: current
---

> Abstract: No annotation is ever required — inference reconstructs everything reconstructable (slot kinds, concept schemas, formula schemes), and an untyped wire concept compiles fine with its fields simply wide. The guarantee a compiled rule carries: *a rule that compiles never produces a runtime type error, and every row it yields inhabits its inferred types* — the closed-world (Elm-style) soundness property restated for an open world. Because the data layer is schema-on-query (an attribute may hold values of several types across facts, and wire concepts need not declare field types), no inference can make unknown data known at compile time; where inference can only establish a *bound* (NUMERIC, or "any present value"), that bound's runtime meaning is the filter semantics — types narrow on use and rows outside the narrowed type are non-matches. The worked example (`person/age` undeclared, feeding `math/sum`) stamps a NUMERIC bound onto the age scan: `age = 30` instantiates unsigned → `31`, `age = 2.5` instantiates float → `3.5`, `age = "old"` is filtered at the scan before the formula runs; and a sibling premise demanding `?age` as `String` would fail to compile (known types misaligned). Two consequences: there is **no implicit numeric promotion** (a row mixing unsigned and float in one scheme variable is a non-match, since dialog's value lattice has no arbitrary-precision type to promote into — conversions are explicit formulas, parallel to `Coalesce`), and because exclusion is silent by design the inference is **inspectable** — `TypeEnv::explain()` / `narrowings()` render each variable's final kind and premise-by-premise narrowing, and `TypeEnv::dead_optionality()` flags fields declared optional that the rule's other premises require present (sound, but never able to carry `Absent`).

No annotation is ever required. Inference reconstructs everything reconstructable — slot kinds, concept schemas, formula schemes — and an untyped wire concept compiles fine; its fields are simply wide. The guarantee a compiled rule carries:

> A rule that compiles never produces a runtime type error, and every row it yields inhabits its inferred types.

This is the closed-world (Elm-style) soundness property restated for an open world. The data layer is schema-on-query: an attribute may hold values of several types across facts, and wire concepts need not declare field types, so no amount of inference can make unknown data known at compile time. Where inference can only establish a *bound* (say NUMERIC, or "any present value"), the bound's runtime meaning is the filter semantics above: types narrow on use, and rows outside the narrowed type are non-matches. One worked example, with `person/age` undeclared on the wire:

```rust
// person/age(?p, ?age)
// math/sum { of: ?age, with: 1, is: ?next }
```

Analysis puts `?age` and `?next` in one type variable bounded NUMERIC (the formula's scheme) and stamps that bound onto the age scan. Then, per row: an entity with `age = 30` (unsigned) instantiates the variable to unsigned, the literal `1` follows losslessly, and `?next = 31`; an entity with `age = 2.5` instantiates to float and yields `3.5`; an entity whose `age` fact is the *string* `"old"` is filtered at the scan by the stamped bound, before the formula ever runs. And if some other premise in the same rule demanded `?age` as a `String`, the rule would not compile: there the types were known, and they misalign.

Two consequences worth naming. There is no implicit numeric promotion: a row mixing unsigned and float inputs in one scheme variable is a non-match, not a lossy widening (dialog's value lattice has no arbitrary-precision type to promote into, so promotion would trade "row excluded" for "row matched with a quietly wrong value"). Conversions are explicit formulas, parallel to `Coalesce` being the explicit form of defaulting. And because exclusion is silent by design — the excluded fact may be someone else's perfectly valid data — the inference is *inspectable*: `TypeEnv::explain()` renders each variable's final kind and the premise-by-premise narrowing steps that produced it (`TypeEnv::narrowings()` is the structured form), and `TypeEnv::dead_optionality()` reports any field declared optional that the rule's other premises require present — sound (the optional lookup is demoted to a plain scan) but almost certainly not what the author meant, since no result can ever carry that field as `Absent`.

Source: [notes/guide.md](https://github.com/dialog-db/dialog-db/blob/3cd6607aa9e6f70d65bafe7692e1a52b953e1faf/notes/guide.md) at commit `3cd6607a`.
