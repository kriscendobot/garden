---
title: CAR file serialization, repository diffs, and operation inversion
source_kind: web
source_url: https://atproto.com/specs/repository
source_content_sha256: bb8ddfacbc2864bdff6d917764da33c0263f4226363878c13cf5abe0979dd249
source_authors: [Bluesky Social PBC]
source_date: 2026-07-28
retrieved: 2026-07-28
ingested: 2026-07-28
ingested_by: scholar
topics: [content-addressed-storage, persistence, local-first-sync]
status: current
---

> Abstract: How an atproto repository moves between hosts and over the wire: full export as a CAR v1 file (`.car`, `application/vnd.ipld.car`) with the current commit as the first root CID, and incremental "CAR slices" carrying a partial Merkle tree that can be partially verified in isolation. The load-bearing sync trick is "operation inversion": apply the claimed record operations in reverse to the diff's partial MST and recompute the root, which must match the previous revision's `data` field, so a consumer can catch an inaccurate operation list without holding the whole repository.

## CAR v1 as the export format

> "The standard file format for storing data objects is Content Addressable aRchives (CAR). The standard repository export format for atproto repositories is CAR v1, which have file suffix `.car` and mimetype `application/vnd.ipld.car`. This aligns with the DASL CAR specification."

In the atproto context:

- "The first element of the CAR `roots` metadata array must be the CID of the most relevant Commit object. For a generic export, this is the current (most recent) commit."
- "For full exports, the full repo structure must be included for the indicated commit, which includes all records and all MST nodes."
- Block ordering is preferred but not required, and parsers "must be tolerant of CAR files with arbitrary block ordering."
- "When importing CAR files, note that there may existing dangling CID references", for example links to blobs or to records in other repositories.

A streamable pre-order block ordering (commit first, then the root MST node, then depth-first through entries) is specified so a consumer can walk references in a single pass without buffering the file. The spec flags this as work-in-progress: "As of February 2026, it has not been included in popular implementations or deployed broadly in the atproto network."

## Diffs as CAR slices

> "Mutations to a repository tree can be encapsulated as a 'diff'. The basic idea is that all new data blocks (including the new commit object, MST nodes, and records) that have changed since a previous revision can be bundled together and serialized in CAR format."

Rules for a CAR slice: the root CID in the header points to the new commit block (which must be included); every MST node in the current revision that did not exist in the previous one must be included; created and updated records are included (updated with the new value only); deleted records omit the value; parsers must tolerate and ignore unexpected extra blocks, though "unreasonable quantities of unnecessary block data may be considered a form of resource abuse."

> "The diff is a partial Merkle tree, including a signed commit, and can be partially verified in isolation. For example, the diff contains a 'proof chain' to verify any created or updated records."

## Operation inversion

> "The sync 'firehose' mechanism uses a process called 'operation inversion' to validate a list of record operations against a diff. In this process, the diff is parsed as a partial MST, and then each operation is applied in reverse: a 'create' is applied as a 'delete', etc. After all operations have been applied, the root CID (hash) of the MST is recomputed, and should match the `data` field of the previous revision of the repository. If the list of record operations is inaccurate or incomplete, the inverted MST will not match."

This is why some contextual MST nodes must be shipped in a diff even though they did not change: "MST nodes that reference record paths directly adjacent (in sorted order) to those mutated in the diff. The definition of which nodes need to be included in the diff is ultimately tautological: those MST nodes which are necessary for the inversion process."

## Import-side security

> "Repositories are untrusted input: accounts have full control over repository contents, and PDS instances have full control over binary encoding." Generic CBOR precautions apply (maximum object size, recursion depth, memory budget), and on import "the completeness of the repository structure should be verified", with care taken not to inject unreferenced blocks into backend storage or to allow cross-account contamination from an unrelated account's CAR.

Source: [https://atproto.com/specs/repository](https://atproto.com/specs/repository), content SHA-256 `bb8ddfac`.
