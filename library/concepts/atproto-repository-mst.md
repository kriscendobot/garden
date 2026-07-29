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
| [atproto--specs-at-uri-scheme--structure-and-strong-reference-caveat](../sections/atproto--specs-at-uri-scheme--structure-and-strong-reference-caveat.md) | The primary statement that an `at://` URI is 'not a strong reference, in that it is not content-addressed', and that handle-authority URIs 'are not durable'. |
| [atproto--specs-at-uri-scheme--usage-and-implementation-guidelines](../sections/atproto--specs-at-uri-scheme--usage-and-implementation-guidelines.md) | The remedy the spec names: pair the AT URI with a CID when a strong reference is required, so the mutable name and the content address stay distinct. |
| [atproto--specs-at-uri-scheme--full-and-restricted-syntax](../sections/atproto--specs-at-uri-scheme--full-and-restricted-syntax.md) | The full versus Lexicon-restricted `at://` grammar, and which forms parse but do not validate. |
| [atproto--specs-at-uri-scheme--normalization](../sections/atproto--specs-at-uri-scheme--normalization.md) | Strict normalization so an AT URI in a signed record is comparable by simple string equality. |
| [atproto--specs-data-model--nodes-blocks-and-links](../sections/atproto--specs-data-model--nodes-blocks-and-links.md) | The primary DRISL statement (successor to DAG-CBOR) and the dual CBOR/JSON representation the repository spec cites second-hand. |
| [atproto--specs-data-model--link-and-cid-formats](../sections/atproto--specs-data-model--link-and-cid-formats.md) | The blessed CID set in full, and the three ways a hash reference can appear in a record. |
| [atproto--specs-data-model--blob-type](../sections/atproto--specs-data-model--blob-type.md) | The schema-agnostic blob node shape that lets a PDS extract blob references without the Lexicon. |
| [atproto--specs-blob--content-addressed-media-and-metadata](../sections/atproto--specs-blob--content-addressed-media-and-metadata.md) | Blobs are CID-addressed but 'always referenced and managed in the context of an individual account (DID)'. |
| [atproto--specs-blob--blob-lifecycle](../sections/atproto--specs-blob--blob-lifecycle.md) | The upload-then-reference two-phase commit, and per-repository reference counting outside the MST. |
| [atproto--specs-sync--mechanisms-and-repository-revisions](../sections/atproto--specs-sync--mechanisms-and-repository-revisions.md) | The commit revision as a per-repository logical clock that must increase across host migration. |
| [atproto--specs-sync--commit-and-sync-events](../sections/atproto--specs-sync--commit-and-sync-events.md) | The exact `#commit` and `#sync` field sets, including `prevData` as 'effectively required for MST inversion'. |
| [atproto--specs-sync--inductive-verification-and-operation-inversion](../sections/atproto--specs-sync--inductive-verification-and-operation-inversion.md) | Operation inversion in the spec's own words, and why a consumer keeps only a revision and a tree root per repository. |
| [atproto--specs-sync--event-stream-relays-and-self-certification](../sections/atproto--specs-sync--event-stream-relays-and-self-certification.md) | The firehose and relay topology, and what the stream does and does not authenticate. |
| [atproto--specs-sync--record-level-synchronization](../sections/atproto--specs-sync--record-level-synchronization.md) | The desynchronized / in-progress / synchronized indexing pattern and the full-CAR resync diff. |

## See also

- [[content-address-versus-signature]] — why the commit signature and the MST root have different half-lives.
- [[did-document-service-endpoint]] — the `#atproto_pds` hint that points at the repository.
- [[content-addressed-block-store]] — the general storage shape an MST is one instance of.
- [[value-based-cas]] — compare-and-swap over a content-addressed value, the same move `rev` plus `prevData` makes on the sync plane.
