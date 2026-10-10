---
title: OVA evaluation: readiness assessment and conclusion
source: docs/architecture/ova-model-evaluation.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc, testing]
status: current
---

> Abstract: A readiness table grades each OVA concern from strong (Component model, specification continuity, source grounding, model routing) through early or missing (composition, schema/version migration, restart/recovery), naming security enforcement as a Phase 1 blocker for any compiler execution. The conclusion: literate-ai owns a portable lifecycle kernel with explicit ports and immutable wire contracts, OVA becomes one application adapter and conformance consumer, and OVA's duplicate implementation is removed only in Phase 2 after real parity evidence.

| Concern | Baseline quality | Extraction implication |
|---|---|---|
| Conceptual Component model | Strong | Preserve, but split logical identity/revision/projections |
| Specification continuity | Strong prototype | Preserve OpenSpec adapter; redesign intent journal |
| Source and evidence grounding | Strong prototype | Preserve invariants; generalize engine and strengthen identities |
| Composition | Early | Replace OVA defaults and simplistic provider selection |
| Model routing | Strong prototype | Extract with arbitrary workflow-stage support |
| Generation orchestration | Strong vertical slice | Recast as durable workflow/event state machine |
| Cache/package lineage | Useful prototype | Move to true CAS and external graph projections |
| Publication | Narrow but well-separated | Retain separation and add registry protocol |
| Settings | Good OVA UI | Define scopes/schema/secrets before extracting presentation |
| Samples | Strong documentation pattern | Rebuild as neutral conformance fixtures |
| Self-hosting | Composition proof only | Add full bootstrap/rebuild proof |
| Security | Thoughtful plan, no enforcement | Phase 1 blocker for any compiler execution |
| Schema/version migration | Missing | Design before first public release |
| Operational restart/recovery | Missing | Add durable runs and reconciliation |

**Conclusion (the document's).** OVA should not remain the owner of these concepts, and literate-ai should not become an OVA utility library. The correct boundary is a portable lifecycle kernel with explicit ports and immutable wire contracts. OVA becomes one application adapter and one demanding conformance consumer. The migration plan makes OVA authoritative during Phase 1 and removes its duplicated implementation only in Phase 2 after real parity evidence.

Source: [docs/architecture/ova-model-evaluation.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/ova-model-evaluation.md) at commit `fcc40bc`.
