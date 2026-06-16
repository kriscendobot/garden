---
title: DNS-PERSIST-01 (emerging)
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

A new Let's Encrypt challenge variant (announced February 2026) designed to reduce the propagation-delay problem by using a persistent DNS record that survives across renewals. Not yet widely supported by ACME clients as of mid-2026. Referenced for awareness; DNS-01 remains the operational standard.

Source: [Challenge Types - Let's Encrypt](https://letsencrypt.org/docs/challenge-types/) retrieved 2026-06-11. DNS-PERSIST-01 reference: [https://letsencrypt.org/2026/02/18/dns-persist-01](https://letsencrypt.org/2026/02/18/dns-persist-01).
