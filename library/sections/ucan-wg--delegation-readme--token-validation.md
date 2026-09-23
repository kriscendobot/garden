---
title: Token validation: time bounds, principal alignment, signature validation
source: README.md
source_repo: ucan-wg/delegation
source_commit: 1cb32dbc9d4d15a23bf9844a02515d760b81e816
source_date: 2026-07-08
source_authors: [Brooklyn Zelenka, Irakli Gozalishvili, Philipp Kruger]
ingested: 2026-07-28
ingested_by: scholar
topics: [ucan-authorization, capability-security]
status: current
---

> Abstract: The three criteria a delegation chain must pass, all checkable offline. Time bounds intersect across the chain, so "a delegation chain [is] valid between the latest `nbf` and earliest `exp`". Principal alignment is the structural rule: "the `aud` field of every proof MUST match the `iss` field of the UCAN being delegated to. This alignment MUST form a chain back to the Subject for each resource," and DID fragments are excluded from that comparison. Also the forgiving-validator rule: a validator "MUST NOT reject all capabilities when one that is not relevant to them is not understood".

## When validation happens

> "Validation of a UCAN chain MAY occur at any time, but MUST occur upon receipt of an Invocation *prior to execution*. While proof chains exist outside of a particular delegation (and are made concrete in UCAN Invocations), each delegate MUST store one or more valid delegations chains for a particular claim."

> "Each capability has its own semantics, which needs to be interpretable by the Executor. Therefore, a validator MUST NOT reject all capabilities when one that is not relevant to them is not understood. For example, if a Condition fails a delegation check at execution time, but is not relevant to the invocation, it MUST be ignored."

> "If *any* of the following criteria are not met, the UCAN Delegation MUST be considered invalid: 1. Time Bounds, 2. Principal Alignment, 3. Signature Validation."

## Time bounds

> "A UCAN's time bounds MUST NOT be considered valid if the current system time is before the `nbf` field or after the `exp` field. This is called the 'validity period.' Proofs in a chain MAY have different validity periods, but MUST all be valid at execution-time. This has the effect of making a delegation chain valid between the latest `nbf` and earliest `exp`."

The intersection semantics are the reason expiry is a usable substitute for revocation in this system: a short-lived link anywhere in the chain caps the whole chain, and no coordination is needed to make that happen.

## Principal alignment

> "In delegation, the `aud` field of every proof MUST match the `iss` field of the UCAN being delegated to. This alignment MUST form a chain back to the Subject for each resource."

> "This calculation MUST NOT take into account DID fragments. If present, fragments are only intended to clarify which of a DID's keys was used to sign a particular UCAN, not to limit which specific key is delegated between. Use `did:key` if delegation to a specific key is desired."

The spec's worked chain: Alice controls storage and issues a root UCAN (`iss: Alice`, `sub: Alice`, `aud: Bob`); Bob delegates onward (`iss: Bob`, `sub: Alice`, `aud: Carol`); Carol delegates to Dan; Dan invokes with `iss: Dan`, `sub: Alice`, and the proofs attached. Every link's subject stays Alice, every audience matches the next issuer, and each capability is equal to or narrower than the one above it.

## Signature validation

> "The Signature field MUST validate against the `iss` DID from the Payload."

All three checks are computable from the chain alone, which is what "offline verification" means concretely: no authorization server, no resolver, no revocation lookup in the required path. Revocation is a separate, best-effort layer on top, per the UCAN Revocation specification.

Source: [`README.md`](https://github.com/ucan-wg/delegation/blob/1cb32dbc9d4d15a23bf9844a02515d760b81e816/README.md) at commit `1cb32dbc`.
