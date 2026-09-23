---
title: "Pattern 4: HTTP-01 with port 80 provisionally open"
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

If the node opens port 80 only during the first-boot ceremony (firewall allows port 80 during AMI startup, closes after certificate is obtained), the ACME client can use HTTP-01 to obtain a certificate without DNS API access. After the certificate is obtained, port 80 is closed or redirected to HTTPS.

Trade-offs:
- No DNS API credential required.
- Requires operator's domain A record to already point at the node's IP.
- Port 80 must be reachable from the internet during the ceremony window.
- Some AWS security groups default to port 80 open; others do not — the CloudFormation template must provision this correctly.
- Simpler than DNS-01 for single-domain certificates; cannot issue wildcards.

Source: Synthesized from [Challenge Types - Let's Encrypt](https://letsencrypt.org/docs/challenge-types/) and the ACME-DNS delegation pattern at [https://agren.cc/p/acme-dns/](https://agren.cc/p/acme-dns/), retrieved 2026-06-11.
