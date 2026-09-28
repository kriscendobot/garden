---
title: CORS evaluation
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

fakecloud's S3 evaluates `PutBucketCors` rules as a browser would see them: preflight matching on origin, method, and every requested header, `Vary` on every evaluated response, CORS decoration on S3 errors but not on SigV4/IAM denials, and write-time rejection of malformed rules.

Condensed from the S3 page's CORS bullet:

- The `OPTIONS` preflight is matched on origin, `Access-Control-Request-Method`, and every header in `Access-Control-Request-Headers` before returning the allow headers and `Access-Control-Max-Age`. Actual requests are matched on method as well as origin.
- Multipart operations are CORS-evaluated, so browser multipart upload works.
- S3's own errors are CORS-decorated (a 404 `NoSuchKey` reaches an allowed origin as a real 404), but "denials raised before the request reaches S3 (SigV4 or IAM, under `--verify-sigv4` / `--iam`) are not CORS-decorated, so under auth enforcement a rejected browser request still surfaces as an opaque failure."
- `Vary: Origin, Access-Control-Request-Headers, Access-Control-Request-Method` on every preflight and every evaluated actual response. Preflight outcomes: `200` allowed, `403 AccessForbidden` refused, `400 BadRequest` when `Origin` is missing.
- A concrete allowed origin also gets `Access-Control-Allow-Credentials: true`. Rule order matters as on S3: a preceding `*` rule can match the actual request and strip credentials after a successful preflight ("order the concrete rule first").
- `AllowedOrigin` / `AllowedHeader` take one `*` anywhere; `ExposeHeader` takes none. Rules missing `AllowedMethods`/`AllowedOrigins`, with more than one wildcard, or a non-numeric `MaxAgeSeconds` are rejected at write time, including through CloudFormation's `CorsConfiguration`.

Source: [fakecloud docs/services/s3](https://fakecloud.dev/docs/services/s3/), retrieved 2026-09-28. Derived summary of vendor documentation; treat claims as the project's self-report.
