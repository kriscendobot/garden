---
title: "ADR 0018: Acceptance tests and release evidence"
source: docs/decisions/0018-never-empty-per-agent-model-stack.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, testing]
status: current
---

> Abstract: Acceptance tests must prove post-session non-emptiness, copied-context and thread isolation, source-located final-pop warnings, and converter execution of all four specification operations, while release notes name the stack and warning behavior.

The criteria bind implementation semantics to independently observable evidence: stack
depth cannot reach zero after session start; concurrency cannot leak frames; a refused
pop reports caller and specification locations; and Markdown plus additive JSON
operations actually drive the converter cursor. The release changelog must expose both
the new stack and its last-frame protection.

Source: [docs/decisions/0018-never-empty-per-agent-model-stack.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0018-never-empty-per-agent-model-stack.md) at commit `fcc40bc6`.
