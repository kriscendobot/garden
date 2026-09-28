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
| [web--fakecloud-services--service-catalog.md](../sections/web--fakecloud-services--service-catalog.md) | Service catalog. |
| [web--fakecloud-services-dynamodb--features-transactions-and-fine-grained-iam.md](../sections/web--fakecloud-services-dynamodb--features-transactions-and-fine-grained-iam.md) | Features, transactions, and fine-grained IAM. |
| [web--fakecloud-services-dynamodb--startup-import-and-introspection.md](../sections/web--fakecloud-services-dynamodb--startup-import-and-introspection.md) | Startup import of AWS exports and introspection. |
| [web--fakecloud-services-s3--objects-post-policy-and-sigv4-gotcha.md](../sections/web--fakecloud-services-s3--objects-post-policy-and-sigv4-gotcha.md) | Objects, POST policy, and the SigV4 gotcha. |
| [web--fakecloud-services-s3--cors-evaluation.md](../sections/web--fakecloud-services-s3--cors-evaluation.md) | CORS evaluation. |
| [web--fakecloud-services-ssm--run-command-lifecycle-and-session-manager.md](../sections/web--fakecloud-services-ssm--run-command-lifecycle-and-session-manager.md) | Run Command lifecycle and Session Manager. |
| [web--fakecloud-services-cognito--auth-flows-oauth-endpoints-and-introspection.md](../sections/web--fakecloud-services-cognito--auth-flows-oauth-endpoints-and-introspection.md) | Auth flows, OAuth2 endpoints, and introspection. |
| [web--fakecloud-services-secretsmanager--versioning-rotation-and-kms.md](../sections/web--fakecloud-services-secretsmanager--versioning-rotation-and-kms.md) | Versioning, rotation, and KMS. |
| [web--fakecloud-services-iam--policy-features-and-trust-enforcement.md](../sections/web--fakecloud-services-iam--policy-features-and-trust-enforcement.md) | Policy features and trust enforcement. |
| [web--fakecloud-sdks--seven-language-test-sdks-and-common-surface.md](../sections/web--fakecloud-sdks--seven-language-test-sdks-and-common-surface.md) | Seven-language test SDKs and common surface. |
| [web--fakecloud-sdks-typescript--typescript-client-surface-and-license.md](../sections/web--fakecloud-sdks-typescript--typescript-client-surface-and-license.md) | TypeScript client surface and license. |
| [web--fakecloud-reference-security--sigv4-verification-and-root-bypass.md](../sections/web--fakecloud-reference-security--sigv4-verification-and-root-bypass.md) | SigV4 verification and the root bypass. |
| [web--fakecloud-reference-security--iam-evaluator-and-condition-keys.md](../sections/web--fakecloud-reference-security--iam-evaluator-and-condition-keys.md) | IAM evaluator and condition keys. |
| [web--fakecloud-reference-introspection--endpoint-catalog.md](../sections/web--fakecloud-reference-introspection--endpoint-catalog.md) | Endpoint catalog. |
| [web--fakecloud-reference-limitations--known-limitations.md](../sections/web--fakecloud-reference-limitations--known-limitations.md) | Known limitations. |

## See also

- [[conformance-versus-behavior-parity]] - the distinction the parity matrix draws between API-shape conformance and emulated behavior (not yet a concept page).
