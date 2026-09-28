---
title: Test introspection endpoints and SDKs
source_kind: web
source_url: https://fakecloud.dev/llms.txt
source_content_sha256: 7da0553629fa56a54689e661b91e2675fc06b469e00242984b086d40e06b553d
source_authors: ["faisca (fakecloud project)"]
source_date: 2026-09-28
ingested: 2026-09-28
ingested_by: gardener
topics: [cloud-emulation, testing]
status: current
---

fakecloud's `/_fakecloud/*` endpoints (reset, health, sent SES emails, SNS messages, Lambda invocations, Cognito confirmation codes, vended credentials, IMDS) let a test assert on side effects; first-party SDKs in TypeScript, Python, Go, PHP, Java, and Rust wrap them.

fakecloud exposes `/_fakecloud/*` endpoints that tests use to assert on side effects and to reset state between tests. First-party SDKs in TypeScript (`npm install fakecloud`), Python, Go, PHP, Java, and Rust wrap them, so the application keeps using the ordinary AWS SDK while the test uses the fakecloud SDK for visibility and control.

Endpoints listed at retrieval:

- `GET /_fakecloud/health` — liveness.
- `POST /_fakecloud/reset` — wipe all state (use between tests).
- `GET /_fakecloud/ses/emails`, `GET /_fakecloud/sns/messages`, `GET /_fakecloud/lambda/invocations` — side-effect ledgers.
- `GET /_fakecloud/cognito/confirmation-codes` — confirmation codes for testing signup flows.
- `POST /_fakecloud/iam/create-admin` — bootstrap an admin user in a given account for multi-account tests (body `{"accountId","userName"}`, optional `organizationId`).
- `GET /_fakecloud/credentials` — vends container-credentials-format JSON; point `AWS_CONTAINER_CREDENTIALS_FULL_URI` here to run an app that expects an instance/task role unmodified, with no static keys.
- EC2 IMDS on `/latest/*` (IMDSv1 and IMDSv2): point `AWS_EC2_METADATA_SERVICE_ENDPOINT=http://localhost:4566/` to resolve credentials and instance identity through the metadata service unmodified; `--imds-link-local` (root) also binds the real `169.254.169.254`/`169.254.170.2` addresses.
- `--dns` real resolver plus `GET /_fakecloud/dns/resolve?name=&type=`.
- ELBv2 and EC2 listing endpoints for infrastructure tests.

The home page adds that the SDKs also give "manual control of async processors" — forcing AWS-style asynchronous behavior to happen on demand after the app has already used the normal APIs. The full list is on the SDK docs page (`https://fakecloud.dev/docs/sdks/`, not ingested this cycle).

Source: [fakecloud llms.txt (agent-oriented project summary)](https://fakecloud.dev/llms.txt), retrieved 2026-09-28. Derived summary of vendor documentation; treat claims as the project's self-report.
