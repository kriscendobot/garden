---
source_kind: web
source_url: https://atproto.com/specs/repository
source_content_sha256: bb8ddfacbc2864bdff6d917764da33c0263f4226363878c13cf5abe0979dd249
source_authors: [Bluesky Social PBC]
source_date: 2026-07-28
retrieved: 2026-07-28
ingested: 2026-07-28
ingested_by: scholar
section_count: 5
status: current
notes: |
  Fetched live and directly from atproto.com (fetch-source.sh reported
  source_fetched_via=direct). The page carries no publication or
  last-modified date, so source_date records the retrieval date; the
  idempotency anchor is source_content_sha256 over the rendered page bytes.
  The encoding is now named DRISL ("successor to DAG-CBOR") at the same
  multicodec 0x71; earlier notes elsewhere in the corpus that say "DAG-CBOR"
  for atproto are describing the same wire format under its former name.
---

> Abstract: The AT Protocol repository specification, describing version 3 of the repository binary format: a self-certifying, content-addressed Merkle Search Tree of DRISL-CBOR records linked by CID, published as signed commits whose `data` field is the tree root, serialized as CAR v1 for full export and as CAR slices for diffs, with blobs referenced by content hash but stored outside the tree. This is the primary source for reading atproto as a deployed instance of "a mutable, authority-grounded name over a content-addressed, self-verifying store", including the two places the analogy is imperfect: the PDS is the authoritative location rather than an advisory hint, and signature verification (unlike hash verification) degrades under key rotation.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [self-certifying-repository](../sections/atproto--specs-repository--self-certifying-repository.md) | content-addressed-storage, decentralized-identifiers, persistence | current |
| [commit-objects-and-signing](../sections/atproto--specs-repository--commit-objects-and-signing.md) | content-addressed-storage, decentralized-identifiers, persistence | current |
| [mst-structure](../sections/atproto--specs-repository--mst-structure.md) | content-addressed-storage, data-structures, persistence | current |
| [car-export-and-diffs](../sections/atproto--specs-repository--car-export-and-diffs.md) | content-addressed-storage, persistence, local-first-sync | current |
| [paths-records-and-cid-formats](../sections/atproto--specs-repository--paths-records-and-cid-formats.md) | content-addressed-storage, persistence, data-structures | current |

Source: [https://atproto.com/specs/repository](https://atproto.com/specs/repository), content SHA-256 `bb8ddfac`, retrieved 2026-07-28.
