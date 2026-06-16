---
title: "Billing integration: pricing models"
source_kind: web
source_url: https://docs.aws.amazon.com/marketplace/latest/userguide/container-product-policies.html
source_date: 2025-05-01
ingested: 2026-06-11
ingested_by: scholar
topics: [cloud-marketplace, node-packaging]
status: current
notes: "Metering details also from container-products-billing-integration.html. Updated May 1, 2025."
parent: web--aws-marketplace-container-requirements--technical-security
---

| Model | Integration |
|---|---|
| Hourly / fixed monthly | `RegisterUsage` API. AWS meters automatically based on task/pod count. |
| Custom metering (usage-based) | `MeterUsage` API. Seller defines dimensions (up to 24); sends hourly metering records with dimension name and quantity. |
| Contract pricing | AWS License Manager. Buyer receives a license; software checks entitlement via License Manager APIs. |

Both MeterUsage and RegisterUsage serve dual purpose: they check entitlement (is the buyer subscribed?) and report usage for billing. If a buyer is not entitled, these APIs return `CustomerNotEntitledException`.

### MeterUsage integration notes

- Do not configure the AWS SDK to use a specific region; obtain the region dynamically at runtime.
- Integrate metering directly into the software (not via CMD/ENTRYPOINT in the base image) so buyers cannot override it by inserting new image layers.
- Managed product codes in a way buyers cannot modify (or maintain a trusted product-code list to prevent free-code substitution for paid-code).

Source: [Container-based product requirements](https://docs.aws.amazon.com/marketplace/latest/userguide/container-product-policies.html) and [Container product billing, metering, and licensing integrations](https://docs.aws.amazon.com/marketplace/latest/userguide/container-products-billing-integration.html) retrieved 2026-06-11.
