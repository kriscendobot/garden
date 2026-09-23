---
title: Goal and hypothesis — selective-pull incremental maintenance
source: notes/dbsp.md
source_repo: dialog-db/dialog-db
source_commit: ff9f03bf29edebb429a37de62eac9bcf99312131
source_date: 2025-06-03
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [change-propagation, datalog-query]
status: current
---

> Abstract: The exploration's objective is to adopt DBSP for **incremental view maintenance** *without* pushing all new facts through the system — instead exploiting the triple store's properties to fetch only the facts relevant to a given query's updates. Three objectives: the primary goal (DBSP-based IVM that pulls only relevant facts rather than processing all fact changes); a secondary goal (if selective-pull IVM works, apply the same mechanism to *initial* query evaluation too, unifying the two strategies so the engine need not maintain both top-down and DBSP evaluators); and a constraint (preserve the existing selective-loading and query-optimization advantages while gaining DBSP's incremental processing). The central hypothesis is that the prolly-tree store's content-defined structure plus the existing planner's conjunct-reordering and cycle-detection let the system detect relevant changes by comparing root pointers, selectively replicate only changed subtrees containing query-relevant facts, exploit the EAV/AEV/VAE index structure to identify which subtrees to replicate, and lean on the cache hierarchy to minimize remote access — transforming IVM from "pull all changes and filter" into "replicate only the relevant subtrees a query's analysis identifies." The secondary hypothesis extends the same selective-pull mechanism to initial evaluation, yielding a unified DBSP approach with the same efficiency characteristics as top-down.

## Goal

Adopt DBSP for **incremental view maintenance** while preserving the benefits of the existing top-down evaluation strategy:

1. **Primary Goal**: use DBSP for IVM without passing all new facts through the system — exploit triple-store properties to fetch only the relevant facts for updates.
2. **Secondary Goal**: if selective-pull IVM works, apply the same strategy to initial query evaluation, unifying the approach and avoiding two separate evaluation strategies (top-down + DBSP).
3. **Preserve Existing Benefits**: keep the current selective-data-loading and query-optimization advantages while gaining DBSP's incremental processing.

## Hypotheses

**Primary Hypothesis**: the properties of the prolly-tree triple store plus existing query-planning capabilities enable DBSP-based IVM that only pulls facts relevant to specific queries, rather than processing all fact changes.

**Secondary Hypothesis**: if selective fact-pulling works for incremental maintenance, the same mechanism should work for initial query evaluation, replacing top-down evaluation with a unified DBSP approach that keeps the same efficiency.

**Key Insight**: the existing planner's conjunct-reordering and cycle-detection, combined with the prolly tree's EAV/AEV/VAE indexes and partial replication, should allow the system to:

1. **Detect relevant changes** by comparing root pointers (revisions).
2. **Selectively replicate** only changed subtrees containing facts relevant to its queries.
3. **Leverage partial replication** to keep data transfer and storage overhead minimal.
4. **Exploit index structure** (EAV, AEV, VAE) to identify which subtrees need replication.
5. **Benefit from the caching hierarchy** to minimize remote blob-store access during incremental updates.

This transforms incremental view maintenance from "pull all changes and filter" into "replicate only relevant subtrees based on query analysis."

Source: [notes/dbsp.md](https://github.com/dialog-db/dialog-db/blob/ff9f03bf29edebb429a37de62eac9bcf99312131/notes/dbsp.md) at commit `ff9f03bf`.
