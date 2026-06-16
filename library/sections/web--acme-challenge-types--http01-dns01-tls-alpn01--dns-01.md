---
title: DNS-01
source_kind: web
source_url: https://letsencrypt.org/docs/challenge-types/
source_date: 2026-02-18
ingested: 2026-06-11
ingested_by: scholar
topics: [tls-provisioning, node-packaging]
status: current
notes: "Let's Encrypt canonical reference. DNS-PERSIST-01 variant documented at https://letsencrypt.org/2026/02/18/dns-persist-01 (future challenge type, not yet widely deployed)."
parent: web--acme-challenge-types--http01-dns01-tls-alpn01
---

**How it works**: The ACME client creates a TXT record at `_acme-challenge.<YOUR_DOMAIN>` derived from the token and account key. Let's Encrypt queries DNS to verify the record.

**Requirements**:
- Programmatic access to the DNS provider API for automation.
- DNS propagation time (typically minutes; occasionally up to an hour).
- The domain must resolve (DNS lookup succeeds), but the node does not need to be publicly accessible.

**CNAME/delegation**: You can use CNAME or NS records to delegate `_acme-challenge` to a separate DNS zone or service (for example, `acme-dns`). This isolates DNS API credentials to the validation service rather than exposing full-zone write access on the node.

**Capabilities and constraints**:
- Only challenge type that can issue wildcard certificates.
- Works for non-publicly-exposed servers (private networks, behind firewalls).
- DNS propagation delay introduces timing uncertainty in automated flows.
- Cannot validate IP addresses.
- DNS API credentials on the node are a security concern; scoped credentials or delegated zones are recommended.

**First-boot relevance**: Best choice for nodes that do not have port 80 accessible at boot time, or where a wildcard certificate covering `*.node.example.com` style subdomains is desired. Requires that the operator pre-configure a DNS record pointing at the node's IP and that the node has DNS API credentials (or that a vendor-delegated subdomain is pre-provisioned). If the vendor pre-provisions a delegated CNAME pointing `_acme-challenge.<nodesubdomain>` at a vendor-controlled DNS service, the node can obtain a certificate during first boot without the operator configuring DNS at all.

Source: [Challenge Types - Let's Encrypt](https://letsencrypt.org/docs/challenge-types/) retrieved 2026-06-11. DNS-PERSIST-01 reference: [https://letsencrypt.org/2026/02/18/dns-persist-01](https://letsencrypt.org/2026/02/18/dns-persist-01).
