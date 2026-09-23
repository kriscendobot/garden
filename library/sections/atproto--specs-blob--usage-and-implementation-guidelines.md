---
title: Blob usage and implementation guidelines
source_kind: web
source_url: https://atproto.com/specs/blob
source_content_sha256: e9de13e4d3c516a4e324d59451c017658aeffcc6c1317a6fda056e20b8643d6d
source_authors: [Bluesky Social PBC]
source_date: 2026-07-29
retrieved: 2026-07-29
ingested: 2026-07-29
ingested_by: scholar
topics: [content-addressed-storage, multi-tenant-platform]
status: current
---

> Abstract: Two operator recommendations, both aimed at interoperability rather than at any single deployment's economics. Prefer account-wide resource quotas over per-blob size limits, because a per-blob limit silently breaks applications the operator has never heard of. And allow several hours of grace before garbage-collecting an un-referenced upload, with one hour as a firm lower bound, because some applications have a long delay between uploading a blob and writing the record that references it.

> "Servers may have their own generic limits and policies for blobs, separate from any Lexicon-defined constraints. They might implement account-wide quotas on data storage; maximum blob sizes; content policies; etc. Any of these restrictions might be enforced at the initial upload. Server operators should be aware that limits and other restrictions may impact functionality with existing and future applications. To maximize interoperability, operators are recommended to prefer limits on overall account resource consumption (eg, 'total blob size' quota, not 'per blob' size limits)."

> "Some applications may have a long delay between blob upload and reference from a record. To maximize interoperability, server implementations and operators are recommended to allow several hours of grace time before 'garbage collecting', with at least one hour a firm lower bound."

Source: [https://atproto.com/specs/blob](https://atproto.com/specs/blob), content SHA-256 `e9de13e4`.
