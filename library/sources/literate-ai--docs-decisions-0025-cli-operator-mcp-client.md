---
source: docs/decisions/0025-cli-operator-mcp-client.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
section_count: 5
status: current
content_caveat: "foreign-content gate classified (jev-1.13.0): disposition proceed, injection 0.12 clean, slant neutral at confidence 0.76; fetched raw content sha256 713d2752"
---

> Abstract: Literate AI ADR 0025 lets headless `litai` mutations fan out directly to operator-catalog MCP servers, makes server discovery explicitly opt-in, prevents coding-session skills from reposting CLI events, and keeps operator, project, embedded-application, and WebMCP authority separate.

| Section | Topics | Status |
|---------|--------|--------|
| [Headless institutional-memory gap](../sections/literate-ai--docs-decisions-0025-cli-operator-mcp-client--headless-institutional-memory-gap.md) | agentic-sdlc, capability-mediated-integrations | current |
| [Direct CLI fan-out contract](../sections/literate-ai--docs-decisions-0025-cli-operator-mcp-client--direct-cli-fan-out-contract.md) | agentic-sdlc, capability-mediated-integrations, repository-governance | current |
| [Opt-in MCP discovery](../sections/literate-ai--docs-decisions-0025-cli-operator-mcp-client--opt-in-mcp-discovery.md) | capability-mediated-integrations, repository-governance | current |
| [Skill wrapping and duplicate suppression](../sections/literate-ai--docs-decisions-0025-cli-operator-mcp-client--skill-wrapping-and-duplicate-suppression.md) | agentic-sdlc, capability-mediated-integrations | current |
| [Four MCP seams and testing consequences](../sections/literate-ai--docs-decisions-0025-cli-operator-mcp-client--four-mcp-seams-and-testing-consequences.md) | capability-mediated-integrations, testing, software-supply-chain | current |
