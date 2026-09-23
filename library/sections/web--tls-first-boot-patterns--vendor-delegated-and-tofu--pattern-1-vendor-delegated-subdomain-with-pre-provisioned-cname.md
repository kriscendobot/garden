---
title: "Pattern 1: Vendor-delegated subdomain with pre-provisioned CNAME"
source_kind: web
source_url: https://letsencrypt.org/docs/challenge-types/
source_date: 2026-02-18
ingested: 2026-06-11
ingested_by: scholar
topics: [tls-provisioning, node-packaging]
status: current
notes: "Synthesized from Let's Encrypt challenge-types documentation and ACME-DNS pattern. TOFU and self-signed patterns drawn from general literature; no single canonical source."
parent: web--tls-first-boot-patterns--vendor-delegated-and-tofu
---

The vendor pre-registers a subdomain for the node (for example, `<node-id>.nodes.example.com`) before the node boots. A CNAME record at `_acme-challenge.<node-id>.nodes.example.com` points to a vendor-controlled DNS service that the vendor's infrastructure manages. At first boot, the node runs its ACME client with DNS-01 challenge, sends the challenge token to the vendor's DNS service (via a provisioning API call using a node-specific short-lived credential embedded in the AMI), and the vendor's DNS service publishes the TXT record. The ACME CA validates against the vendor's DNS service, and the node receives a certificate with SAN `<node-id>.nodes.example.com`.

Trade-offs:
- No operator DNS configuration required at first boot — the node can obtain a certificate entirely autonomously.
- The vendor controls the namespace; operators who want custom domains need an additional step (CNAME from their own domain to the node's vendor subdomain, or a separate certificate workflow).
- Vendor DNS service is a dependency; vendor must maintain it for all issued nodes.
- The certificate proves control over the vendor subdomain, not the operator's own domain.
- Short-lived provisioning credentials in the AMI are a small attack surface: if the node ID is predictable and the provisioning API has insufficient authorization, an attacker could pre-empt a node's subdomain.

Source: Synthesized from [Challenge Types - Let's Encrypt](https://letsencrypt.org/docs/challenge-types/) and the ACME-DNS delegation pattern at [https://agren.cc/p/acme-dns/](https://agren.cc/p/acme-dns/), retrieved 2026-06-11.
