---
title: Abstract
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

AWS Marketplace container product requirements mirror the AMI requirements on credential embedding and vulnerability scanning, but are ECS/EKS/Fargate-specific: images must go into AWS Marketplace-managed ECR repositories, must be Linux-based, must use IAM roles (not embedded credentials) for AWS service access, and must integrate with either the MeterUsage or RegisterUsage metering API for paid products. Helm chart products have additional structural requirements for image references and regionalization. For a containerized Endo gateway node, these rules govern how the image is packaged, how billing integrates, and what the user's deployment experience looks like.

Source: [Container-based product requirements](https://docs.aws.amazon.com/marketplace/latest/userguide/container-product-policies.html) and [Container product billing, metering, and licensing integrations](https://docs.aws.amazon.com/marketplace/latest/userguide/container-products-billing-integration.html) retrieved 2026-06-11.
