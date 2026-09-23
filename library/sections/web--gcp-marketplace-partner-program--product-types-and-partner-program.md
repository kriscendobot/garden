---
title: "GCP Marketplace product types, partner program enrollment, and unified billing"
source_kind: web
source_url: https://docs.cloud.google.com/marketplace/docs/partners
source_date: 2025-09-01
ingested: 2026-06-17
ingested_by: scholar
topics: [cloud-marketplace, node-packaging]
status: current
notes: "Aggregated from the partner overview page plus the partner get-started, VM, and Kubernetes-app sub-pages. GCP's partner docs tree is shallower than AWS's or Azure's — many specifics live in code-lab tutorials rather than reference pages."
---

Google Cloud Marketplace's partner program supports seven product categories. Partners must be members of the Google Cloud Partner Network, hold a Marketplace vendor account with a Payment Profile in good standing, and be incorporated in a supported region. The standard revenue share is 3%; for products that pass internal validation but don't meet all listing requirements, an "adjusted revenue share" may apply (specifics not disclosed publicly).

## Product types

| Type | Description (verbatim or paraphrased from partner docs) |
|---|---|
| **AI Agents** | Offer AI agents (newest category, added 2025). |
| **SaaS Products** | Partner-hosted software billed by Google through Cloud Console. Integration through Cloud Commerce Partner Procurement API + Service Control API. |
| **Virtual Machine** | Compute Engine images deployed via Deployment Manager or Terraform templates. Image hosted by Cloud Marketplace with attached Compute Engine license. |
| **Kubernetes Applications** | Containerized apps deployed to Google Kubernetes Engine or to the customer's own Kubernetes infrastructure. Configuration as Kubernetes YAML manifest or Helm chart, with an Application CRD describing the app. Deployer container pushes the config to the Kubernetes API. As of 2025-01-20, all new or updated GKE app listings must annotate their image manifest with the product service name. |
| **Data Products** | BigQuery Data Listings, dataset publishing. |
| **Professional Services** | Consulting / implementation services. |
| **Container Images** | Free container images only (paid container distribution goes through the Kubernetes Application type). |

## Partner program enrollment

Steps from the partner get-started checklist:

1. Join the Google Cloud Partner Network (Partner Network Hub) if not already a member.
2. Confirm organization incorporation is in a supported region (consult [supported countries / regions](https://docs.cloud.google.com/marketplace/docs/partners/get-started) for the current list; supported geography expands periodically).
3. Set up a Cloud Marketplace vendor account.
4. Maintain a Payment Profile in good standing.
5. Submit each product for review; the Marketplace team works with the publisher to resolve issues.

For VM products specifically, the partner workflow has eight steps (verbatim from `partners/vm` docs):

1. Configure your Google Cloud environment for distribution.
2. Select and review a pricing model (4 business day review period).
3. Build your VM image.
4. Create deployment package.
5. Add consumption-tracking labels.
6. Conduct end-to-end testing.
7. Submit product for review and approval.
8. Maintain and monitor post-launch.

For Kubernetes apps: container images must be uploaded to Artifact Registry or Container Registry. The deployer image pushes configuration to the Kubernetes API when users deploy from Cloud Console. Apps must run on x86 nodes. Image manifests must carry the service-name annotation (as of 2025-01-20).

## Unified billing-through-Cloud-Console model

The defining feature of the GCP buyer experience: *"For most configurations, your customers receive one bill for all of your products and services, as well as the Google Cloud services that they use."* The buyer interacts with one consolidated invoice covering both the partner's product and Google's infrastructure.

For usage-based pricing, Google handles metering and bills customers dynamically. For SaaS specifically, the partner integrates the metering reports via the Service Control API; Google then bills.

## Listing review timeline

- Pricing model review: 4 business days.
- Product review (full): up to 2 weeks for some submissions (varies by product type and integration shape).

## Fee structure (independent-sources data)

Standard 3% revenue share for products meeting requirements. Tiered private-offer discounts comparable to AWS:

- 2% for private offers $1M-$10M
- 1.5% for deals over $10M
- Adjustments apply to migrations and channel-led transactions

## Comparison-relevant attributes

- **GCP customer base**: strongest in data engineering, machine-learning, AI, and analytics buyers (independent sources, see [comparative-analysis-of-aws-azure-gcp-marketplaces.md](../sections/web--comparative-analysis-aws-azure-gcp-marketplaces--landscape-fees-and-isv-fit.md)).
- **GCP onboarding complexity** (independent sources): "Medium" (compared with AWS "High" and Azure "Medium").
- **GCP payment terms**: Net 30-45 (compared with AWS Net 60).
- **GCP marketplace YoY growth** (independent sources): fastest of the three by percentage; smaller absolute base than AWS.

Source: [Google Cloud Marketplace Partners — Documentation](https://docs.cloud.google.com/marketplace/docs/partners) and [Requirements for Google Cloud Marketplace](https://docs.cloud.google.com/marketplace/docs/partners/get-started) retrieved 2026-06-17.
