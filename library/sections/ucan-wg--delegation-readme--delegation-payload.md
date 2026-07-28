---
title: The delegation payload and envelope tag
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

> Abstract: The concrete wire shape of a UCAN 1.0 delegation: envelope tag `ucan/dlg@1.0.0` and a nine-field payload whose required set is `iss`, `aud`, `sub`, `cmd`, `pol`, `nonce`, and `exp` (nullable but present). Note the two differences from the high-level spec's minimum payload: delegation carries `pol` (a policy) where an invocation carries `args`, and `sub` is nullable here to permit the Powerline pattern.

> "This specification describes the representation and semantics for delegating attenuated authority between principals. UCAN Delegation provides a cryptographically verifiable container, batched capabilities, hierarchical authority, and a minimal syntactically-driven policy language."

> "Delegation provides a way to 'transfer authority without transferring cryptographic keys'. As an authorization system, it is more interested in 'what can be done' than a list of 'who can do what'."

## Type tag

> "The UCAN envelope tag for UCAN Delegation MUST be set to `ucan/dlg@1.0.0`."

## Payload

> "The Delegation payload MUST describe the authorization claims, who is involved, and its validity period."

| Field | Type | Required | Description |
|---|---|---|---|
| `iss` | `DID` | Yes | "Issuer DID (sender). All DIDs are represented as string URLs." |
| `aud` | `DID` | Yes | "Audience DID (receiver)" |
| `sub` | `DID \| null` | Yes | "Principal that the chain is about (the Subject)" |
| `cmd` | `String` | Yes | "The Command to eventually invoke" |
| `pol` | `Policy` | Yes | Policy |
| `nonce` | `Bytes` | Yes | Nonce |
| `meta` | `{String : Any}` | No | "Meta (asserted, signed data) is not delegated authority" |
| `nbf` | `Integer` (53 bits) | No | "'Not before' UTC Unix Timestamp in seconds (valid from)" |
| `exp` | `Integer \| null` (53 bits) | Yes | "Expiration UTC Unix Timestamp in seconds (valid until)" |

Two details worth carrying forward:

- `exp` is **required but nullable**. A delegation must decide explicitly whether it expires; there is no "field omitted means forever" default. Given that the spec elsewhere prefers expiry over revocation as the primary control, that requiredness is doing real work.
- `meta` is signed but is explicitly "not delegated authority", so it is attested context rather than permission. Do not read anything in `meta` as widening what the token allows.

The 53-bit integer note reflects JavaScript's single numeric type: an IEEE-754 double has a 53-bit significand, so timestamps are constrained to fit.

Source: [`README.md`](https://github.com/ucan-wg/delegation/blob/1cb32dbc9d4d15a23bf9844a02515d760b81e816/README.md) at commit `1cb32dbc`.
