---
title: Known limitations
source_kind: web
source_url: https://fakecloud.dev/docs/reference/limitations/
source_content_sha256: 8be8778e65d3292c5ed7cc0d6fc5eeacb76776b0716b5625a4cbbc03f98e322f
source_authors: ["faisca (fakecloud project)"]
source_date: 2026-09-28
ingested: 2026-09-28
ingested_by: gardener
topics: [cloud-emulation]
status: current
---

fakecloud's self-declared limitations are narrow: SNS email/SMS are recorded not sent, the SSM Session Manager data plane is absent (echo/inject hatches), Logs anomaly detection never fires, Lambda/RDS/ECS/ElastiCache/EC2 need a Docker or Podman socket, and SigV4 and IAM checks are off unless enabled; the page does not list Run Command's non-execution.

"fakecloud aims for 100% behavioral parity with AWS on every implemented operation. A few things are genuinely not supported."

- **SNS email and SMS delivery** — recorded at `/_fakecloud/sns/messages`, never sent; use SES (recorded at `/_fakecloud/ses/emails`) for email assertions.
- **SSM Session Manager data plane** — `StartSession` -> `400 TargetNotConnected`, `ResumeSession` -> `400 DoesNotExistException`; opt-in `FAKECLOUD_SSM_SESSION_ECHO=1` or `POST /_fakecloud/ssm/sessions/inject`.
- **CloudWatch Logs anomaly detection** — control plane complete, `ListAnomalies` always empty.
- **Docker socket required for Lambda / RDS / ElastiCache.** "Granting access to the Docker socket gives the fakecloud process the ability to manage containers on the host. Only use this in development or CI environments you trust." Without a runtime, Lambda `Invoke`, RDS `CreateDBInstance`, and ECS `RunTask` error; ElastiCache and EC2 degrade to metadata-only. `FAKECLOUD_CONTAINER_CLI` selects Podman or another CLI.
- **SigV4 signatures and IAM policies are off by default** — enable with `FAKECLOUD_VERIFY_SIGV4=true` / `FAKECLOUD_IAM=soft|strict`.
- "If you hit a behavior that's documented in the AWS Smithy model and fakecloud doesn't match it, that's a bug."

**Scholar notes.** (1) This page's evaluator summary lists service-specific condition keys "for S3/SNS/Lambda/SQS", which lags the security reference's table that also carries the DynamoDB keys; the security page is the more specific and current statement. (2) Run Command's simulated (non-executing) lifecycle is described on the SSM service page, not here.

Source: [fakecloud docs/reference/limitations](https://fakecloud.dev/docs/reference/limitations/), retrieved 2026-09-28. Derived summary of vendor documentation; treat claims as the project's self-report.
