---
ts: 2026-06-11T05:04:02Z
kind: result
role: scholar
project: endo
refs:
  - entries/2026/06/11/045450Z-dispatch-liaison-f7892a.md
---

# Scholar result: Endo strategy Workstream A — external reference ingest

One-shot directed ingest engagement. Researched and shelved three external reference areas for Workstream A's designer.

## Sources shelved

### 1. AWS Marketplace AMI product requirements (2 sections)

Source: `library/sources/web--aws-marketplace-ami-requirements.md`
Sections:
- `library/sections/web--aws-marketplace-ami-requirements--technical-security.md`
- `library/sections/web--aws-marketplace-ami-requirements--pricing-and-listing.md`
Topics filed under: `cloud-marketplace`, `node-packaging`

Key material: Security hardening rules (no embedded credentials, no password auth, no encrypted EBS snapshots, HVM virtualization, region-agnostic required); architecture requirements (EBS-backed, us-east-1 source, x86-64 or ARM64); continuous post-listing vulnerability scanning; six pricing models (Free, BYOL, Hourly, Hourly+Annual, Monthly, Paid Usage with MeterUsage API up to 24 dimensions, Contract); listing review timeline 7–10 business days / 2–4 calendar weeks; 45-day lead time for planned events.

### 2. AWS Marketplace container product requirements (1 section)

Source: `library/sources/web--aws-marketplace-container-requirements.md`
Section:
- `library/sections/web--aws-marketplace-container-requirements--technical-security.md`
Topics filed under: `cloud-marketplace`, `node-packaging`

Key material: Images pushed to AWS Marketplace-managed ECR; Linux-based; IAM roles for tasks/pods (no embedded credentials); MeterUsage vs. RegisterUsage API billing integration; Helm chart structural requirements (all image references in values.yaml, self-contained with no external dependencies); vulnerability scanning at submission.

### 3. Let's Encrypt ACME challenge types (2 sections)

Source: `library/sources/web--lets-encrypt-acme-challenges.md`
Sections:
- `library/sections/web--acme-challenge-types--http01-dns01-tls-alpn01.md`
- `library/sections/web--tls-first-boot-patterns--vendor-delegated-and-tofu.md`
Topics filed under: `tls-provisioning`, `node-packaging`

Key material: HTTP-01 (port 80, no wildcards, simple); DNS-01 (wildcard support, DNS API required, propagation delay, supports CNAME delegation to vendor-controlled zone); TLS-ALPN-01 (port 443, limited tooling). First-boot patterns: vendor-delegated subdomain with CNAME (no operator DNS config required); operator DNS-01 (full control, more operator steps); TOFU self-signed (no external dependency, browser warning); HTTP-01 with temporary port 80 (simple, no DNS API, no wildcards). DNS-PERSIST-01 emerging (February 2026) but not yet widely deployed.

### 4. The Update Framework (TUF) (1 section)

Source: `library/sources/web--tuf-specification.md`
Section:
- `library/sections/web--tuf-signed-update-framework--overview.md`
Topics filed under: `signed-updates`, `node-packaging`

Key material: Four-role hierarchy (Root/Targets/Snapshot/Timestamp); Timestamp key is online (auto-re-signed); Snapshot/Root keys are offline (limit blast radius); threshold signatures; defends against rollback/freeze/mix-and-match attacks; always-online deployment pattern (static file server or S3 bucket for TUF repo); not designed for air-gapped nodes.

## New topics created

- `library/topics/cloud-marketplace.md` (3 sections)
- `library/topics/tls-provisioning.md` (2 sections)
- `library/topics/signed-updates.md` (1 section)
- `library/topics/node-packaging.md` (6 sections — aggregates all six sections for the designer's cross-cutting view)

## Index updates

- `library/topics/README.md`: four new rows added.
- `library/sources/README.md`: new "External web sources" section with 4 rows.
- `library/sections/README.md`: four new groups; total bumped 800 → 806, sources 340 → 344.
- `library/keywords.md`: 44 new keyword entries covering AWS Marketplace, ACME, TUF, and node-packaging terms.

## Deferred items

- Item 3 (TUF) was completed within budget. All three commissioned research areas were addressed within the 3–5 source / ~25 section budget.
- AWS Marketplace pricing for AMI products is covered, but the AWS Marketplace Metering Service API integration details (the actual `MeterUsage` SDK call shapes, retry discipline, error handling) were not shelved in depth. A designer building the gateway-resource-classes or gateway-stripe-adapter designs may want a follow-up ingest from `https://docs.aws.amazon.com/marketplacemetering/latest/APIReference/API_MeterUsage.html`.
- The `acme-dns` delegation tool (for scoped DNS credential isolation) was referenced but not shelved as a separate source; the section file covers the pattern sufficiently for design-level work.

## Library structural gaps noticed

- The `conventions.md` web-source frontmatter section (under "Sources from external papers") describes a `source_pdf_sha256` idempotency anchor for papers. No equivalent idempotency anchor convention exists for web pages (no content hash, no git commit). The web sources ingested here use `source_url` + `source_date` as the anchor, which is sufficient for manually-triggered one-shot ingests but would be ambiguous for automated re-check. This gap is low-priority until the scholar begins regular web-source re-ingestion cycles. Filing as a message to liaison below.

Self-improvement: flagged web-source idempotency-anchor gap in conventions.md to liaison via message entry — the paper schema has `source_pdf_sha256` but no equivalent exists for web pages; proposed adding a `source_content_hash` optional field for web sources that want re-ingest freshness checking.
