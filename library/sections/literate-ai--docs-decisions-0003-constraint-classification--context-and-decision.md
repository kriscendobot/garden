---
title: "ADR 0003 (constraint classes): Context and decision"
source: docs/decisions/0003-constraint-classification.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc]
status: current
---

> Abstract: Literate AI separates semantic and authority invariants from replaceable repository or project policy and from desired delivery claims that still lack end-to-end proof; “must” is reserved for invariants or rules inside an explicitly named policy.

- Status: Accepted for bootstrap
- Date: 2026-08-03
- Decision owners: literate-ai maintainers
- Supersedes: the undifferentiated “Non-negotiable properties” list in the root README

## Context

The first-day architecture used *non-negotiable* for three different things: semantic
boundaries, choices made by the reference implementation, and end-state guarantees that
still need proof. That wording can freeze replaceable choices and, more seriously, make
an incomplete security or provenance property sound delivered.

## Decision

Every high-level constraint has one of these classes:

| Class | Meaning | Change rule |
| --- | --- | --- |
| **Invariant** | Violating it changes the framework's meaning, loses authority, or creates a security/confused-deputy path. | Supersede this decision, migrate affected contracts, and update conformance proof. |
| **Policy/default** | The reference repository, a project, or a pinned policy chooses it today. Another conforming integration may choose differently and record that choice. | Change the owning policy or decision and its tests; do not present it as universal. |
| **Deferred claim** | It is a desired delivery property without complete end-to-end enforcement evidence. | Describe it as a target or gate. Do not advertise it as a current guarantee. |

“Must” is reserved for an invariant or for a rule inside an explicitly named policy.
Roadmap exit criteria are requirements for that future phase, not claims about the
installed package.

Source: [docs/decisions/0003-constraint-classification.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0003-constraint-classification.md) at commit `fcc40bc` (source lines 1–27).
