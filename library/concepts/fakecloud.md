---
id: fakecloud
aliases: [fakecloud, fakecloud.dev, faiscadev/fakecloud, fake cloud, local AWS emulator, LocalStack alternative, Moto alternative]
topics: [cloud-emulation, testing]
---

# fakecloud

fakecloud is a free, AGPL-3.0, Rust local AWS emulator (single binary or container on port 4566, no account or auth token) that serves unmodified AWS SDK/CLI/IaC traffic, claims 100% Smithy API-shape conformance over 105 services, reports behavior parity per service in a separate matrix, runs real backing infrastructure (Docker Lambda, real Postgres/Redis) where the service needs it, and exposes `/_fakecloud/*` introspection endpoints plus first-party test SDKs for asserting on side effects.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [web--fakecloud-llms-txt--positioning-and-conformance-claims.md](../sections/web--fakecloud-llms-txt--positioning-and-conformance-claims.md) | Positioning and conformance claims. |
| [web--fakecloud-llms-txt--identity-data-and-secrets-services.md](../sections/web--fakecloud-llms-txt--identity-data-and-secrets-services.md) | Identity, data, storage, and secrets services. |
| [web--fakecloud-llms-txt--test-introspection-endpoints-and-sdks.md](../sections/web--fakecloud-llms-txt--test-introspection-endpoints-and-sdks.md) | Test introspection endpoints and SDKs. |
| [web--fakecloud-llms-txt--install-and-configuration.md](../sections/web--fakecloud-llms-txt--install-and-configuration.md) | Install and configuration. |
| [web--fakecloud-parity--conformance-versus-behavior-parity.md](../sections/web--fakecloud-parity--conformance-versus-behavior-parity.md) | Conformance versus behavior parity. |
| [web--fakecloud-parity--core-service-parity-rows.md](../sections/web--fakecloud-parity--core-service-parity-rows.md) | Core-service parity rows (S3, DynamoDB, IAM, STS, SSM, Secrets Manager, KMS, Cognito, Lambda). |
| [web--fakecloud-parity--will-never-implement.md](../sections/web--fakecloud-parity--will-never-implement.md) | What fakecloud will never implement. |
| [web--fakecloud-parity--roadmap-projects.md](../sections/web--fakecloud-parity--roadmap-projects.md) | Significant roadmap projects. |
| [web--fakecloud-home--positioning-and-localstack-comparison.md](../sections/web--fakecloud-home--positioning-and-localstack-comparison.md) | Positioning and LocalStack comparison. |

## See also

- [[conformance-versus-behavior-parity]] - the distinction the parity matrix draws between API-shape conformance and emulated behavior (not yet a concept page).
