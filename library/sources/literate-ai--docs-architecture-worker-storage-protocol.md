---
source: docs/architecture/worker-storage-protocol.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
section_count: 6
status: current
content_caveat: "foreign-content gate classified (jev-1.13.0): disposition proceed, injection 0.09 clean, slant neutral 1.0; fetched raw content sha256 4a9079bb"
---

> Abstract: This architecture document specifies how Literate AI observes execution-worker storage under ADR 0043: a private, digest-bound request/response protocol to an exact worker's receiver, watchdog-enforced deadlines, independent per-domain byte and inode quotas, a one-shot `litai worker health` inspection with optional sustained-pressure and alert-history layers, job-bound admission and polling, and a read-only cleanup investigation whose apply step needs separate exact authorization. Observations are evidence only; they never authorize execution, allocation, or deletion.

| Section | Topics | Status |
|---------|--------|--------|
| [Receiver selection and request protocol](../sections/literate-ai--docs-architecture-worker-storage-protocol--receiver-selection-and-request-protocol.md) | agentic-sdlc, process-monitoring | current |
| [Deadlines and failures](../sections/literate-ai--docs-architecture-worker-storage-protocol--deadlines-and-failures.md) | agentic-sdlc, process-monitoring | current |
| [Independent quota domains](../sections/literate-ai--docs-architecture-worker-storage-protocol--independent-quota-domains.md) | agentic-sdlc, process-monitoring | current |
| [Public storage inspection](../sections/literate-ai--docs-architecture-worker-storage-protocol--public-storage-inspection.md) | agentic-sdlc, process-monitoring | current |
| [Explicit alert history](../sections/literate-ai--docs-architecture-worker-storage-protocol--explicit-alert-history.md) | agentic-sdlc, process-monitoring | current |
| [Workflow admission, polling, and cleanup](../sections/literate-ai--docs-architecture-worker-storage-protocol--admission-polling-and-cleanup.md) | agentic-sdlc, process-monitoring | current |
