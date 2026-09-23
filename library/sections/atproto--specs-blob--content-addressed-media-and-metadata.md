---
title: "Blobs: content-addressed media held outside the repository tree"
source_kind: web
source_url: https://atproto.com/specs/blob
source_content_sha256: e9de13e4d3c516a4e324d59451c017658aeffcc6c1317a6fda056e20b8643d6d
source_authors: [Bluesky Social PBC]
source_date: 2026-07-29
retrieved: 2026-07-29
ingested: 2026-07-29
ingested_by: scholar
topics: [content-addressed-storage, persistence, decentralized-identifiers]
status: current
---

> Abstract: Blobs are atproto's media plane: files stored alongside an account's repository, referenced from records by the `blob` Lexicon datatype (which carries the CID), uploaded and distributed separately from records. The sentence that matters for an addressing taxonomy is the qualification on universal content addressing: "While blobs are universally content addressed (by CID), they are always referenced and managed in the context of an individual account (DID)." A blob's hash names the bytes; the DID is still what decides whether you may have them, who is authoritative for them, and when they are deleted.

Blobs are media files stored alongside an account's repository. They include images, video, and audio, "but could also include any other file format". Blobs are referenced by individual records by the `blob` Lexicon datatype, which includes a content hash (CID) for the blob.

> "Blob files are uploaded and distributed separately from records. Blobs are authoritatively stored by the account's PDS instance, but views are commonly served by CDNs associated with individual applications ('AppViews'), to reduce traffic on the PDS. CDNs may serve transformed (resized, transcoded, etc) versions of the original blob."

> "While blobs are universally content addressed (by CID), they are always referenced and managed in the context of an individual account (DID)."

The empty blob (zero bytes) is generally valid, though it may be disallowed by individual Lexicons or applications.

## Blob metadata

The only currently blessed CID type for blobs is similar to the one for repository records, but with the `raw` codec:

- CID version: 1 (`0x01`)
- Codec: `raw` (`0x55`)
- Hash type: `sha-256` (`0x12`) with size of 256 bits (`0x20` bytes)
- Encoding: binary serialization within DRISL-CBOR `link` fields, and `base32` (with `b` prefix) for string encoding elsewhere

This aligns with the DASL-CID specification. An example blob CID in base32 string encoding: `bafkreibjfgx2gprinfvicegelk5kosd6y2frmqpqzwqkg7usac74l3t2v4`.

Blob metadata also includes the size of the blob in bytes and the MIME type. "The size and CID are deterministic and must be valid and consistent. The MIME type is somewhat more subjective: it is possible for the same bytes to be valid for multiple MIME types."

That last split is worth keeping: two of the three metadata fields are functions of the bytes and therefore self-verifying, while the third is an assertion about them and therefore a trust question. Content addressing settles identity, not interpretation.

Source: [https://atproto.com/specs/blob](https://atproto.com/specs/blob), content SHA-256 `e9de13e4`.
