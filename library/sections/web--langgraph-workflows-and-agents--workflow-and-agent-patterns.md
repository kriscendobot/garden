---
title: "LangGraph workflow and agent patterns"
source_kind: web
source_url: https://docs.langchain.com/oss/python/langgraph/workflows-agents
source_content_sha256: 9ac54d3c0df92a047a95df22ff273ecc15e7df64e19bf0c38d71a6d99c3d60c7
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
topics: [llm-agent-frameworks, patterns]
status: current
notes: "Living vendor docs (docs.langchain.com). Idempotency anchor is source_content_sha256 over the `.md` rendering."
---

Abstract: LangGraph distinguishes **workflows** (predetermined code paths in a fixed order) from **agents** (dynamic systems that define their own process and tool usage), and catalogs both as composable patterns over an "augmented LLM" (an LLM augmented with structured output, tool calling, and short-term memory). The workflow patterns are prompt chaining (decompose into sequential steps), parallelization (run independent calls concurrently and aggregate), routing (classify input, dispatch to a specialized path), orchestrator-worker (a lead node dynamically spawns workers, often via the `Send` API, and synthesizes), and evaluator-optimizer (a generator-evaluator loop that iterates until a quality bar). An agent is an LLM running a continuous feedback loop over a defined toolset, used when problems and solutions are unpredictable.

## Workflows vs agents

- **Workflows** have predetermined code paths and operate in a certain order.
- **Agents** are dynamic: they define their own processes and tool usage.

Both are built on LLMs and their augmentations. The "augmented LLM" is an LLM equipped with structured output (a schema for its response), tool calling, and short-term memory; tool calling and structured outputs are the building blocks the patterns compose.

## Workflow patterns

- **Prompt chaining**: decompose a task into a fixed sequence of LLM calls where each step processes the previous output; optional programmatic "gate" checks between steps.
- **Parallelization**: run independent LLM calls concurrently and aggregate their outputs (sectioning a task, or running the same task multiple times for voting).
- **Routing**: classify an input and direct it to a specialized follow-on path, separating concerns and letting each path be tuned independently.
- **Orchestrator-worker**: a central orchestrator LLM dynamically breaks a task into subtasks and delegates each to a worker, then synthesizes the results. The number of subtasks is not known ahead of time, so workers are typically spawned with the `Send` API (one worker per generated subtask, each writing a section of the output).
- **Evaluator-optimizer**: one LLM generates a response while another evaluates it in a loop, iterating until the evaluator's quality criteria are met; effective when there are clear evaluation criteria and iterative refinement adds value.

## Agents

Agents are typically an LLM performing actions using tools, operating in continuous feedback loops, used when problems and solutions are unpredictable. They have more autonomy than workflows and decide which tools to use and how to solve a problem; you still define the available toolset and behavioral guidelines. The prebuilt `ToolNode` runs the tools an LLM requested. LangGraph applies its persistence, streaming, debugging, and deployment benefits uniformly to both workflows and agents.

Source: [Workflows and agents](https://docs.langchain.com/oss/python/langgraph/workflows-agents) retrieved 2026-06-30, content hash `9ac54d3c`.
