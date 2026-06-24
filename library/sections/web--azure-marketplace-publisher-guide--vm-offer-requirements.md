---
title: "Azure Marketplace virtual-machine offer requirements"
source_kind: web
source_url: https://learn.microsoft.com/en-us/partner-center/marketplace-offers/marketplace-virtual-machines
source_date: 2025-06-02
ingested: 2026-06-17
ingested_by: scholar
topics: [cloud-marketplace, node-packaging]
status: current
notes: "Counterpart of AWS Marketplace AMI requirements (web--aws-marketplace-ami-requirements--technical-security and --pricing-and-listing). Pricing models differ substantially: Azure supports usage-based pay-as-you-go plus reservation pricing (1-5 year discounts) and BYOL only; AWS offers six pricing models including Custom Metering."
---

A Microsoft Marketplace virtual-machine offer is transactable: customers buy through the Marketplace and Microsoft bills on the publisher's behalf. Required artifacts are one operating-system VHD (`.vhd` only, not VHDX) and zero-to-16 data-disk VHDs, plus at least one plan (the marketing/pricing unit). Publishers must support the Azure Linux Agent (`waagent`) for Linux images or Sysprep for Windows images so Azure can re-image-and-deploy. Microsoft scans every submission and re-scans periodically post-listing.

## Technical fundamentals

- Engineering team must know Azure Virtual Machines, Azure Storage, Azure Networking, and Azure architecture conventions.
- Two preparation paths: *use an approved base image* (Azure Marketplace's `endorsed base image` list) or *use your own image* (more steps: VM agent, sysprep/waagent, validation).
- VHD constraints: every VM image in a plan must have the same number of data disks; use one VHD per data disk even if blank; don't use the OS VHD for persistent data.

## Plans, pricing, and trials

VM offers require at least one plan. Two licensing models:

| Licensing model | Transaction process |
|---|---|
| Usage-based | Pay-as-you-go per hour. Microsoft meters, bills the customer, pays the publisher. |
| BYOL (Bring Your Own License) | Publisher supports order, fulfillment, metering, billing, invoicing, payment, collection. |

### Reservation pricing (optional)

For usage-based monthly-billed plans, publishers can configure reservation discounts for 1-, 2-, 3-, 4-, or 5-year commitments. Reservation pricing applies to *Flat rate*, *Per vCPU*, or *Per vCPU size* price options. Not applicable to BYOL, Free, or *Per market and vCPU size* plans. All calculations are based on 8,760 hours per year. Example: a 1 vCPU VM at $1/hour public yields:

| Contract duration | Public price | Percentage discount | Discounted price |
|---|---|---|---|
| 1-year | $8,760.00 | 5% | $8,322.00 |
| 2-year | $17,520.00 | 10% | $15,768.00 |
| 3-year | $26,280.00 | 15% | $22,338.00 |
| 4-year | $35,040.00 | 20% | $28,032.00 |
| 5-year | $43,800.00 | 25% | $32,850.00 |

### Trials

One-, three-, or six-month free trials are configurable per plan. Trial behavior depends on licensing model and on whether the offer is transactable (the offer must be transactable for some trial shapes).

## Private plans, preview audience, hidden plans

- **Preview audience**: a list of Azure subscription IDs (up to 10 manual, 100 via CSV) that test the offer before publication. Distinct from private audience.
- **Private plans** (set on the Pricing and Availability page per plan): restrict discovery and deployment to specific subscription/tenant IDs. **Caveat**: *"Private plan names, IDs, and URNs remain publicly visible via Azure CLI (for example, `az vm image list`), even to users outside the configured private audience."* Only deployment is restricted; name your private plans accordingly to avoid information disclosure.
- **Hidden plans**: not visible in Marketplace but deployable via Solution Template, Managed Application, Azure CLI, or PowerShell. A plan can be both hidden and private.

## Cloud Solution Providers (CSPs)

Every BYOL plan is automatically opted in to the CSP program. Non-BYOL plans can opt in. CSP partners may resell as part of bundled offers.

## Customer leads, legal contracts

- Leads flow into the Partner Center Referrals workspace. CRM integration supported for Dynamics 365, Marketo, Salesforce, plus generic Azure table / HTTPS endpoint via Power Automate.
- Two legal-contract choices: Microsoft Standard Contract (with up to 10 custom amendments) or publisher's own terms.

## Comparison-relevant differences from AWS

- **Pricing models**: Azure VM offers support only Usage-based (pay-as-you-go) and BYOL, plus optional Reservation discounts. AWS Marketplace AMI offers support six models including *Paid Hourly with Annual* (multi-year contracts up to 12 years via private offers), *Paid Monthly*, *Paid Usage with Custom Metering* (via MeterUsage API). Azure's reservation pricing is a *discount layer* on usage; AWS's annual/contract pricing is a *separate billing model*.
- **VHD vs. AMI**: Azure VHD vs. AWS AMI. Same logical artifact, different file format. Both require image generalization (waagent / sysprep on Azure; cleanup of credentials/keys on AWS).
- **Private plan visibility**: Azure private plan *names* are public via CLI. AWS Marketplace private offers do not expose private offer names beyond the configured customer set.

Source: [Plan a virtual machine offer for Microsoft Marketplace](https://learn.microsoft.com/en-us/partner-center/marketplace-offers/marketplace-virtual-machines) retrieved 2026-06-17.
