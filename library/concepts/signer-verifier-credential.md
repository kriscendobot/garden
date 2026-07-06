---
id: signer-verifier-credential
aliases: [signer credential, verifier credential, SignerCredential, VerifierCredential, credential storage, named space credential, ed25519-priv multicodec, ed25519-pub multicodec, credentials/self]
topics: [ucan-authorization, content-addressed-storage]
---

# signer-verifier-credential

The ed25519 identity a dialog-db *named space* (a profile or a repository) holds, called its **credential**. It is either a **`SignerCredential`** (the full keypair — owner of the space, can delegate) or a **`VerifierCredential`** (public key only — a delegate, read-only unless invited). Credentials are stored as multicodec-tagged key material: a signer is 68 bytes `[0x80 0x26 | secret(32) | 0xed 0x01 | public_key(32)]` (`0x80 0x26` = varint `0x1300`, ed25519-priv) and a verifier is 34 bytes `[0xed 0x01 | public_key(32)]` (`0xed 0x01` = varint `0xed`, ed25519-pub). The human-readable space name scopes storage on both platforms — native at `{name}/credentials/self` on the filesystem, web in IndexedDB database `{name}`, store `credentials`, key `self` (signer as a non-extractable `CryptoKeyPair`, verifier as a `Uint8Array`). `space::Load` returns `Some(Signer)` / `Some(Verifier)` / `None`, driving the owner / delegate / create-new branches of opening a repository.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [dialog-db--notes-repository--named-spaces-and-credential-format](../sections/dialog-db--notes-repository--named-spaces-and-credential-format.md) | Signer vs verifier; multicodec byte layouts; per-platform storage layout. |
| [dialog-db--notes-repository--opening-and-operator-setup](../sections/dialog-db--notes-repository--opening-and-operator-setup.md) | `space::Load` returning `Signer`/`Verifier`/`None` and the create-new keypair path. |
| [dialog-db--notes-space-and-storage--core-types-location-space-storage](../sections/dialog-db--notes-space-and-storage--core-types-location-space-storage.md) | The `credential` provider slot in `Space<A, M, C, D>` that stores/loads these. |
| [dialog-db--rust-dialog-repository-guide--repository-and-branch-modes](../sections/dialog-db--rust-dialog-repository-guide--repository-and-branch-modes.md) | Repository open/load return Repository<Credential>; create returns Repository<SignerCredential> — the type-level owner-vs-delegate distinction. |

## See also

- [[profile-account-operator]] — the invoker identity that authorizes against a space owned by a signer credential.
- [[ucan-delegation]] — how a signer delegates to a verifier or a profile.
- [[space]] — the *chat-UI* space concept; unrelated to dialog-db's named space (a common-confusion collision on the word "space").
