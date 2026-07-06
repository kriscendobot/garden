---
title: The problem — compound values that are atomic
source: notes/record-value.md
source_repo: dialog-db/dialog-db
source_commit: 4ea723ad69f7702916b53114b7f8de202d9b94c7
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query]
status: current
---

> Abstract: Dialog models data as `{the, of, is}` triples whose `is` holds an atomic value, and today `Value` covers only scalars (strings, integers, floats, booleans, bytes, entities, symbols). Some values are compound but still atomic — a geolocation `{lat, lon}`, a color `{r, g, b}`, a bounding box, an automerge text document, a signed credential — where splitting into separate claims (`location/latitude`, `location/longitude`) is wrong because the parts can be updated independently and drift out of consistency. A `Record` is the answer: a single fact whose internal structure is the concern of its own type, opaque to the query layer (which carries, stores, and byte-compares it but never looks inside). This is different from modeling structured data as multiple claims — multiple claims give independent facts with independent provenance and conflict resolution; a `Record` gives one fact with one provenance. Concrete cases: compound atomic values, rich-text/CRDT types (an automerge doc as one `TextDocument(automerge::Automerge)` value, not many claims), and capturing a whole resolved `Claim` (artifact) in a binding to retire the side `claims` map.

Dialog models data as `{the, of, is}` triples where `is` holds an atomic value. Today `Value` covers scalars: strings, integers, floats, booleans, bytes, entities, symbols. This works when each attribute maps to a single scalar, but not all values are scalars.

Consider geolocation. A location is a latitude/longitude pair. These two numbers form a single atomic unit. Storing them as separate claims (`location/latitude`, `location/longitude`) is wrong because you can end up in a state where one is updated without the other, or where the two are inconsistent with each other. The pair needs to be written and read as one value. The same applies to any compound value that should be treated atomically: a color (r, g, b), a bounding box (x, y, width, height), an automerge text document, a signed credential. These are not collections of independent facts. They are single values that happen to have internal structure.

`Value` already has a `Record` variant, but it is a placeholder. A `Record` is a value that is not a scalar but still represents a single atomic unit in the `{the, of, is}` model. It is **opaque to the query layer**: the query engine carries it, stores it, compares it (by bytes), but never looks inside. Only the type that implements `RecordFormat` knows how to interpret the bytes. This is different from modeling structured data as multiple claims — multiple claims give you independent facts with independent provenance and independent conflict resolution; a Record gives you one fact whose internal structure is the concern of its type, not of Dialog.

## Concrete cases

- **Compound atomic values.** Geolocation, color, bounding box. Small structured values where splitting into separate claims introduces consistency problems. `GeoLocation` implements `RecordFormat` to encode `{lat, lon}` as a single `Record`.
- **Rich text and collaborative types.** An automerge document is a CRDT with its own binary format and merge semantics. A text attribute backed by automerge should be a single value in one claim, not spread across multiple claims. A newtype wrapper like `TextDocument(automerge::Automerge)` implements `RecordFormat` using `Automerge::load`/`save`.
- **Capturing a whole claim (a.k.a. artifact) in a binding.** When claim selection evaluates, it produces a `Claim` (the resolved artifact). Downstream consumers need the full `Claim`, not just its individual fields. Today this is worked around with a side `claims` map, separate from the general bindings. With `Value::Record`, claims can be treated as regular bindings produced by query evaluation.

Source: [notes/record-value.md](https://github.com/dialog-db/dialog-db/blob/4ea723ad69f7702916b53114b7f8de202d9b94c7/notes/record-value.md) at commit `4ea723ad`.
