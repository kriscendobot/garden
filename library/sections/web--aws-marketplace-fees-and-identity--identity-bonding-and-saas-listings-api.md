---
title: "AWS Marketplace SaaS Listings: ResolveCustomer, entitlement APIs, SNS topics, and IAM Identity Center buyer SSO"
source_kind: web
source_url: https://aws.amazon.com/blogs/awsmarketplace/step-by-step-guide-to-saas-integration-with-aws-marketplace/
source_date: 2024-09-01
ingested: 2026-06-17
ingested_by: scholar
topics: [cloud-marketplace, node-packaging]
status: current
notes: "Identity-bonding shape for AWS Marketplace SaaS Listings: the customer is identified by their AWS account (via the customerID returned by ResolveCustomer); SaaS auth on top of that is the publisher's responsibility, with IAM Identity Center as an optional federation layer. This differs from Azure (Entra ID SSO mandatory) and GCP (Procurement account ID + Google sign-in)."
---

AWS Marketplace SaaS Listings (and SaaS Contracts) bind the customer's *AWS account* to the publisher's customer record via a short-lived token. The publisher exchanges the token for a `customerID` using the `ResolveCustomer` API, then maintains the SaaS lifecycle through entitlement and metering APIs plus Amazon SNS event notifications. SaaS-side authentication for end users is the publisher's responsibility; IAM Identity Center (formerly AWS SSO) is the supported federation hook for both procurement-system SSO and per-customer SaaS-app SSO.

## The six-step SaaS integration workflow

(Per the AWS Partner Network blog's step-by-step guide.)

1. **Customer acceptance**: customer subscribes via AWS Marketplace; the browser is redirected to the publisher's registration landing page (publisher-hosted within their AWS infrastructure).
2. **Customer verification**: the landing page receives a temporary token (valid 4 hours) via POST. Integration calls `ResolveCustomer` (AWS Marketplace Metering Service) to exchange the token for a `customerID`.
3. **SNS topic subscription**: SQS queues subscribe to two SNS topics for subscription-change notifications (unsubscribe, upgrade, renewal, failed subscription).
4. **Entitlement verification**: call `GetEntitlement` to verify which dimension(s) the customer is subscribed to and the quantity. Store responses in DynamoDB; monitor updates via SNS.
5. **Account creation / configuration**: implement automated or manual onboarding after verification.
6. **Metered usage** (for usage-based pricing): CloudWatch Events rules trigger hourly metering jobs; `BatchMeterUsage` API reports aggregated usage by dimension.

## SNS topics

Two primary SNS topics deliver:

- **Entitlement Service topic**: subscription and entitlement status changes.
- **Metering Service topic**: subscription modifications affecting metering dimensions.

Critical API changes must be supported within 24 hours; non-critical changes are released periodically.

## SaaS-listings APIs

| API | Purpose |
|---|---|
| `ResolveCustomer` | Token → `customerID` exchange. Initial customer identification. |
| `GetEntitlement` | Query subscribed dimensions and quantities. |
| `BatchMeterUsage` | Hourly metering report for usage-based pricing. |
| `MeterUsage` (predecessor) | Single-dimension metering call. |
| `RegisterUsage` | Hourly or per-task metering (container-product alternative). |

## SaaS Contracts vs. SaaS Listings (vs. SaaS Subscriptions)

AWS Marketplace SaaS has three sub-shapes:

| Sub-shape | Billing model |
|---|---|
| **SaaS Subscriptions** | Pure usage-based metered billing through `MeterUsage`. |
| **SaaS Contracts** | Customer commits to a contract (1/12/24/36 months) with fixed entitlement; usage above contract is metered. |
| **SaaS Contracts with consumption** | Hybrid: metering applies only to usage exceeding contract entitlements. |

## Identity federation for buyers (IAM Identity Center)

AWS Marketplace supports IAM Identity Center (formerly AWS SSO) as the buyer-side federation hook in two scenarios:

1. **Procurement-system SSO**: enable SSO for AWS Marketplace procurement system integration by passing the IAM Identity Center access portal URL as a query parameter. Users redirect to their organization's SSO login page instead of standard AWS sign-in.
2. **SaaS-app SSO** (optional, publisher-managed): the publisher can integrate their SaaS authentication with the buyer's IAM Identity Center directory (or a downstream IdP via Identity Center).

IAM Identity Center supports any SAML 2.0 / OIDC IdP, including Okta, Microsoft Entra ID, and the built-in Identity Center directory. SCIM is supported for user/group provisioning.

## SaaS product authentication requirements (verbatim)

From AWS Marketplace SaaS guidelines: *"SaaS products must authenticate all customers before granting access to customer data, and sellers must provision resources in a secure way, such as using AWS Security Token Service (STS) or AWS Identity and Access Management (IAM), following the principle of least privilege."*

## Comparison-relevant differences

- **Identity binding** (this section's headline): customer is identified by *AWS account* (via `customerID`), not by an end user. The publisher must provide its own end-user identity system or federate via IAM Identity Center. Compare with Azure (Entra ID SSO mandatory) and GCP (Procurement account ID + Google sign-in).
- **Hybrid SaaS Contract billing**: AWS's three-way split (Subscriptions / Contracts / Contracts-with-consumption) gives more pricing-shape flexibility than Azure or GCP. Azure has flat-rate + per-user; GCP has subscription + usage-based + commitments.
- **Event channel**: AWS uses SNS topics; Azure uses HTTPS webhooks; GCP uses Pub/Sub topics. Three distinct integration shapes.

## Implication for Endo Gateway SaaS sequencing on AWS

The 24-hour critical-API-change requirement means the Gateway needs ongoing API maintenance for any AWS SaaS Listing — not a fire-and-forget integration. The 4-hour token validity at customer registration is a tight window; the landing page must be reliable. The mandatory two-SNS-topic subscription means the Gateway needs durable SQS+DynamoDB infrastructure (or equivalent) just for entitlement state.

The combination of high integration effort (matching Automatum.io's "High" complexity rating) plus 20% server fee plus 3% SaaS fee suggests publishing as a SaaS Contract may be the lowest-friction shape if it's feasible for the Gateway.

Sources retrieved 2026-06-17:
- [Step-by-Step Guide to SaaS Integration with AWS Marketplace](https://aws.amazon.com/blogs/awsmarketplace/step-by-step-guide-to-saas-integration-with-aws-marketplace/)
- [SaaS product guidelines for AWS Marketplace](https://docs.aws.amazon.com/marketplace/latest/userguide/saas-guidelines.html)
- [Enabling SSO for procurement system integration](https://docs.aws.amazon.com/marketplace/latest/buyerguide/procurement-system-sso.html)
- [Identity Federation and SSO for SaaS on AWS](https://aws.amazon.com/blogs/apn/identity-federation-and-sso-for-saas-on-aws/)
