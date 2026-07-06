---
title: Abbreviated notation — addressing
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

> Abstract: The **abbreviated notation** is a YAML-only shorthand that expands into the formal notation, inferring details from the enclosing context and adding an addressing scheme so attributes and concepts can be referenced without inlining their full definitions. Since `domain/name` is usually unique enough in one application context, it serves as a practical shorthand, and every abbreviated address expands to a structural reference. Three addressing modes: **implicit** — the label under which an attribute is defined implies its *name*, the enclosing key implies its *domain* (`diy.cook: { quantity: {...} }` ⇒ `the: diy.cook/quantity`, `cardinality: one`); **relative** — `.` means same name and same domain (inheriting from label + enclosing concept domain, e.g. `Ingredient` under `diy.cook` gives domain `diy.cook.ingredient`), `.name` means explicit name with inferred domain; **fully qualified** — a bare `domain/name` crosses domain boundaries explicitly.

The abbreviated notation is a YAML-only shorthand that expands into the formal notation. It infers details from the enclosing context and introduces an addressing scheme for referencing attributes and concepts without inlining their full definitions.

### Addressing

Since `domain/name` is usually unique enough to identify an attribute in a single application context it serves as a practical shorthand. (It is highly unlikely to have several attributes for the same relation but with different types or cardinality.) All abbreviated addresses expand to structural reference in the formal notation.

**Implicit addressing.** The **label** under which an attribute is defined implies its name; the **enclosing key** implies its domain:

```yaml
diy.cook:
  quantity:
    description: Amount needed
    as: UnsignedInteger
```

expands to `{ the: diy.cook/quantity, cardinality: one, as: UnsignedInteger }`. The label `quantity` becomes the name, the enclosing key `diy.cook` becomes the domain, and `cardinality` defaults to `one`.

**Relative addressing** reduces repetition by making references relative to the context they appear in.

- **`.`** — same name, same domain. When used as a concept field value, inherits both from the label and enclosing concept domain. Under `diy.cook`, a concept `Ingredient` with `with: { quantity: . }` produces the attribute domain `diy.cook.ingredient` (concept label lowercased and appended as a segment) and the field name `quantity`, giving `diy.cook.ingredient/quantity`.
- **`.name`** — explicit name, inferred domain. `name: .ingredient-name` overrides the field name to `ingredient-name` while keeping the inferred domain.

**Fully qualified addressing.** A bare **`domain/name`** crosses domain boundaries explicitly — e.g. an `Ingredient` field `name: io.gozala.person/name` is backed by an attribute from a completely different domain.

Source: [notes/notation.md](https://github.com/dialog-db/dialog-db/blob/bde506d786a080291051b2e069cabe38cda769b2/notes/notation.md) at commit `bde506d7`.
