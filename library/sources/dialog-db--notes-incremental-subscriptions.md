---
source: notes/incremental-subscriptions.md
source_repo: dialog-db/dialog-db
source_commit: 005d8c7b123a1105a46458bea2c05d01134cacfa
source_date: 2026-07-01
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
section_count: 3
status: current
---

> Abstract: "Demand-driven incremental query subscriptions" — the design note that revises the earlier DBSP exploration into its shipped-target architecture. The goal is standing subscriptions that receive result *deltas* rather than recomputed results, maintained demand-driven so only touched data is fetched. Its enabling model is a **single local content-addressed tree** — peers exist only at the merge boundary (`Tree::integrate`, LWW), every query runs locally, and replication is the tree's lazy-load driven by which subtrees the query reads — which makes demand equal to the query's subtree-access pattern and turns negation-correctness into a checkable tree-materialization invariant. The architectural pivot: **pull-driven magic sets / demand transformation, not push-driven DBSP** (DBSP's retained operator state re-materializes exactly what a partial replica avoids holding), keeping DBSP's algebra only as the account of *what* each operator computes. It assembles a technique stack (magic sets/SIPS, Dynamic Magic Sets, the `n.p` complement + stratified order for negation, DRed/FBF for retraction, prolly-tree `differentiate` for the signed delta), shows the planner already computes the SIPS and the prolly tree already yields signed range-scopable deltas, and lays a four-step dependency-ordered build path (AST→operator IR, reify demand, subscription layer, dynamic demand maintenance). Companion to `notes/dbsp.md`; the operator-IR step it names is the same `feat/operator-ir` structural turn that reshaped `notes/optional-fields.md` and the `scalar-associative-layer` cluster.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [goal-and-replication-model](../sections/dialog-db--notes-incremental-subscriptions--goal-and-replication-model.md) | change-propagation, local-first-sync | current |
| [magic-sets-not-dbsp](../sections/dialog-db--notes-incremental-subscriptions--magic-sets-not-dbsp.md) | change-propagation, datalog-query | current |
| [codebase-provides-and-build-path](../sections/dialog-db--notes-incremental-subscriptions--codebase-provides-and-build-path.md) | change-propagation, datalog-query | current |

## Provenance

- Repository default branch `main`; the file's last-touching commit is `005d8c7b` (2026-07-01), authored by Irakli Gozalishvili. Explicitly a companion to `notes/dbsp.md`.
- Draws on external incremental-Datalog literature (Tekle-Liu, Alviano, Balbin, Gupta-Mumick-Subrahmanian, DBSP VLDB).
- Ingested in the `scholar-ingest-dialog-db-remainder-5` follow-on cycle (2026-07-06).
