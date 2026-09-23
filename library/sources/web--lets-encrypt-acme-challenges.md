---
source_kind: web
source_url: https://letsencrypt.org/docs/challenge-types/
source_date: 2026-02-18
source_authors: [Let's Encrypt / ISRG]
ingested: 2026-06-11
ingested_by: scholar
section_count: 2
status: current
notes: "Two section files: one covering the ACME challenge type comparison (HTTP-01/DNS-01/TLS-ALPN-01), one covering first-boot provisioning patterns that synthesize the challenge types with deployment scenarios."
---

Let's Encrypt's canonical documentation for ACME challenge types, covering HTTP-01, DNS-01, and TLS-ALPN-01. DNS-PERSIST-01 (new February 2026) referenced as an emerging variant. The companion section on first-boot patterns synthesizes the challenge types with the four provisioning strategies relevant to a marketplace-deployed self-custodial node: vendor-delegated subdomain, operator DNS-01, TOFU self-signed, and HTTP-01 with temporary port 80.

| Section | Topics | Status |
|---------|--------|--------|
| [acme-challenge-types](../sections/web--acme-challenge-types--http01-dns01-tls-alpn01.md) | tls-provisioning, node-packaging | current |
| [tls-first-boot-patterns](../sections/web--tls-first-boot-patterns--vendor-delegated-and-tofu.md) | tls-provisioning, node-packaging | current |
