---
title: Lifecycle components
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

> Abstract: UCAN's lifecycle separates Delegation and Invocation (REQUIRED) from Promise and Revocation (RECOMMENDED). The components make authority transfer, authority exercise, asynchronous composition, and chain invalidation explicit rather than folding them into a single opaque token operation.

## Lifecycle

The four components have intentionally unequal status: Delegation passes and attenuates authority; Invocation exercises it through delegates; Promise awaits an invocation from another invocation; and Revocation breaks a chain for a malicious user. A database example makes the separation operational: Alice can delegate a database-write capability to Bob, Bob invokes with both proofs, and a later revocation of Alice-to-Bob makes the same proof chain reject.

Source: [`README.md`](https://github.com/ucan-wg/spec/blob/9955aa1fb7b32897f80b57651f4ee8b22ebf35a7/README.md) at commit `9955aa1f`.
