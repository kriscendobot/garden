---
id: atproto-repository-mst
aliases: [atproto repository, Merkle Search Tree, MST, atproto MST, DRISL, DRISL CBOR, atproto commit, signed commit, CAR slice, at:// URI, AT URI, PDS, Personal Data Server, atproto firehose, subscribeRepos, operation inversion]
topics: [content-addressed-storage, decentralized-identifiers, data-structures, persistence]
---

# atproto-repository-mst

An atproto account's public data lives in a **repository**: "a content-addressed Merkle-tree" of DRISL-CBOR objects (DRISL being the successor name for DAG-CBOR, at the same multicodec `0x71`) linked by CID, whose contents are "entirely public and verifiable ('self-certifying')". The concrete structure is a **Merkle Search Tree** keyed by `<collection>/<record-key>` byte strings, where a key's depth is the leading-binary-zero count of its SHA-256 hash divided by two (fanout 4), nodes prefix-compress their keys, and the shape is "fully reproducible from such a mapping of bytestrings-to-CIDs, with exactly reproducible root CID hash ... regardless of the history of insertions and deletions". Each published version is a **signed commit** (`did`, `version: 3`, `data` as a CID link to the MST root, `rev` as a monotonic TID logical clock, `prev` virtually always null, `sig`), so the signature covers a content address rather than content. Repositories export as **CAR v1** (`application/vnd.ipld.car`) and diff as **CAR slices**, which the firehose validates by **operation inversion**: apply the claimed record operations in reverse to the partial MST and check that the recomputed root matches the previous revision's `data`. Blobs are referenced by CID (`raw` codec) but stored outside the tree and fetched via `com.atproto.sync.getBlob`. The whole thing sits under a mutable, authority-grounded name (a `did:plc` or `did:web` DID) whose document carries the `#atproto_pds` location hint, which makes atproto the clearest deployed instance of "mutable authority over a content-addressed store". Two caveats keep the analogy honest: the PDS is the *authoritative* location, not an advisory hint, because currency cannot be verified from content; and `at://` URIs are explicitly "not content-addressed", so atproto ships a mutable name and a content address side by side and refuses to conflate them.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [atproto--specs-repository--self-certifying-repository](../sections/atproto--specs-repository--self-certifying-repository.md) | The overview: a content-addressed Merkle tree of DRISL-CBOR objects, self-certifying, with blobs by hash outside the tree and CAR export for migration. |
| [atproto--specs-repository--mst-structure](../sections/atproto--specs-repository--mst-structure.md) | Key depth from SHA-256 leading zeros at fanout 4, prefix-compressed node entries, a history-independent deterministic shape, and key-mining mitigations. |
| [atproto--specs-repository--commit-objects-and-signing](../sections/atproto--specs-repository--commit-objects-and-signing.md) | The signed commit: did, version 3, data as the MST root CID, rev as a monotonic TID, prev virtually always null, sig over the SHA-256 of the DRISL-CBOR body. |
| [atproto--specs-repository--car-export-and-diffs](../sections/atproto--specs-repository--car-export-and-diffs.md) | CAR v1 export, CAR-slice diffs, and operation inversion as the firehose's consistency check against the previous revision's root. |
| [atproto--specs-repository--paths-records-and-cid-formats](../sections/atproto--specs-repository--paths-records-and-cid-formats.md) | The <collection>/<record-key> key space, chronological TID sorting, and the strict-versus-permissive CID rules for structural links and leaf links. |
| [atproto--specs-did--did-document-atproto-fields](../sections/atproto--specs-did--did-document-atproto-fields.md) | The #atproto_pds hint that names where the repository currently lives. |

## See also

- [[content-address-versus-signature]] — why the commit signature and the MST root have different half-lives.
- [[did-document-service-endpoint]] — the `#atproto_pds` hint that points at the repository.
- [[content-addressed-block-store]] — the general storage shape an MST is one instance of.
- [[value-based-cas]] — compare-and-swap over a content-addressed value, the same move `rev` plus `prevData` makes on the sync plane.
