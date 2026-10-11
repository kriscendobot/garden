---
title: "ADR 0036: Exact Flavor-bound npm profile"
source: docs/decisions/0036-selection-bound-npm-dependency-lifecycle.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, software-supply-chain]
status: current
---

> Abstract: Only exact `package-npm` Flavor selection authorizes a typed npm command profile binding the Flavor, tools, manifests, resolver, complete package graph, and requested privileges.

The chosen Node resolves and executes npm even when the two tools have different prefixes. The initial lifecycle accepts one package root, exact direct versions, complete v2 or v3 locks, path-derived omitted names, locked optional nodes, and only admitted or explicitly optional peer relationships.

Workspaces, alternate managers, non-registry dependencies, duplicate versions, lifecycle scripts, and native addons fail closed pending separate designs.

Source: [docs/decisions/0036-selection-bound-npm-dependency-lifecycle.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0036-selection-bound-npm-dependency-lifecycle.md) at commit `fcc40bc6`.
