---
title: "Azure Marketplace SaaS offer requirements and Entra ID integration"
source_kind: web
source_url: https://learn.microsoft.com/en-us/partner-center/marketplace-offers/plan-saas-offer
source_date: 2026-04-29
ingested: 2026-06-17
ingested_by: scholar
topics: [cloud-marketplace, node-packaging]
status: current
notes: "Identity-bonding shape for Microsoft Marketplace SaaS offers is the Entra ID single-sign-on requirement. AWS Marketplace's equivalent identity hook is `ResolveCustomer` + IAM Identity Center (formerly AWS SSO). The two are not equivalent: Entra ID SSO authenticates the buyer's user, while `ResolveCustomer` identifies the buyer's AWS account."
---

A Microsoft Marketplace SaaS offer is a publisher-hosted, subscription-billed software service. The publisher manages all infrastructure and bills (via Microsoft for *Sell through Microsoft* offers, or directly for the other listing options). The technical requirements vary by listing option, but for any transactable shape (`Get it now Free`, `Free trial`, `Sell through Microsoft`), Microsoft Entra ID single sign-on for buyers is mandatory.

## Listing options

| Listing option | Transaction process |
|---|---|
| Contact me | Customer contacts publisher directly from listing. No technical integration required. |
| Free trial | Customer redirected to publisher target URL via Microsoft Entra ID. SSO required. |
| Get it now (Free) | Customer redirected to publisher target URL via Microsoft Entra ID. SSO required. |
| Sell through Microsoft | *Transactable*: Microsoft facilitates the license exchange, bills the customer, pays the publisher on the agency model (Microsoft withholds an agency fee, currently 3%). SSO + Fulfillment APIs required. |

The listing option for any non-Contact-me listing is **changeable after publish** except *Sell through Microsoft*, which is permanent once published.

## Technical requirements (transactable SaaS)

Required integrations for any non-Contact-me listing:

1. **Microsoft Entra ID + Microsoft Accounts (MSA) buyer auth on the publisher site**, with single sign-on. Both are required (MSA *and* Entra ID); the customer chooses which to use.
2. **Landing page** with seamless sign-in and onboarding for new and returning customers. Up 24/7. The landing page receives a token (Marketplace purchase identification token) on every customer touch and must call the `Resolve API` to exchange it for SaaS subscription details. The landing page receives the token both on first purchase and on every subsequent management touch from the Azure portal or Microsoft 365 Admin Center.

For *Sell through Microsoft* (transactable) only, three additional requirements:

3. **SaaS Fulfillment API integration**: publisher app exposes a service that creates / updates / deletes user accounts and service plans. Critical API changes must be supported within 24 hours. Includes Resolve, Activate, and webhook-driven subscription lifecycle.
4. **Connection webhook URL** (24/7 uptime) that Microsoft calls for asynchronous events (cancellation, plan change, renewal).
5. **Registered Microsoft Entra application** (tenant ID + application ID) used to authenticate Marketplace API calls. One Entra app per Partner Center account.

For SaaS offers with Microsoft License Management Service, the publisher must integrate with Microsoft Graph API to verify customer eligibility (customers manage their licenses through Microsoft Admin Center).

## SaaS pricing models

Two pricing models per offer (all plans in the same offer share one):

- **Flat rate**: monthly or annual fixed price. Optionally pairs with metered overages via the Marketplace metering service.
- **Per user**: priced by the number of users with access. Each plan can set min/max user counts.

The pricing model is permanent once the offer is published.

## Contract durations and billing frequencies

Available for SaaS offers (combinations):

| Contract duration | One-time upfront | Monthly equal billing | Annual equal billing | Flexible schedule (private offers only) |
|---|---|---|---|---|
| 1-month | Yes | n/a | n/a | n/a |
| 1-year | Yes | Yes | n/a | Yes |
| 2-year | Yes | Yes | Yes | Yes |
| 3-year | Yes | Yes | Yes | Yes |
| 4-year | Yes | Yes | Yes | Yes |
| 5-year | Yes | Yes | Yes | Yes |

Private plans do not support 4-year or 5-year contract durations.

## Billing economics

For SaaS apps running in the publisher's Azure subscription, Azure infrastructure usage is billed to the publisher directly (not to the customer). The publisher bundles infrastructure cost into the license price. Microsoft charges a 3% Marketplace Service Fee on the license cost (publisher receives 97%).

Worked example from the docs: license cost $100/month, customer pays Microsoft $100/month, publisher receives $97/month, publisher pays infrastructure separately.

## Microsoft 365 integration

If the SaaS integrates with Microsoft Graph, publisher provides the Entra App ID used for Graph integration. Customers see a single Marketplace search result for the SaaS plus any linked add-ins (Teams apps, Microsoft 365 add-ins, SharePoint Framework solutions). Administrators can deploy SaaS + linked add-ins as an E2E solution via Microsoft 365 admin center.

## Comparison with AWS Marketplace SaaS

AWS Marketplace SaaS Products use a different identity binding shape:

- **AWS**: customer subscribes through AWS Marketplace, browser redirected to publisher landing page with a temporary 4-hour token. Publisher calls `ResolveCustomer` (AWS Marketplace Metering Service API) to exchange token for `customerID`. Publisher subscribes to SNS topics for subscription lifecycle. Identity is the *AWS account*, not the IAM user. Customers must authenticate to the publisher's own identity system on top of this.
- **Azure**: customer subscribes through Microsoft Marketplace, browser redirected with Marketplace purchase identification token, publisher calls `Resolve API`. Authentication for SaaS app access is itself federated through Entra ID SSO; the publisher does *not* need a separate identity system — the user is already an Entra user. This is the key identity-integration delta.

Implication for Endo Gateway SaaS staging: an Azure SaaS listing puts identity entirely in Entra ID's hands (operator gets seamless SSO from their corporate AAD); an AWS SaaS listing requires the publisher to provide an identity provider (either via IAM Identity Center, which adds a configuration step for the buyer, or via the publisher's own IdP).

## Agency model and revenue share

Microsoft Marketplace operates on agency: publisher sets prices, Microsoft bills customers, Microsoft pays publisher with a 3% agency fee withheld. Stable across deal sizes and offer types as of 2025-2026 (Azure has no tiered-by-deal-size discount, unlike AWS and GCP private offers).

Source: [Plan a SaaS offer for Microsoft Marketplace](https://learn.microsoft.com/en-us/partner-center/marketplace-offers/plan-saas-offer) retrieved 2026-06-17.
