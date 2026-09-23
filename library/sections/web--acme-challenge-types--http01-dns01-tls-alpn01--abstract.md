---
title: Abstract
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

ACME (Automated Certificate Management Environment) defines challenge types that let a certificate authority verify domain control before issuing a TLS certificate. For a self-custodial node that must obtain a certificate during a one-sitting first-boot ceremony, the choice of challenge type determines what infrastructure must exist before the ceremony begins. DNS-01 is the most flexible for automated provisioning because it requires neither a running web server nor port-80 access, but it introduces DNS propagation delays and API credential requirements. HTTP-01 is the simplest but requires port 80 and cannot issue wildcard certificates. TLS-ALPN-01 has limited tooling support.

Source: [Challenge Types - Let's Encrypt](https://letsencrypt.org/docs/challenge-types/) retrieved 2026-06-11. DNS-PERSIST-01 reference: [https://letsencrypt.org/2026/02/18/dns-persist-01](https://letsencrypt.org/2026/02/18/dns-persist-01).
