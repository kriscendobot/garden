---
title: Metadata as signed but non-authority data
source: README.md
source_repo: ucan-wg/spec
source_commit: 9955aa1fb7b32897f80b57651f4ee8b22ebf35a7
source_date: 2026-07-08
source_authors: [Brooklyn Zelenka, Irakli Gozalishvili, Daniel Holmgren, Philipp Kruger]
ingested: 2026-07-29
ingested_by: scholar
topics: [ucan-authorization, marshal]
status: current
---

> Abstract: Optional `meta` carries arbitrary signed metadata, facts, and proofs of knowledge only when they are self-evident and externally verifiable; it may carry hash preimages, server challenges, Merkle proofs, or dictionary data, but MUST NOT be semantically meaningful to delegation chains. It is the sanctioned data channel that keeps nonce focused on uniqueness rather than application challenges.

The boundary matters: metadata is covered by the signed envelope but is not delegated authority. A verifier may check a supplied challenge or proof, yet chain meaning and attenuation cannot depend on opaque application data in this map.

Source: [`README.md`](https://github.com/ucan-wg/spec/blob/9955aa1fb7b32897f80b57651f4ee8b22ebf35a7/README.md) at commit `9955aa1f`.
