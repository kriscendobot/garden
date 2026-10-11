---
source: docs/decisions/0023-mutagenic-cli-channel-fan-out.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
section_count: 5
status: current
content_caveat: "foreign-content gate classified (jev-1.13.0): disposition proceed, injection 0.07 clean, slant neutral at confidence 0.97; fetched raw content sha256 3278d1cb"
---

> Abstract: Literate AI ADR 0023 classifies state-changing CLI events, journals and fans them out through operator-selected channels without rolling back successful work, associates releases with durable Jira context, and admits authenticated inbound Outlook requests only through the work queue.

| Section | Topics | Status |
|---------|--------|--------|
| [Institutional event context](../sections/literate-ai--docs-decisions-0023-mutagenic-cli-channel-fan-out--institutional-event-context.md) | agentic-sdlc, capability-mediated-integrations | current |
| [Mutagenic classification and journal](../sections/literate-ai--docs-decisions-0023-mutagenic-cli-channel-fan-out--mutagenic-classification-and-journal.md) | agentic-sdlc, repository-governance | current |
| [Jira association policy](../sections/literate-ai--docs-decisions-0023-mutagenic-cli-channel-fan-out--jira-association-policy.md) | agentic-sdlc, capability-mediated-integrations, repository-governance | current |
| [Inbound Outlook authority](../sections/literate-ai--docs-decisions-0023-mutagenic-cli-channel-fan-out--inbound-outlook-authority.md) | agentic-sdlc, capability-mediated-integrations, repository-governance | current |
| [Alternatives, consequences, and tests](../sections/literate-ai--docs-decisions-0023-mutagenic-cli-channel-fan-out--alternatives-consequences-and-tests.md) | agentic-sdlc, testing | current |
