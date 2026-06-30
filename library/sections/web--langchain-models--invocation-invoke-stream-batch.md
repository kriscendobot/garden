---
title: "LangChain models: invocation — invoke, stream, batch"
source_kind: web
source_url: https://docs.langchain.com/oss/python/langchain/models
source_content_sha256: a17630c0272faed4aa0d4e1d10f7641d0cb3f2457c537516c15e953bc6bc81d3
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
topics: [llm-agent-frameworks]
status: current
notes: "Living vendor docs (docs.langchain.com, Mintlify). Idempotency anchor is source_content_sha256 over the page's `.md` rendering, not a git SHA. Re-fetch the `.md` form to re-check freshness."
---

Abstract: A chat model must be invoked to generate output, and LangChain offers three primary invocation methods. **`invoke()`** takes a single message or a list of messages (a list represents conversation history, each message carrying a role) and returns one `AIMessage` after generation completes. **`stream()`** returns an iterator that yields `AIMessageChunk` objects as they are produced — each chunk holds a portion of the output text, and chunks are designed to be summed back into a full message that can be treated exactly like an `invoke()` result. **`batch()`** runs a collection of independent requests in parallel to improve performance and reduce cost (distinct from provider batch APIs like OpenAI's or Anthropic's); by default it returns only the final outputs, while `batch_as_completed()` streams each individual result as it finishes.

## Invoke

The most straightforward way to call a model is `invoke()` with a single message or a list of messages. A list of messages represents conversation history; each message has a role that models use to indicate who sent it. (See the *messages* guide for roles, types, and content.) `invoke()` returns a single `AIMessage` after the model has finished generating its full response.

## Stream

Most models can stream their output content while it is being generated; displaying output progressively improves user experience for longer responses. `stream()` returns an iterator that yields output chunks as they are produced; process each chunk in a loop in real time.

Unlike `invoke()`, which returns a single `AIMessage`, `stream()` returns multiple `AIMessageChunk` objects, each containing a portion of the output text. Each chunk in a stream is designed to be gathered into a full message via summation, and the resulting message can be treated the same as an `invoke()` result — for example, aggregated into a message history and passed back to the model as conversational context.

## Batch

Batching a collection of independent requests can significantly improve performance and reduce costs, as processing is done in parallel. This LangChain-level batching is **distinct** from the batch APIs supported by inference providers (OpenAI, Anthropic). By default `batch()` returns only the final output for the entire batch; to receive each individual output as it finishes generating, stream results with `batch_as_completed()`.

Source: [LangChain models](https://docs.langchain.com/oss/python/langchain/models) retrieved 2026-06-30, content hash `a17630c0`.
