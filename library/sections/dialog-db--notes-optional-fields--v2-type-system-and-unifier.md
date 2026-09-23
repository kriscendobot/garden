---
title: The v2 type system and unifier — the flatter shipped form
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

> Abstract: The proposed v2 type descriptor was a two-constructor enum — `Type::Definite(Box<Definite>)` and `Type::Optional(Box<Definite>)` (the set-widened `Definite ∪ {Absent}`, one level only because the wrapped type is `Definite` not `Type`) — over a `Definite` of `Primitive(PrimitiveSet)` (a `u16` bitfield union of primitive shapes) and `Variable(VarId)` (a type variable whose constraint lives in a `UnificationContext` constraint registry), with `Record`/`Variant` reserved for the future. What **shipped** is flatter: `type_system::Type` with `Primitive(Primitive)` and `Composite(Primitive, BTreeSet<Composite>)`, where optionality is a `Nothing` bit inside the same `Primitive` bitfield rather than a wrapping `Optional` variant — a `Type` carrying `Nothing` *is* the set-widened thing, no separate constructor, and `Type::optional()` is idempotent so nested optionality stays structurally impossible. There is no `Any` variant (untyped slots carry `None` at an `Option<Type>` boundary or use `Primitive::ALL`/`ANY`); `Composite::Product`/`Variant` are placeholders not yet active in inference. The unifier shipped as `type_system::unifier::Context` (Robinson unification: `fresh`, `unify`, `apply`) plus a `names: HashMap<String, VarId>` for per-named-rule-variable allocation; the `Definite ≡ Optional` unification cases collapsed into intersection semantics — optionality is a bit and intersection narrows it correctly. Type schemes are not serialized; concept descriptors and attribute queries serialize concrete types only, "no variables on the wire".

## `Type` and `Definite` (proposed)

```rust
pub enum Type {
    /// A definite shape. Subtype of `Optional(definite)` via the
    /// `T ⊆ Optional<T>` set-widening rule.
    Definite(Box<Definite>),
    /// Set-widened: `Definite ∪ {Absent}`. One level only; nested
    /// optionality is structurally impossible because the wrapped
    /// type is `Definite`, not `Type`. Optionality lives at the slot
    /// layer, not on type variables.
    Optional(Box<Definite>),
}

pub enum Definite {
    /// Atomic value type, possibly a union over several primitive shapes.
    Primitive(PrimitiveSet),
    /// A type variable, anonymous (per-site fresh) or named within a
    /// single type scheme. Its constraint lives in the
    /// UnificationContext's constraint registry, keyed by VarId.
    Variable(VarId),
    // Future: Record(BTreeMap<String, Type>), Variant(BTreeMap<String, Definite>),
}
```

✅ **Shipped as** `type_system::Type` with variants `Primitive(Primitive)` and `Composite(Primitive, BTreeSet<Composite>)`. The shipped form is flatter than the proposed `Definite/Optional` split: optionality is encoded as a `Nothing` bit in the same `Primitive` bitfield, not as a wrapping `Optional` variant. A shipped `Type` carrying `Nothing` *is* the set-widened thing: no separate constructor. Nested optionality is still structurally impossible: `Type::optional()` adds the bit, calling it again is idempotent.

Key structural properties (mostly hold in the shipped form):

- **No `Any` variant.** ✅ The shipped form has no `Any` either. Untyped slots carry `None` at the `Option<Type>` boundary or use `Primitive::ALL` (any present value) / `Primitive::ANY` (any including `Nothing`).
- **Records and variants are reserved as `Composite` cases.** ✅ The shipped `Composite` enum has `Product(BTreeMap<String, Type>)` and `Variant{label, value}`: placeholders, not active in inference yet.

## `PrimitiveSet`

`pub struct PrimitiveSet { bits: u16 }`. ✅ **Shipped as** `type_system::Primitive` (same shape, different name). API matches the proposal closely: `Primitive::ALL`/`NUMERIC`/`STRING_LIKE`/`COMPARABLE`, `intersect`, `singleton`. The shipped version also exposes `Primitive::NOTHING` and `Primitive::ANY` (= `ALL | NOTHING`) that the doc doesn't mention; these are what make the "Nothing bit" encoding work.

## `VarId` and unification

```rust
pub struct VarId(u32);
pub struct UnificationContext {
    substitution: HashMap<VarId, Definite>,
    constraints: HashMap<VarId, PrimitiveSet>,
    next_id: u32,
}
```

✅ **Shipped as** `type_system::unifier::VarId` and `type_system::unifier::Context`. The shipped `Context` also tracks a `names: HashMap<String, VarId>` so the rule-level inference pass can allocate one variable per named rule variable.

Operations: `fresh(constraint) -> VarId` ✅ shipped; `unify(a, b)` Robinson unification ✅ shipped; `apply(ty)` ✅ shipped; `instantiate(scheme)` ⚠️ **not shipped** (nothing constructs `TypeScheme`s, so nothing instantiates them). All unification rules between concrete `Type`s and between variables and concretes are shipped; the `Definite ≡ Optional` cases collapsed into the shipped form's intersection semantics — optionality is just a bit on the primitive set, and intersection narrows it correctly.

## Wire format

✅ **Shipped.** Type schemes are not serialized (they're Rust-side registry data). Concept descriptors and attribute queries serialize their types directly via the existing JSON format. The shipped `Type` enum has a serde representation; it's not the exact shape the doc proposes (`{"definite": ...}` / `{"optional": ...}`) but the underlying property ("concrete types only, no variables on the wire") holds.

Source: [notes/optional-fields.md](https://github.com/dialog-db/dialog-db/blob/ebd8f73989dd785697e58d31495dbb056c9f6c8b/notes/optional-fields.md) at commit `ebd8f739`.
