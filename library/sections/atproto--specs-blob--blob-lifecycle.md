---
title: "Blob lifecycle: upload, temporary storage, reference counting, deletion"
source_kind: web
source_url: https://atproto.com/specs/blob
source_content_sha256: e9de13e4d3c516a4e324d59451c017658aeffcc6c1317a6fda056e20b8643d6d
source_authors: [Bluesky Social PBC]
source_date: 2026-07-29
retrieved: 2026-07-29
ingested: 2026-07-29
ingested_by: scholar
topics: [content-addressed-storage, persistence]
status: current
---

> Abstract: A blob's life is a two-phase commit against the record that references it. Upload lands the bytes in temporary storage where they are not downloadable and not listed; creating a record that references the blob is what makes it public; deleting the last referencing record in that repository deletes the blob. Un-referenced temporary blobs are garbage-collected. The reference count is scoped per repository, so the same bytes uploaded by two accounts are two independently-managed blobs even though the CID is identical: content addressing deduplicates identity, not custody.

## Upload

> "Blobs must be uploaded to the PDS before a record can be created referencing that blob. Note that the server does not know the intended Lexicon when receiving an upload, so can only apply generic blob limits and restrictions at initial upload time, and then enforce Lexicon-defined limits later when the record is created."

Clients use the `com.atproto.repo.uploadBlob` endpoint on their PDS, which returns verified metadata in the form of a Lexicon blob object. Clients "should" set the HTTP `Content-Type` header and "should" set the `Content-Length` header on the upload request. Chunked transfer encoding may also be permitted. Servers may sniff the blob mimetype to validate against the declared `Content-Type`, and either return a modified mimetype in the response or reject the upload. If the actual upload size differs from the `Content-Length` header, the server should reject the upload.

## Temporary storage and garbage collection

> "After a successful upload, blobs are placed in temporary storage. They are not accessible for download or distribution while in this state. Servers should 'garbage collect' (delete) un-referenced temporary blobs after an appropriate time span. Blobs which are in temporary storage should not be included in the `listBlobs` output."

## Referencing makes a blob public

> "The upload blob can now be referenced from records by including the returned blob metadata in a record. When processing record creation, the server extracts the set of all referenced blobs, and checks that they are either already referenced, or are in temporary storage. Once the record creation succeeds, the server makes the blob publicly accessible."

The same blob can be referenced by multiple records in the same repository. Re-uploading a blob which has already been stored and referenced results in no change to the existing blobs or records.

## Deletion

- "When a record referencing blobs is deleted, the server checks if any other current records from the same repository reference the blob. If not, the blob is deleted along with the record."
- When an account is deleted, all hosted blobs are deleted within some reasonable time frame. When an account is deactivated, taken down, or suspended, blobs should not be publicly accessible.
- Servers may decide to make individual blobs inaccessible, separately from any account takedown or other account lifecycle event.

## Dangling references are possible

> "Creation of new individual records which reference a blob which does not exist should be rejected at the time of creation (or update). However, it is possible for servers to host repository records which reference blobs which are not available locally. For example, during a bulk repository import or account migration; data loss; or content deletion/removal for policy reasons."

Original blobs can be fetched from the PDS using the `com.atproto.sync.getBlob` endpoint, with appropriate `Content-Type` and `Content-Length` response headers. "It is not a recommended or required pattern to serve media directly from the PDS to end-user browsers, and servers do not need to support or facilitate this use case."

Source: [https://atproto.com/specs/blob](https://atproto.com/specs/blob), content SHA-256 `e9de13e4`.
