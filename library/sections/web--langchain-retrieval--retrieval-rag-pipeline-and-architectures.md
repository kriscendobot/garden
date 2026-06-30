---
title: "LangChain retrieval: the RAG pipeline and three RAG architectures"
source_kind: web
source_url: https://docs.langchain.com/oss/python/langchain/retrieval
source_content_sha256: 838d73fc2464f45c1f7ad822c2e686d514981434465d7fb9b09b64777d37d24b
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
topics: [llm-agent-frameworks, content-addressed-storage]
status: current
notes: "Living vendor docs (docs.langchain.com). Idempotency anchor is source_content_sha256 over the `.md` rendering."
---

Abstract: Retrieval addresses two LLM limitations, finite context and static (frozen) training knowledge, by fetching relevant external knowledge at query time; this is the foundation of Retrieval-Augmented Generation (RAG). LangChain models retrieval as a **modular pipeline** of swappable building blocks (document loaders, text splitters, embedding models, vector stores, retrievers) and offers three named RAG architectures that trade control against flexibility: 2-Step RAG (retrieve-then-generate, high control, low flexibility, fast), Agentic RAG (the LLM decides when and how to retrieve, low control, high flexibility, variable latency), and Hybrid (validation steps, medium on both axes).

## From retrieval to RAG

Retrieval lets LLMs access relevant context at runtime; RAG integrates retrieval with generation to produce grounded, context-aware answers. A knowledge base is a repository of documents or structured data used during retrieval. An existing knowledge base (a SQL database, CRM, internal docs) need not be rebuilt: it can be connected as a **tool** for an agent (Agentic RAG) or queried and supplied as context (2-Step RAG).

## The retrieval pipeline

A typical workflow: Sources -> Document Loaders -> Documents -> Split into chunks -> Turn into embeddings -> Vector Store; and at query time: User Query -> Query embedding -> Vector Store -> Retriever -> LLM uses retrieved info -> Answer. Each component is modular: loaders, splitters, embeddings, or vector stores can be swapped without rewriting the application logic.

Building blocks:

- **Document loaders** ingest data from external sources, returning standardized `Document` objects.
- **Text splitters** break large docs into smaller chunks that are retrievable individually and fit within a model's context window.
- **Embedding models** turn text into a vector so texts with similar meaning land close together in vector space.
- **Vector stores** are specialized databases for storing and searching embeddings.
- **Retrievers** are an interface that returns documents given an unstructured query.

## RAG architectures

| Architecture | Description | Control | Flexibility | Latency |
|---|---|---|---|---|
| **2-Step RAG** | Retrieval always happens before generation. Simple and predictable. | High | Low | Fast |
| **Agentic RAG** | An LLM-powered agent decides *when* and *how* to retrieve during reasoning. | Low | High | Variable |
| **Hybrid** | Combines both with validation steps. | Medium | Medium | Variable |

In 2-Step RAG the retrieval step always runs before generation, capping the number of LLM calls and making latency predictable. In Agentic RAG the only thing needed to enable retrieval is giving the agent access to one or more tools that fetch external knowledge; the agent reasons step by step and decides when to retrieve.

Source: [LangChain retrieval](https://docs.langchain.com/oss/python/langchain/retrieval) retrieved 2026-06-30, content hash `838d73fc`.
