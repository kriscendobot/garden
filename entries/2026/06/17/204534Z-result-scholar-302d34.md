---
ts: 2026-06-17T20:45:34Z
kind: result
role: scholar
host: endolinbot
project: endo
refs:
  - entries/2026/06/17/195115Z-dispatch-scholar-302d34.md
  - entries/2026/06/17/195115Z-dispatch-scout-4ed554.md
---

# result: scholar 302d34 -- Azure + GCP marketplace + cross-vendor comparison library ingest (companion to scout 4ed554)

One-shot directed ingest companion to scout 4ed554 (Gateway -> cloud
marketplace artifact reconnaissance). All four target areas from the dispatch
brief were shelved: Azure Marketplace, GCP Marketplace, comparative analysis,
plus AWS Marketplace gap-fills (listing fees, identity bonding) that the
existing library lacked.

## Sources ingested (5; 9 section files total)

### 1. Azure / Microsoft Marketplace publisher guide

`library/sources/web--azure-marketplace-publisher-guide.md` + 3 sections:

- `web--azure-marketplace-publisher-guide--offer-type-taxonomy` -- nine offer
  types (Azure App, Container, VM, Professional Service, Dynamics 365,
  Managed Service, Microsoft 365, Power BI, SaaS); permanent offer-type
  choice; AWS-equivalent translation table.
- `web--azure-marketplace-publisher-guide--vm-offer-requirements` -- VHD-based
  VM offer mechanics; Reservation pricing 1-5 year discount tiers; private
  plan visibility-via-CLI caveat; CSP program auto-opt-in for BYOL.
- `web--azure-marketplace-publisher-guide--saas-offer-requirements` -- four
  listing options; mandatory Entra ID SSO for non-Contact-me; SaaS
  Fulfillment APIs (Resolve, Activate, webhook); 3% Microsoft agency fee;
  agency-model worked example; contract durations table (1-month to 5-year).

  Topics filed: `cloud-marketplace`, `node-packaging`.
  Source dates: 2025-06-09, 2025-06-02, 2026-04-29 (per-page Microsoft Learn
  `ms.date` frontmatter).

### 2. Azure / Microsoft Marketplace container offer

`library/sources/web--azure-marketplace-containers.md` + 1 section:

- `web--azure-marketplace-containers--requirements-pricing-and-lifecycle` --
  Kubernetes-only since 2024-01-18 (Docker images retired); CNAB-packaged
  Helm + ARM + manifest + createUiDefinition; ACR-hosted; eight predefined
  billing dimensions (Per pod / node / cluster / core variants) plus BYOL
  plus Custom.

  Topics filed: `cloud-marketplace`, `node-packaging`.
  Source date: 2025-07-31.

### 3. Google Cloud Marketplace partner program

`library/sources/web--gcp-marketplace-partner-program.md` + 2 sections:

- `web--gcp-marketplace-partner-program--product-types-and-partner-program` --
  seven product categories (AI Agents, SaaS, VM, K8s apps, Data, Pro Services,
  free Container Images); Partner Network Hub + vendor account + Payment
  Profile enrollment; 8-step VM workflow with 4-business-day pricing review;
  consolidated Cloud Console billing model; 2025-01-20 service-name image
  annotation requirement for GKE apps.
- `web--gcp-marketplace-partner-program--saas-integration-and-identity` --
  Cloud Commerce Partner Procurement API + Service Control API + Pub/Sub
  event channel; Procurement account ID as identity-binding anchor; partner
  provides Google sign-in (Google Identity / OIDC); three-vendor identity-
  binding comparison table (AWS / Azure / GCP differ on federation, anchor,
  publisher's IdP burden, event channel, metering API).

  Topics filed: `cloud-marketplace`, `node-packaging`.
  Sources synthesized from: `docs.cloud.google.com/marketplace/docs/partners`
  (the partner overview is sparse; deeper detail aggregated from
  `partners/get-started`, `partners/vm`, `partners/integrated-saas`, plus the
  GCP-marketplace-SaaS codelab on developers.google.com).

### 4. AWS Marketplace fees + identity bonding (gap-fill)

`library/sources/web--aws-marketplace-fees-and-identity.md` + 2 sections:

- `web--aws-marketplace-fees-and-identity--listing-fees-and-partner-network` --
  canonical fee table: 3% SaaS / 20% server / 3% Data Exchange (public);
  tiered private offers ($1M and $10M boundaries: 3% / 2% / 1.5%); CPPO
  +0.5% uplift; South Korea +1% regional uplift effective 2025-04-01;
  professional services 0.5%; APN enrollment prerequisite; Seller Agreement
  terms (30-day deactivation, 90-day wind-down).
- `web--aws-marketplace-fees-and-identity--identity-bonding-and-saas-listings-api`
  -- six-step SaaS integration workflow; ResolveCustomer + GetEntitlement +
  BatchMeterUsage APIs; two SNS topics (Entitlement Service + Metering
  Service); IAM Identity Center for procurement-system SSO and per-app SaaS
  SSO; SaaS Subscriptions vs. Contracts vs. Contracts-with-consumption
  sub-shapes; SAML 2.0 / OIDC / SCIM support.

  Topics filed: `cloud-marketplace`, `node-packaging`.
  Sources: AWS Marketplace User Guide listing-fees + APN blog SaaS-integration
  guide + AWS Marketplace SaaS guidelines + IAM Identity Center procurement-
  system SSO docs.

### 5. Comparative analysis (cross-vendor)

`library/sources/web--comparative-analysis-aws-azure-gcp-marketplaces.md` + 1
section:

- `web--comparative-analysis-aws-azure-gcp-marketplaces--landscape-fees-and-isv-fit`
  -- independent-source synthesis of fee structures (with the 20% server fee
  highlighted as the biggest delta), certification cadence (AWS 7-10 business
  days, Azure up-to-2-weeks, GCP up-to-2-weeks with 4-business-day pricing-
  model review), customer-base reach (AWS broadest / Azure Microsoft-centric /
  GCP ML+AI), Automatum.io's onboarding-complexity rating (AWS High / Azure +
  GCP Medium), payment terms (AWS Net 60 vs. Azure + GCP Net 30-45), co-sell
  programs, and ISV recommendation patterns. Implication for the Gateway:
  validates the maintainer's AWS-first sequencing in `prospectus-2026-06.md`.

  Topics filed: `cloud-marketplace`, `node-packaging`.
  Independent sources: divein.market (fees), automatum.io 2026 comparison
  (onboarding + co-sell + payment terms), invisory.co (positioning), Labra
  (ISV experience), Channel Futures (growth data), partnerinsight.io
  (mindshare data).

