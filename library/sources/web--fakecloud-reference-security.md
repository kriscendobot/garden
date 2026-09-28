---
source_kind: web
source_url: https://fakecloud.dev/docs/reference/security/
source_content_sha256: beadb5c08e912872183ee20a26ba9aa3f2eac1253f1e9610c1cb946d4a52196e
source_authors: ["faisca (fakecloud project)"]
source_date: 2026-09-28
retrieved: 2026-09-28
ingested: 2026-09-28
ingested_by: gardener
section_count: 2
status: current
notes: "Living vendor documentation for the open-source fakecloud local AWS emulator (github.com/faiscadev/fakecloud). Fetched direct via fetch-source.sh on 2026-09-28; the idempotency anchor is the content SHA-256 of that retrieval. Ingested by scholar-ingest-fakecloud-dev-services-sdks."
---

fakecloud's security reference: opt-in cryptographic SigV4 verification (header and presigned query-string), the `test*` root bypass, `--iam off|soft|strict`, the enforced-service list, and the policy evaluator's operators, global and service-specific condition keys, resource policies, and principal matching.

| Section | Topics | Status |
|---------|--------|--------|
| [SigV4 verification and the root bypass](../sections/web--fakecloud-reference-security--sigv4-verification-and-root-bypass.md) | cloud-emulation | current |
| [IAM evaluator and condition keys](../sections/web--fakecloud-reference-security--iam-evaluator-and-condition-keys.md) | cloud-emulation, policy-language-authorization | current |
