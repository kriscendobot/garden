---
title: "ADR 0011: Versioned typed domain metadata"
source: docs/decisions/0011-component-domain-structure-literate-markdown-v2.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, software-supply-chain]
status: current
---

> Abstract: `literate-markdown@2` adds lock-bound data contracts, bounded invariants, error taxonomies, performance budgets, and discriminated acceptance contracts under fresh identities; upgrading is an explicit re-lock while v1 documents and schemas remain unchanged.

The new provider version accepts optional structured fields:

- `data_contracts` references pinned assets for JSON Schema, Protobuf, Avro, or CSV
  headers with enforced media types.
- `invariants` carries bounded input/output predicates evaluated by the independent
  verifier.
- `error_taxonomy` enumerates codes, status or exit behavior, and conditions.
- `performance_budgets` gives qualification a metric, bound, and probe.

Acceptance entries gain `golden-io`, `exit-code`, `schema-match`, and `property` types
with deterministic verifier adapters. A generatable non-sample Component without an
acceptance contract needs an explicit waiver. New wire types receive new schema
identities; v1 remains immutable. The provider version participates in specification
identity, so migration is visible in each lock.

Source: [docs/decisions/0011-component-domain-structure-literate-markdown-v2.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0011-component-domain-structure-literate-markdown-v2.md) at commit `fcc40bc6` (source lines 35-67).
