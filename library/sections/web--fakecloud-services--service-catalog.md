---
title: Service catalog
source_kind: web
source_url: https://fakecloud.dev/docs/services
source_content_sha256: 30364ffe6fc0d7be7c7d59894474f668def203cccd362dc43b913055521c5878
source_authors: ["faisca (fakecloud project)"]
source_date: 2026-09-28
ingested: 2026-09-28
ingested_by: gardener
topics: [cloud-emulation]
status: current
---

The docs/services hub claims 105 AWS services and 3,966 operations with 248,557/248,557 Smithy conformance variants passing, in an 84-row service table whose operation counts sometimes lag the per-service pages; AWS App Runner is absent.

The hub page opens: "fakecloud implements 105 AWS services with 3,966 total operations. 248,557/248,557 generated Smithy conformance variants pass on every commit — true 100% across the board. Per-service feature matrices and gotchas live on individual service pages."

Selected rows of the service table (Service | Ops | Notes), as published:

| Service | Ops | Notes |
|---|---|---|
| S3 | 107 | Versioning, lifecycle, notifications, multipart, replication, website, real SSE-KMS encrypt/decrypt |
| Lambda | 70 | Real Docker, 23 runtimes, ESM with FilterCriteria + partial-batch failure |
| DynamoDB | 57 | Transactions, PartiQL, backups, global tables, streams, KMS audit-trail on SSE-KMS tables |
| IAM | 176 | Users, roles, policies, groups, OIDC/SAML, PassRole trust enforcement |
| STS | 11 | AssumeRole, session tokens, federation |
| SSM | 146 | Parameters, documents, commands, maintenance, patch baselines, SecureString -> real KMS encrypt/decrypt |
| Secrets Manager | 23 | Versioning, rotation via Lambda, replication, real KMS encrypt/decrypt |
| KMS | 53 | Encryption, aliases, grants, real ECDH, key import, cross-service hook |
| Cognito User Pools | 122 | Pools, clients, MFA, identity providers, full auth flows; verification email -> SES, SMS -> SNS, all 12 Lambda triggers |

**Count drift (scholar note).** The hub's per-service counts do not always match the per-service pages retrieved the same day: IAM 176 here versus 180 on its page, SSM 146 versus 152, Cognito User Pools 122 versus 126, Lambda 70 versus 73 (the llms.txt figure). The hub's 3,966-operation total also differs from the llms.txt headline of 7,508. Treat counts as approximate and prefer the per-service page.

**Absent:** no App Runner row (checked against the retrieved HTML; zero matches for "App Runner" / "apprunner").

Source: [fakecloud docs/services](https://fakecloud.dev/docs/services), retrieved 2026-09-28. Derived summary of vendor documentation; treat claims as the project's self-report.
