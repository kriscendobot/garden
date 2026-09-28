---
title: Policy features and trust enforcement
source_kind: web
source_url: https://fakecloud.dev/docs/services/iam/
source_content_sha256: 2b8493e90eb3f96b5b0f69697143c4ba1543c7ec21c54c9179a50009f666433a
source_authors: ["faisca (fakecloud project)"]
source_date: 2026-09-28
ingested: 2026-09-28
ingested_by: gardener
topics: [cloud-emulation, policy-language-authorization]
status: current
---

fakecloud's IAM carries the real AWS-managed policy catalog, runs `SimulatePrincipalPolicy` through the same evaluator as enforcement, checks PassRole trust and `sts:ExternalId`, and enforces permission boundaries, session policies, and ABAC tag conditions, all of it evaluated only when `FAKECLOUD_IAM` is `soft` or `strict`.

"fakecloud implements 180 of 180 IAM operations at 100% Smithy conformance." Selected features:

- **Policies** — managed policies and versions; `SimulateCustomPolicy` / `SimulatePrincipalPolicy` "run the same evaluator real IAM enforcement uses", returning `allowed` / `explicitDeny` / `implicitDeny` over identity and resource policies, boundaries, session policies, SCPs, and `Condition` blocks.
- **AWS-managed policies** — the full catalog (~1,500, including `service-role/` and `aws-service-role/`) with each policy's real default-version document.
- **PassRole trust enforcement** — a role passed to Lambda `CreateFunction` or ECS is checked against the calling service principal and rejected if the trust policy does not allow it.
- **ExternalId enforcement on AssumeRole** — missing, empty, or mismatched `ExternalId` fails with `AccessDenied`.
- **Permission boundaries**, **session policies** (intersection recorded on issued credentials and enforced on later calls), **ABAC** (`aws:ResourceTag/*`, `aws:RequestTag/*`, `aws:TagKeys`, `aws:PrincipalTag/*`) across S3, SQS, SNS, IAM, KMS, DynamoDB, and `NotPrincipal` with KMS key policies in cross-account combining.
- Unrecognized principals log a `warn` on first evaluation rather than silently bypassing.

**Gotchas:** "Policies are stored and optionally evaluated. By default fakecloud records IAM policies without evaluating them. Set `FAKECLOUD_IAM=strict` (or `soft` for log-only)." And: "SigV4 verification is opt-in ... The reserved `test`/`test` root-bypass convention always passes, matching LocalStack." Protocol: Query (form-encoded, XML responses).

Source: [fakecloud docs/services/iam](https://fakecloud.dev/docs/services/iam/), retrieved 2026-09-28. Derived summary of vendor documentation; treat claims as the project's self-report.
