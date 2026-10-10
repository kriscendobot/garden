---
title: CI identity, evidence publication, and backend delivery
source: docs/architecture/production-containment-threat-model.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [sandbox-platforms, agentic-sdlc]
status: current
---

> Abstract: Live GitHub OIDC proves a narrowly challenge-bound CI identity, immutable evidence maps publish only after fresh closure verification, and production delivery remains gated on Linux sandbox implementation, VM isolation elsewhere, phase separation, signed observations, adversarial fixtures, and independent security review.

The OIDC profile fixes issuer, algorithm, discovery endpoints, key shape, audience, claim set, and freshness. Its result proves live identity and possession for one expected run and envelope; it is not durable signing authority, graph closure, challenge consumption, or receipt admission.

Current evidence maps are indexes over canonical receipt, plan, matrix, and retention roots. Read and publication paths reauthenticate the graph against independent policy and current revocations, verify immutable storage, and atomically replace the pointer only after checks pass. No local `current` marker or previously verified map bypasses fresh verification.

The delivery order implements Linux `os-sandboxed` first, uses VM isolation for enterprise macOS and Windows until native backends qualify, isolates every lifecycle phase, binds signed evidence into platform receipts, and finishes with independent review. Adversarial fixtures cover host canaries, secrets, output escape, symlinks, egress, resource exhaustion, child retention, target substitution, and forged or truncated evidence.

Source: [docs/architecture/production-containment-threat-model.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/production-containment-threat-model.md) at commit `fcc40bc`.
