---
id: langchain
aliases: [LangChain, create_agent, LCEL, LangChain Expression Language, Runnable, retriever, RAG, Retrieval-Augmented Generation, Agentic RAG, vector store, embedding model]
topics: [llm-agent-frameworks, content-addressed-storage]
---

# langchain

LangChain is an LLM-application framework built by LangChain Inc. It frames an agent as **model plus harness** and centers on `create_agent(model, tools, system_prompt, ...)`: a minimal, highly configurable harness (prompt, tools, middleware) over a model loop. Its value propositions are a **standard cross-provider model interface** (swap providers with minimal code change), tool calling, **retrieval / RAG** (a modular pipeline of loaders, splitters, embedding models, vector stores, and retrievers, with 2-Step, Agentic, and Hybrid RAG architectures), short- and long-term memory, and a composable middleware layer. LangChain's agents are built on top of [[langgraph]], inheriting its durable execution, persistence, and human-in-the-loop.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [create_agent harness and standard interfaces](../sections/web--langchain-overview--create-agent-harness-and-standard-interfaces.md) | The model+harness frame, create_agent, and the standard model interface. |
| [retrieval RAG pipeline and architectures](../sections/web--langchain-retrieval--retrieval-rag-pipeline-and-architectures.md) | The retrieval pipeline building blocks and the three RAG architectures. |

## See also

- [[langgraph]] — the orchestration runtime LangChain agents are built on.
