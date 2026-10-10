---
source: docs/architecture/component-authoring-lock-boundary.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
section_count: 8
status: current
---

> Abstract: The component authoring and lock boundary document (LOCK-200) assigns every Component field to authored intent, resolvable selector, resolved identity, runtime evidence, or catalog audit; keeps a one-way selected lock apart from its candidates audit; states the lock graph invariants and read-only observation rules; describes the litai lock and migrate commands and lock-only generation; and defines the authored lifecycle kinds.

| Section | Topics | Status |
|---------|--------|--------|
| [authored intent, selected lock, and runtime evidence; component.md as the single-file default](../sections/literate-ai--docs-architecture-component-authoring-lock-boundary--intent-lock-evidence-separation.md) | agentic-sdlc | current |
| [field classification rule and Component field ownership](../sections/literate-ai--docs-architecture-component-authoring-lock-boundary--field-classification.md) | agentic-sdlc | current |
| [flavor, target, policy, and provider-resolution fields](../sections/literate-ai--docs-architecture-component-authoring-lock-boundary--flavor-target-and-provider-resolution.md) | agentic-sdlc | current |
| [workflow, routing, skill, acceptance, repository, and asset fields](../sections/literate-ai--docs-architecture-component-authoring-lock-boundary--workflow-skill-acceptance-repository-asset-fields.md) | agentic-sdlc, repository-governance | current |
| [lock graph invariants](../sections/literate-ai--docs-architecture-component-authoring-lock-boundary--lock-graph-invariants.md) | agentic-sdlc | current |
| [one-way lock/audit identity, evidence ownership, and read-only lock observation](../sections/literate-ai--docs-architecture-component-authoring-lock-boundary--lock-audit-pair-and-evidence-ownership.md) | agentic-sdlc | current |
| [the litai lock and component migrate commands, and lock-only generation](../sections/literate-ai--docs-architecture-component-authoring-lock-boundary--lock-and-migrate-commands.md) | agentic-sdlc, tooling | current |
| [component lifecycle kinds](../sections/literate-ai--docs-architecture-component-authoring-lock-boundary--component-lifecycle-kinds.md) | agentic-sdlc, testing | current |
