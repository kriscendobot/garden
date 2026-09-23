---
title: Pricing models
source_kind: web
source_url: https://docs.aws.amazon.com/marketplace/latest/userguide/ami-single-ami-products.html
source_date: 2025-05-01
ingested: 2026-06-11
ingested_by: scholar
topics: [cloud-marketplace, node-packaging]
status: current
notes: "Pricing model table confirmed across ami-single-ami-products.html and product-submission.html. Timelines from product-submission.html."
parent: web--aws-marketplace-ami-requirements--pricing-and-listing
---

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

Source: [Creating AMI-based products](https://docs.aws.amazon.com/marketplace/latest/userguide/ami-single-ami-products.html) and [Submitting your product for publication](https://docs.aws.amazon.com/marketplace/latest/userguide/product-submission.html) retrieved 2026-06-11.
