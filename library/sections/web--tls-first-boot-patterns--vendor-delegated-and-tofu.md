---
title: "TLS certificate provisioning patterns for first-boot self-custodial nodes"
source_kind: web
source_url: https://letsencrypt.org/docs/challenge-types/
source_date: 2026-02-18
ingested: 2026-06-11
ingested_by: scholar
topics: [tls-provisioning, node-packaging]
status: current
notes: "Synthesized from Let's Encrypt challenge-types documentation and ACME-DNS pattern. TOFU and self-signed patterns drawn from general literature; no single canonical source."
kind: index
section_count: 6
---

Sections:

- [Abstract](web--tls-first-boot-patterns--vendor-delegated-and-tofu--abstract.md)
- [Pattern 1: Vendor-delegated subdomain with pre-provisioned CNAME](web--tls-first-boot-patterns--vendor-delegated-and-tofu--pattern-1-vendor-delegated-subdomain-with-pre-provisioned-cname.md)
- [Pattern 2: Operator-provided domain with DNS-01 at first boot](web--tls-first-boot-patterns--vendor-delegated-and-tofu--pattern-2-operator-provided-domain-with-dns-01-at-first-boot.md)
- [Pattern 3: Self-signed certificate with trust-on-first-use (TOFU)](web--tls-first-boot-patterns--vendor-delegated-and-tofu--pattern-3-self-signed-certificate-with-trust-on-first-use-tofu.md)
- [Pattern 4: HTTP-01 with port 80 provisionally open](web--tls-first-boot-patterns--vendor-delegated-and-tofu--pattern-4-http-01-with-port-80-provisionally-open.md)
- [Renewal](web--tls-first-boot-patterns--vendor-delegated-and-tofu--renewal.md)

Source: Synthesized from [Challenge Types - Let's Encrypt](https://letsencrypt.org/docs/challenge-types/) and the ACME-DNS delegation pattern at [https://agren.cc/p/acme-dns/](https://agren.cc/p/acme-dns/), retrieved 2026-06-11.
