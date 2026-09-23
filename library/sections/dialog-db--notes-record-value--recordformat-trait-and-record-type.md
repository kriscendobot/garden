---
title: The RecordFormat trait and the Record type
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

> Abstract: A `Record` value is designed so the type itself knows how to encode/decode — no separate format object. `RecordFormat` is a `decode(&[u8]) -> Self` / `encode(&self) -> Vec<u8>` trait; `Record` is a type-erased container (`Arc<RecordState>` holding `source: Vec<u8>` plus a lazily-populated `forms: RwLock<HashMap<TypeId, ErasedForm>>`). A `Record` always has bytes; the `forms` cache is filled on first `realize::<F>()` and reused, and because the bytes live outside the lock, `realize` decodes straight from bytes if the lock cannot be acquired. `TryFrom<F>` builds a record with eager serialization (one `encode` at construction); `From<Vec<u8>>` wraps raw bytes with decoding deferred. The trait-bound story for living inside `Value` (which needs `Clone/Eq/Hash/Debug/Serialize/Deserialize`): `Clone` bumps the `Arc`; `Eq`/`Hash` compare/hash the `source` bytes (same bytes = same record); `Serialize`/`Deserialize` operate on `source` and `Deserialize` produces `Record::from(bytes)`. `GeoLocation` decodes/encodes via serde_cbor; `TextDocument` via `Automerge::load`/`save`; the query layer treats both identically as bytes and the typed consumer calls `realize` to get the object out.

The type itself knows how to encode and decode. No separate format object needed.

```rust
type ErasedForm = Arc<dyn Any + ConditionalSend + ConditionalSync>;

trait RecordFormat: ConditionalSend + ConditionalSync + Sized + 'static {
    fn decode(bytes: &[u8]) -> Result<Self, RecordError>;
    fn encode(&self) -> Result<Vec<u8>, RecordError>;
}
```

## Record: a type-erased container

`Record` holds serialized bytes and decoded forms:

```rust
#[derive(Debug, Clone)]
struct Record(Arc<RecordState>);

struct RecordState {
    source: Vec<u8>,
    forms: RwLock<HashMap<TypeId, ErasedForm>>,
}
```

`Record` always has bytes. The `forms` map is populated lazily on first `realize` call for a given type and reused on subsequent calls. The bytes live outside the lock so they are always accessible; if the lock cannot be acquired, `realize` decodes directly from bytes.

`TryFrom<F>` constructs a record with eager serialization (paying one `encode` up front, seeding `forms` with the already-decoded form); `From<Vec<u8>>` wraps raw bytes with an empty `forms` map so decoding is deferred:

```rust
impl<F: RecordFormat> TryFrom<F> for Record { /* encode(); seed forms with the form */ }
impl From<Vec<u8>> for Record { /* wrap source; forms empty */ }

impl Record {
    pub fn realize<F: RecordFormat>(&self) -> Result<Arc<F>, RecordError> {
        let key = TypeId::of::<F>();
        // Try the cache under a read lock.
        if let Ok(forms) = self.0.forms.try_read() {
            if let Some(form) = forms.get(&key) {
                return form.clone().downcast::<F>().map_err(|_| RecordError::TypeMismatch);
            }
        }
        // Decode from bytes; cache the result if the write lock is free, else skip.
        let form = Arc::new(F::decode(&self.0.source)?);
        if let Ok(mut forms) = self.0.forms.try_write() {
            forms.insert(key, form.clone());
        }
        Ok(form)
    }
}
```

Usage: write a geolocation as a record value with `let record: Record = geo.try_into()?; let value = Value::Record(record);` and read it back with `let geo: Arc<GeoLocation> = record.realize::<GeoLocation>()?;`.

## Trait bounds — living inside `Value`

`Record` lives inside `Value`, which requires `Clone`, `Eq`, `Hash`, `Debug`, `Serialize`, `Deserialize`.

- **Clone**: derived; clones the inner `Arc` (a cheap reference-count bump).
- **Eq/Hash**: compare/hash the `source` bytes. Same bytes = same record.
- **Debug**: print byte length or a hex prefix.
- **Serialize/Deserialize**: operate on `source` bytes. `Deserialize` produces `Record::from(bytes)`.

## Example implementations

```rust
impl RecordFormat for GeoLocation {
    fn decode(bytes: &[u8]) -> Result<Self, RecordError> { Ok(serde_cbor::from_slice(bytes)?) }
    fn encode(&self) -> Result<Vec<u8>, RecordError> { Ok(serde_cbor::to_vec(self)?) }
}

struct TextDocument(automerge::Automerge);

impl RecordFormat for TextDocument {
    fn decode(bytes: &[u8]) -> Result<Self, RecordError> { Ok(TextDocument(automerge::Automerge::load(bytes)?)) }
    fn encode(&self) -> Result<Vec<u8>, RecordError> { Ok(self.0.save()) }
}
```

The query layer treats both identically. It carries the bytes, and the consumer who knows the type calls `realize` to get the typed object out.

Source: [notes/record-value.md](https://github.com/dialog-db/dialog-db/blob/4ea723ad69f7702916b53114b7f8de202d9b94c7/notes/record-value.md) at commit `4ea723ad`.
