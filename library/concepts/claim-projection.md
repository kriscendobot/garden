---
id: claim-projection
aliases: [claim-based serialization, Claim trait, Caveat trait, constrain method, claim projection, remove Serialize from capabilities, dialog Effect Attenuation Policy, PolicyBuilder push]
topics: [ucan-authorization]
---

# claim-projection

Dialog's move to remove the `Serialize + DeserializeOwned` requirement from capability types (effects, attenuations, policies) so they can carry non-serializable runtime types like `Ed25519Signer` or `CryptoKeyPair`. The bound was inherited from `Caveat` and is vestigial now that the `Claim` system generates *separate* serializable claim types: serialization moves from the capability types themselves to their claim representations. The change is five steps — drop the `Serialize` supertrait and blanket impl from `Caveat`, merge `Caveat` into `Claim` (which gains a `constrain(&self, builder)` method that pushes the claim type into the UCAN `PolicyBuilder`), drop the serialize bounds from the `Effect`/`Attenuation`/`Policy`/`Ability` traits, make `Constrained`/`Capability` conditionally serializable, and switch UCAN `parameters()` collection from `Caveat::constrain()` to `Claim::constrain()`. Most types are unaffected (where `Claim::Claim = Self`, behavior is identical); the change also eliminates the two-step Proof/claim(signer) flow and lets `access::Prove<P>` carry `by: P::Issuer` projected to a `Did`.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [dialog-db--notes-claim-based-serialization--vestigial-serialize-bound](../sections/dialog-db--notes-claim-based-serialization--vestigial-serialize-bound.md) | Why the Serialize bound on capabilities is now vestigial and what it blocks; the current trait state and UCAN path. |
| [dialog-db--notes-claim-based-serialization--claim-projection-proposed-change](../sections/dialog-db--notes-claim-based-serialization--claim-projection-proposed-change.md) | The five-step change moving serialization to claim representations; impact and the ten files to modify. |

## See also

- [[object-capability]] — the ocap authorization model Dialog's capability/effect/UCAN surface instantiates.
