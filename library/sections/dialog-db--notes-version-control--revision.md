---
title: Revision (content-addressed, claim-stored, Datalog-queryable)
source: notes/version-control.md
source_repo: dialog-db/dialog-db
source_commit: 682d4dcf2353874585ebc1444449e99df9bd39b0
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [local-first-sync, datalog-query]
status: current
---

> Abstract: A **Revision** is a Dialog concept stored as a claim in the EAV index under the **repository DID as the entity**, so revision history is queryable via Datalog like any other data. It is content-addressed: `this` is the hash of the Revision object (its stable entity id); `origin()` is computed on demand as `Blake3(issuer + subject)` and never stored; `version()` returns `{origin, edition}`. As a claim, `of` is the repository DID and `is` is the Version hash. **Edition rule:** `edition = last_edition + 1` locally, `max(local, received) + 1` on sync. **Offline construction** needs only the previous revision (no fetches). **Merge revisions** are the only case where `cause` holds more than one parent version.

A revision is a Dialog concept stored as a claim in the EAV index under the repository DID as the entity, making revision history queryable via Datalog like any other data:

```rust
pub struct Revision {
    pub this:      Entity,     // content-addressed hash of this Revision object
    pub tree:      Tree,
    pub edition:   Edition,
    pub subject:   Did,        // DID of the repository
    pub issuer:    Issuer,
    pub authority: Authority,
    pub signature: Signature,
    pub cause:     Cause,      // parent revision versions (one normally, multiple on merge)
}

impl Revision {
    /// Derives the origin from issuer and repository DID. Stored nowhere; always computed.
    pub fn origin(&self) -> Origin {
        Origin(blake3::hash(&[self.issuer.0.as_ref(), self.subject.as_bytes()].concat()))
    }
    pub fn version(&self) -> Version { Version { origin: self.origin(), edition: self.edition.clone() } }
}
```

When stored as claims, `of` is the repository DID and `is` is the revision's entity hash (`hash(edition + origin)`, the Version) rather than the full object:

```
Claim { the: "dialog.db/revision", of: repository_did, is: version_hash, cause: Cause(vec![...]) }
```

The repository DID as `of` means querying the current revision is a simple lookup, and the full revision history is all claims on that entity ordered by edition. Multiple repositories each maintain their own independent lineage under their respective DIDs.

- **Edition rule:** on each local revision, `edition = last_edition + 1`; on sync, `edition = max(local_edition, received_edition) + 1`. A higher edition has seen more causal history regardless of repository.
- **Offline construction:** a new revision requires only the previous revision — no fetches. The new version derives from the previous revision's edition and origin, and `cause` points to the previous revision's version.
- **Merge revisions:** when incorporating changes from another lineage, `cause` lists the versions of all parent revisions — the only case where `cause` has more than one entry.

Source: [notes/version-control.md](https://github.com/dialog-db/dialog-db/blob/682d4dcf2353874585ebc1444449e99df9bd39b0/notes/version-control.md) at commit `682d4dcf`.
