---
title: "Azure Marketplace container offer: technical requirements, eight billing models, and lifecycle"
source_kind: web
source_url: https://learn.microsoft.com/en-us/partner-center/marketplace-offers/marketplace-containers
source_date: 2025-07-31
ingested: 2026-06-17
ingested_by: scholar
topics: [cloud-marketplace, node-packaging]
status: current
notes: "Counterpart of web--aws-marketplace-container-requirements. Azure Kubernetes-only; AWS supports Kubernetes plus Helm plus plain Docker. Azure offers eight predefined pricing dimensions natively; AWS routes everything through MeterUsage/RegisterUsage."
---

Microsoft Marketplace container offers target only Azure Kubernetes Service deployments. The artifact is a Kubernetes Application (Helm chart, Kubernetes manifest, `createUiDefinition.json`, and Azure Resource Manager template) packaged as a Cloud Native Application Bundle (CNAB) and hosted in an Azure Container Registry repository. The listing's customer-facing button is *Get It Now*.

## Technical fundamentals

- Solution must be deployable to a managed AKS cluster (or Azure Arc-enabled Kubernetes cluster, with caveats — custom-meter billing isn't yet supported on Arc-enabled clusters).
- Artifacts (Helm chart, manifest, `createUiDefinition.json`, ARM template) must be packaged as a CNAB.
- CNAB hosted in Azure Container Registry (ACR). Microsoft documents the ACR onboarding flow.
- *Docker container images retired 2024-01-18.* New offers must be Kubernetes Applications.

## Licensing options (eight predefined billing dimensions plus BYOL plus Custom)

| Licensing option | Transaction process |
|---|---|
| **Free** | List free; no charge. |
| **Bring your own license (BYOL)** | Publisher supports all aspects of the license transaction. |
| **Per every core in cluster** | Charged per total CPU core in the cluster, hourly. |
| **Per core** | Charged per CPU core used by the Kubernetes application extension, hourly. |
| **Per cluster** | Charged per Kubernetes application extension instance, hourly. |
| **Per every node in cluster** | Charged per total node in the cluster, hourly. |
| **Per node** | Charged per node where the Kubernetes application extension runs, hourly. |
| **Per pod** | Charged per pod running the application extension, hourly. |
| **Custom** | Publisher-defined dimensions; application reports usage. Supports advanced billing models (tiered pricing via multiple custom meters). **Currently not supported on Azure Arc-Enabled Kubernetes clusters.** |

The eight predefined models report at hourly frequency. Free + BYOL + custom-meter combinations are configurable, but custom-only models lose hourly auto-metering convenience.

## Offer requirements (verbatim from the page)

| Requirement | Details |
|---|---|
| Billing and metering | Support one of the predefined, custom, or BYOL billing models. |
| Artifacts packaged as a CNAB | Helm chart, manifest, `createUiDefinition.json`, ARM template must be packaged as a CNAB. |
| Hosting in an Azure Container Registry repository | The CNAB must be hosted in ACR. |

## Customer leads, listing details, preview audience

Same Partner Center plumbing as VM offers: leads flow to the Referrals workspace; CRM integration available (Dynamics 365, Marketo, Salesforce, Azure tables, generic HTTPS endpoint via Power Automate); offer listing requires logo (PNG), 1-5 screenshots (1280x720), optional videos (up to 4), descriptions in five fields, plus general/SaaS certification policies must be met before publish.

A preview audience is set via Azure subscription IDs (10 manual, 100 via CSV) and gates pre-launch testing.

## Comparison with AWS Marketplace Container Products

- **Azure**: Kubernetes-only since 2024. ACR-hosted. Eight predefined pricing dimensions + BYOL + custom.
- **AWS**: still supports plain Docker container images plus Helm charts. ECR-hosted (AWS Marketplace-managed ECR). Two billing-integration APIs: `MeterUsage` (custom metering) and `RegisterUsage` (hourly or per-task). Helm-chart structural requirements (image references only in `values.yaml`).
- **Implication for the Endo gateway**: an Azure container listing forces the gateway into a Kubernetes Application shape. The OS-process / systemd packaging path doesn't translate; the gateway would need to be re-packaged as a deployable AKS extension. The pricing-model menu is friendlier (less integration code) but the deployment-shape constraint is sharper.

Source: [Plan a Microsoft Marketplace Container offer](https://learn.microsoft.com/en-us/partner-center/marketplace-offers/marketplace-containers) retrieved 2026-06-17.
