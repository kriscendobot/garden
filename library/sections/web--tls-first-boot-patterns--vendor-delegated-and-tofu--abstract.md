---
title: Abstract
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

A self-custodial node that must be operable after a single first-boot sitting faces a TLS bootstrapping problem: it needs a certificate before the operator can trust its HTTPS endpoint, but obtaining a certificate from a public CA requires proving domain control, which itself requires that the node is running and reachable. This section surveys the four pattern families for resolving this bootstrapping problem, with their trade-offs relevant to a marketplace-deployed appliance.

Source: Synthesized from [Challenge Types - Let's Encrypt](https://letsencrypt.org/docs/challenge-types/) and the ACME-DNS delegation pattern at [https://agren.cc/p/acme-dns/](https://agren.cc/p/acme-dns/), retrieved 2026-06-11.
