---
title: Token resolution
source: README.md
source_repo: ucan-wg/spec
source_commit: 9955aa1fb7b32897f80b57651f4ee8b22ebf35a7
source_date: 2026-07-08
source_authors: [Brooklyn Zelenka, Irakli Gozalishvili, Daniel Holmgren, Philipp Kruger]
ingested: 2026-07-29
ingested_by: scholar
topics: [ucan-authorization, content-addressed-storage]
status: current
---

> Abstract: UCAN identifies proofs by CID but deliberately leaves their transport-specific retrieval outside the core format: a transport specification MUST define request, response, and collection formats, and an executor that cannot dereference a needed CID at runtime MUST fail validation. Content addressing supplies integrity, not availability.

The core specification does not choose a proof distribution network. The canonicalization section permits local stores, DHTs, gossip, and RESTful services; this section makes the complementary validation consequence explicit. A proof chain is constructive only when the validator can obtain its referenced CIDs, so a missing token cannot be treated as an authorization success merely because its claimed CID is well formed.

Source: [`README.md`](https://github.com/ucan-wg/spec/blob/9955aa1fb7b32897f80b57651f4ee8b22ebf35a7/README.md) at commit `9955aa1f`.
