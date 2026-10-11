---
title: "ADR 0001 (software-neutral lifecycle kernel): Boundary rule"
source: docs/decisions/0001-framework-boundary.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc]
status: current
---

> Abstract: Core code and schemas may not name OVA, embed Omniverse/robotics policy, parse CodeGraph output, assume a particular provider, language, builder, filesystem, UI, or transport, or fix four global LLM stages; such behavior lives in OVA or a temporary compatibility layer.

## Boundary rule

Core code and schemas must not contain:

- `ova` names, IDs, paths, environment variables, or manifest assumptions;
- Omniverse, Isaac, ROS, Kit, physics, or foundation-component policy;
- CodeGraph wire formats or shell-output parsing;
- a particular model provider, programming language, builder, filesystem, UI, or
  publication transport; or
- four globally fixed LLM stages.

OVA-specific behavior belongs in the OVA repository or `compatibility/ova` during the
migration window. Generic adapters may live here if they satisfy neutral port contracts.

Source: [docs/decisions/0001-framework-boundary.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0001-framework-boundary.md) at commit `fcc40bc` (source lines 37–49).
