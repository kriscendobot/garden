---
source: notes/claim-based-serialization.md
source_repo: dialog-db/dialog-db
source_commit: 18c640a06797b62eb3c57f3aeedb016634a5da19
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
section_count: 2
status: current
---

> Abstract: A change proposal to remove the `Serialize + DeserializeOwned` requirement from Dialog's capability types (effects, attenuations, policies) so they can carry non-serializable runtime types like `Ed25519Signer` or `CryptoKeyPair`. The bound is vestigial now that the `Claim` system generates separate serializable claim types: serialization moves from the capability types themselves to their claim representations. Five steps: drop the `Serialize` supertrait and blanket impl from `Caveat`, merge `Caveat` into `Claim` (which gains a `constrain()` method), drop the serialize bounds from the `Effect`/`Attenuation`/`Policy`/`Ability` traits, make `Constrained`/`Capability` conditionally serializable, and switch UCAN `parameters()` collection to `Claim::constrain()`. Most types are unaffected (where `Claim::Claim = Self`), and the change eliminates the two-step Proof/claim(signer) flow. The note lists the ten `dialog-capability`/`dialog-macros`/`dialog-ucan` files to modify.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [vestigial-serialize-bound](../sections/dialog-db--notes-claim-based-serialization--vestigial-serialize-bound.md) | ucan-authorization | current |
| [claim-projection-proposed-change](../sections/dialog-db--notes-claim-based-serialization--claim-projection-proposed-change.md) | ucan-authorization | current |

## Provenance

- Repository default branch `main`; the file's last-touching commit is `18c640a0` (2026-07-05), authored by Irakli Gozalishvili. Part of Dialog's capability/UCAN authorization surface — companion to `notes/capability-sysstem.md` (the effect/subject/command/policy model) and `notes/scope-and-delegation.md` (UCAN scope and delegation), both already ingested.
- Ingested in the `scholar-ingest-dialog-db-remainder-4` follow-on cycle (2026-07-06).
