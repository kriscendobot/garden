---
title: Abbreviated notation — attribute
source: notes/notation.md
source_repo: dialog-db/dialog-db
source_commit: bde506d786a080291051b2e069cabe38cda769b2
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query]
status: current
---

> Abstract: How the abbreviated notation writes attributes. It infers `the` and `cardinality` from document structure — an immediate label implies the attribute name, the enclosing key implies the domain, and cardinality defaults to `one`. Two overrides let the reference label diverge from the actual relation: **`the: ./name`** overrides the inferred *name* while keeping the domain from context (so a label `quantity-int` can back the relation `diy.cook/quantity` yet stay referenceable as `diy.cook/quantity-int`); **`the: domain/.`** overrides the inferred *domain* while keeping the name from the label. Planned-but-unshipped extensions mirror the formal ones: concept-typed values via a dot-prefix (`as: .Ingredient` ⇒ `diy.cook/Ingredient`) and symbol enumerations via array syntax (`as: [:tsp, :mls]` ⇒ one of `diy.cook/tsp`, `diy.cook/mls`).

The abbreviated notation infers `the` and `cardinality` from document structure. An immediate name implies attribute name, and enclosing key implies attribute domain. Cardinality when omitted defaults to `one`.

**Overriding name.** Use `the: ./name` to override the inferred attribute name while keeping the domain from context:

```yaml
diy.cook:
  quantity-int:
    the: ./quantity
    description: Quantity as a whole number
    as: UnsignedInteger
```

expands to `{ the: diy.cook/quantity, cardinality: one, as: UnsignedInteger }`. The label `quantity-int` is the key used for referencing this definition, but `the` overrides the actual attribute name to `quantity`. This attribute is referenceable as `diy.cook/quantity-int` in the abbreviated notation.

**Overriding domain.** Use `the: domain/.` to override the inferred domain while keeping the name from the label:

```yaml
diy.cook:
  quantity:
    the: io.gozala.person/.
    description: Quantity as a person attribute
    as: UnsignedInteger
```

expands to `{ the: io.gozala.person/quantity, cardinality: one, as: UnsignedInteger }`. The name `quantity` comes from the label, but the domain is overridden to `io.gozala.person`.

**Future attribute extensions (not yet supported).** Concept references use dot-prefix notation and symbol enumerations use array syntax:

```yaml
diy.cook:
  ingredient:
    description: An ingredient in a recipe
    as: .Ingredient
  unit:
    description: The unit of measurement
    as: [:tsp, :mls]
```

`.Ingredient` resolves to `diy.cook/Ingredient` within the current domain. `[:tsp, :mls]` means the value must be one of the symbols `diy.cook/tsp` or `diy.cook/mls`.

Source: [notes/notation.md](https://github.com/dialog-db/dialog-db/blob/bde506d786a080291051b2e069cabe38cda769b2/notes/notation.md) at commit `bde506d7`.
