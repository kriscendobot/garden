---
title: Attribute (formal notation)
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

> Abstract: An **attribute** is a relation elevated with domain-specific invariants — it extends a relation's `domain/name` identifier (`the`) with a value type (`as`) and a cardinality constraint. Identity is structural, `(the, type, cardinality)`; `description` is part of the definition but not the identity. The `as` field admits eight built-in scalar types from the `dialog` domain (`Bytes`, `Entity`, `Boolean`, `Text`, `UnsignedInteger`, `SignedInteger`, `Float`, `Symbol`); if omitted, any type is allowed. **Cardinality** governs succession: `one` (default) retracts the prior claim so at most one value exists at a time, `many` accumulates claims alongside existing ones — a *semantic-layer* decision the indifferent associative layer beneath does not make. Planned-but-unshipped extensions: an attribute referencing a concept as its value type, and constraining values to a fixed symbol set.

An attribute is a relation elevated with domain-specific invariants. It extends a relation's `domain/name` identifier with type and cardinality constraints, specifying what kind of values the association admits and how many. An attribute's identity is structural: `(the, type, cardinality)`. The `description` field is part of the attribute definition but not part of its identity; two attributes with the same structure but different descriptions are the same attribute.

```yaml
description: Name of the person
the: io.gozala.person/name
cardinality: one
as: Text
```

Schema (`Attribute`): `the` (required, the relation in `domain/name` format), `cardinality` (`one` | `many`, default `one`), `as` (one of the scalar-type enum), `description` (human-readable, non-identity).

### Value Types

The `as` field declares what kind of value the attribute admits. Scalar types from the `dialog` domain can be referenced without qualification:

| Type | Description |
|------|-------------|
| `Bytes` | Raw byte sequence |
| `Entity` | Reference to another entity |
| `Boolean` | `true` or `false` |
| `Text` | UTF-8 string |
| `UnsignedInteger` | Unsigned integer |
| `SignedInteger` | Signed integer |
| `Float` | IEEE 754 floating point |
| `Symbol` | Symbolic identifier |

### Future attribute extensions (not yet supported)

An attribute will also be able to reference a concept as its value type (an inline `{ description, with: {...} }` under `as`), or constrain values to a fixed set of symbols (`"as": ["diy.cook/tsp", "diy.cook/mls"]`). Neither is yet supported.

### Cardinality

Cardinality governs what happens when a new claim is asserted for an attribute an entity already has a value for.

- `one` (default): asserting a new value retracts the prior claim so at most one value exists at a time.
- `many`: new claims are added alongside existing ones.

The associative layer beneath is indifferent to cardinality; it is the semantic layer that decides what to do with prior claims before asserting new ones.

Source: [notes/notation.md](https://github.com/dialog-db/dialog-db/blob/bde506d786a080291051b2e069cabe38cda769b2/notes/notation.md) at commit `bde506d7`.
