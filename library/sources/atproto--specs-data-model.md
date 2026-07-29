---
source_kind: web
source_url: https://atproto.com/specs/data-model
source_content_sha256: 519f0d9076e77840bd5e296ca2631997266c28a01e7d259249d44a47bbe5ec74
source_authors: [Bluesky Social PBC]
source_date: 2026-07-29
retrieved: 2026-07-29
ingested: 2026-07-29
ingested_by: scholar
section_count: 6
status: current
notes: |
  Fetched live and directly from atproto.com (fetch-source.sh reported
  source_fetched_via=direct). The page carries no publication or
  last-modified date, so source_date records the retrieval date; the
  idempotency anchor is source_content_sha256 over the rendered page bytes,
  not a git SHA. Because the hash covers site chrome as well as spec prose,
  a site-wide navigation change will trip the check without the spec having
  changed; re-read before assuming a mismatch means new content.
---

> Abstract: The primary source for atproto's encoding layer, which the corpus previously quoted second-hand from the repository spec. It names DRISL as the normalized CBOR subset "which is successor to DAG-CBOR", states the dual-representation rule (CBOR when data must be signed, hash-linked, or stored efficiently; a non-byte-deterministic JSON everywhere else), and gives the blessed CID set in full (CIDv1, DRISL `0x71` or `raw` `0x55`, SHA-256 at 256 bits, base32 with a `b` prefix) along with the alignment to DASL and IPLD. Two rules here follow directly from content addressing: floats are excluded from the type system because round-trip encoding is not reliably stable, and `$`-prefixed field names are reserved to the protocol with unknown ones ignored. It also carries the canonical `blob` node shape (``, `ref`, `mimeType`, `size`) and its deprecated legacy form.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [nodes-blocks-and-links](../sections/atproto--specs-data-model--nodes-blocks-and-links.md) | content-addressed-storage, data-structures | current |
| [data-types-and-no-floats](../sections/atproto--specs-data-model--data-types-and-no-floats.md) | data-structures, content-addressed-storage | current |
| [blob-type](../sections/atproto--specs-data-model--blob-type.md) | content-addressed-storage, data-structures | current |
| [json-representation](../sections/atproto--specs-data-model--json-representation.md) | data-structures, content-addressed-storage | current |
| [link-and-cid-formats](../sections/atproto--specs-data-model--link-and-cid-formats.md) | content-addressed-storage, decentralized-identifiers | current |
| [security-and-future-changes](../sections/atproto--specs-data-model--security-and-future-changes.md) | endpoint-security, data-structures | current |

Source: [https://atproto.com/specs/data-model](https://atproto.com/specs/data-model), content SHA-256 `519f0d90`, retrieved 2026-07-29.
