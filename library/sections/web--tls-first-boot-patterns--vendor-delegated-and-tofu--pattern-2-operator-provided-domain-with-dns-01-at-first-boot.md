---
title: "Pattern 2: Operator-provided domain with DNS-01 at first boot"
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

The operator configures a DNS A record pointing their own domain or subdomain at the node's IP before initiating the first-boot ceremony. The first-boot wizard prompts for the domain name and the DNS provider API credentials (or a pre-generated ACME-DNS delegated credential). The ACME client publishes the DNS-01 challenge record and requests the certificate.

Trade-offs:
- Operator has full control over their domain namespace.
- Requires operator to perform DNS configuration before the ceremony; adds a step.
- DNS propagation delay (minutes to an hour) lengthens the first-boot ceremony.
- API credentials for the operator's DNS provider must be available at first boot (stored in ceremony context, not persisted on disk unless the operator chooses to for renewals).
- Suitable for technically sophisticated operators; less suitable for a marketplace "deploy and go" experience.

Source: Synthesized from [Challenge Types - Let's Encrypt](https://letsencrypt.org/docs/challenge-types/) and the ACME-DNS delegation pattern at [https://agren.cc/p/acme-dns/](https://agren.cc/p/acme-dns/), retrieved 2026-06-11.
