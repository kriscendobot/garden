---
source_kind: web
source_url: https://atproto.com/specs/blob
source_content_sha256: e9de13e4d3c516a4e324d59451c017658aeffcc6c1317a6fda056e20b8643d6d
source_authors: [Bluesky Social PBC]
source_date: 2026-07-29
retrieved: 2026-07-29
ingested: 2026-07-29
ingested_by: scholar
section_count: 4
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

> Abstract: The ATProto blob specification: media files stored alongside a repository, referenced from records by CID, uploaded and distributed separately from records, and authoritatively held by the account's PDS while views are served by application CDNs. It carries the qualification that keeps atproto's content addressing honest, "While blobs are universally content addressed (by CID), they are always referenced and managed in the context of an individual account (DID)", and the blessed `raw`-codec CID format for blobs. The lifecycle is a two-phase commit (upload to temporary storage, then a referencing record makes it public, then deleting the last reference deletes the blob), and the security section treats serving user bytes as unsafe by default: a Content Security Policy on `getBlob` is "effectively mandatory" and PDS instances "should not directly implement media resizing or transcoding".

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [content-addressed-media-and-metadata](../sections/atproto--specs-blob--content-addressed-media-and-metadata.md) | content-addressed-storage, persistence, decentralized-identifiers | current |
| [blob-lifecycle](../sections/atproto--specs-blob--blob-lifecycle.md) | content-addressed-storage, persistence | current |
| [usage-and-implementation-guidelines](../sections/atproto--specs-blob--usage-and-implementation-guidelines.md) | content-addressed-storage, multi-tenant-platform | current |
| [security-considerations](../sections/atproto--specs-blob--security-considerations.md) | endpoint-security, content-addressed-storage | current |

Source: [https://atproto.com/specs/blob](https://atproto.com/specs/blob), content SHA-256 `e9de13e4`, retrieved 2026-07-29.
