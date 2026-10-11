---
title: "ADR 0002 (Python reference kernel, isolated Node tooling): Dependency admission policy"
source: docs/decisions/0002-reference-implementation-ecosystem.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, software-supply-chain]
status: current
---

> Abstract: Every proposed runtime dependency must record the missing capability, maintenance and release evidence, transitive size, vulnerability/provenance/license posture, upgrade owner, isolation boundary, and removal path; dependencies are direct and intentional, and lockfiles never turn tooling into runtime.

## Dependency admission policy

For each proposed runtime dependency, record:

- the exact capability that the standard library or existing code cannot reasonably
  provide;
- active-maintenance and release evidence;
- direct and transitive package count;
- vulnerability, provenance, and license posture;
- version/support policy and upgrade owner;
- isolation boundary and failure behavior; and
- a removal or replacement path.

Dependencies SHALL be direct and intentional. Framework adapters may use pinned extras;
the domain package cannot import them. Lockfiles are mandatory for contributor and release
environments but do not convert tooling dependencies into runtime dependencies.

Source: [docs/decisions/0002-reference-implementation-ecosystem.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0002-reference-implementation-ecosystem.md) at commit `fcc40bc` (source lines 42–57).
