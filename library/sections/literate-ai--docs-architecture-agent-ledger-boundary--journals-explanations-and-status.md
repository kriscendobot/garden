---
title: Prompt journals, customer explanations, and implementation status
source: docs/architecture/agent-ledger-boundary.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc, agent-fleet-orchestration]
status: current
---

> Abstract: The complete prompt journal covers only what is visible at the framework boundary (not provider-hidden instructions or chain of thought), is sensitive forensic evidence governed by ledger and store policy, and is distinct from the derived customer explanation; the join protocol is specified but not yet implemented, and learned experience changes generation authority only through the gated authority learning loop.

"Complete prompt journal" means every prompt, response, tool request, tool result, and decision visible at the Literate AI framework boundary. It does not promise access to a provider's hidden system instructions or private chain of thought. Raw journals can contain source, customer data, secrets, or security findings, so retention, encryption, redaction, and access control belong to ledger and artifact-store policy.

The normal customer artifact is a derived explanation: requirements and target choices, important recorded decisions, exact skills and models, generated outputs, tests, approvals, and exceptions. The sealed raw journal is forensic evidence, not the default user interface.

**Current status.** The document fixes the boundary but does not claim the join protocol is implemented. Literate AI records many input and result identities today, while some coding-CLI request files and bounded process streams are transient. A durable injected journal sink, a portable run-envelope schema, and retained canonical input blobs are required before claiming complete enterprise derivation replay or audit.

Retained experience becomes reusable project behavior only through the separately gated authority learning loop (`docs/architecture/authority-learning-loop.md`); neither a ledger entry nor a candidate repair may silently change future generation authority.

Source: [docs/architecture/agent-ledger-boundary.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/agent-ledger-boundary.md) at commit `fcc40bc`.
