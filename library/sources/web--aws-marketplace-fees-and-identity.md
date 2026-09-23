---
source_kind: web
source_url: https://docs.aws.amazon.com/marketplace/latest/userguide/listing-fees.html
source_date: 2025-04-01
source_authors: [AWS Marketplace Documentation Team]
ingested: 2026-06-17
ingested_by: scholar
section_count: 2
status: current
notes: "Coverage of AWS-Marketplace dimensions not in the existing AMI / container source pages: (1) the canonical listing-fee table including server fees (20%), private-offer tiers, CPPO uplift, regional uplifts; (2) identity-bonding / IAM Identity Center SSO integration for SaaS Listings (ResolveCustomer + SNS subscription lifecycle + IAM Identity Center buyer SSO)."
---

The two AWS Marketplace dimensions not covered by the existing AMI and container source pages: the canonical listing-fee table (which determines the economic shape of *any* AWS Marketplace listing including the Gateway) and the identity-bonding hooks (Marketplace Metering Service `ResolveCustomer` + SNS topics + IAM Identity Center buyer SSO). Both are required reading for a Gateway-as-AWS-Marketplace sequencing decision.

| Section | Topics | Status |
|---------|--------|--------|
| [listing-fees-and-partner-network](../sections/web--aws-marketplace-fees-and-identity--listing-fees-and-partner-network.md) | cloud-marketplace, node-packaging | current |
| [identity-bonding-and-saas-listings-api](../sections/web--aws-marketplace-fees-and-identity--identity-bonding-and-saas-listings-api.md) | cloud-marketplace, node-packaging | current |
