---
title: SigV4 verification and the root bypass
source_kind: web
source_url: https://fakecloud.dev/docs/reference/security/
source_content_sha256: beadb5c08e912872183ee20a26ba9aa3f2eac1253f1e9610c1cb946d4a52196e
source_authors: ["faisca (fakecloud project)"]
source_date: 2026-09-28
ingested: 2026-09-28
ingested_by: gardener
topics: [cloud-emulation]
status: current
---

fakecloud parses but does not verify SigV4 by default; `--verify-sigv4` (`FAKECLOUD_VERIFY_SIGV4=true`) turns on spec-faithful canonical-request rebuilding, constant-time comparison, and a ±15-minute skew window for both header and presigned query-string signatures, while any access key beginning `test` bypasses both signature and IAM checks.

"By default, fakecloud parses SigV4 headers for routing but doesn't verify signatures, and stores IAM policies without evaluating them." Two orthogonal flags:

```
FAKECLOUD_VERIFY_SIGV4=true    # or --verify-sigv4
FAKECLOUD_IAM=off|soft|strict  # or --iam off|soft|strict
```

**Reserved root identity.** "The credential pair `test`/`test` (and any access key starting with `test`) is treated as the de-facto root bypass. It skips both SigV4 verification and IAM enforcement." A one-time WARN is logged when either feature is on.

**`--verify-sigv4`:**

- Canonical request rebuilt per the SigV4 spec (double-encoded path for non-S3, single-encoded for S3; sorted, URL-encoded query string; lowercased sorted headers; payload hash from `X-Amz-Content-Sha256` or `sha256(body)`).
- Signing key via the `AWS4 -> date -> region -> service -> aws4_request` HMAC chain; constant-time comparison.
- Clock skew window of ±15 minutes.
- Failures return AWS errors before business logic: `SignatureDoesNotMatch`, `InvalidClientTokenId`, `RequestTimeTooSkewed`, `IncompleteSignature`.
- "Header-based `Authorization: AWS4-HMAC-SHA256 ...` and query-string (presigned URL) signatures are both supported." STS temporary credentials are verified against the secret the client received.

Not stated: whether a presigned URL's `X-Amz-Expires` lifetime is enforced separately from the skew window. Practical consequence: a test that must prove a presigned URL is honored should use a non-`test` access key (for example one minted through IAM `CreateAccessKey`) with `--verify-sigv4` on, or the bypass makes the check vacuous.

Source: [fakecloud docs/reference/security](https://fakecloud.dev/docs/reference/security/), retrieved 2026-09-28. Derived summary of vendor documentation; treat claims as the project's self-report.
