---
title: Identity, data, storage, and secrets services
source_kind: web
source_url: https://fakecloud.dev/llms.txt
source_content_sha256: 7da0553629fa56a54689e661b91e2675fc06b469e00242984b086d40e06b553d
source_authors: ["faisca (fakecloud project)"]
source_date: 2026-09-28
ingested: 2026-09-28
ingested_by: gardener
topics: [cloud-emulation, oauth-credentials]
status: current
---

The llms.txt per-service summaries for the services a small AWS-backed web app typically touches: S3, DynamoDB, IAM, STS, Secrets Manager, KMS, SSM, Cognito User Pools and Identity, Lambda, Route 53.

Selected per-service summaries from the llms.txt `Supported Services` list (operation counts as published; the parity page and services page sometimes give slightly different counts for the same service, for example Cognito User Pools 132 here versus 122 on the services page).

- **S3 (107 ops):** buckets, objects, multipart uploads, versioning, lifecycle, CORS, notifications, object lock, replication, website hosting.
- **DynamoDB (57 ops):** tables, items, transactions, PartiQL, backups, global tables, streams; IAM-enforced under `--iam strict` with AWS action/resource mapping (tables, indexes, streams, per-table batch and transaction checks, PartiQL actions, tag conditions).
- **IAM (180 ops):** users, roles, groups, policies, instance profiles, OIDC/SAML providers, MFA, permission boundaries, session policies, ABAC tag conditions.
- **STS (11 ops):** AssumeRole, AssumeRoleWithWebIdentity, GetSessionToken, GetCallerIdentity, session tags, external IDs, federation.
- **Secrets Manager (23 ops):** secret CRUD, versioning, rotation via Lambda, replication, soft delete/restore.
- **KMS (53 ops):** symmetric/asymmetric keys, encrypt/decrypt, aliases, grants, data keys, real ECDH, key import, multi-region keys.
- **SSM (152 ops):** Parameter Store (hierarchical parameters with KMS), documents, commands, maintenance windows, patch baselines.
- **Cognito User Pools (132 ops):** user pools, app clients, users, groups, MFA (SMS, TOTP, WebAuthn), identity providers (Google, Facebook, SAML, OIDC), resource servers, domains, devices, full authentication flows (USER_PASSWORD_AUTH, USER_SRP_AUTH, REFRESH_TOKEN_AUTH, CUSTOM_AUTH), triggers.
- **Cognito Identity (23 ops):** identity pools, federated identities, `GetId`/`GetCredentialsForIdentity`/`GetOpenIdToken`, developer-authenticated identities, role mappings.
- **Lambda (73 ops):** function CRUD, real code execution via Docker, event source mappings (SQS, Kinesis, DynamoDB Streams), layers, versions, aliases, URL endpoints.
- **Route 53 (71 ops):** hosted zones, RRsets, health checks, and more; an opt-in `--dns` resolver answers from created records.

Not in the published service list at retrieval: AWS App Runner (checked against llms.txt and the services page; no match).

Source: [fakecloud llms.txt (agent-oriented project summary)](https://fakecloud.dev/llms.txt), retrieved 2026-09-28. Derived summary of vendor documentation; treat claims as the project's self-report.
