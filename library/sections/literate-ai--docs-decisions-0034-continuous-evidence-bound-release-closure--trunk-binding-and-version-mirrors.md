---
title: "ADR 0034: Trunk binding and version mirrors"
source: docs/decisions/0034-continuous-evidence-bound-release-closure.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, software-supply-chain]
status: current
---

> Abstract: Initial, major, and minor candidates must contain the live remote default-branch revision, and every checked-in package version becomes an atomic release-version mirror.

The trunk invariant is rechecked during planning, preparation, checking, and publication so an early-cut release line cannot omit later approved work. A newly fetched trunk revision invalidates the phase and requires a deliberate merge or backport; patch releases remain selective.

Package metadata, including a Homebrew formula's quoted version constant and derived archive URL, stays inside the same planned write and scope check as Python, project, and schema versions.

Source: [docs/decisions/0034-continuous-evidence-bound-release-closure.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0034-continuous-evidence-bound-release-closure.md) at commit `fcc40bc6`.
