---
title: "Retained library bindings: canonical ZIP archives and immutable storage"
source: docs/architecture/retained-library-bindings.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [content-addressed-storage, tooling]
status: current
---

> Abstract: Retained immutable records transport as read-only `records/<sha256>` members of the existing canonical ZIP format; `read_directory_export` is a pure, digest-checked reader that walks the central directory before allocating and rejects compression, ZIP64, extra fields, links, and noncanonical headers; persistence uses `FileSystemEvidenceStore`'s atomic CAS publication with verified readback, proven by a round-trip fixture, and none of this grants admission.

The archive adapter can encode retained immutable file records using the existing
canonical ZIP format. It budgets headers, names and content before allocation and
reuses the reader's path and format checks. Encoding performs no filesystem writes
or execution. Closed evidence publication, importer admission, transactional
materialization and the complete Cargo/source-retirement flow remain open.

The directory-archive adapter also provides `read_directory_export`, a pure reader
for the existing canonical ZIP bytes. The caller supplies the pinned `BlobRef` and
positive byte/entry limits; transport must enforce the byte limit before allocating
the input. The reader checks the digest and size, walks the central directory before
allocating ZIP entries, and admits only sorted regular files with ordinary permission
bits and portable, noncolliding paths. It rejects compression, ZIP64, extra fields,
comments, links, special modes, malformed records and noncanonical header bytes.
The returned immutable file records preserve exact bytes and file modes. Reading
performs no extraction or execution and does not admit qualification evidence.

The producer’s evidence output includes the exact captured package bytes under
their content identities, sharing its existing record/byte limits. Failed capture
or final authority checks expose neither evidence nor products.
The qualification archive adapter transports immutable evidence and package bytes
as read-only `records/<sha256>` members in that existing ZIP format. Reopening
requires an explicit archive blob reference and byte/record bounds, checks every
member name, mode and content digest, and returns the existing evidence reader.
The caller still pins the qualification, run and export identities and supplies
current authority to the composed verifier; the archive grants no admission.

Persistence uses the existing `FileSystemEvidenceStore`: atomic immutable CAS
publication followed by verified readback. The storage round-trip fixture discards
the writer and encoded archive, reopens through a fresh read-only store, removes
the transport store, and verifies both runs from retained bytes and current
authority. This proves storage composition, not a qualified publication command
or the importing maintainer’s trust decision.

The bounded reader does not replace the existing qualified-local-tree transport
verifier or authorize transactional materialization. Admission must enforce the
reviewed importer binding and current evidence before making packages consumable.

Source: [docs/architecture/retained-library-bindings.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/retained-library-bindings.md) at commit `fcc40bc` (source lines 360–395).
