---
source_kind: web
source_url: https://docs.aws.amazon.com/marketplace/latest/userguide/product-and-ami-policies.html
source_date: 2025-05-01
source_authors: [AWS Documentation Team]
ingested: 2026-06-11
ingested_by: scholar
section_count: 2
status: current
notes: "Covers both the AMI security/architecture policy page and the AMI product creation/pricing/submission pages. Two section files cover the two distinct concerns: technical hardening rules and commercial listing process."
---

AWS Marketplace's canonical requirements for AMI-based product listings, effective May 1, 2025. Covers security hardening (no embedded credentials, no password auth, HVM virtualization, EBS-backed, region-agnostic), AMI architecture constraints, the AMI scanning and review process, pricing model options (Hourly, Monthly, Annual, Contract, Custom Metering), and the listing lifecycle from Draft through Limited to Public. These requirements are the binding constraints for the Endo gateway's Phase 11 OS packaging milestone.

| Section | Topics | Status |
|---------|--------|--------|
| [technical-security](../sections/web--aws-marketplace-ami-requirements--technical-security.md) | cloud-marketplace, node-packaging | current |
| [pricing-and-listing](../sections/web--aws-marketplace-ami-requirements--pricing-and-listing.md) | cloud-marketplace, node-packaging | current |
