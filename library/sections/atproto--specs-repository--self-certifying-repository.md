---
title: The repository as a self-certifying, content-addressed Merkle tree
source_kind: web
source_url: https://atproto.com/specs/repository
source_content_sha256: bb8ddfacbc2864bdff6d917764da33c0263f4226363878c13cf5abe0979dd249
source_authors: [Bluesky Social PBC]
source_date: 2026-07-28
retrieved: 2026-07-28
ingested: 2026-07-28
ingested_by: scholar
topics: [content-addressed-storage, decentralized-identifiers, persistence]
status: current
---

> Abstract: The overview of the atproto repository: a content-addressed Merkle tree of DRISL-CBOR objects linked by CID, published as signed commits, exportable as CAR files, with large blobs referenced by content hash but stored outside the tree. It states the two facts that make atproto a worked example of the mutable-name-over-content-addressed-store layering: the repository is "entirely public and verifiable ('self-certifying')", and "the authoritative location of an account's repository is the associated Personal Data Server (PDS). An account's current PDS location is declared in the DID Document."

> "Each atproto account has a repository (or 'repo') which stores all of their public data records. Repository contents are entirely public and verifiable ('self-certifying'). Record deletion is supported without leaving a trace or 'tombstone' of previous contents."

> "The repository data structure is a content-addressed Merkle-tree. Creating, updating, or deleting records (or any other mutations to the repository) changes the root hash value of the overall repository tree. Each published version of the repository tree structure is represented as a commit. Commits are cryptographically signed, with rotatable signing keys, which allows recursive authentication of either the repository structure as a whole, or compact 'proof chains' for individual records."

> "Repositories and their contents are represented as a graph of data objects, encoded in DRISL CBOR and referencing each other by content hash (CID Links). Larger binary media files ('blobs') are also referenced by content hash, but are not stored directly in the repository. Complete repositories can be exported as CAR files for synchronization, offline backup, account migration, or other purposes."

> "In the atproto network architecture, the authoritative location of an account's repository is the associated Personal Data Server (PDS). An account's current PDS location is declared in the DID Document."

That last sentence is the load-bearing one for any comparison with a magnet-style source set. A magnet source can be fully untrusted because the locator names a frozen artifact: any source yielding bytes that hash to the exact topic is as good as any other, and a lying source is merely useless. The PDS endpoint carries a second job no hash can do, namely telling you what the current revision is. Currency is not verifiable from content; it can only be asserted by an authority. So the endpoint is load-bearing in a way a magnet web-seed hint is not, and that difference is the real dividing line between a content-address row and a mutable-authority row in any addressing taxonomy.

## Versioning

> "This document describes version 3 of the repository binary format. Version 2 had a slightly different commit object schema, but is mostly compatible with 3. Version 1 had a different MST fanout configuration, and an incompatible schema for commits and repository metadata. Version 1 is deprecated, no repositories in this format exist in the network, and implementations do not need to support it."

Repositories "are intended to store up to single-digit millions records. Beyond that they become unweidly to distribute and process."

Source: [https://atproto.com/specs/repository](https://atproto.com/specs/repository), content SHA-256 `bb8ddfac`.
