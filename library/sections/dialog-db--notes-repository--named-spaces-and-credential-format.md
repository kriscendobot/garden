---
title: Named spaces and the signer/verifier credential format
source: notes/repository.md
source_repo: dialog-db/dialog-db
source_commit: 18c640a06797b62eb3c57f3aeedb016634a5da19
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [ucan-authorization, content-addressed-storage]
status: current
---

> Abstract: Profiles and repositories are both **named spaces** — a human-readable name scoping an ed25519 identity called the space's *credential*. A credential is either a **`SignerCredential`** (full keypair; owner of the space, can delegate) or a **`VerifierCredential`** (public key only; delegate, read-only unless invited). Credentials are stored using multicodec-tagged key material: a signer is 68 bytes `[0x80 0x26 | secret(32) | 0xed 0x01 | public_key(32)]` (where `0x80 0x26` is varint `0x1300`, the ed25519-priv multicodec) and a verifier is 34 bytes `[0xed 0x01 | public_key(32)]` (`0xed 0x01` = varint `0xed`, ed25519-pub). On web the signer is stored as a non-extractable `CryptoKeyPair` in IndexedDB and the verifier as a `Uint8Array`. The name scopes storage on both platforms: native lays credentials at `{name}/credentials/self` on the filesystem; web uses IndexedDB database `{name}`, store `credentials`, key `self` — one directory (native) or database (web) per named space.

## Named Spaces

Profiles and repositories are both named spaces identified by a human-readable name, each containing an ed25519 identity (the "credential").

### Credential

A credential is either:
- **Signer** (`SignerCredential`) -- full keypair available (owner of the space)
- **Verifier** (`VerifierCredential`) -- public key only (delegate of the space)

### Storage Format

Credentials are stored using multicodec-tagged key material:

- **Signer** (68 bytes): `[0x80 0x26 | secret(32) | 0xed 0x01 | public_key(32)]`
- **Verifier** (34 bytes): `[0xed 0x01 | public_key(32)]`

Where `0x80 0x26` is varint-encoded `0x1300` (ed25519-priv multicodec) and `0xed 0x01` is varint-encoded `0xed` (ed25519-pub multicodec).

On web (IndexedDB), signer credentials are stored as `CryptoKeyPair` objects (non-extractable). Verifier credentials are stored as `Uint8Array`.

### Storage Layout

- **Native (FileSystem)**: `{name}/credentials/self`
- **Web (IndexedDB)**: database `{name}`, store `credentials`, key `self`

The `name` scopes the storage on both platforms. Each named space gets its own directory (native) or database (web).

Source: [notes/repository.md](https://github.com/dialog-db/dialog-db/blob/18c640a06797b62eb3c57f3aeedb016634a5da19/notes/repository.md) at commit `18c640a0`.
