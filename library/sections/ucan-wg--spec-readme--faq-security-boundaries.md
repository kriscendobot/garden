---
title: FAQ security boundaries
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

> Abstract: The UCAN FAQ locates several security guarantees precisely: a delegation is bound to its signed issuer and checked audience, an invocation additionally signs the use request, replay defense requires unique invocation CIDs checked against unexpired local state, and UCAN has no special person-in-the-middle protection. Extensions to its required cryptosuite are possible but non-interoperable and must be declared in the self-describing Varsig header.

An intercepted delegation is not usable by an arbitrary recipient because the intended audience must check `aud`, while only the issuer's private-key holder can issue it. That does not authenticate the transport: a successful interception can insert attacker DIDs in the proof chain, so trusted, authenticated recipients and secure channels remain strongly recommended. Delegation reception is idempotent; invocation execution is the replay-sensitive operation.

Source: [`README.md`](https://github.com/ucan-wg/spec/blob/9955aa1fb7b32897f80b57651f4ee8b22ebf35a7/README.md) at commit `9955aa1f`.
