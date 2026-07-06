---
title: Concept (formal notation)
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

> Abstract: A **concept** is a named composition of attributes sharing an entity — the primary unit of domain modeling. It describes the shape of a thing in terms of its relations; an entity matches a concept iff it has claims satisfying all the attributes the concept requires. Identity is structural, derived from the sorted set of constituent attributes; the *name* is not part of identity (two concepts with the same attributes but different names are the same concept), though a realized conclusion can reference attribute values by the names the concept gave them. Fields under `with` are **required** (at least one; the name `this` is reserved for the shared entity and must not appear there); the planned-but-unshipped `maybe` block defines **optional** attributes that do not gate matching but are included in the conclusion when present. In the formal notation all attributes are inlined with their full form.

A concept is a named composition of attributes sharing an entity. It describes the shape of a thing in terms of its relations, the primary unit of domain modeling in dialog. An entity matches a concept if and only if it has claims satisfying all the attributes the concept requires.

The name is not part of the concept's identity; two concepts with the same attributes but different names are the same concept. Identity is structural, derived from the sorted set of constituent attributes. However, when a concept is realized into a conclusion, the attribute values can be referenced by the names the concept gave them.

In the formal notation all attributes are inlined with their full form:

```yaml
description: Description of the person
with:
  name:
    description: Name of the person
    the: io.gozala.person/name
    cardinality: one
    as: Text
  address:
    description: Address of the person
    the: io.gozala.person/address
    cardinality: one
    as: Text
```

Schema (`Concept`): `with` (required, a map of field name → inline `Attribute`, `minProperties: 1`), optional `maybe` (future extension), `description`. Fields under `with` are required; an entity must have claims satisfying all those attributes to match. The name `this` is reserved for referencing the shared entity and must not appear as a field in `with`.

### Optional attributes (not yet supported)

> ⚠️ Optional attributes are not currently supported. For now the `maybe` field can be used as metadata which is ignored by the query engine.

Fields under `maybe` define attributes that the entity may or may not have related claims for. The entity will still match the concept as long as all required attributes (defined in `with`) are satisfied. Optional attribute values will be included in the conclusion when present. For example, a `RecipeStep` requiring only `instruction` but with `maybe` fields `after` and `duration` matches any entity with an `instruction` claim; the optional values appear in the conclusion when present but are not required to match.

Source: [notes/notation.md](https://github.com/dialog-db/dialog-db/blob/bde506d786a080291051b2e069cabe38cda769b2/notes/notation.md) at commit `bde506d7`.
