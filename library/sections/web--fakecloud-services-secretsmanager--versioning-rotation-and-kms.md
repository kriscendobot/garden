---
title: Versioning, rotation, and KMS
source_kind: web
source_url: https://fakecloud.dev/docs/services/secretsmanager/
source_content_sha256: 9586e6fd29e7cd0edc20312bb9b141436c2945191f18135171b2a44fc13eb327
source_authors: ["faisca (fakecloud project)"]
source_date: 2026-09-28
ingested: 2026-09-28
ingested_by: gardener
topics: [cloud-emulation]
status: current
---

fakecloud's Secrets Manager implements all 23 operations with AWSCURRENT/AWSPREVIOUS/AWSPENDING stages, recovery-window soft delete, Lambda rotation through all four steps (scheduled via a tick endpoint), replication tracked in state only, and real KMS envelope encryption when `KmsKeyId` is set.

"fakecloud implements 23 of 23 Secrets Manager operations at 100% Smithy conformance."

- Secrets — CRUD, tags, resource-based policies.
- Versioning — stages (AWSCURRENT, AWSPREVIOUS, AWSPENDING), version IDs, explicit version retrieval.
- Soft delete — `DeleteSecret` with recovery window, `RestoreSecret`.
- Rotation — `RotateSecret` invokes a Lambda through all four steps (createSecret, setSecret, testSecret, finishSecret); automatic scheduling via `POST /_fakecloud/secretsmanager/rotation-scheduler/tick`.
- Replication — "replica regions tracked in state, not actually replicated."
- `GetRandomPassword` with full character-class support.
- Real KMS encryption — with `KmsKeyId` set, `CreateSecret` / `PutSecretValue` call `kms:GenerateDataKey` and `GetSecretValue` calls `kms:Decrypt` with context `{aws:secretsmanager:secretArn: <arn>}`; `aws/secretsmanager` auto-provisions; all calls land in `GET /_fakecloud/kms/usage`.

Note: Secrets Manager is **not** in the opt-in IAM enforcement list on the security reference page, so its resource policies are stored but not evaluated even under `--iam strict`.

Source: [fakecloud docs/services/secretsmanager](https://fakecloud.dev/docs/services/secretsmanager/), retrieved 2026-09-28. Derived summary of vendor documentation; treat claims as the project's self-report.
