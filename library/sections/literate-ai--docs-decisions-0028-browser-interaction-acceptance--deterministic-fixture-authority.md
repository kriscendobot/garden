---
title: "ADR 0028: Deterministic fixture authority"
source: docs/decisions/0028-browser-interaction-acceptance.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, capability-security, testing]
status: current
---

> Abstract: Browser acceptance uses deterministic stub transports and withholds credentials, fixture values, expected counts, and the private oracle from generation prompts so generated code cannot hardcode its own acceptance answer.

This retains the authority split between producer and verifier. A generator receives
enough public behavior authority to implement the frontend, but the independent oracle
and its private test material remain outside the model-writable input boundary.

Source: [docs/decisions/0028-browser-interaction-acceptance.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0028-browser-interaction-acceptance.md) at commit `fcc40bc6`.
