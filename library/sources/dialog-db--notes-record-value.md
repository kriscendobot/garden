---
source: notes/record-value.md
source_repo: dialog-db/dialog-db
source_commit: 4ea723ad69f7702916b53114b7f8de202d9b94c7
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
section_count: 3
status: current
---

> Abstract: The design note for `Value::Record` — how Dialog stores a value that is compound but still a single atomic unit in the `{the, of, is}` model (a geolocation, a color, an automerge text document, a signed credential), instead of splitting it across multiple claims that can drift out of consistency. A `Record` is opaque to the query layer (carried, stored, byte-compared, never inspected); only the type implementing the `RecordFormat` (`decode`/`encode`) trait interprets the bytes. `Record` is a type-erased `Arc<RecordState>` holding source bytes plus a lazily-populated decoded-forms cache, built eagerly via `TryFrom<F>` or from raw bytes via `From<Vec<u8>>`, with `realize::<F>()` returning the typed object. The decision is a two-step rollout (now: the types + eager serialization, retiring the claims side-channel; later: zero-copy `Record::from(bytes)` from storage), and the same trait grows a `merge` method the storage layer calls to reconcile conflicting `(entity, attribute)` values (automerge → CRDT merge, plain struct → last-write-wins).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [problem-compound-atomic-values](../sections/dialog-db--notes-record-value--problem-compound-atomic-values.md) | datalog-query | current |
| [recordformat-trait-and-record-type](../sections/dialog-db--notes-record-value--recordformat-trait-and-record-type.md) | datalog-query, content-addressed-storage | current |
| [storage-deferral-and-decision](../sections/dialog-db--notes-record-value--storage-deferral-and-decision.md) | datalog-query, content-addressed-storage | current |

## Provenance

- Repository default branch `main`; the file's last-touching commit is `4ea723ad` (2026-07-05), authored by Irakli Gozalishvili. Part of the notes/ data-model cluster (concept/attribute value model). Companion to `notes/concept.md` (the claim/attribute/concept model this extends) and `notes/optional-fields.md` (the `Absent`/optionality half of value modeling, deferred to its own cycle).
- Ingested in the `scholar-ingest-dialog-db-remainder-4` follow-on cycle (2026-07-06).
