---
title: TypeScript client surface and license
source_kind: web
source_url: https://fakecloud.dev/docs/sdks/typescript/
source_content_sha256: 650f64beee48974d4442530101d182bc83c8a59db2453849c07c3d392b753e3d
source_authors: ["faisca (fakecloud project)"]
source_date: 2026-09-28
ingested: 2026-09-28
ingested_by: gardener
topics: [cloud-emulation, testing]
status: current
---

The `fakecloud` npm package is a zero-runtime-dependency `fetch` client (`new FakeCloud(baseUrl)`, default `http://localhost:4566`) with `health`/`reset`/`resetService` and per-service namespaces such as `fc.dynamodb.tickTtl()` and `fc.ssm.failCommand()`; it is licensed AGPL-3.0-or-later (package.json and a per-package LICENSE file at v0.46.0).

**Install and initialize.** `npm install fakecloud`; "Works in Node.js and any environment with `fetch`. TypeScript types are bundled."

```ts
import { FakeCloud } from "fakecloud";
const fc = new FakeCloud(); // defaults to http://localhost:4566
```

**Top level:** `health()`, `reset()`, `resetService(service)`, `credentials()` (`GET /_fakecloud/credentials`), `instanceIdentityDocument()`, `dnsResolve(name, type?)`, `createAdmin(accountId, userName, organizationId?)`.

**Namespaces relevant to a DynamoDB/Cognito/S3/SSM/Secrets Manager app** (method: description):

- `fc.dynamodb` — `tickTtl()`, `saveSnapshot(dataPath?)`.
- `fc.cognito` — `getUserCodes(poolId, username)`, `getConfirmationCodes()`, `confirmUser(req)`, `getTokens()`, `expireTokens(req)`, `getAuthEvents()`, `getPreTokenGenInvocations()`, `mintAuthorizationCode(req)`, `setCompromisedPasswords(req)`, `getWebAuthnCredentials()`.
- `fc.s3` — `getNotifications()`, `tickLifecycle()`, `getAccessPoints()`, `getObjectLambdaResponses()`.
- `fc.secretsmanager` — `tickRotation()`.
- `fc.ssm` — `setCommandStatus(commandId, req)`, `failCommand(commandId, req?)`, `getParameterPolicyEvents(accountId?)`, `injectSession(req)`.

The page also documents namespaces for ACM, API Gateway v2, Application Auto Scaling, Athena, Bedrock (canned responses, response rules, fault queue), CloudFront, EC2, ECR, ECS, ElastiCache, ELBv2, EventBridge, Scheduler, SES, Step Functions, WAFv2, and others. Errors: every method throws `FakeCloudError` (with `status` and `body`) on a non-2xx response.

**License and package facts (read from the upstream repository, not the docs page).** The npm registry's `fakecloud@latest` is `0.46.0` with `"license": "AGPL-3.0-or-later"` and **no runtime `dependencies`**; `sdks/typescript/package.json` on `faiscadev/fakecloud` `main` (last touched at commit `97f61b42`) declares the same license, and `sdks/typescript/LICENSE` is the GNU AGPL v3 text, matching the repository-root `LICENSE`. There is no separate permissive license carve-out for the SDK. Source: `sdks/typescript/src/client.ts` at `4db815e2` shows `reset()` posting to **`/_reset`** (not a `/_fakecloud/reset` path) and `resetService` to `/_fakecloud/reset/{service}`.

Source: [fakecloud docs/sdks/typescript](https://fakecloud.dev/docs/sdks/typescript/), retrieved 2026-09-28. Derived summary of vendor documentation; treat claims as the project's self-report.
