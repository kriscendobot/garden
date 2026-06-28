---
id: e-guards
aliases: ["E guards", "e-guards", "soft type checking", "soft type-checking", "coerce-or-reject", "coerce or reject", ":Guard", "guard annotation", "reference-state guard", ":near guard", ":vow guard", ":rcvr guard", ":pbc guard", ":any guard", "Guarding Asynchrony"]
topics: [e-language, pass-style, eventual-send]
status: current
---

# e-guards

A **guard** in E is a first-class object that sits between a value and its use and
either **coerces** the value into a guaranteed shape or **rejects** it. Guards
appear in two surface positions: on a definition pattern (`def x :Guard := expr`)
and on a function or method return (`def name(patterns) :Guard { … }`). Because a
guard is itself an ordinary object, guards **compose** and are first-class. E
calls this **soft type checking**: enforcement happens at runtime at the guard's
coercion point, not in a static type system, giving an object the defensive-
programming guarantee it needs to validate the messages it receives from
mutually-suspicious callers. One family is the **reference-state guards** (`:near`,
`:pbc`, `:vow`, `:rcvr`, `:any`) that annotate whether a reference supports
immediate calls or only eventual sends. E guards are the direct ancestor of
Endo's coerce-or-reject **patterns / guards** in `@endo/patterns` and the
`M.interface(...)` method guards exo classes use; the syntactic root is the kernel
`: eExpr` guard hook on patterns.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [erights--elang-guarding--soft-type-checking-map](../sections/erights--elang-guarding--soft-type-checking-map.md) | The Soft-Type-Checking guards hub: coerce-or-reject objects on `:Guard` patterns and returns; first-class composable runtime validation; the Endo lineage. |
| [erights--elang-guarding-async--reference-state-guards-for-asynchrony](../sections/erights--elang-guarding-async--reference-state-guards-for-asynchrony.md) | The reference-state guards (`:near`, `:pbc`, `:vow`, `:rcvr`, `:any`) and the proposed `near <= vow <= rcvr` static-checking lint ruleset. |
| [erights--elang-kernel--pattern-forms-and-helpers](../sections/erights--elang-kernel--pattern-forms-and-helpers.md) | The kernel `: eExpr` guard hook on patterns — the syntactic ancestor of `@endo/patterns`. |
| [endo--pkg-patterns-readme--interface-guards](../sections/endo--pkg-patterns-readme--interface-guards.md) | The Endo realization: `M.interface(...)` method guards that validate calls against per-method argument and return shapes. |
| [endo--pkg-pass-style-readme--type-guards](../sections/endo--pkg-pass-style-readme--type-guards.md) | The pass-style type-guard predicates the pattern layer builds on. |

## See also

- [[pass-by-construction]] — the object-passing taxonomy the `:pbc` reference-state guard names.
- [[eventual-send]] — the near/eventual reference distinction the `:vow` / `:rcvr` guards annotate.
- [[brand-and-trademark]] — rights-amplification primitives that include interface guards as a types-by-fiat mechanism.
