---
title: UCAN monotone revocation and validation
source: README.md
source_repo: ucan-wg/revocation
source_commit: 1235679bef2d74b7be46a6295e40184936247649
source_date: 2025-07-14
source_authors: [Brooklyn Zelenka]
ingested: 2026-07-29
ingested_by: scholar
topics: [ucan-authorization, capability-security]
status: current
---

> Abstract: UCAN Revocation v1.0.0-rc.1 invalidates delegation proofs by canonical CID through immutable, gossipable messages, preserving local-first and eventually consistent operation while making revocation a last-resort complement to expiry and attenuated scope.

Revocations are irreversible and recipients treat them as a monotonically growing set. If a revocation was mistaken, the remedy is a fresh delegation with a new nonce or time bounds, not retraction. The issuer of a delegation, and principals given the `ucan/revoke` capability, may revoke relevant links in a proof chain. Revoking one proof does not eliminate authority independently established through another valid chain.

An agent controlling a subject resource must cache revocations for that subject and, during proof validation, check each delegation's canonical CID. Matching proof links are ignored when the revocation issuer appears in the chain or has delegated revocation authority. Stores may be local, gossiped, centralized, or eventually consistent; out-of-order delivery is expected, and accepting prior revocations is recommended. A revocation can be evicted once its target token has expired or otherwise become invalid.

Source: [README.md](https://github.com/ucan-wg/revocation/blob/1235679bef2d74b7be46a6295e40184936247649/README.md) at commit `1235679b`.
