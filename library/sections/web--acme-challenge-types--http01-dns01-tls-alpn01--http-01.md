---
title: HTTP-01
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

**How it works**: The ACME client places a file at `http://<YOUR_DOMAIN>/.well-known/acme-challenge/<TOKEN>` containing the token plus an account key thumbprint. Let's Encrypt retrieves this file over HTTP.

**Requirements**:
- Port 80 must be reachable from the internet (fixed; not configurable to other ports).
- Only accepts redirects to `http:` or `https:` and only to ports 80 or 443.
- No other listener on port 80 at validation time.
- In multi-server setups, the file must be accessible on all servers.

**Capabilities and constraints**:
- Cannot issue wildcard certificates.
- Can validate individual domain names (including IP addresses).
- Easy automation; ACME clients handle server configuration without DNS provider access.

**First-boot relevance**: Works well when port 80 is available and the node already has a minimal HTTP server running (or the ACME client can temporarily occupy port 80). Blocked by some ISPs at the residential level; cloud nodes generally have port 80 open by default.

Source: [Challenge Types - Let's Encrypt](https://letsencrypt.org/docs/challenge-types/) retrieved 2026-06-11. DNS-PERSIST-01 reference: [https://letsencrypt.org/2026/02/18/dns-persist-01](https://letsencrypt.org/2026/02/18/dns-persist-01).
