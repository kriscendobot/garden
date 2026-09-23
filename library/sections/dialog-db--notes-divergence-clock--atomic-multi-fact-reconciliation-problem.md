---
title: The problem — reconciling concurrent commits and atomic multi-fact updates
source: notes/divergence-clock.md
source_repo: dialog-db/dialog-db
source_commit: abb5ca3f7c1b7bde278034eed41b66207a2b1d4e
source_date: 2026-07-01
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [change-propagation, local-first-sync]
status: current
---

> Abstract: "Commit History Encoding" opens by naming what concurrent multi-writer support demands of reconciliation across partial replicas: (1) identify concurrent changes — so a query reading a set of facts can tell whether some conflict (updated the same state via concurrent changes), letting the system project concurrent states a consumer chooses from — and (2) totally order all changes, including concurrent ones, so a commit index enables reconciliation without replicating the full commit history, indexed so reconciling query results incurs minimal reads (no chasing pointers to random tree segments). The **current design** requires that every causal triple `{the, of, is, cause}` carry a `cause` referencing another triple with the *same* `{the, of}`, keeping all causal references co-located in the same subtree as the selected facts (no extra reads to reconcile). The **problem** with that constraint: limiting causal references to one fact's lineage makes it impossible to update multiple facts atomically. The worked illustration is a message record where one concurrent change updates both `by` and `msg` and another updates only `msg`, ending in a state where `by` comes from one change and `msg` from another — misattribution. The desired behavior reconciles so that either only `msg` changes or both `by` and `msg` change together — a problem the note believes automerge and other popular CRDTs also have.

## Goal

Supporting concurrent writes implies multiple actors create concurrent commits (containing assertions/retractions) that all partial replicas must reconcile. The requirements:

1. **Identify concurrent changes.** When a query reads a set of facts, identify whether some facts conflict — updated the same state via concurrent changes. This enables projecting concurrent states a consumer could choose from.
2. **Order all changes** (including concurrent ones). Ordering enables a commit index, so reconciliation happens without replicating the full commit history. The history should be indexed so that reconciling query results incurs minimal reads — avoiding following pointers to random tree segments.

## Current design

The current design assumes every causal triple `{ the, of, is, cause }` MUST have a `cause` referencing another causal triple with the same `{ the, of }` as the original. This constraint implies all causal references are co-located in the same subtree as the selected facts, requiring no additional reads to reconcile.

## The problem

Limiting causal references to the same fact lineage constrains the achievable consistency guarantees. Specifically, it becomes impossible to update multiple facts atomically. Consider two concurrent changes to a message record `{ by: 'gozala', msg: "Hej" }`: one updates both `by` and `msg` (to `cdata` / `"Hello"`), the other updates only `msg` (to `"Hi"`). With per-fact lineages the reconciled state can end up with `by` from one change and `msg` from the other — a misattribution. The desired behavior reconciles such that either only `msg` changes to `"Hi"`, or both `msg` and `by` change together.

The note observes: "I believe this is a problem with automerge and other popular CRDT implementations."

Source: [notes/divergence-clock.md](https://github.com/dialog-db/dialog-db/blob/abb5ca3f7c1b7bde278034eed41b66207a2b1d4e/notes/divergence-clock.md) at commit `abb5ca3f`.
