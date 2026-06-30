---
id: langchain
aliases: [LangChain, create_agent, harness, middleware, LCEL, LangChain Expression Language, Runnable, retriever, RAG, Retrieval-Augmented Generation, Agentic RAG, vector store, embedding model, init_chat_model, bind_tools, response_format, structured output, tool calling, ToolRuntime, model profile, dynamic tool selection, headless tools, return_direct, messages, SystemMessage, HumanMessage, AIMessage, ToolMessage, content blocks, multimodal, short-term memory, long-term memory, AgentState, SummarizationMiddleware, ProviderStrategy, ToolStrategy, structured_response, handle_errors]
topics: [llm-agent-frameworks, content-addressed-storage]
---

# langchain

LangChain is an LLM-application framework built by LangChain Inc. It frames an agent as **model plus harness** and centers on `create_agent(model, tools, system_prompt, ...)`: a minimal, highly configurable harness (prompt, tools, middleware) over a model loop. Its value propositions are a **standard cross-provider model interface** (`init_chat_model`, swap providers with minimal code change), tool calling (`bind_tools`), **structured output** (`response_format` with `ProviderStrategy` native vs `ToolStrategy` tool-calling, returned in the `structured_response` state key), **retrieval / RAG** (a modular pipeline of loaders, splitters, embedding models, vector stores, and retrievers, with 2-Step, Agentic, and Hybrid RAG architectures), short- and long-term **memory**, and a composable **middleware** layer (the harness's support areas: execution environment, context management, planning/delegation, fault tolerance, guardrails, steering). **Messages** are the unit of model context — a standard cross-provider type (`SystemMessage` / `HumanMessage` / `AIMessage` / `ToolMessage`) with a loosely-typed `content` plus a lazily-parsed standard `content_blocks` view for text, reasoning, and multimodal data. **Short-term memory** is thread-scoped conversation history persisted by a checkpointer (managed in the agent's `AgentState`), with trim/delete/summarize patterns for the context window; **long-term memory** is cross-thread data in a [[langgraph-store]], reached from tools via `runtime.store`. Tools are `@tool`-decorated callables whose return value (string, object, multimodal, `Command`, `return_direct`) shapes the loop. LangChain's agents are built on top of [[langgraph]], inheriting its durable execution, persistence, and human-in-the-loop.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [create_agent harness and standard interfaces](../sections/web--langchain-overview--create-agent-harness-and-standard-interfaces.md) | The model+harness frame, create_agent, and the standard model interface. |
| [the agent loop and core components](../sections/web--langchain-agents--agent-loop-and-core-components.md) | The agent loop and the four core components (model, tools, prompt, structured output). |
| [agent invocation, runtime context, and streaming](../sections/web--langchain-agents--invocation-streaming-and-state.md) | Invoking against the LangGraph State, thread persistence, runtime context, streaming. |
| [configuring the harness via middleware](../sections/web--langchain-agents--configure-the-harness-via-middleware.md) | The middleware catalog that extends the harness. |
| [retrieval RAG pipeline and architectures](../sections/web--langchain-retrieval--retrieval-rag-pipeline-and-architectures.md) | The retrieval pipeline building blocks and the three RAG architectures. |
| [models: standard interface and initialization](../sections/web--langchain-models--standard-interface-and-initialization.md) | Models as reasoning engine, the standard interface, init_chat_model, resilience. |
| [models: invocation — invoke, stream, batch](../sections/web--langchain-models--invocation-invoke-stream-batch.md) | The three invocation methods and AIMessageChunk summation. |
| [models: tool calling and structured output](../sections/web--langchain-models--tool-calling-and-structured-output.md) | bind_tools, tool_choice, and the three structured-output methods. |
| [models: advanced topics](../sections/web--langchain-models--advanced-profiles-multimodal-reasoning-caching.md) | Profiles, multimodal, reasoning, caching, dynamic model selection. |
| [tools: defining tools and schemas](../sections/web--langchain-tools--defining-tools-and-schemas.md) | The @tool decorator, required type-hint schemas, reserved argument names. |
| [tools: accessing context via ToolRuntime](../sections/web--langchain-tools--accessing-context-via-toolruntime.md) | State, context, store, stream writer, execution info, server info. |
| [tools: execution and return values](../sections/web--langchain-tools--execution-and-return-values.md) | Return string/object/multimodal/Command/return_direct; error handling via middleware. |
| [tools: dynamic selection, headless, prebuilt](../sections/web--langchain-tools--dynamic-selection-headless-and-prebuilt.md) | Runtime toolset shaping; client-side headless tools; prebuilt tools. |
| [messages: message types and roles](../sections/web--langchain-messages--message-types-and-roles.md) | System/Human/AI/Tool messages, input formats, AIMessage attributes, tool calls. |
| [messages: content blocks and multimodal](../sections/web--langchain-messages--content-blocks-and-multimodal.md) | Standard cross-provider content blocks; multimodal image/audio/video/file blocks. |
| [short-term memory: thread persistence via the checkpointer](../sections/web--langchain-short-term-memory--checkpointer-thread-persistence.md) | Thread-scoped history via a checkpointer; AgentState; production backends. |
| [short-term memory: context-window management and state access](../sections/web--langchain-short-term-memory--context-management-and-state-access.md) | Trim/delete/summarize patterns; reading/writing state from tools and middleware. |
| [long-term memory: the cross-thread store and tool access](../sections/web--langchain-long-term-memory--cross-thread-store-and-tool-access.md) | Cross-thread memory on the LangGraph store; read/write via runtime.store. |
| [structured output: response_format and the strategies](../sections/web--langchain-structured-output--response-format-and-strategies.md) | response_format; ProviderStrategy vs ToolStrategy; auto-selection; structured_response. |
| [structured output: ToolStrategy error handling and retries](../sections/web--langchain-structured-output--tool-strategy-error-handling.md) | Multiple-output and validation errors; the six handle_errors shapes; retries. |

## See also

- [[langgraph]] — the orchestration runtime LangChain agents are built on.
- [[langgraph-store]] — the long-term cross-thread store that backs LangChain long-term memory.
- [[langgraph-checkpointer]] — the persistence mechanism behind short-term (thread-scoped) memory.
- [[human-in-the-loop]] — the steering capability (`HumanInTheLoopMiddleware`) LangChain inherits from LangGraph.
- [[multi-agent-handoff]] — state-driven control transfer between LangChain agents.
