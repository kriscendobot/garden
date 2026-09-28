---
title: Core-service parity rows (S3, DynamoDB, IAM, STS, SSM, Secrets Manager, KMS, Cognito, Lambda)
source_kind: web
source_url: https://fakecloud.dev/docs/parity
source_content_sha256: ee0e08c4fd9a477add0cf8f22d9a97e65951f9f48472c04429eb6154da0166db
source_authors: ["faisca (fakecloud project)"]
source_date: 2026-09-28
ingested: 2026-09-28
ingested_by: gardener
topics: [cloud-emulation, oauth-credentials]
status: current
---

Parity-matrix rows for the core services: S3, DynamoDB, IAM, STS, Secrets Manager, and KMS are Full/Full; SSM's data plane is Partial (no Session Manager); Cognito User Pools is Full/Full with real RS256 JWTs, JWKS/OIDC discovery, `/oauth2/*` endpoints, and a real PreTokenGeneration Lambda trigger.

Rows as published (service — ops — protocol — control plane — data plane — known limitations):

- **S3** — 107 — REST-XML — Full — Full — SelectObjectContent returns real EventStream chunks; WriteGetObjectResponse stores body and metadata; access points include data-plane routing; `PublicAccessBlock.IgnorePublicAcls` enforced on GetObject; Object Lock compliance mode enforced on single-object delete but not yet on batch delete; multi-region access points are control-plane only. (Presigned-URL behavior for S3 is not called out on this page either way.)
- **DynamoDB** — 57 — JSON 1.1 — Full — Full — no known limitations listed.
- **IAM** — 180 — Full — Full — none listed. **STS** — 11 — Full — Full — none listed.
- **SSM** — 152 — Full — **Partial** — `StartSession` returns the model's `TargetNotConnected` and `ResumeSession` returns `DoesNotExistException` rather than opening a real websocket; the Session Manager data plane is not implemented. (Whether `SendCommand` with `AWS-RunShellScript` executes anything is not stated.)
- **Secrets Manager** — 23 — Full — Full — none listed. The services page adds rotation via Lambda and real KMS encrypt/decrypt.
- **KMS** — 53 — Full — Full — real ECDSA P-256/P-384/P-521 signing.
- **Cognito User Pools** — 132 — JSON 1.1 — Full — Full — real RSA-2048 RS256 JWT signing; JWKS and OIDC discovery endpoints serve real JWKs; `/oauth2/token`, `/oauth2/authorize`, `/oauth2/userInfo`, and `/oauth2/revoke` are implemented; refresh-token rotation supported when enabled; the **PreTokenGeneration trigger invokes the configured Lambda and merges claims**; CompromisedCredentialsRiskConfiguration enforced; WebAuthn packed attestation verified; GetSigningCertificate returns real X.509 certificates. The services page adds "verification email -> SES, SMS -> SNS, all 12 Lambda triggers."
- **Cognito Identity** — 23 — Full — Full — identity pools, federated and developer identities, real STS-style credential issuance.
- **Lambda** — 73 — REST-JSON — Full — Full — UpdateFunctionCode fetches real bytes from S3 and recomputes CodeSha256; reserved concurrency recorded but not enforced at invoke; provisioned concurrency on the roadmap.

The Cognito row's roadmap entry (see [web--fakecloud-parity--roadmap-projects](web--fakecloud-parity--roadmap-projects.md)) notes full WebAuthn attestation for the non-`packed` formats is still to come.

Source: [fakecloud parity matrix](https://fakecloud.dev/docs/parity), retrieved 2026-09-28. Derived summary of vendor documentation; treat claims as the project's self-report.
