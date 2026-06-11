---
title: "AWS Marketplace AMI product: pricing models and listing/review process"
source_kind: web
source_url: https://docs.aws.amazon.com/marketplace/latest/userguide/ami-single-ami-products.html
source_date: 2025-05-01
ingested: 2026-06-11
ingested_by: scholar
topics: [cloud-marketplace, node-packaging]
status: current
notes: "Pricing model table confirmed across ami-single-ami-products.html and product-submission.html. Timelines from product-submission.html."
---

## Abstract

AWS Marketplace offers six pricing models for AMI products. Sellers choose one at creation time; some changes between models require AWS review. The listing process moves through Draft, Limited (testable by seller and a curated allowlist), and Public states, with 7–10 business days for initial publication and 2–4 calendar weeks total. For a self-custodial node product, the relevant models are Paid Hourly, Paid Hourly-Annual, and Paid Usage (custom metering via MeterUsage); the review timeline must be budgeted into any Phase 11 milestone plan.

## Pricing models

| Model | How it works |
|---|---|
| Free | No software charge; buyer still pays EC2 costs. |
| Bring Your Own License (BYOL) | Buyer obtains license from seller outside AWS Marketplace. |
| Paid Hourly | Flat per-hour price per instance type; AWS meters automatically from AMI product code. |
| Paid Hourly with Annual | Hourly rate plus optional annual subscription (up to ~40% savings vs. hourly). Annual subscriptions require hourly pricing to also be defined; annual-only is not permitted. Multi-year contracts (up to 12 years) available via private offers. |
| Paid Monthly | Fixed monthly charge regardless of running hours. |
| Paid Usage (Custom Metering) | Usage-based billing via the AWS Marketplace Metering Service (MeterUsage API). Seller chooses one usage category from: Users, Hosts, Data, Bandwidth, or Unit. Up to 24 pricing dimensions within the category. Metering records sent hourly. Three consumption models: Provisioned, Concurrent, Accumulated. Dimensions are locked after product publication; new dimensions may be added up to the 24-dimension limit. |
| Contract Pricing | Upfront fee for a single AMI or AMI with CloudFormation stack. |

Annual pricing caveat: all annual instance types must also have a corresponding hourly type.

Custom metering (Paid Usage) notes:
- Seller software calls `MeterUsage` API once per hour with dimension name and quantity.
- The dimension name (FCP Dimension Name) is limited to 15 characters, alphanumeric and underscore only.
- Products using custom metering cannot be converted to hourly, monthly, or BYOL after publication.
- Free trial and annual pricing are not compatible with custom metering.

## Listing and review process

1. **Seller registration**: Tax and banking information required for paid products.
2. **AMI preparation**: Build AMI meeting all security and architecture requirements. AMI must reside in us-east-1 owned by the seller account.
3. **Self-service scan**: Use "Test Add Version" in the AWS Marketplace Management Portal; scan typically completes in under an hour.
4. **Submission**: Submit via the Build tab (self-service experience) or Assets tab (product load form for complex configurations).
5. **Limited state**: After submission validates, product enters Limited state — visible only to the seller's account and an optional allow-listed set of test accounts. Test thoroughly here.
6. **Public publication**: Request Update Visibility. AWS Marketplace Seller Operations reviews.
7. **AMI cloning**: AWS creates region-specific clones and attaches a product code for metering and access control.

Timing:
- Initial publication: 7–10 business days if no errors.
- Total request time: 2–4 calendar weeks for new products.
- Planned events or releases: submit at least 45 days in advance.
- Price changes: 90-day notice; effective on the first of the month following the 90-day window.
- Region or instance-type changes: 90-day process.

Source: [Creating AMI-based products](https://docs.aws.amazon.com/marketplace/latest/userguide/ami-single-ami-products.html) and [Submitting your product for publication](https://docs.aws.amazon.com/marketplace/latest/userguide/product-submission.html) retrieved 2026-06-11.
