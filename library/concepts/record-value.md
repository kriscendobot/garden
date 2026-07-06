---
id: record-value
aliases: [Value::Record, RecordFormat, record value, compound atomic value, TextDocument record, GeoLocation record, realize record]
topics: [datalog-query, content-addressed-storage]
---

# record-value

Dialog's `Value::Record` variant: a value that is compound (has internal structure) but still a single atomic unit in the `{the, of, is}` triple model — a geolocation `{lat, lon}`, a color, a bounding box, an automerge text document, a signed credential. It is the alternative to modeling structured data as multiple independent claims, which would let the parts drift out of consistency. A `Record` is opaque to the query layer (carried, stored, byte-compared, never inspected); only the type implementing the `RecordFormat` (`decode`/`encode`) trait interprets the bytes. Mechanically it is a type-erased `Arc<RecordState>` holding source bytes plus a lazily-populated decoded-forms cache, built eagerly via `TryFrom<F>` or from raw bytes via `From<Vec<u8>>`, with `realize::<F>()` returning the typed object. The trait can grow a `merge` method the storage layer calls to reconcile conflicting `(entity, attribute)` values (automerge → CRDT merge, plain struct → last-write-wins).

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [dialog-db--notes-record-value--problem-compound-atomic-values](../sections/dialog-db--notes-record-value--problem-compound-atomic-values.md) | Why compound-but-atomic values need a Record rather than multiple claims; the concrete cases. |
| [dialog-db--notes-record-value--recordformat-trait-and-record-type](../sections/dialog-db--notes-record-value--recordformat-trait-and-record-type.md) | The RecordFormat trait and the type-erased Record container with its realize/TryFrom/From API and trait bounds. |
| [dialog-db--notes-record-value--storage-deferral-and-decision](../sections/dialog-db--notes-record-value--storage-deferral-and-decision.md) | The two-step rollout to zero-copy Record::from(bytes) from storage, and the merge extension for conflict resolution. |

## See also

- [[prolly-tree]] — the content-addressed storage whose keys already encode enough to filter/group record values without deserializing them (the zero-copy path).
- [[schema-on-read]] — the wider Dialog model where a Record is one opaque fact whose interpretation is the reading type's concern.
- [[crdt-in-formula-persistence]] — CRDT-shaped merge appears here too (automerge `RecordFormat::merge`); contrast with where a bidirectional CRDT was rejected.
