---
title: Seven-language test SDKs and common surface
source_kind: web
source_url: https://fakecloud.dev/docs/sdks/
source_content_sha256: 386ed5cdf4c87d362bb0b9fb2358d02c1589643ebd3e94c073434e0a9d7c1729
source_authors: ["faisca (fakecloud project)"]
source_date: 2026-09-28
ingested: 2026-09-28
ingested_by: gardener
topics: [cloud-emulation, testing]
status: current
---

fakecloud ships first-party test-assertion SDKs in seven languages that wrap the `/_fakecloud/*` endpoints (reset, health, per-service introspection, simulation ticks, admin state flips); they are not AWS SDKs, since application code keeps talking to fakecloud through the normal AWS SDK.

"fakecloud ships first-party SDKs in seven languages for test assertions and simulation control. Each SDK wraps the `/_fakecloud/*` introspection and configuration endpoints into ergonomic helpers." And: "These SDKs are not the AWS SDK. Your application code still talks to fakecloud through the normal AWS SDK ... the fakecloud SDK is what your tests use to assert on what happened."

| Language | Install |
|---|---|
| TypeScript | `npm install fakecloud` |
| Python | `pip install fakecloud` |
| Go | `go get github.com/faiscadev/fakecloud/sdks/go` |
| PHP | `composer require fakecloud/fakecloud` |
| Java | `dev.fakecloud:fakecloud:0.15.0` |
| Rust | `cargo add fakecloud-sdk` |
| C# / .NET | `dotnet add package FakeCloud` |

Common surface in all seven: reset (`reset()`, `resetService(service)`); health; per-service introspection (messages, emails, invocations, events); simulation and processor ticks (TTL expiration, secret rotation, S3 lifecycle); a Bedrock test harness; ECS task metadata and credentials endpoints; admin state mutation (CloudFront distribution status, Route 53 health checks, SSM command status, ACM certificate status, SES sandbox/mail-from); Route 53 DNSSEC material; Lambda code/layer downloads; ECS/ElastiCache/ECR introspection; Logs anomaly injection; API Gateway v2 recorded requests and WebSocket connections; the RDS bridge. Method names follow each language's case idiom.

The hub page's footer links the repository `LICENSE` (github.com/faiscadev/fakecloud/blob/main/LICENSE); licensing is recorded on the [TypeScript SDK section](web--fakecloud-sdks-typescript--typescript-client-surface-and-license.md).

Source: [fakecloud docs/sdks](https://fakecloud.dev/docs/sdks/), retrieved 2026-09-28. Derived summary of vendor documentation; treat claims as the project's self-report.
