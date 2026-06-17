---
title: "AWS vs. Azure vs. GCP marketplace landscape: fees, certification cadence, customer reach, and ISV fit (2025-2026)"
source_kind: web
source_url: https://divein.market/cloud-marketplace-fee-comparison-2025/
source_date: 2025-12-01
ingested: 2026-06-17
ingested_by: scholar
topics: [cloud-marketplace, node-packaging]
status: current
notes: "Independent-source synthesis. Each platform's own docs cover their own offering well but say little about how they compare; the independent reporting is where reach + onboarding-effort + customer-base differences surface."
---

Independent reporting (from 2025-2026) consistently characterizes the three hyperscaler marketplaces along five dimensions: fees, certification cadence, customer-base reach, ISV onboarding effort, and co-sell program strength. Each platform has different tradeoffs; the "best" depends on product type, deal size, and target customer.

## Fees: standard public + tiered private offers

| Platform | Standard public-offer fee | Tiered private-offer reductions | Notes |
|---|---|---|---|
| **AWS Marketplace** | 3% (SaaS, Data Exchange), 20% (Server: AMI/container/ML) | 3% <$1M, 2% $1M-$10M, 1.5% ≥$10M, 1.5% all renewals; +0.5% CPPO uplift | South Korea regional uplift +1% effective 2025-04-01. Professional services: 0.5%. |
| **Microsoft Marketplace (Azure)** | 3% flat | None — flat 3% across all deals | Stability at the expense of large-deal incentive. |
| **GCP Marketplace** | 3% baseline | 2% $1M-$10M, 1.5% ≥$10M; adjustments for migrations and channel-led | Adjusted revenue share for products not meeting all listing requirements (publicly undisclosed rates). |

### AWS-specific note: 20% server fee

AWS's server (AMI / container / ML) listing fee is 20% of transaction proceeds, compared to 3% for SaaS. This is a sharp economic incentive to publish as SaaS-Sell-Through-Microsoft / SaaS-on-GCP-Marketplace vs. as a server product. Gateway-side: an AMI-only listing on AWS carries 20% of every transaction; a SaaS listing carries 3%. Same product, different financial structure.

## Certification cadence (independent sources)

| Platform | First-listing review | Per-update review | Pricing model review |
|---|---|---|---|
| **AWS Marketplace** | 7-10 business days (2-4 calendar weeks) | Faster | (per-product) |
| **Microsoft Marketplace** | "Up to 2 weeks" varies by offer type | Faster for incremental changes | n/a (no separate model review) |
| **GCP Marketplace** | Up to 2 weeks | Variable | 4 business days specifically for pricing models |

## Customer-base reach and characteristics

| Platform | Reach character | Strongest verticals |
|---|---|---|
| **AWS Marketplace** | Broadest; AWS-native enterprises | All verticals; deepest transaction proof. |
| **Microsoft Marketplace** | Microsoft-centric enterprises | Financial services, healthcare, manufacturing, government. |
| **GCP Marketplace** | Specialized | Data engineering, machine learning, AI, analytics. |

Channel Futures (independent reporting) notes that all three marketplaces are growing rapidly in 2025-2026, with a 5-year CAGR forecast of 29.1% (2025-2030). GCP grows fastest YoY by percentage from the smallest base; AWS has the largest absolute volume; Microsoft (after the September 2025 rebrand merging Azure Marketplace + AppSource into Microsoft Marketplace) closed mindshare gap the fastest.

## ISV onboarding effort (Automatum.io 2026 comparison)

| Platform | Onboarding complexity (verbatim) | Co-sell program | Payment terms |
|---|---|---|---|
| **AWS Marketplace** | "High" | AWS ISV Accelerate (1.5% on co-sell deals) | Net 60 |
| **Microsoft Marketplace** | "Medium" | Azure IP Co-Sell | Net 30-45 |
| **GCP Marketplace** | "Medium" | GCP ISV Solution Connect | Net 30-45 |

The "High" onboarding for AWS reflects: heavier API integration (Metering Service `ResolveCustomer` + entitlement + SNS topics; separate identity model from buyer's AWS account); more pricing-model choices; stricter image security requirements; broader artifact-shape choices that each have their own review.

## Co-sell programs

- **AWS ISV Accelerate**: joint opportunity registration with AWS sales teams; reduced co-sell fees (down to 1.5%).
- **Microsoft Azure IP Co-Sell**: Microsoft sales team has financial incentive to recommend the product. Critical signal: Microsoft sales reps' compensation factors marketplace transactions.
- **GCP ISV Solution Connect**: growing program; strength in Vertex AI, BigQuery, Looker integration partnerships.

## ISV recommendation patterns (verbatim from independent sources)

From Labra's 2025 ISV guide: *"the 'best' marketplace depends on product type, deal size, and sales motion, with those pursuing large enterprise contracts benefiting most from AWS or Google Cloud, while ISVs seeking operational simplicity may prefer Azure."*

From Invisory: *"AWS Marketplace is the default starting point for most software companies."*

From Automatum.io 2026: *"the setup matters more than people think"* and *"follow customer location first, then assess product alignment and co-sell potential."*

## Comparison-table caveat

Independent comparison tables often quote a "3% to 5%" range for AWS without disambiguating server-vs-SaaS or public-vs-private. The canonical AWS fee table (`web--aws-marketplace-ami-requirements--pricing-and-listing--pricing-models` plus [Understanding listing fees](https://docs.aws.amazon.com/marketplace/latest/userguide/listing-fees.html)) carries the authoritative number per shape. Use this comparative section for landscape orientation; consult the per-vendor sources for billable figures.

## Implication for Endo Gateway sequencing

The independent comparison reinforces the maintainer's framing in `journal/projects/endo/drafts/prospectus-2026-06.md` ("AWS first"):

1. **AWS first**: largest reach, deepest transaction proof, the platform where most enterprise buyers expect a marketplace presence.
2. **Azure second**: tied to Microsoft-centric customer base; identity story (Entra ID SSO) is the cleanest for operator-as-buyer (Gateway can lean on Entra ID for sign-in); flat 3% fee structure.
3. **GCP third**: smaller base but fastest growth and a customer base aligned with the agent-tooling buyer (data + ML + AI). Listing here is a future bet on category growth.

Sources retrieved 2026-06-17:
- [Cloud Marketplace Fees Compared: AWS, Google & Azure (2025)](https://divein.market/cloud-marketplace-fee-comparison-2025/)
- [AWS vs Azure vs GCP Marketplace: 2026 Comparison](https://www.automatum.io/blog-posts/aws-vs-azure-vs-gcp-marketplace-comparison)
- [Google Cloud Marketplace (GCP) vs. Azure vs. AWS: Which is right for you?](https://invisory.co/resources/blog/google-cloud-marketplace-gcp-vs-azure-vs-aws-marketplace-which-is-right-for-you/)
- [One Chart Shows Cloud Marketplaces Going Mainstream](https://newsletter.partnerinsight.io/p/one-chart-shows-cloud-marketplaces)
- [AWS vs. Microsoft Azure vs. GCP Marketplace: Which is Best for SaaS Sellers in 2025?](https://labra.io/aws-vs-microsoft-azure-vs-gcp-marketplace-which-is-best-for-saas-sellers-in-2025/)
