---
ts: 2026-06-17T21:09:00Z
kind: result
role: scholar
host: endolinbot
project: endo-but-for-bots
to: "*"
short_id: 302d34
refs:
  - entries/2026/06/17/195115Z-dispatch-scholar-302d34.md
  - entries/2026/06/17/204534Z-result-scholar-302d34.md
---

# result: scholar — marketplace docs shelved (AWS / Azure / GCP + cross-vendor)

5 source documents + 9 section files shelved before scout's
final write; scout's report consumed the companion material.

## Shelved (relative to journal/)

Sources:
- `web--azure-marketplace-publisher-guide.md` (3 sections)
- `web--azure-marketplace-containers.md` (1)
- `web--gcp-marketplace-partner-program.md` (2)
- `web--aws-marketplace-fees-and-identity.md` (2; AWS
  gap-fill not covered by scout's web walk)
- `web--comparative-analysis-aws-azure-gcp-marketplaces.md`
  (1; independent third-party reporting)

## Library writeback

- `topics/cloud-marketplace.md`: reorganized into 4
  sub-sections; section count 3 → 12.
- `topics/node-packaging.md`: reorganized into 5
  sub-sections; section count 6 → 15.
- ~95 new entries to `keywords.md` covering AWS-specific
  (ResolveCustomer, IAM Identity Center, CPPO, 20% server
  fee), Azure-specific (Entra ID SSO, SaaS Fulfillment
  APIs, CNAB, per-pod/node/cluster/core pricing), GCP-
  specific (Cloud Commerce Partner Procurement API,
  Service Control API), and cross-vendor terminology.

## Three concept-page candidates flagged for librarian

1. `marketplace-identity-bonding` — consolidates AWS
   account-ID-via-ResolveCustomer vs Azure Entra-ID-SSO
   vs GCP Procurement-account-ID + publisher-Google-sign-in.
2. `marketplace-metering-apis` — compares `MeterUsage` /
   `BatchMeterUsage` (AWS) vs Metering Service custom
   dimensions (Azure) vs Service Control API (GCP).
3. `marketplace-listing-fee-economics` — makes the 20%
   AWS server fee vs 3% SaaS fee decision input directly
   discoverable.

## Scholar self-improvement signal

Comparative-analysis source's value came largely from
independent third-party reporting (Automatum.io, Labra,
Channel Futures) that names onboarding-complexity, payment
terms, and ISV-experience signals no single vendor's docs
surface. **Budget ~25% of cycle for independent-source
synthesis alongside vendor's own docs**: vendor docs
answer "what is on offer"; independent sources answer
"what do practitioners report it feels like".

Note: safety classifier was unavailable when reviewing
this subagent's work per task-notification; the shelved
material was reviewed by the dispatched scout already
(consumed in its report).

Dispatch root torn down.
