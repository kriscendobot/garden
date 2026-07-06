---
id: ucan-delegation
aliases: [ucan, ucans, user controlled authorization network, did:key, did key, subject command policy, subject ability policy, capability delegation token, dialog-ucan, claim delegate, access claim]
topics: [ucan-authorization, capability-security]
---

# ucan-delegation

A **UCAN** (User Controlled Authorization Network) is an offline-verifiable, cryptographically-signed delegation token encoding a capability as `subject x command x policy`: `sub` a did:key principal (the resource), `cmd` a command path (the ability), `pol` a list of predicates over invocation arguments (the policy). Tokens delegate from an issuer (`iss`) to an audience (`aud`) and may be re-delegated only with equal-or-more-restrictive scope, verifiable without a central authority. It is the serialized, offline token form of object-capability delegation. Dialog models it in Rust as nested `Access<Inner, Outer>` types and uses it both to authorize effects (Archive/Memory capabilities) and to grant privacy access levels (L0–L3), with delegation tokens storable in-tree. The `dialog-ucan` crate is the concrete bridge: it connects `dialog-capability`'s generic typed capability chains to `dialog-ucan-core`'s UCAN-spec implementation, with a `claim(&repo).delegate(did)` / `save(delegation)` delegate-then-retain flow, delegation optionally narrowed to a specific attenuated capability before it is delegated.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [dialog-db--notes-capability-sysstem--subject-ability-policy](../sections/dialog-db--notes-capability-sysstem--subject-ability-policy.md) | Each of subject/ability/policy maps to a UCAN delegation field; nested `Access` types mirror the chain. |
| [dialog-db--notes-capability-sysstem--overview](../sections/dialog-db--notes-capability-sysstem--overview.md) | Effects, the ocap motivation, and the "capability is subject x command x policy" definition. |
| [dialog-db--notes-privacy--ucan-authorization-model](../sections/dialog-db--notes-privacy--ucan-authorization-model.md) | UCAN bearer tokens grant L0–L3 access; in-tree storage; re-delegation with more-restrictive scope. |
| [dialog-db--rust-dialog-ucan-readme--ucan-delegation-bridge](../sections/dialog-db--rust-dialog-ucan-readme--ucan-delegation-bridge.md) | The `dialog-ucan` crate bridges `dialog-capability` to `dialog-ucan-core`; the claim/delegate/save flow with narrowed capabilities. |
| [dialog-db--rust-dialog-operator-readme--profiles-operators-and-capability-environment](../sections/dialog-db--rust-dialog-operator-readme--profiles-operators-and-capability-environment.md) | The operator through which `access().claim().delegate()` and other effects are performed. |
| [dialog-db--notes-repository--identity-layers-account-profile-operator](../sections/dialog-db--notes-repository--identity-layers-account-profile-operator.md) | Account/profile/operator layers map onto the UCAN chain `Subject → Profile → Operator`. |
| [dialog-db--notes-repository--authorization-chain-and-capability-domains](../sections/dialog-db--notes-repository--authorization-chain-and-capability-domains.md) | Local vs recovered delegation chains from subject to operator; the `dialog-effects` capability domains. |
| [dialog-db--notes-repository--authorization-delegation-identification](../sections/dialog-db--notes-repository--authorization-delegation-identification.md) | `access::Prove` resolves a chain from a `CertificateStore`; delegations import via `profile.access().save(chain)`. |
| [dialog-db--rust-dialog-repository-guide--collaboration-ucan-delegation](../sections/dialog-db--rust-dialog-repository-guide--collaboration-ucan-delegation.md) | Sharing a repository across profiles via claim(&cap).delegate(audience) / save(chain); the produced chain carries the full proof path repo -> Alice -> Bob. |
| [dialog-db--rust-dialog-remote-ucan-s3-readme--collaboration](../sections/dialog-db--rust-dialog-remote-ucan-s3-readme--collaboration.md) | The remote-layer expression: Alice `claim(&repo).delegate(bob.did())`, Bob `save`s the chain and pushes with `.subject(alice_repo.did())` — no bucket secret shared. |

## See also

- [[capability-chain]] — the typed in-memory `Subject`/`Attenuation`/`Policy`/`Effect` chain the `ucan` feature serializes into these offline tokens.
- [[fact-triple]] — the data the capabilities gate access to.
- [[dialog-db]] — the database whose authorization this is.
- [[profile-account-operator]] — the three-layer identity model whose chain this delegation token realizes.
- [[signer-verifier-credential]] — the space credential a signer delegates from.
