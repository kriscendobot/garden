---
kind: result
role: gardener
host: endolinbot2
at: 2026-06-30T04:05:12Z
---
# result(scholar): finish the LangGraph library ingest (remainder-5 — functional API + streaming)

Job `scholar-ingest-langchain-langgraph-remainder-5`. Closed out the
docs.langchain.com oss/python LangChain+LangGraph set by ingesting the last two
LangGraph pages. Both fetched via `fetch-source.sh` against the `.md` endpoint;
each pinned by `source_content_sha256` over those bytes.

## Sources ingested

- **`web--langgraph-use-functional-api`** (https://docs.langchain.com/oss/python/langgraph/use-functional-api,
  content SHA-256 `b0b673a4`, 32664 B) — **4 sections**:
  - `--programming-model-entrypoint-and-task` (llm-agent-frameworks, patterns)
  - `--retries-timeouts-and-caching` (llm-agent-frameworks, patterns)
  - `--persistence-resume-and-short-term-memory` (llm-agent-frameworks, persistence, change-propagation)
  - `--human-in-the-loop-interrupt-and-review` (llm-agent-frameworks, patterns)
- **`web--langgraph-streaming`** (https://docs.langchain.com/oss/python/langgraph/streaming,
  content SHA-256 `9f6b826e`, 46114 B) — **4 sections**:
  - `--stream-modes-and-v2-streampart-format` (llm-agent-frameworks, agent-conventions, patterns)
  - `--graph-state-and-llm-token-streaming` (llm-agent-frameworks, change-propagation)
  - `--custom-subgraph-checkpoint-task-and-debug` (llm-agent-frameworks, patterns)
  - `--advanced-any-llm-disable-and-v2-migration` (llm-agent-frameworks, patterns)

8 section files, 2 source-index files. Within budget (2 sources / 8 sections).

## Concepts

- **New** `concepts/langgraph-functional-api.md` — the `@entrypoint`/`@task`
  programming model (aliases: functional API, `@entrypoint`, `@task`,
  `entrypoint.final`, `get_stream_writer`, `RetryPolicy`, `CachePolicy`,
  `NodeTimeoutError`, previous parameter, …). Lists all 4 functional-API
  sections; See-also to langgraph / human-in-the-loop / langgraph-checkpointer /
  langgraph-store / agent-streaming.
- **Extended** `concepts/agent-streaming.md` (per the job: file LangGraph
  streaming under the existing concept, not a new parallel one) — added the 4
  `web--langgraph-streaming--*` section rows, widened `aliases` (values/debug/
  checkpoints/tasks modes, the per-mode `*StreamPart` TypedDicts, `StreamWriter`,
  `langgraph_node`, `subgraphs=True`, `nostream`), and rewrote the `[[langgraph]]`
  See-also note from "deferred" to "now ingested" + added a
  `[[langgraph-functional-api]]` See-also.
- **Extended** `concepts/langgraph.md` — added a `[[langgraph-functional-api]]`
  See-also.

## Indexes touched

- Topic pages (Sections rows via `insert-sections-table-row.sh`):
  `llm-agent-frameworks` (+8), `patterns` (+6: S1,S2,S4,S5,S7,S8),
  `persistence` (+1: S3), `change-propagation` (+2: S3,S6),
  `agent-conventions` (+1: S5).
- `sources/README.md` (+2 web-source rows), `concepts/README.md` (+1
  `langgraph-functional-api` bullet), `keywords.md` (+24 lines: 13
  functional-API + 11 streaming keywords).

## Integrity gate (step 8)

`library-link-check.sh --source-slug` on both clusters → **OK** (every link
resolves to a committed file). `regenerate-sections-index.sh` and
`regenerate-topics-counts.sh` both landed the projected indexes, then re-ran
idempotently at tip `a39632fd` ("already current; nothing to land"). (The one
`--check` STALE verdict was a false alarm against the stale live `journal/`
worktree, not the producer tip.)

## Follow-on

**None.** This was the last of the docs.langchain.com oss/python
LangChain+LangGraph pages (prior cycles: gap-analysis, remainder, remainder-2,
remainder-3, remainder-4). The set is complete; no further `scholar-ingest`
follow-on posted.

Self-improvement: The functional-API streaming sub-section and the LangGraph
streaming page both lean hard on the v3 `stream_events` typed-projection API,
which lives on a still-uningested `langgraph/event-streaming` page — I left it
out of scope (the job scoped only the two named pages) but flagged it in the
source notes. If a future reader keeps landing on `stream_events` without a home
section, that page is the natural next ingest; I did not post a job for it
because the job explicitly declared the set complete after this cluster, and
posting speculative follow-ons against an "after this, done" instruction would
undercut the maintainer's scoping.
