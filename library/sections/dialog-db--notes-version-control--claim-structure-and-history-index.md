---
title: Claim structure and unified history index
source: notes/version-control.md
source_repo: dialog-db/dialog-db
source_commit: 682d4dcf2353874585ebc1444449e99df9bd39b0
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [local-first-sync, change-propagation]
status: current
---

> Abstract: Every **Claim** `{the, of, is, cause}` carries a `cause` naming the prior claims on the same `(entity, attribute)` it supersedes — analogous to a git commit recording its parents, but scoped to *individual fact lineages* rather than whole-repository state. `cause` is empty on first write, one entry in the normal sequential case, and multiple only when deliberately resolving concurrent claims. This scopes conflict detection to an attribute's lineage instead of full revision-DAG traversal. Revisions and claims share one **history index** keyed `/edition/origin/entity/attribute/value_hash → Claim`, serving both revision-DAG traversal (revision claims stored under `entity = repository_did`, scanned by edition for causal order) and claim conflict resolution (locate a conflicting claim directly by its Version and follow its `cause` chain backward).

Claims carry a `cause` field identifying the prior claims on the same `(entity, attribute)` that this claim supersedes — analogous to how a git commit records which commits it builds on, but scoped to individual fact lineages rather than the full repository state:

```rust
pub struct Claim { pub the: The, pub of: Entity, pub is: Value, pub cause: Cause }
```

`cause` is empty on first write to an attribute, contains one entry in the normal sequential case, and contains multiple entries when explicitly resolving concurrent claims from different authors (recording that the author saw and deliberately superseded all of them). This enables conflict detection scoped to individual attribute lineages rather than full revision-DAG traversal.

**History index.** Revisions and claims share a unified index, `/edition/origin/entity/attribute/value_hash -> Claim`, serving two purposes:

- **Revision DAG traversal:** revision claims are stored under `entity = repository_did`; scanning by edition gives revision history in causal order, and a common ancestor between two lineages is found by following `cause` pointers backward from each head.
- **Claim conflict resolution:** for two conflicting claims on the same `(entity, attribute)`, the key `/edition/origin/entity/attribute` locates a claim directly and its `cause` chain can be followed backward.

Source: [notes/version-control.md](https://github.com/dialog-db/dialog-db/blob/682d4dcf2353874585ebc1444449e99df9bd39b0/notes/version-control.md) at commit `682d4dcf`.
