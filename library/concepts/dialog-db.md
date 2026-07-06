---
id: dialog-db
aliases: [dialog, dialogdb, dialog-db, dialog database, Irakli Gozalishvili, io.gozala, gozala]
topics: [datalog-query, local-first-sync, ucan-authorization]
---

# dialog-db

**Dialog** (`dialog-db/dialog-db`, Irakli Gozalishvili) is an embeddable database for local-first software, in experimental development. It stores information as immutable `{the, of, is, cause}` claims in a content-addressed, append-only store, combines Probabilistic B-Trees (EAV/AEV/VAE indexes) with a Datalog query language, reconciles concurrent replicas as a Merkle-CRDT with query-time merge strategy, and separates a get/put blob store from a signed DID:key compare-and-swap mutable pointer. Its authorization and privacy layers use UCAN delegation over did:key subjects (a `subject x command x policy` model) and a four-tier (L0–L3) nested-encryption access scheme. A peer design to Endo's ocap model: capabilities as unforgeable delegable authority, content-addressed durable storage, and confinement by provided environment. Ingested into the library as a high-signal aligned design reference (first pass 2026-07-06).

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [dialog-db--readme--overview](../sections/dialog-db--readme--overview.md) | The project's framing: embeddable local-first DB, four target properties, Rust/TS layout. |
| [dialog-db--notes-architecture-overview--overview](../sections/dialog-db--notes-architecture-overview--overview.md) | Six design goals and the fact-store + Prolly-Tree + Datalog information model. |
| [dialog-db--ts-dialog-experimental-session--overview](../sections/dialog-db--ts-dialog-experimental-session--overview.md) | The JavaScript face: a did:key Session over the WASM artifacts store bridging to @dialog-db/query. |
| [dialog-db--ts-dialog-experimental-react--overview](../sections/dialog-db--ts-dialog-experimental-react--overview.md) | The React bindings — Provider/useSession/useQuery/useTransaction over a Dialog session. |

## See also

- [[fact-triple]], [[prolly-tree]], [[merkle-crdt]], [[schema-on-read]], [[ucan-delegation]] — its core mechanisms.
