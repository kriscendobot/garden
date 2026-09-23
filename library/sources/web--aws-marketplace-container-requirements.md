---
source_kind: web
source_url: https://docs.aws.amazon.com/marketplace/latest/userguide/container-product-policies.html
source_date: 2025-05-01
source_authors: [AWS Documentation Team]
ingested: 2026-06-11
ingested_by: scholar
section_count: 1
status: current
notes: "Covers container product policy page and billing/metering integration page. One section file covering both technical requirements and pricing models (the two are inseparable for container paid products)."
---

AWS Marketplace's requirements for container-based product listings, effective May 1, 2025. Images must be pushed to AWS Marketplace-managed ECR, must be Linux-based, must not embed credentials (use IAM roles for tasks/pods), and must integrate with either MeterUsage (custom metering) or RegisterUsage (hourly/task-count) APIs for paid products. Helm charts have additional structural requirements (image references only in values.yaml). For container-packaged Endo gateway: these constraints govern image preparation, billing integration choice, and deployment experience.

| Section | Topics | Status |
|---------|--------|--------|
| [technical-security](../sections/web--aws-marketplace-container-requirements--technical-security.md) | cloud-marketplace, node-packaging | current |
