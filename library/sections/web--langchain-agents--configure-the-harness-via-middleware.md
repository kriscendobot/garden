---
title: "LangChain agents: configuring the harness via middleware"
source_kind: web
source_url: https://docs.langchain.com/oss/python/langchain/agents
source_content_sha256: b5c5c292e41a272c72e0e5bbad2536433ccc6fe78c733c6cd7d4c2c3951423fc
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
topics: [llm-agent-frameworks, agent-conventions]
status: current
notes: "Living vendor docs (docs.langchain.com, Mintlify). Idempotency anchor is source_content_sha256 over the page's `.md` rendering, not a git SHA. Re-fetch the `.md` form to re-check freshness."
---

Abstract: Beyond the model/tools/prompt basics, a LangChain agent's harness is extended through **middleware** — common patterns are prebuilt as first-class middleware, and anything else is built as custom middleware. The page organizes the middleware ecosystem into the support areas an agent needs as work grows complex: **execution environment** (a workspace of tools, filesystem, and code execution), **context management** (summarization, persistent memory, on-demand skills to fit a fixed context window), **planning and delegation** (subagents that run in isolated contexts so the main agent stays focused on coordination), **agent naming** (for embedding as a subgraph in multi-agent systems), **fault tolerance** (model/tool retry middleware for rate limits and transient errors), **guardrails** (deterministic policy enforcement such as PII redaction before tool results reach the model), and **steering** (human-in-the-loop pauses at specific decision points). This catalog is the conceptual spine of LangChain's "harness" framing.

## Configure the harness

Common patterns are prebuilt as first-class middleware; you can build anything else as custom middleware. As agents take on complex work, they need support across a few key areas, which the middleware ecosystem provides.

### Execution environment

Agents are especially useful when they can take action rather than just generate text. The execution environment gives the agent a workspace: tools it can call, a filesystem for reading and writing files across turns, and code execution for running scripts or shell commands. (`FilesystemMiddleware`, sandboxes, interpreters.)

### Context management

Every model call has a fixed context window. As an agent runs, that window fills with accumulating history, tool results, and intermediate steps. **Summarization** compresses history before overflow hits; **memory** loads persistent instructions at startup so knowledge carries across sessions; **skills** surface domain knowledge on demand rather than loading everything upfront. (`SummarizationMiddleware`, `MemoryMiddleware`, skills, context engineering.)

### Planning and delegation

Complex tasks often exceed what one context window can handle. **Delegation** lets the main agent break work into pieces, hand them to subagents that each run in their own isolated context, and stay focused on coordination rather than execution. Work can run in parallel; the main agent's context stays clean. (Subagents.)

### Name your agent

Optionally use an identifier for the agent. This is especially useful when embedding the agent as a subgraph in multi-agent systems.

### Fault tolerance

Agents in production encounter failures that rarely appear in development: rate limits, model timeouts, transient API errors. Fault-tolerance middleware handles these at the infrastructure level so tools and business logic do not need try/catch around every call. (`ModelRetryMiddleware`, `ToolRetryMiddleware`.)

### Guardrails

Some policies cannot live in a prompt — they need to be enforced deterministically regardless of what the model does. Guardrails intercept data as it flows through the agent loop, applying compliance rules or content policies before tool results reach the model's context. (`PIIMiddleware`.)

### Steering

Full autonomy is not always appropriate. Steering lets you place humans at specific decision points — before destructive writes, expensive API calls, or anything requiring judgment — without restructuring the agent. The agent pauses and waits; a human approves, edits, or rejects; execution continues. (`HumanInTheLoopMiddleware`; the underlying LangGraph mechanism is the `interrupt()` function.)

Source: [LangChain agents](https://docs.langchain.com/oss/python/langchain/agents) retrieved 2026-06-30, content hash `b5c5c292`.
