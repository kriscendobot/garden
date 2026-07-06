---
id: profile-account-operator
aliases: [account, profile, operator, three-layer identity, delegation chain, local access, recovered access, operator derivation, ephemeral operator key, powerline delegation, dialog-operator, capability environment]
topics: [ucan-authorization]
---

# profile-account-operator

Dialog-db's three-layer identity model for authorizing repository operations. An **account** is an optional persistent recovery identity (passkey / hardware key / paper key) with no storage of its own, represented as an `Option<Did>` on the profile attenuation; a **profile** is a named per-device ed25519 identity that persists for the device's lifetime; an **operator** is an ephemeral per-session key *deterministically derived* from the profile key using a context byte string (same profile + context → same operator). The three compose into the UCAN chain `Subject → Profile { profile, account } → Operator { operator }`. Authorization then requires a delegation chain that is either **local** (`subject → profile → operator`; unrecoverable if the device is lost) or **recovered** (`subject → account → profile → operator`, or `subject → account → operator` when the repo was created after the account existed). This is distinct from dialog's *named space* credential (which identifies a space's owner/delegate); the identity layers identify the *invoker*. In the implemented crates, `dialog-operator` builds the operator as a session-scoped **capability environment** that routes every effect through DID-based dispatch with privilege narrowing (`Profile::open(name).derive(context).allow(cap).build(storage)`).

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [dialog-db--notes-repository--identity-layers-account-profile-operator](../sections/dialog-db--notes-repository--identity-layers-account-profile-operator.md) | The account/profile/operator layers and how they map onto the UCAN chain. |
| [dialog-db--notes-repository--authorization-chain-and-capability-domains](../sections/dialog-db--notes-repository--authorization-chain-and-capability-domains.md) | Local vs recovered delegation chains; the capability domains defined in `dialog-effects`. |
| [dialog-db--notes-repository--opening-and-operator-setup](../sections/dialog-db--notes-repository--opening-and-operator-setup.md) | Building an operator from a profile via `.derive(context).allow(cap).build(storage)`. |
| [dialog-db--notes-repository--authorization-delegation-identification](../sections/dialog-db--notes-repository--authorization-delegation-identification.md) | `access::Prove` chain resolution; `authority::Identify` returns the current chain. |
| [dialog-db--rust-dialog-operator-readme--profiles-operators-and-capability-environment](../sections/dialog-db--rust-dialog-operator-readme--profiles-operators-and-capability-environment.md) | The `dialog-operator` crate: Profile as a signing-credential-backed identity, Operator as the DID-routing privilege-narrowed environment. |
| [dialog-db--rust-dialog-repository-guide--identity-profile-operator-account](../sections/dialog-db--rust-dialog-repository-guide--identity-profile-operator-account.md) | Crate-doc statement of the three keypairs; the subject -> profile -> operator invocation chain; operator derivation is deterministic and revocable. |
| [dialog-db--rust-dialog-repository-guide--setup-storage-and-operator](../sections/dialog-db--rust-dialog-repository-guide--setup-storage-and-operator.md) | Building the operator from a profile via .derive(context).allow(cap).build(storage); base-directory override; .build takes ownership of storage. |

## See also

- [[ucan-delegation]] — the delegation-token model whose chain these three layers instantiate.
- [[capability-chain]] — the typed capability chain whose subject root these identities occupy and whose effects the operator performs.
- [[signer-verifier-credential]] — the space credential the subject at the chain root owns or delegates.
- [[dialog-db]] — the local-first database whose repository authorization this is.
