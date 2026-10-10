---
title: Direct versus ledger-driven prompt translation
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

> Abstract: Before the join boundary a direct request may be sharpened by Literate AI's pinned prompt-master skill, while a MAC-originated request arrives already translated by MAC's own prompt-master step; the two paths are never both applied and neither can change locked derivation authority or grant execution privilege.

Before the join boundary, direct and ledger-driven requests take different prompt translation paths. A user invoking Literate AI or a supported coding agent directly may use the pinned `skills/agent/prompt-master/` adapter to sharpen a rough request into a bounded provider task. A MAC-originated request bypasses that adapter: MAC applies its own prompt-master step between the task and provider layers and supplies an already translated task envelope.

Literate AI never applies both paths to one request, and neither path can change locked derivation authority or grant execution privilege.

Source: [docs/architecture/agent-ledger-boundary.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/agent-ledger-boundary.md) at commit `fcc40bc`.
