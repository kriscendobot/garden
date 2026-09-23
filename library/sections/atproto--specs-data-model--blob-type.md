---
title: "The blob type: a schema-agnostic file reference, and its deprecated legacy form"
source_kind: web
source_url: https://atproto.com/specs/data-model
source_content_sha256: 519f0d9076e77840bd5e296ca2631997266c28a01e7d259249d44a47bbe5ec74
source_authors: [Bluesky Social PBC]
source_date: 2026-07-29
retrieved: 2026-07-29
ingested: 2026-07-29
ingested_by: scholar
topics: [content-addressed-storage, data-structures]
status: current
---

> Abstract: The `blob` node shape is fixed and self-describing so that "it is possible to parse nodes and extract any blob references without knowing the schema" — the property the PDS depends on when it scans a newly-created record for the blobs it must make public. A deprecated legacy form still exists in the wild with no `$type`, so it can only be parsed for known Lexicons; implementations "should not throw errors when encountering the old format, but should never write them".

> "References to 'blobs' (arbitrary files) have a consistent format in atproto, and can be detected and processed without access to any specific Lexicon. That is, it is possible to parse nodes and extract any blob references without knowing the schema."

Blob nodes are maps with the following fields:

- `$type` (string, required): fixed value `blob`. "Note that this is not a valid NSID."
- `ref` (link, required): CID reference to blob, with codec type `raw`. In JSON, encoded as a `$link` object as usual.
- `mimeType` (string, required, not empty): content type of blob. `application/octet-stream` if not known.
- `size` (integer, required, positive, non-zero): length of blob in bytes.

## Legacy format

There is a deprecated legacy blob format, "with some records in the wild still containing blob references in this format":

- `cid` (string, required): a CID in string format, not link format.
- `mimeType` (string, required, not empty): same as `mimeType` above.

> "Note that the legacy format has no `$type` and can only be parsed for known Lexicons. Implementations should not throw errors when encountering the old format, but should never write them, and it is acceptable to only partially support them."

When working with the legacy format, the spec recommends storing it in the same internal representation as a regular blob reference "but to set the `size` to zero or a negative value. This field should be checked when re-serializing to ensure proper round-trip behavior and avoid ever encoding a zero or negative `size` value in the normal object format."

The legacy form is instructive about append-only content-addressed corpora generally: because old records are immutable and hash-identified, a format mistake cannot be migrated away by rewriting, only by tolerating it forever. The spec's future-changes section says as much: the legacy blob format "may be entirely removed, if all known records and repositories can be rewritten."

Source: [https://atproto.com/specs/data-model](https://atproto.com/specs/data-model), content SHA-256 `519f0d90`.
