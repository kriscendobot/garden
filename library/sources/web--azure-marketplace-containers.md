---
source_kind: web
source_url: https://learn.microsoft.com/en-us/partner-center/marketplace-offers/marketplace-containers
source_date: 2025-07-31
source_authors: [Microsoft Learn Partner-Center Marketplace Team]
ingested: 2026-06-17
ingested_by: scholar
section_count: 1
status: current
notes: "Azure container offers are Kubernetes-only as of 2024-01-18 (Docker container images retired). Counterpart of AWS Marketplace's container product page; structurally similar at the Helm + ACR/ECR layer but the pricing-model menu differs substantially (Azure has 8 predefined per-pod / per-node / per-core variants plus custom; AWS has MeterUsage/RegisterUsage)."
---

A Microsoft Marketplace container offer is a Kubernetes application (Helm chart + Azure Resource Manager template, packaged as a CNAB and hosted in Azure Container Registry) deployable to a managed Azure Kubernetes Service cluster. Docker container images were retired 2024-01-18; all new container offers must be Kubernetes applications. Transactable offers are billed through Microsoft using one of eight predefined billing models, BYOL, or custom meters.

| Section | Topics | Status |
|---------|--------|--------|
| [requirements-pricing-and-lifecycle](../sections/web--azure-marketplace-containers--requirements-pricing-and-lifecycle.md) | cloud-marketplace, node-packaging | current |
