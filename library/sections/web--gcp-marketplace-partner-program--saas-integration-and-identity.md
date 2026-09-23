---
title: "GCP Marketplace SaaS integration: Procurement API, Service Control API, and customer identity binding"
source_kind: web
source_url: https://docs.cloud.google.com/marketplace/docs/partners/integrated-saas
source_date: 2025-09-01
ingested: 2026-06-17
ingested_by: scholar
topics: [cloud-marketplace, node-packaging]
status: current
notes: "Identity-binding shape differs from AWS (which uses ResolveCustomer-to-AccountID mapping) and Azure (which requires Entra ID SSO directly). GCP binds the Google customer's Procurement account ID to the partner's database row, then asks the publisher to provide separate sign-in using Google credentials."
---

A Google Cloud Marketplace SaaS product is partner-hosted but billed by Google through Cloud Console. Integration is via two APIs: Cloud Commerce Partner Procurement API (for subscription lifecycle) and Service Control API (for usage reporting / metering). The customer's *Procurement account ID* is the identity-binding anchor: the partner stores it in their own database to map the Google account to the partner-side account, and provides a sign-in path that uses the customer's Google credentials.

## Integration architecture

Three core APIs and an event stream:

| API / Event | Purpose |
|---|---|
| **Cloud Commerce Partner Procurement API** | Subscription lifecycle: create, update, cancel, entitlement changes. |
| **Service Control API** | Usage reporting (metering) for usage-based pricing. Equivalent of AWS `MeterUsage` and Azure custom-meter dimensions. |
| **Pub/Sub event topic** | Asynchronous lifecycle events (entitlement creation, account changes). Partner subscribes to receive notifications. |
| **App Lifecycle Manager** | (Optional integration helper.) Manages the partner-side resources for the customer when the partner's app sets up a data plane in the customer's project and a control plane in the partner's project. Uses a consumption-tracking label. |

## Identity binding

The integration requires partners to:

1. **Create accounts for users**: front-end and back-end modifications to support per-customer accounts.
2. **Link the accounts to their Google accounts**: each customer's Google identity is associated with the partner-side account record.
3. **Provide Google-credentials sign-in**: partner's app exposes a sign-in path that uses the customer's Google credentials. (Partner can use Google Identity / OpenID Connect for this; details are partner's responsibility.)
4. **Store the Procurement account ID**: in the partner's database, mapped to the partner-side account. This is the canonical anchor for entitlement queries and metering reports.

In short, GCP's identity binding is half-baked compared with Azure (which makes Entra ID SSO mandatory) but more flexible (partner picks the implementation). It's closer to AWS Marketplace's identity model (publisher provides the identity system; Marketplace provides the customer-account anchor).

## Supported pricing models

Listed in partner SaaS docs (specifics not fully enumerated on the entry-point pages):

- Subscription (flat-rate)
- Usage-based (metered via Service Control API)
- Commitments (multi-year discounts)
- Free trial

Pricing model review: 4 business days. Models can be combined per plan (subscription with metered overage, for example).

## Review and launch

From the integrated-SaaS overview: *"Cloud Marketplace team reviews each submission and works with you to resolve any issues before approving it"* — and *"Upon approval, products can publish and launch the product within a few minutes."* The publish step itself is fast; the gating is the review.

## Consolidated billing-through-Cloud-Console

Customers receive a single Cloud Console invoice covering the partner's SaaS purchase plus their Google Cloud infrastructure usage. Google handles invoicing, collections, and remittances; the partner does not handle customer payment.

## Comparison with AWS and Azure SaaS

| Identity-binding | AWS | Azure | GCP |
|---|---|---|---|
| Mandatory federation | No | Yes (Entra ID SSO required) | No |
| Customer-account anchor | AWS account (via `ResolveCustomer` → `customerID`) | Tenant ID + Marketplace purchase token | Procurement account ID |
| Publisher's own IdP required | Yes | No (Entra ID covers it) | Yes (with Google sign-in option) |
| Lifecycle event channel | SNS topic | Webhook | Pub/Sub topic |
| Metering API | `MeterUsage` / `RegisterUsage` | Metering Service API | Service Control API |

## Implication for Endo Gateway SaaS staging

GCP SaaS imposes the lightest identity-integration friction *after* Azure (which gets it free via Entra ID), but requires the partner to ship a Google-credentials sign-in path themselves. For the Gateway, this aligns reasonably with the operator-as-buyer model: an operator on GCP Console subscribes, then signs into the Gateway with their Google account. The Procurement account ID anchor enables the Gateway to look up the operator's plan / quota without duplicating identity.

Source: [Offering software as a service (SaaS) products on Google Cloud Marketplace](https://docs.cloud.google.com/marketplace/docs/partners/integrated-saas) retrieved 2026-06-17. Supplemented by [Cloud Commerce Partner Procurement API codelab](https://developers.google.com/codelabs/gcp-marketplace-saas) and [Billing for Google Cloud Marketplace products](https://cloud.google.com/marketplace/docs/understanding-billing).
