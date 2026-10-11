---
title: "ADR 0044: Worker-side source indexing and the production index port"
source: docs/decisions/0044-action-dag-and-shared-cache.md
source_repo: jordanhubbard/literate-ai
source_commit: 2820f8535116c5bc0056232d7251e178f02016d1
source_date: 2026-10-01
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, content-addressed-storage]
status: current
---

> Abstract: `literate_ai.action_worker` materializes CAS-verified source into a private workspace to run only the source-index action, optionally fetching blobs from a private HTTPS CAS.

A source-index action keeps the planner's static payload; its accepted generation predecessor supplies the candidate and bounded file manifest of exact `BlobRef` values, bound to the same plan and Component. Source payloads live in the worker's private CAS, not base64 in messages. The receiver binds its own worker identity independently of requests (`LITAI_ACTION_WORKER_IDENTITY`), verifies tree identity, paths, and limits (100,000 files, 256 MiB) before materialization, copies each blob through the streaming CAS verifier into a disposable workspace, checks the deadline throughout, and removes custody after success or refusal. A successful index result grants neither build authorization nor acceptance. The initial receiver is `python -m literate_ai.action_worker` reading the request from stdin.

The receiver may fetch manifest-declared missing blobs from an operator-bound HTTP(S) CAS (`--source-cas-url`, `--source-token-env`, `--allow-http`): HTTPS by default, GET only, redirects and encoded responses refused, exact size and SHA-256 verified before publishing, corrupt local blobs refused rather than repaired, and a named token that fails to resolve never falls back to anonymous. The command indexer implements `GenerationIndexer.index(component, source)`, snapshotting bounded portable source files and verifying the full candidate tree before CAS publication; its evidence must equal the disabled-index policy's canonical result, and CLI routing plus non-index phases remain separate obligations.

Source: [docs/decisions/0044-action-dag-and-shared-cache.md](https://github.com/jordanhubbard/literate-ai/blob/2820f8535116c5bc0056232d7251e178f02016d1/docs/decisions/0044-action-dag-and-shared-cache.md) at commit 2820f853.
