---
title: "Microsoft Marketplace offer type taxonomy"
source_kind: web
source_url: https://learn.microsoft.com/en-us/partner-center/marketplace-offers/publisher-guide-by-offer-type
source_date: 2025-06-09
ingested: 2026-06-17
ingested_by: scholar
topics: [cloud-marketplace, node-packaging]
status: current
notes: "Routing-tree page; per-type details are on companion sections (vm-offer-requirements, saas-offer-requirements) and on the container offer's own source page (web--azure-marketplace-containers)."
---

Microsoft Marketplace publishers must select one of nine offer types before creating an offer. The offer type is permanent for that listing: switching requires creating a new offer. Each type implies a distinct transaction-capability profile (transactable through Microsoft vs. listing-only), identity-integration requirement, and review path. The complete taxonomy as of June 2025:

| Offer type | Best for | Description |
|---|---|---|
| **Azure Application** | Multi-resource Azure deployments | Two plan kinds: *solution template* (listing-only, customer manages, billed via deployed VM) and *managed application* (transactable via Microsoft Marketplace, publisher-managed-or-customer-managed). |
| **Azure Container** | Kubernetes apps on AKS | Container images packaged as Cloud Native Application Bundle (CNAB) hosted in Azure Container Registry. **Docker container images were retired 2024-01-18; all new offers are Kubernetes Applications.** |
| **Azure virtual machine** | Virtual appliances / software images | Deploys a VHD-based VM to the customer's Azure subscription. Transactable. |
| **Professional service** | Consulting / implementation services | Assessment, briefing, implementation, PoC, workshop, migration, customer support — services that support Microsoft Cloud. |
| **Dynamics 365** | Solutions extending Dynamics 365 | Builds on or extends Dynamics 365 products. |
| **Managed service** | Managed Azure resources via delegation | Manages customer-delegated subscriptions or resource groups through Azure Lighthouse. |
| **Microsoft 365** | Solutions extending Microsoft 365 | Office add-ins, Teams apps, SharePoint Framework solutions. |
| **Power BI app** | Solutions extending Power BI | Builds on or extends Power BI. |
| **Software as a Service** | Cloud-based subscription software | Publisher-hosted SaaS sold as a subscription; transactable through Microsoft using SaaS Fulfillment APIs. Microsoft Entra ID single sign-on is required for buyers. |

## Account prerequisite

Publishing requires a Microsoft Marketplace account in Partner Center, enrolled in the Microsoft Marketplace program. Account verification gates first listing. See [Create a Microsoft Marketplace account in Partner Center](https://learn.microsoft.com/en-us/partner-center/account-settings/create-account).

## Once-and-done choice warning

The page repeats this warning twice (verbatim): *"After you select an offer type, you cannot change it later. To use a different offer type, you'll need to create a new offer."* This affects the Gateway's marketplace sequencing: an AMI-first listing cannot be promoted to a Kubernetes-app listing later without a new listing identity (and a new review cycle).

## Decision factors

Microsoft Learn's stated decision factors (verbatim from the page): "**Solution type**: What kind of technical solution, business application, or service are you providing? **Deployment model**: How will your solution be deployed and managed? **Pricing model**: What monetization approach works best for your solution?"

## Translation to AWS Marketplace vocabulary

For Gateway-side planning, the Microsoft Marketplace offer types map roughly to AWS Marketplace artifact shapes as follows:

| Microsoft Marketplace | AWS Marketplace equivalent | Differences |
|---|---|---|
| Azure virtual machine | AMI Product | Both are VM images; Azure uses VHD instead of AMI; both transactable. |
| Azure Container (Kubernetes only) | Container Product (ECS/EKS/Fargate) | Microsoft *removed* plain Docker-image offers in 2024; AWS still accepts them. |
| Software as a Service | SaaS Product | Both publisher-hosted; identity-integration is mandatory and platform-specific (Entra ID vs. AWS Marketplace Metering Service `ResolveCustomer`). |
| Azure Application (solution template / managed application) | CloudFormation Quick Start | AWS does not have a managed-application analogue with publisher-managed customer resources. |
| Professional service | AWS Marketplace Professional Services | Direct analogue. |
| Managed service (via Lighthouse) | (no exact AWS analogue) | Lighthouse-style cross-tenant delegation has no AWS Marketplace SKU. |

Source: [Publishing guide by offer type — Microsoft Marketplace](https://learn.microsoft.com/en-us/partner-center/marketplace-offers/publisher-guide-by-offer-type) retrieved 2026-06-17.
