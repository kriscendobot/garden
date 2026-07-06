---
title: Records from storage, and the decision
source: notes/record-value.md
source_repo: dialog-db/dialog-db
source_commit: 4ea723ad69f7702916b53114b7f8de202d9b94c7
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query, content-addressed-storage]
status: current
---

> Abstract: The end state and rollout for record values. Today the storage layer fully deserializes every datum into an `Artifact` before the query layer sees it; ideally record values arrive as raw bytes wrapped in `Record::from(bytes)` with deserialization deferred to `realize` on demand — the prolly-tree keys already encode enough for filtering and grouping without deserializing the datum, and the `Record` type is designed with that zero-copy path in mind. The decision: **add `Record` as a `Value` variant with a `RecordFormat` trait for self-describing encode/decode**, in two steps — now, the `Record`/`RecordFormat` types with eager `TryFrom` serialization, eliminating the claims side-channel by storing claims as `Value::Record` (self-contained, does not touch storage); later, have the storage layer produce `Record::from(bytes)` directly. Rationale: some values are compound-but-atomic (splitting them creates consistency problems); the query layer should carry bytes and not understand contents; eager serialization is an acceptable start with a clear incremental path to zero-copy; and the same trait extends to conflict resolution — `RecordFormat` can grow a `merge(a, b)` method (automerge overrides with CRDT merge, a simple struct uses last-write-wins) that the storage layer calls on conflicting `(entity, attribute)` values without knowing what is inside the record.

Today the storage layer fully deserializes every datum into an `Artifact` before the query layer sees it. Ideally, record values would arrive as raw bytes wrapped in `Record::from(bytes)`, with deserialization deferred to `realize` on demand. The prolly tree keys already encode enough information for filtering and grouping without deserializing the datum. Getting there requires changes to `ArtifactStore` and its consumers, but the `Record` type is designed with this path in mind.

## Decision

**Add `Record` as a `Value` variant with `RecordFormat` trait for self-describing encode/decode.**

Incremental path:

1. **Now**: create the `Record` type and `RecordFormat` trait. Use `TryFrom` to create records with eager serialization. Eliminate the claims side-channel by storing claims as `Value::Record`. Self-contained, does not touch the storage layer.
2. **Later**: have the storage layer produce `Record::from(bytes)` directly, deferring deserialization to the consumer.

Rationale:

1. **Some values are compound but still atomic.** Geolocation, color, rich text. Splitting them into separate claims creates consistency problems. Storing them as a single opaque value in one claim preserves atomicity.
2. **The query layer should not need to understand record contents.** It carries bytes; the type knows how to encode and decode itself. No separate format object to pass around.
3. **Eager serialization is acceptable as a starting point.** `TryFrom` pays one encode at construction. The path to zero-copy from storage is clear and incremental.
4. **The same trait extends to conflict resolution.** `RecordFormat` can grow a `merge` method — an automerge implementation overrides it with CRDT merge, a simple struct uses last-write-wins. The storage layer calls `merge` when it encounters conflicting values for the same `(entity, attribute)` pair, without knowing what is inside the record:

```rust
trait RecordFormat: ConditionalSend + ConditionalSync + Sized + 'static {
    fn decode(bytes: &[u8]) -> Result<Self, RecordError>;
    fn encode(&self) -> Result<Vec<u8>, RecordError>;

    fn merge(a: &Self, b: &Self) -> Self { b.clone() } // default: last-write-wins
}
```

Source: [notes/record-value.md](https://github.com/dialog-db/dialog-db/blob/4ea723ad69f7702916b53114b7f8de202d9b94c7/notes/record-value.md) at commit `4ea723ad`.
