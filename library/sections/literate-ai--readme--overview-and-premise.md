---
title: Overview and premise
source: README.md
source_repo: jordanhubbard/literate-ai
source_commit: 76f498a824f74ec94ee7d03500913025579fb15f
source_date: 2026-10-04
source_authors: [jkh]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc]
status: current
---

> Abstract: Literate AI presents itself as a release-engineering and software-development-lifecycle harness for specification-led software: it can create a repository or adopt an existing one, while treating specifications and other pinned authoring inputs as authority and generated source as disposable output.

The project applies the literate-programming idea to agent-generated software: a human-readable explanation and acceptance contract should remain traceable to an executable implementation. Its durable product is the harness that decides whether a generated or adopted tree is valid, rather than any particular model's ability to write production code.

Its unit of composition is a Component. Components can depend on other spec-driven Components or pinned repository sources and can be nested without flattening all implementation detail into one model context. New and adopted repositories enter the same development workflow, evidence, and release protocol.

Source: [README.md](https://github.com/jordanhubbard/literate-ai/blob/76f498a824f74ec94ee7d03500913025579fb15f/README.md) at commit `76f498a`.
