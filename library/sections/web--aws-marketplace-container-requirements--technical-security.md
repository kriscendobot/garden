---
title: "AWS Marketplace container product requirements: security, architecture, and metering"
source_kind: web
source_url: https://docs.aws.amazon.com/marketplace/latest/userguide/container-product-policies.html
source_date: 2025-05-01
ingested: 2026-06-11
ingested_by: scholar
topics: [cloud-marketplace, node-packaging]
status: current
notes: "Metering details also from container-products-billing-integration.html. Updated May 1, 2025."
---

## Abstract

AWS Marketplace container product requirements mirror the AMI requirements on credential embedding and vulnerability scanning, but are ECS/EKS/Fargate-specific: images must go into AWS Marketplace-managed ECR repositories, must be Linux-based, must use IAM roles (not embedded credentials) for AWS service access, and must integrate with either the MeterUsage or RegisterUsage metering API for paid products. Helm chart products have additional structural requirements for image references and regionalization. For a containerized Endo gateway node, these rules govern how the image is packaged, how billing integrates, and what the user's deployment experience looks like.

## Security requirements

All container-based products must:

- Not contain any known vulnerabilities, malware, or end-of-life software packages or OS.
- Not request AWS credentials to access AWS services. Use IAM roles for service accounts (EKS) or IAM roles for tasks (ECS) instead.
- Only require least privileges to run.
- Be configured to run with non-root privileges by default.
- Not contain hardcoded secrets: no system/service passwords (even hashed), no private keys, no credentials.
- Not use password-based authentication for any services running inside the container, even if generated at launch.
- Not include image layers with unsupported architectures (for example, in-toto Attestation Framework metadata in an incompatible form).

Images are scanned for vulnerabilities when submitted. AWS credentials for the buyer are automatically obtained at runtime when the container runs inside ECS or EKS; never configure credentials in the image.

## Architecture requirements

- Source container images must be pushed to the AWS Marketplace-managed Amazon ECR repository (created in the AWS Marketplace Management Portal).
- Container images must be Linux-based.
- Paid products must deploy on Amazon ECS, Amazon EKS, or AWS Fargate.
- For EKS add-on products: must support both AMD64 and ARM64; must use a Helm chart.

### Helm chart requirements

- All container image references must be defined exclusively in `values.yaml`, not hardcoded in other chart files. This enables AWS Marketplace to replace references for cross-region replication.
- Helm templates must reference image variables using standard Helm syntax: `{{ .Values.image.repository }}:{{ .Values.image.tag }}`.
- The chart must be self-contained; all dependencies (including open-source images) must be pushed to AWS Marketplace ECR repositories. External references (Docker Hub, ECR Public, GitHub) are not allowed.

## Billing integration: pricing models

| Model | Integration |
|---|---|
| Hourly / fixed monthly | `RegisterUsage` API. AWS meters automatically based on task/pod count. |
| Custom metering (usage-based) | `MeterUsage` API. Seller defines dimensions (up to 24); sends hourly metering records with dimension name and quantity. |
| Contract pricing | AWS License Manager. Buyer receives a license; software checks entitlement via License Manager APIs. |

Both MeterUsage and RegisterUsage serve dual purpose: they check entitlement (is the buyer subscribed?) and report usage for billing. If a buyer is not entitled, these APIs return `CustomerNotEntitledException`.

### MeterUsage integration notes

- Do not configure the AWS SDK to use a specific region; obtain the region dynamically at runtime.
- Integrate metering directly into the software (not via CMD/ENTRYPOINT in the base image) so buyers cannot override it by inserting new image layers.
- Managed product codes in a way buyers cannot modify (or maintain a trusted product-code list to prevent free-code substitution for paid-code).

Source: [Container-based product requirements](https://docs.aws.amazon.com/marketplace/latest/userguide/container-product-policies.html) and [Container product billing, metering, and licensing integrations](https://docs.aws.amazon.com/marketplace/latest/userguide/container-products-billing-integration.html) retrieved 2026-06-11.
