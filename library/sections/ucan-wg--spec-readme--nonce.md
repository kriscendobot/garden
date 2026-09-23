---
title: Nonce and token uniqueness
source: README.md
source_repo: ucan-wg/spec
source_commit: 9955aa1fb7b32897f80b57651f4ee8b22ebf35a7
source_date: 2026-07-08
source_authors: [Brooklyn Zelenka, Irakli Gozalishvili, Daniel Holmgren, Philipp Kruger]
ingested: 2026-07-29
ingested_by: scholar
topics: [ucan-authorization, capability-security]
status: current
---

> Abstract: Every UCAN has a required `nonce`, an arbitrary value whose recommended random form makes the signed, CID-addressed token unique and thereby supports replay prevention. A 12-byte random nonce is usually sufficient, but the relevant DID cryptosuite decides; a monotonic hash-chain count is also allowed. `nonce` is not an arbitrary signed-data channel: use `meta` for externally verifiable challenges and proofs.

The issuer, audience, and expiry often differentiate tokens already, but they do not guarantee uniqueness. The nonce closes that gap and makes each delegation produce a distinct CID. The specification recommends consulting the DID cryptosuite where the generic size guidance is insufficient.

Source: [`README.md`](https://github.com/ucan-wg/spec/blob/9955aa1fb7b32897f80b57651f4ee8b22ebf35a7/README.md) at commit `9955aa1f`.
