---
title: TLS-ALPN-01
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

**How it works**: Uses TLS on port 443 with a custom ALPN protocol. Only servers aware of this challenge type respond to validation requests.

**Requirements**:
- Port 443 accessible from the internet.
- TLS configuration control; multi-server setups require all servers to respond identically.

**Capabilities and constraints**:
- Cannot validate wildcard domains.
- Limited ACME client support (intended primarily for TLS-terminating reverse proxy authors).
- In multi-server setups, requires synchronized response across all instances.
- Can validate IP addresses.
- Works when port 80 is blocked but port 443 is accessible.

**First-boot relevance**: Rarely the right choice; minimal ecosystem support makes setup and troubleshooting difficult. Only relevant when port 80 is unavailable and DNS-01 is impractical.

Source: [Challenge Types - Let's Encrypt](https://letsencrypt.org/docs/challenge-types/) retrieved 2026-06-11. DNS-PERSIST-01 reference: [https://letsencrypt.org/2026/02/18/dns-persist-01](https://letsencrypt.org/2026/02/18/dns-persist-01).
