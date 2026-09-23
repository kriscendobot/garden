---
title: Related work and prior art
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

> Abstract: UCAN positions itself among SPKI/SDSI, ZCAP-LD, CACAO, Local-First Auth, Macaroons, Biscuit, and verifiable credentials. The comparison clarifies its distinctive combination: asymmetric, end-user-rooted delegation chains addressed by CID, separate invocation, and offline validation; its nearest relatives trade different addressing, proof, server, or data-model choices.

SPKI/SDSI supplies the closest core delegation idea, while UCAN modernizes its encoding and adds content identifiers. ZCAP-LD differs in URL addressing, invocation separation, and proof multiplicity. CACAO targets small cross-blockchain bearer messages rooted in mutable blockchain documents and does not support subdelegation. Local-First Auth uses a CRDT membership and role model rather than certificates and improves visibility of who has access. Macaroons trade asymmetric signatures for MAC efficiency within a trusted service network; Biscuit uses Datalog; verifiable credentials assert attributes of people or organizations rather than delegated resource authority.

Source: [`README.md`](https://github.com/ucan-wg/spec/blob/9955aa1fb7b32897f80b57651f4ee8b22ebf35a7/README.md) at commit `9955aa1f`.
