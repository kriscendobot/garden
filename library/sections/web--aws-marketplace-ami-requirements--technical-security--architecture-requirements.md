---
title: Architecture requirements
source_kind: web
source_url: https://docs.aws.amazon.com/marketplace/latest/userguide/product-and-ami-policies.html
source_date: 2025-05-01
ingested: 2026-06-11
ingested_by: scholar
topics: [cloud-marketplace, node-packaging]
status: current
notes: "AWS updated these requirements as of May 1, 2025. Continuously scanned post-listing."
parent: web--aws-marketplace-ami-requirements--technical-security
---

- Source AMIs must be provided in the US East (N. Virginia / us-east-1) Region.
- Must use HVM virtualization.
- Must use x86-64 or 64-bit ARM architecture.
- Must be EBS-backed. S3-backed AMIs are not supported.
- Must not use encrypted EBS snapshots.
- Must not use encrypted file systems.
- Must be built to run in all AWS Regions and must be region-agnostic. Per-region AMI variants are not allowed.

Source: [AMI-based product requirements for AWS Marketplace](https://docs.aws.amazon.com/marketplace/latest/userguide/product-and-ami-policies.html) retrieved 2026-06-11.
