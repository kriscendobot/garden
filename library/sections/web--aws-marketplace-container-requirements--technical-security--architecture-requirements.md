---
title: Architecture requirements
source_kind: web
source_url: https://docs.aws.amazon.com/marketplace/latest/userguide/container-product-policies.html
source_date: 2025-05-01
ingested: 2026-06-11
ingested_by: scholar
topics: [cloud-marketplace, node-packaging]
status: current
notes: "Metering details also from container-products-billing-integration.html. Updated May 1, 2025."
parent: web--aws-marketplace-container-requirements--technical-security
---

- Source container images must be pushed to the AWS Marketplace-managed Amazon ECR repository (created in the AWS Marketplace Management Portal).
- Container images must be Linux-based.
- Paid products must deploy on Amazon ECS, Amazon EKS, or AWS Fargate.
- For EKS add-on products: must support both AMD64 and ARM64; must use a Helm chart.

### Helm chart requirements

- All container image references must be defined exclusively in `values.yaml`, not hardcoded in other chart files. This enables AWS Marketplace to replace references for cross-region replication.
- Helm templates must reference image variables using standard Helm syntax: `{{ .Values.image.repository }}:{{ .Values.image.tag }}`.
- The chart must be self-contained; all dependencies (including open-source images) must be pushed to AWS Marketplace ECR repositories. External references (Docker Hub, ECR Public, GitHub) are not allowed.

Source: [Container-based product requirements](https://docs.aws.amazon.com/marketplace/latest/userguide/container-product-policies.html) and [Container product billing, metering, and licensing integrations](https://docs.aws.amazon.com/marketplace/latest/userguide/container-products-billing-integration.html) retrieved 2026-06-11.