## Library writeback summary

- **`library/sources/README.md`** -- 5 new rows under the "Web-document
  sources" section (AWS fees, Azure publisher guide, Azure containers, GCP
  partner program, comparative analysis).
- **`library/topics/cloud-marketplace.md`** -- reorganized into four
  sub-sections (AWS / Microsoft / GCP / Cross-vendor); 9 new section rows;
  section count 3 -> 12.
- **`library/topics/node-packaging.md`** -- reorganized into five sub-sections
  (AWS / Microsoft / GCP / Comparison / First-boot+updates); 9 new section
  rows; section count 6 -> 15.
- **`library/topics/README.md`** -- updated counts for cloud-marketplace
  (3 -> 12) and node-packaging (6 -> 15); refreshed abstract for both to
  name the three vendors.
- **`library/sections/README.md`** -- 5 new source-grouped sub-headers added
  for the new sources (azure-marketplace-publisher-guide, azure-marketplace-
  containers, gcp-marketplace-partner-program, aws-marketplace-fees-and-
  identity, comparative-analysis-aws-azure-gcp-marketplaces).
- **`library/keywords.md`** -- ~95 new entries appended under existing
  cloud-marketplace cluster: AWS-specific (ResolveCustomer / GetEntitlement /
  IAM Identity Center / APN / CPPO / 20% server fee / regional uplifts);
  Azure-specific (Entra ID SSO / SaaS Fulfillment APIs / Sell through
  Microsoft / CNAB / ACR / per-pod-node-cluster-core pricing / Docker
  retirement 2024-01-18 / reservation pricing); GCP-specific (Cloud Commerce
  Partner Procurement API / Service Control API / Procurement account ID /
  App Lifecycle Manager / Partner Network Hub / Pub/Sub event channel);
  cross-vendor (hyperscaler marketplace / fee comparison / ISV onboarding
  complexity); node-packaging-specific (operator-as-buyer / AWS-first
  sequencing / multi-vendor sequencing).

## Open questions for the librarian

Material that surfaced as load-bearing in the comparative analysis but does
not yet have its own concept page in `library/concepts/`:

1. **Identity-binding shapes** as a cross-cutting concept: AWS's
   account-ID-via-`ResolveCustomer` model, Azure's Entra-ID-SSO-mandatory
   model, and GCP's Procurement-account-ID-plus-publisher-managed-Google-
   sign-in model are three distinct shapes worth a concept page comparing
   them (see the three-vendor table in the GCP SaaS section). Existing
   keywords resolve to `cloud-marketplace`, but a `marketplace-identity-
   bonding` concept would route a "how do customers authenticate to my
   SaaS?" query more directly.
2. **Metering APIs** as a cross-cutting concept: `MeterUsage` /
   `BatchMeterUsage` (AWS), Metering Service custom dimensions (Azure),
   Service Control API (GCP). These do the same job with subtly different
   data models; a concept page would help future authors not re-derive the
   comparison.
3. **Listing fee economics** as a concept: not currently a concept page;
   the 20% AWS server fee vs. 3% SaaS fee is a load-bearing decision input
   that would benefit from a discoverable lookup.

These are notes-for-the-librarian, not asks the scholar can resolve in this
cycle (concept-page authorship is the librarian's province; the scholar
flags candidates).

## Coordination with scout 4ed554

The five shelved sources were pushed to `origin/journal` immediately after
authoring so the scout's polling-for-companion-result loop completes
promptly. The scout consumes:

- AWS Marketplace artifact shapes: existing AMI + container sources +
  new fees + identity-bonding sections.
- Azure marketplace artifact shapes: new offer-type-taxonomy + VM + SaaS +
  container sections.
- GCP marketplace artifact shapes: new product-types + SaaS-integration
  sections.
- Cross-vendor comparison: new comparative-analysis section.
- AWS-first sequencing rationale: validates the maintainer's framing in
  `prospectus-2026-06.md` and `road-to-maturity-2026-06.md` via independent
  sources.

## Library state delta

| Metric | Delta |
|--------|-------|
| Sources | +5 |
| Sections | +9 |
| Topics changed | 2 (cloud-marketplace: 3 -> 12; node-packaging: 6 -> 15) |
| Keywords | +~95 |
| New concept pages | 0 (3 flagged to librarian) |

## Cycle budget

Within budget: 5 source documents, 9 section file writes. Below the
3-to-5 sources or ~25 section writes per-cycle ceiling.

Self-improvement: the comparative-analysis source's value came largely
from independent third-party reporting (Automatum.io, Labra, Channel
Futures) that name onboarding-complexity ratings, payment terms, and
ISV-experience signals that no single vendor's docs would surface. When
shelving material on a competitive landscape, budget ~25% of the cycle
for independent-source synthesis alongside the vendor's own docs; the
vendor's docs answer "what is on offer," the independent sources answer
"what do practitioners report it feels like."
