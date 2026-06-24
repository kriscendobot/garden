---
source_kind: web
source_url: https://learn.microsoft.com/en-us/partner-center/marketplace-offers/publisher-guide-by-offer-type
source_date: 2025-06-09
source_authors: [Microsoft Learn Partner-Center Marketplace Team]
ingested: 2026-06-17
ingested_by: scholar
section_count: 3
status: current
notes: "Canonical entry point for Azure (Microsoft) Marketplace publisher offer types. Companion reference for scout 4ed554 (Gateway cloud-marketplace reconnaissance). Three section files cover overall offer type taxonomy, VM offers, and SaaS offers, with separate sources for container offers (`web--azure-marketplace-containers.md`) since that page is substantially distinct in shape."
---

The publisher-facing taxonomy of Microsoft Marketplace (rebranded from Azure Marketplace + AppSource in September 2025) offer types: Azure Application (solution-template and managed-application sub-types), Azure Container (Kubernetes apps deployed to AKS only — Docker container images were retired 2024-01-18), Azure Virtual Machine, Professional Service, Dynamics 365, Managed Service (via Azure Lighthouse), Microsoft 365, Power BI App, and Software as a Service. Each type has a fixed transaction-vs-listing capability profile, identity-integration requirement (Microsoft Entra ID is mandatory for transactable offers other than Contact-me), and review path. The page itself is the routing tree; per-type planning pages carry the technical details. Once an offer type is selected, it cannot be changed without creating a new offer.

| Section | Topics | Status |
|---------|--------|--------|
| [offer-type-taxonomy](../sections/web--azure-marketplace-publisher-guide--offer-type-taxonomy.md) | cloud-marketplace, node-packaging | current |
| [vm-offer-requirements](../sections/web--azure-marketplace-publisher-guide--vm-offer-requirements.md) | cloud-marketplace, node-packaging | current |
| [saas-offer-requirements](../sections/web--azure-marketplace-publisher-guide--saas-offer-requirements.md) | cloud-marketplace, node-packaging | current |
