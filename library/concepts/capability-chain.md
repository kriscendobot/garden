---
id: capability-chain
aliases: [capability chain, ability path, capability space, attenuation, Attenuation, Policy, Effect, dialog-capability, Subject, subject command policy, ability, invoke, perform]
topics: [ucan-authorization, capability-security]
---

# capability-chain

Dialog-db's typed encoding of attenuated object-capability delegation, implemented in the `dialog-capability` Rust crate. A capability is a **chain** rooted at a `Subject` (a resource identified by a did:key, representing full authority — ability `/` with no policy constraints) and narrowed through any number of links down to an invocable `Effect`. A link plays one of three roles: an **`Attenuation`** narrows the *ability path* (`/` → `/storage`), a **`Policy`** constrains *parameters only* without changing the path, and an **`Effect`** narrows the path *and* is invocable, declaring an `Output` type. The accreted **ability path** (`/storage/get`) is the authorization semantics, with prefix-inclusion — an ability includes every effect whose path starts with it, so `/storage` grants all storage operations while `/storage/get` restricts to reads. Every subject thus defines a **capability space** (the full hierarchy of ability paths on that resource), and capabilities attenuate that space. The chain answers `capability.ability()` (the path string) and `T::of(&capability)` (extract a link's values back out) structurally. An optional `ucan` feature serializes these in-memory chains to offline-verifiable UCAN tokens, which is how `dialog-ucan` transports them. This is the implemented form of the `subject × command × policy` sketch in dialog's `notes/capability-sysstem.md`.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [dialog-db--rust-dialog-capability-readme--overview-and-chain-example](../sections/dialog-db--rust-dialog-capability-readme--overview-and-chain-example.md) | The chain built fluently from `Subject` through `attenuate`/`invoke` to an ability path, with `::of` extraction. |
| [dialog-db--rust-dialog-capability-readme--capability-space-and-ability-paths](../sections/dialog-db--rust-dialog-capability-readme--capability-space-and-ability-paths.md) | `Subject` as full authority; the capability space as a hierarchy of prefix-inclusion ability paths. |
| [dialog-db--rust-dialog-capability-readme--traits-policy-attenuation-effect](../sections/dialog-db--rust-dialog-capability-readme--traits-policy-attenuation-effect.md) | The three trait roles (`Policy`, `Attenuation`, `Effect`) and the optional `ucan` serialization feature. |
| [dialog-db--rust-dialog-effects-readme--capability-domain-effect-hierarchy](../sections/dialog-db--rust-dialog-effects-readme--capability-domain-effect-hierarchy.md) | The six concrete domain effect trees (access, storage, space, archive, memory, credential) built on this chain. |
| [dialog-db--notes-capability-sysstem--subject-ability-policy](../sections/dialog-db--notes-capability-sysstem--subject-ability-policy.md) | The design-level `subject × command × policy` framing this crate implements. |

## See also

- [[ucan-delegation]] — the offline delegation-token model the `ucan` feature serializes these chains into.
- [[profile-account-operator]] — the identity layers that sit at the chain's subject root and invoke its effects.
- [[object-capability]] — the ocap discipline (Endo/Agoric practice) this is a typed-Rust realization of.
- [[subject-routing]] — how effects on a subject DID route to the storage provider that performs them.
