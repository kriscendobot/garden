---
title: R2 configuration — API token permissions and a web-client CORS policy
source: rust/dialog-storage/README.md
source_repo: dialog-db/dialog-db
source_commit: 4ded84e340bbc56c6bd5f9ebd1db7c534cc9bdda
source_date: 2025-12-12
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [content-addressed-storage]
status: current
---

> Abstract: The operational configuration for backing the `S3` storage backend with Cloudflare R2. The R2 API token needs **Object Read & Write** permission (which allows reading, writing, and listing objects) scoped to the specific buckets to be used. For web clients, the bucket also needs a **CORS policy**: `AllowedOrigins` `["*"]`, `AllowedMethods` `GET/POST/PUT/DELETE/HEAD`, `AllowedHeaders` `["*"]`, and — importantly — `ExposeHeaders` including `ETag` and `x-amz-checksum-sha256`, so a browser can read back the checksum a content-addressed store depends on. These are the concrete deployment settings for running Dialog's cloud storage on R2 rather than AWS S3 proper.

## R2 Configuration

### API Token

Create an R2 API token with the following settings:

**Permissions**: Object Read & Write (allows reading, writing, and listing objects)

**Bucket Access**: Specify the buckets you want to enable access for

### CORS Policy

For web clients, configure a CORS policy on your bucket:

```json
[
  {
    "AllowedOrigins": ["*"],
    "AllowedMethods": ["GET", "POST", "PUT", "DELETE", "HEAD"],
    "AllowedHeaders": ["*"],
    "ExposeHeaders": ["ETag", "x-amz-checksum-sha256"]
  }
]
```

Exposing `ETag` and `x-amz-checksum-sha256` is what lets a browser-side client verify the content hash of each block it reads — the property [[content-addressed-storage-backend]] relies on when the `S3` backend runs against R2.

Source: [rust/dialog-storage/README.md](https://github.com/dialog-db/dialog-db/blob/4ded84e340bbc56c6bd5f9ebd1db7c534cc9bdda/rust/dialog-storage/README.md) at commit `4ded84e3`.
