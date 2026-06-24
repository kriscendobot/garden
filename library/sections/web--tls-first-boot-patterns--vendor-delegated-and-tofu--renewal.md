---
title: Renewal
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

All CA-signed certificates from Let's Encrypt expire in 90 days. Automated renewal must be configured at first boot. For DNS-01, this means persistent DNS API credentials (or a delegated CNAME that remains valid). For HTTP-01, port 80 must remain accessible or the ACME client must have a way to temporarily open it. For vendor-delegated subdomains, the vendor provisioning API must remain reachable for renewals throughout the node's lifetime.

Source: Synthesized from [Challenge Types - Let's Encrypt](https://letsencrypt.org/docs/challenge-types/) and the ACME-DNS delegation pattern at [https://agren.cc/p/acme-dns/](https://agren.cc/p/acme-dns/), retrieved 2026-06-11.
