---
title: "AWS Marketplace listing fees, partner-network enrollment, and seller-agreement terms"
source_kind: web
source_url: https://docs.aws.amazon.com/marketplace/latest/userguide/listing-fees.html
source_date: 2025-04-01
ingested: 2026-06-17
ingested_by: scholar
topics: [cloud-marketplace, node-packaging]
status: current
notes: "These fees are effective 2024-01-05 (the AWS Marketplace 'simplified and reduced listing fees' announcement). Server fee at 20% is the line item with the largest economic impact for a Gateway AMI / container listing; consider whether a SaaS shape (3%) is feasible instead."
---

AWS Marketplace fees apply per transaction, not per listing — there is no fee to list a product, only to transact through one. The fee table varies along three axes: (1) deployment method (SaaS vs. Server vs. Data Exchange), (2) offer shape (public vs. private vs. CPPO), and (3) Total Contract Value tier (private offers only). Regional uplifts apply additively for South Korea (as of 2025-04-01); other regions may follow.

## Public-offer listing fees

| Deployment method | Fee |
|---|---|
| Software-as-a-service (SaaS) | 3% |
| Server (AMI, container, machine learning) | **20%** |
| AWS Data Exchange | 3% |

The 20% server fee is the highest fee in the AWS Marketplace fee table and the strongest economic incentive against publishing as an AMI / container if a SaaS shape is feasible.

## Private-offer listing fees (Total Contract Value tiered)

| TCV | Fee |
|---|---|
| Less than $1M | 3% |
| $1M to less than $10M | 2% |
| ≥ $10M | 1.5% |
| All renewals | 1.5% |

These tiers apply to private offers; public offers pay the public-offer fee regardless of contract value.

## Channel Partner Private Offer (CPPO) listing fees

CPPO products have a **+0.5% uplift** on the listing fee, regardless of offer type or deployment method. Example: a SaaS private offer with TCV <$1M sold via CPPO has 3% + 0.5% = 3.5% total fee.

## Professional services listing fees

Professional services offerings have a 0.5% listing fee for private offers (no public-offer SKU).

## Regional listing fees (additive)

| Region | Additional regional fee | Effective date |
|---|---|---|
| South Korea | +1% | 2025-04-01 |

Regional fees are additive: a SaaS private offer with TCV <$1M sold to a buyer in South Korea pays 3% (standard private) + 1% (region) = 4% total.

## Seller-agreement and registration prerequisites

To register as an AWS Marketplace seller:

1. Register with the AWS Partner Network (APN) and pay the applicable program fee. AWS Partner Network membership is the gating prerequisite.
2. Link an AWS account to a Marketplace seller account.
3. Agree to the AWS Marketplace Seller Agreement (latest update 2025-03-31).
4. Provide business and tax information.
5. AWS reviews registration; additional eligibility / compliance checks may apply before listing is allowed.

Key seller-agreement terms (from 2025 update):

- AWS may review or remove offerings with a **30-day deactivation notice**.
- A **90-day wind-down period** is provided for current subscribers when an offering is deactivated.
- AWS acts as the payment processing agent for the seller.

## Ongoing fees vs. transaction fees

Per the AWS Marketplace docs: *"sellers are not required to pay any upfront or recurring fees to maintain their listings on the marketplace."* All fees are transaction-triggered and calculated on pre-tax Total Contract Value.

## Identity-bonding section pointer

The companion section [identity-bonding-and-saas-listings-api](web--aws-marketplace-fees-and-identity--identity-bonding-and-saas-listings-api.md) covers `ResolveCustomer` + SNS topic lifecycle + IAM Identity Center buyer SSO.

Sources retrieved 2026-06-17:
- [Understanding listing fees for AWS Marketplace sellers](https://docs.aws.amazon.com/marketplace/latest/userguide/listing-fees.html)
- [AWS Marketplace announces simplified and reduced listing fees for sellers (2024-01)](https://aws.amazon.com/about-aws/whats-new/2024/01/aws-marketplace-simplified-reduced-listing-fees/)
- [AWS Marketplace Partner Network](https://aws.amazon.com/partners/aws-marketplace/)
