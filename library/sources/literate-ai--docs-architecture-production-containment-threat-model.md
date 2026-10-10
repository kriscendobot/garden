---
source: docs/architecture/production-containment-threat-model.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
section_count: 7
status: current
---

> Abstract: The production-containment threat model defines ordered isolation guarantees, phase-specific controls, fail-closed local evaluation, authenticated evidence closure and publication, backend qualification, single-use launch authority, and exact Linux build-budget preflight without claiming that the production backend already exists.

| Section | Topics | Status |
|---------|--------|--------|
| [isolation levels and threat scope](../sections/literate-ai--docs-architecture-production-containment-threat-model--isolation-levels-and-threats.md) | sandbox-platforms, agentic-sdlc | current |
| [phase-specific isolation controls](../sections/literate-ai--docs-architecture-production-containment-threat-model--phase-specific-controls.md) | sandbox-platforms, agentic-sdlc | current |
| [provider-neutral fail-closed isolation contract](../sections/literate-ai--docs-architecture-production-containment-threat-model--provider-neutral-fail-closed-contract.md) | sandbox-platforms, agentic-sdlc | current |
| [authenticated evidence closure and retention](../sections/literate-ai--docs-architecture-production-containment-threat-model--authenticated-evidence-closure.md) | sandbox-platforms, agentic-sdlc | current |
| [CI identity, evidence publication, and backend delivery](../sections/literate-ai--docs-architecture-production-containment-threat-model--ci-identity-publication-and-delivery.md) | sandbox-platforms, agentic-sdlc | current |
| [single-use build admission](../sections/literate-ai--docs-architecture-production-containment-threat-model--single-use-build-admission.md) | sandbox-platforms, agentic-sdlc | current |
| [exact build binding and cgroup preflight](../sections/literate-ai--docs-architecture-production-containment-threat-model--exact-build-binding-and-cgroup-preflight.md) | sandbox-platforms, agentic-sdlc | current |
