---
title: Objects, POST policy, and the SigV4 gotcha
source_kind: web
source_url: https://fakecloud.dev/docs/services/s3/
source_content_sha256: 5cbfe3e92fbdbf8abc9c6091f8bb288fc935a24514f853ac2f8bcf6dc039b90f
source_authors: ["faisca (fakecloud project)"]
source_date: 2026-09-28
ingested: 2026-09-28
ingested_by: gardener
topics: [cloud-emulation]
status: current
---

fakecloud's S3 claims all 107 operations, verifies browser POST-policy signatures, and does real SSE-KMS, but its Gotchas say SigV4 signatures are parsed for routing and never validated; presigned GET/PUT query-auth is only cryptographically checked under the opt-in `--verify-sigv4` flag (documented on the security reference page), and `X-Amz-Expires` enforcement is not stated.

"fakecloud implements 107 of 107 S3 operations at 100% Smithy conformance." Selected features:

- **Objects** — GET/PUT/DELETE/HEAD, versioning, delete markers, metadata, tags, ACLs.
- **POST Object (browser POST Policy)** — the upload targeted by boto3's `generate_presigned_post` / the JS SDK's `createPresignedPost`. "The signed base64 policy is verified (SigV4 over the policy document, checked against the caller's IAM secret; `test*` root-bypass keys skip the crypto check), its `expiration` and `conditions` (`eq`, `starts-with`, `content-length-range`) are enforced, and any form field not authorized by a condition is rejected with `AccessDenied`."
- **Multipart** (resumable across restarts in persistent mode), **lifecycle** via a tick endpoint, **notifications** to SNS/SQS/Lambda/EventBridge in AWS record shape, **versioning** with AWS null-version rules, **encryption** SSE-S3 / SSE-KMS (real envelope encryption through the KMS hook) / SSE-C, bucket subresources, Object Lock, website hosting, access points, S3 Select, Object Lambda, Public Access Block.
- **Anonymous access** — unsigned GET/HEAD are served permissively by default; under `--iam soft|strict` only when a bucket policy grants `Principal:"*"` or a public-read ACL is set.

**Gotchas (verbatim):**

- "In persistent mode, object bodies stream to disk with a bounded LRU cache (`--s3-cache-size`, default 256 MiB)."
- "The `/_fakecloud/s3/notifications` introspection buffer is intentionally not persisted across restarts."
- "SigV4 signatures are parsed for request routing but never validated."

**Scholar reconciliation.** The last gotcha describes the default mode. The SigV4/IAM reference page ([sigv4 verification](web--fakecloud-reference-security--sigv4-verification-and-root-bypass.md)) says that with `--verify-sigv4` "header-based ... and query-string (presigned URL) signatures are both supported". So a presigned `s3 presign` GET works unconditionally by default (any signature passes), and is cryptographically checked only under the flag. Neither page says whether a presigned URL's `X-Amz-Expires` lifetime is enforced (distinct from the ±15-minute clock-skew window); treat expiry as unverified.

Introspection: `GET /_fakecloud/s3/notifications`, `POST /_fakecloud/s3/lifecycle-processor/tick`, `GET /_fakecloud/s3/access-points`, `GET /_fakecloud/s3/object-lambda-responses`.

Source: [fakecloud docs/services/s3](https://fakecloud.dev/docs/services/s3/), retrieved 2026-09-28. Derived summary of vendor documentation; treat claims as the project's self-report.
