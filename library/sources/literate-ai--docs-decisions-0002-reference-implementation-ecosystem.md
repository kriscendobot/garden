---
source: docs/decisions/0002-reference-implementation-ecosystem.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
section_count: 3
status: current
content_caveat: "foreign-content gate classified (jev-1.13.0): disposition proceed_with_caveat, injection 0.09 clean, slant neutral at low confidence 0.32 (slant classification uncertain); fetched raw content sha256 c1ae4745"
---

> Abstract: Literate AI's second architecture decision record (2026-08-02, amended for CycloneDX validation) makes the reference kernel a Python 3.11+ distribution with exactly one pinned runtime dependency (`cyclonedx-python-lib` with strict JSON validation) behind the dependency adapter, confines the OpenSpec CLI's npm tree to private contributor tooling under `tools/openspec/`, keeps schemas language-neutral, and sets an explicit evidence checklist for admitting any future runtime dependency.

| Section | Topics | Status |
|---------|--------|--------|
| [Context and decision](../sections/literate-ai--docs-decisions-0002-reference-implementation-ecosystem--context-and-decision.md) | agentic-sdlc, software-supply-chain | current |
| [Dependency admission policy](../sections/literate-ai--docs-decisions-0002-reference-implementation-ecosystem--dependency-admission-policy.md) | agentic-sdlc, software-supply-chain | current |
| [Consequences and validation](../sections/literate-ai--docs-decisions-0002-reference-implementation-ecosystem--consequences-and-validation.md) | agentic-sdlc, software-supply-chain | current |
