---
title: Core types (Tree, Edition, Origin, Version, Cause)
source: notes/version-control.md
source_repo: dialog-db/dialog-db
source_commit: 682d4dcf2353874585ebc1444449e99df9bd39b0
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [local-first-sync]
status: current
---

> Abstract: The Rust types carrying the causal encoding, all in the `dialog.revision` attribute domain: **Tree** (Blake3 root of the search tree at a revision), **Edition** (u64 Lamport-timestamp count of the causal chain, incremented locally / advanced to `max(seen)+1` on sync), **Origin** (Blake3 repository-membership id from issuer+subject), **Authority**/**Issuer** (Ed25519 keys), **Signature**, **Version** = `{origin, edition}` (sorts by causal depth; same edition + different origin = concurrent), and **Cause** = `Vec<Version>` (the set of prior claim versions this one supersedes).

The causal-encoding types (all `#[domain("dialog.revision")]`):

```rust
/// Root of the search tree at a given revision
pub struct Tree(Blake3Hash);

/// Count of revisions in the causal chain leading to this one.
/// Increments locally on each revision; advances to max(seen) + 1 on sync.
/// Isomorphic to a Lamport timestamp.
pub struct Edition(u64);

/// Repository membership identifier derived as Blake3(issuer + subject).
/// Deriving from both signing key and repository DID ensures the same
/// principal acting on two different repositories produces two distinct origins.
pub struct Origin(Blake3Hash);

pub struct Authority([u8; 32]);   // Ed25519 authority responsible for the revision
pub struct Issuer([u8; 32]);      // Ed25519 principal committing the revision
pub struct Signature(Vec<u8>);    // Cryptographic signature for the revision

/// Uniquely identifies a specific revision by a specific origin.
/// Sorts naturally by causal depth via edition.
/// Two versions with the same edition but different origins are concurrent.
pub struct Version { pub origin: Origin, pub edition: Edition }

/// A set of versions identifying prior claims superseded by this one.
pub struct Cause(Vec<Version>);
```

Source: [notes/version-control.md](https://github.com/dialog-db/dialog-db/blob/682d4dcf2353874585ebc1444449e99df9bd39b0/notes/version-control.md) at commit `682d4dcf`.
