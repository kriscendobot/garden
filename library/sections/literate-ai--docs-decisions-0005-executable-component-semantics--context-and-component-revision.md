---
title: "ADR 0005: Context and Component revision unit"
source: docs/decisions/0005-executable-component-semantics.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, software-supply-chain]
status: current
---

> Abstract: To replace graph-wide prompt flattening, Literate AI makes one immutable Component revision the independent unit of generation, source caching, build, test, and publication, with its own tree, derivation identity, evidence, public interfaces, and publication result while composition preserves private authority boundaries.

- Status: Accepted for contract implementation
- Date: 2026-08-06
- Decision owners: literate-ai maintainers
- Roadmap: `COMP-190`

## Context

The current generation path can resolve a Component dependency graph, but then flattens
dependency manifests, specifications, authoring inputs, and acceptance material into one
coding-agent recipe. That makes a dependency's private authority visible to its consumer,
makes one prompt grow with a transitive graph, and prevents independent cache and
invalidation decisions.

A Component needs an executable meaning before a per-Component planner can replace that
flattening. In particular, the framework needs one stable answer to four questions:

1. What may cross a dependency boundary during generation?
2. What does each dependency kind order and consume?
3. Which target, Flavor, asset, and driver decisions belong to each node?
4. Which nodes regenerate, rebuild, and retest after a classified change?

## The unit is a Component revision

One immutable Component revision is the unit of generation, source caching, build, test,
and publication. Each graph node has its own generated source tree, derivation identity,
build/test evidence, public interfaces, and publication result. A project or application
may compose those units, but composition does not merge their private authority.

This decision defines domain contracts. `LOCK-200` will define authored intent and exact
locks, and `DAG-210` will make the planner execute these semantics.

Source: [docs/decisions/0005-executable-component-semantics.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0005-executable-component-semantics.md) at commit `fcc40bc` (source lines 1–34).
