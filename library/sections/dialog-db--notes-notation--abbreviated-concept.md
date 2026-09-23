---
title: Abbreviated notation — concept
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

> Abstract: How the abbreviated notation writes concepts. A concept may **reference** pre-defined attributes by address instead of inlining them (`with: { name: io.gozala.person/name }`). The same can be written more concisely by **punning** — `.` references the same-named attribute under the current domain, so `name: .` expands to `io.gozala.person/name` by inheriting the field name and the concept's domain (`io.gozala/Person` normalizes to `io.gozala.person`). Attribute definitions can also be **inlined** inside a concept in abbreviated form: the domain is derived by lowercasing the concept label and appending it as a segment (`diy.cook/RecipeStep` → `diy.cook.recipe-step/`), so a `name` inlined under `io.gozala/Person` lives at `io.gozala.person/name` and is referenceable from anywhere by that path. Planned-but-unshipped: optional fields under a `maybe` key.

### Attribute references

A concept can reference pre-defined attributes by address instead of inlining them:

```yaml
io.gozala:
  Person:
    description: Description of the person
    with:
      name: io.gozala.person/name
      address: io.gozala.person/address
```

### Punning

The same can be expressed more concisely through punning, where `.` references the same-named attribute under the current domain:

```yaml
io.gozala:
  Person:
    description: Description of the person
    with:
      name: .
      address: .
```

`name: .` expands to `io.gozala.person/name` by inheriting the field name and the concept's domain (`io.gozala/Person` normalizes to `io.gozala.person`).

### Inline attributes

Attribute definitions can be inlined inside a concept in abbreviated form. The domain is derived by lowercasing the concept label and appending it as an additional segment:

```
diy.cook/RecipeStep  ->  diy.cook.recipe-step/
```

A `name` and `address` defined inline (with `description`/`as`) inside `io.gozala/Person` live at `io.gozala.person/name` and `io.gozala.person/address` and can be referenced from anywhere by those paths (each expanding to the full `{ the, cardinality, as }` form).

### Future concept extensions (not yet supported)

Optional fields use the `maybe` key:

```yaml
diy.cook:
  RecipeStep:
    description: A cooking step
    with:
      instruction: .
    maybe:
      after:
        description: Step to perform this after
        as: .RecipeStep
```

Source: [notes/notation.md](https://github.com/dialog-db/dialog-db/blob/bde506d786a080291051b2e069cabe38cda769b2/notes/notation.md) at commit `bde506d7`.
