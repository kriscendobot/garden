---
source: docs/decisions/0018-never-empty-per-agent-model-stack.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
section_count: 9
status: current
content_caveat: "foreign-content gate classified (jev-1.13.0): disposition proceed, injection 0.10 clean, slant neutral at confidence 0.85; fetched raw content sha256 1bb718f5"
---

> Abstract: Literate AI ADR 0018 adds a context-local, never-empty runtime model stack beside immutable lexical model bindings, exposes push/pop/query operations to specifications, and refuses the final pop with precise diagnostics rather than creating an undefined model cursor.

| Section | Topics | Status |
|---------|--------|--------|
| [Lexical binding versus runtime cursor](../sections/literate-ai--docs-decisions-0018-never-empty-per-agent-model-stack--lexical-binding-versus-runtime-cursor.md) | agentic-sdlc | current |
| [Context-local stack ownership](../sections/literate-ai--docs-decisions-0018-never-empty-per-agent-model-stack--context-local-stack-ownership.md) | agentic-sdlc | current |
| [Never-empty session frame](../sections/literate-ai--docs-decisions-0018-never-empty-per-agent-model-stack--never-empty-session-frame.md) | agentic-sdlc | current |
| [Scoped push and pop](../sections/literate-ai--docs-decisions-0018-never-empty-per-agent-model-stack--scoped-push-and-pop.md) | agentic-sdlc | current |
| [Specification-language operations](../sections/literate-ai--docs-decisions-0018-never-empty-per-agent-model-stack--specification-language-operations.md) | agentic-sdlc, repository-governance | current |
| [Refused final-pop diagnostics](../sections/literate-ai--docs-decisions-0018-never-empty-per-agent-model-stack--refused-final-pop-diagnostics.md) | agentic-sdlc, testing | current |
| [Rejected stack semantics](../sections/literate-ai--docs-decisions-0018-never-empty-per-agent-model-stack--rejected-stack-semantics.md) | agentic-sdlc | current |
| [Product consequences](../sections/literate-ai--docs-decisions-0018-never-empty-per-agent-model-stack--product-consequences.md) | agentic-sdlc, repository-governance | current |
| [Acceptance tests and release evidence](../sections/literate-ai--docs-decisions-0018-never-empty-per-agent-model-stack--acceptance-tests-and-release-evidence.md) | agentic-sdlc, testing | current |
