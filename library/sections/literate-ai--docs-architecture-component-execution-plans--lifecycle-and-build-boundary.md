---
title: Standard lifecycle and typed build boundary
source: docs/architecture/component-execution-plans.md
source_repo: jordanhubbard/literate-ai
source_commit: 2820f8535116c5bc0056232d7251e178f02016d1
source_date: 2026-10-01
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc, testing]
status: current
---

> Abstract: The standard lifecycle keeps source generation, validation, build authorization, build, generated tests, independent acceptance, workspace admission, and release evidence as distinct typed boundaries whose inputs and outputs can be checked independently.

Source generation returns a candidate rather than mutating the project. The outer lifecycle verifies its identity and tree safety, derives a build intent, obtains current authorization, and invokes a typed build port. Generated tests and independent acceptance then gate transactional admission.

Build output is not inferred from a coding agent's narrative. It crosses a typed result boundary with exact artifact and evidence identities. This permits local, SSH, or command workers to vary as adapters while preserving the same lifecycle and custody checks.

Source: [docs/architecture/component-execution-plans.md](https://github.com/jordanhubbard/literate-ai/blob/2820f8535116c5bc0056232d7251e178f02016d1/docs/architecture/component-execution-plans.md) at commit `2820f85`.
