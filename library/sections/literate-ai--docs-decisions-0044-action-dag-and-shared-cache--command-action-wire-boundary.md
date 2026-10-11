---
title: "ADR 0044: Command action wire boundary"
source: docs/decisions/0044-action-dag-and-shared-cache.md
source_repo: jordanhubbard/literate-ai
source_commit: 2820f8535116c5bc0056232d7251e178f02016d1
source_date: 2026-10-01
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, capability-security]
status: current
---

> Abstract: `lifecycle-action-wire@1` carries exact, hash-verified, size- and deadline-bounded action requests to a private command argv whose responses are rebound and rehashed.

The command-action adapter uses `lifecycle-action-wire@1`, separate from the whole-lifecycle dispatcher protocol. Requests embed the exact action, admitted worker/catalog/observation, slot, ordered predecessor results, and an absolute deadline whose identity enters the request; payload and predecessor records cross as verified SHA-256 bytes, and missing, extra, duplicate, corrupt, foreign, or changed records refuse execution. Limits: 4,096 input records, 16 MiB of record bytes, 24 MiB encoded, and a current deadline within one day.

The adapter invokes only the selected private command argv via stdin or the `{request_file}` placeholder with explicitly bound environment variables; a shared bounded pipe runner drains both streams concurrently, enforces byte and time limits, and terminates the owned process tree. Responses bind the exact request and worker, result bytes are rehashed, and stderr never becomes a failure message. Subprocess fixtures prove protocol custody and two-worker overlap but not production phase execution, remote cleanup, SSH actuation, CLI routing, or transitive artifact transfer, which remain under RELEASE-INTEGRATION-003; a legacy command worker is not phase-capable merely by being in the catalog.

Source: [docs/decisions/0044-action-dag-and-shared-cache.md](https://github.com/jordanhubbard/literate-ai/blob/2820f8535116c5bc0056232d7251e178f02016d1/docs/decisions/0044-action-dag-and-shared-cache.md) at commit 2820f853.
