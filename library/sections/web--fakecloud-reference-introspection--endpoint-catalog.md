---
title: Endpoint catalog
source_kind: web
source_url: https://fakecloud.dev/docs/reference/introspection/
source_content_sha256: f5197dd25dbe3915202deeb16c933ce44385152ad94499bca316ff249f4fc965
source_authors: ["faisca (fakecloud project)"]
source_date: 2026-09-28
ingested: 2026-09-28
ingested_by: gardener
topics: [cloud-emulation, testing]
status: current
---

The introspection reference is the source of truth for fakecloud's `/_fakecloud/*` routes: health, per-service and per-account reset, an ECS-shaped credentials vendor, and per-service tick, record-listing, and state-flip endpoints; it lists no global `/_fakecloud/reset`, which the TypeScript SDK instead reaches at `POST /_reset`.

"This page lists every `/_fakecloud/*` endpoint shipped today: 86 routes across 28 service areas." (The retrieved table has about 120 rows, since some routes list several methods.)

**Health and reset:**

- `GET /_fakecloud/health` — `{"status":"ok","version":"<v>","services":[...]}`.
- `POST /_fakecloud/reset/{service}` and `POST /_fakecloud/reset/{service}/{account_id}`.

**Credentials:** `GET /_fakecloud/credentials` vends short-lived credentials in the ECS container-credentials shape; point `AWS_CONTAINER_CREDENTIALS_FULL_URI` at it and the default AWS SDK credential chain resolves locally.

**Rows for the services a small web app touches:**

- Cognito — `confirmation-codes` (GET, all or `{pool_id}/{username}`), `confirm-user`, `tokens`, `expire-tokens`, `auth-events`, `authorization-codes`, `compromised-passwords`, `webauthn-credentials`, `pretokengen/invocations`.
- DynamoDB — `ttl-processor/tick`, `snapshot/save`.
- KMS — `usage`.
- S3 — `notifications`, `lifecycle-processor/tick`, `access-points`, `object-lambda-responses`.
- Secrets Manager — `rotation-scheduler/tick`.
- SSM — `commands/{command_id}/status` (POST, change an invocation status), `commands/{command_id}/fail`, `parameter-policy-events` (GET/DELETE), `sessions/inject`.

Other areas: ACM, API Gateway v2, Application Auto Scaling, Athena, Bedrock (+ Agent, Agent Runtime), CloudFront, CloudWatch, EC2, ECR, ECS, ElastiCache, ELBv2, EventBridge, Firehose, Glue, IAM, Lambda, Logs, Organizations, RDS, Route 53, Scheduler, SES, SNS, SQS, Step Functions, WAFv2.

**Conventions:** JSON responses unless noted; `{snake_case}` path parameters; state-mutating POSTs accept an empty body; "they are never exposed by the real AWS SDKs, so production traffic cannot reach them by accident."

**Global reset (scholar note).** No whole-server reset route appears in this table. The TypeScript SDK's `reset()` posts to `POST /_reset` (source `sdks/typescript/src/client.ts` at `4db815e2`), so a raw-HTTP test harness should use `/_reset` or per-service `/_fakecloud/reset/{service}`.

Source: [fakecloud docs/reference/introspection](https://fakecloud.dev/docs/reference/introspection/), retrieved 2026-09-28. Derived summary of vendor documentation; treat claims as the project's self-report.
