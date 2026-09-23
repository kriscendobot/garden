---
source: notes/version-control.md
source_repo: dialog-db/dialog-db
source_commit: 682d4dcf2353874585ebc1444449e99df9bd39b0
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
section_count: 6
status: current
---

> Abstract: Dialog's Version Control design: a causal encoding grounded in the revision DAG that preserves the divergence-clock's fast concurrency detection while composing across independent repositories. A revision's **Edition** is a Lamport-timestamp count of its causal chain; paired with **Origin** = `Blake3(issuer + subject)` it forms a **Version** that sorts by causal depth and uniquely addresses any revision across all repos. Revisions are content-addressed Dialog concepts stored as claims under the repository DID (queryable via Datalog); claims carry a `cause` scoping conflict detection to individual `(entity, attribute)` lineages; a unified history index keyed `/edition/origin/entity/attribute/value_hash` serves both DAG traversal and conflict resolution; a two-tier (O(1) direct-cause, O(k) chain-traversal) detector resolves conflicts, with genuinely-concurrent claims deterministically ordered by claim hash. Forks, cross-repo merges, and collaborators joining all follow from the Lamport-edition + derived-origin primitives.

| Section | Topics | Status |
|---------|--------|--------|
| [context-and-idea](../sections/dialog-db--notes-version-control--context-and-idea.md) | local-first-sync, change-propagation | current |
| [core-types](../sections/dialog-db--notes-version-control--core-types.md) | local-first-sync | current |
| [revision](../sections/dialog-db--notes-version-control--revision.md) | local-first-sync, datalog-query | current |
| [claim-structure-and-history-index](../sections/dialog-db--notes-version-control--claim-structure-and-history-index.md) | local-first-sync, change-propagation | current |
| [conflict-detection](../sections/dialog-db--notes-version-control--conflict-detection.md) | local-first-sync, change-propagation | current |
| [cross-repo-merges-forks-and-collaboration](../sections/dialog-db--notes-version-control--cross-repo-merges-forks-and-collaboration.md) | local-first-sync, change-propagation | current |

## Provenance

- Repository default branch `main`; the file's last-touching commit is `682d4dcf` (2026-07-05), authored by Irakli Gozalishvili. Companion to `notes/divergence-clock.md` (the single-repo clock this generalizes).
- Ingested in the `scholar-ingest-dialog-db-remainder` follow-on cycle (2026-07-06).
