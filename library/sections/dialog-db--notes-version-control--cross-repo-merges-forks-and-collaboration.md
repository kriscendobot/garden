---
title: Cross-repo merges, forks, and concurrent-claim resolution
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

> Abstract: Because `Edition` is a Lamport timestamp and `Origin` = `Blake3(issuer+subject)`, editions from different repositories are directly comparable and both are meaningful across repository boundaries without coordination. **Forking:** a new repo DID whose first revision's `cause` points at the source head and whose edition is `max(source)+1`. **Merging upstream:** find the common ancestor by traversing both lineages via `cause`, resolve conflicts with two-tier detection. **Collaborators joining** (with or without prior history) advance their counter to `max(peer, self)+1` on pull; pre-join claims are preserved with original editions and re-anchor from the merge point. **Genuinely concurrent** claims (neither in the other's cause) are both valid; a last-write-wins query sorts on claim hash for a stable deterministic winner, and apps can request all concurrent values to surface conflicts. This directly fixes the divergence-clock's repo-local, incommensurable `since` counter.

Each repository maintains its own revision lineage identified by its DID. Because `Edition` is a Lamport timestamp, editions from different repositories are directly comparable: a higher edition has seen more causal history regardless of which repository produced it.

- **Forking:** Alice creates her own repository DID and writes her first revision with `cause` pointing to Bob's current head version; her edition takes `max(Bob's edition) + 1`. All subsequent edition comparisons are meaningful relative to Bob's history.
- **Merging upstream:** Alice finds the common ancestor by traversing both revision lineages via `cause` pointers; conflicting claims are resolved using two-tier conflict detection.
- **Collaborator joining with no prior history:** Carol initializes a fresh repository (edition 0, no claims), accepts Bob's invite, pulls his history — her counter advances to `max(Bob's edition) + 1` on pull — and makes her first commit at that edition. No reconciliation needed.
- **Collaborator joining with prior history:** Carol has worked independently to edition 2. On pulling Bob's history (also at edition 2 via an independent history, so incommensurable), her counter advances to `max(Bob, Carol) + 1`. Her prior claims are preserved in the revision DAG with their original editions, and her cause chain re-anchors from the merge point.

**Fork and merge illustrated:** Alice forks Bob's repository at edition 2; her first revision is edition 3 (`max(2)+1`). When she merges Bob's later `B:3`/`B:4`, the common ancestor at edition 2 is found by traversing the DAG via `cause`; conflicts resolve via two-tier detection; after the merge Alice's `A:5` has edition 5 and its `cause` references both lineages.

**Concurrent claim resolution.** When two claims on the same `(entity, attribute)` are genuinely concurrent (neither in the other's cause chain), both are valid. A last-write-wins query resolves this deterministically by sorting on claim hash, producing a stable winner without user intervention; applications needing to surface the conflict can request all concurrent values.

**Cross-repository collaboration.** The divergence-clock `since` counter is local to a repository's sync history, so two independent repositories that later merge have incommensurable counters. This design fixes that directly: because `Edition` is a Lamport timestamp and `Origin` is derived from `Blake3(issuer + subject)`, both are meaningful across repository boundaries without coordination — revisions from independent repositories can be compared, their common ancestor found via `cause` pointers, and conflicts resolved with the same two-tier detection that works within a single repository. Forks, merges, and collaborators joining with prior history all follow from the same primitives.

Source: [notes/version-control.md](https://github.com/dialog-db/dialog-db/blob/682d4dcf2353874585ebc1444449e99df9bd39b0/notes/version-control.md) at commit `682d4dcf`.
