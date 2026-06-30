---
title: "LangChain tools: defining tools and their schemas"
source_kind: web
source_url: https://docs.langchain.com/oss/python/langchain/tools
source_content_sha256: a40a0dad0d7db34773b41d18074eec8e6f33c66305ab16b346e6df3679c10174
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
topics: [llm-agent-frameworks, agent-conventions]
status: current
notes: "Living vendor docs (docs.langchain.com, Mintlify). Idempotency anchor is source_content_sha256 over the page's `.md` rendering, not a git SHA. Re-fetch the `.md` form to re-check freshness."
---

Abstract: Tools extend what an agent can do — fetch real-time data, execute code, query databases, take actions — and under the hood are callable functions with well-defined inputs and outputs passed to a chat model, which decides when to invoke them and with what arguments. The simplest definition is the `@tool` decorator, where the function's docstring becomes the model-facing description and **type hints are required** because they define the tool's input schema (so the docstring should be informative and concise). Tool name and description default from the function but can be overridden for clearer model guidance; complex inputs are defined with Pydantic models or JSON schemas. Certain parameter names are **reserved** (`config`, `runtime`) and cannot be used as tool arguments — runtime information is reached through the `ToolRuntime` parameter instead.

## Create tools

### Basic tool definition

The simplest way to create a tool is the `@tool` decorator. By default, the function's docstring becomes the tool's description, which helps the model understand when to use it. **Type hints are required** as they define the tool's input schema. The docstring should be informative and concise to help the model understand the tool's purpose.

```python
from langchain.tools import tool

@tool
def search(query: str) -> str:
    """Search for information."""
    return f"Results for: {query}"
```

### Customize tool properties

- **Custom tool name.** By default the tool name comes from the function name; override it when you need something more descriptive.
- **Custom tool description.** Override the auto-generated description for clearer model guidance.

### Advanced schema definition

Define complex inputs with Pydantic models or JSON schemas.

### Reserved argument names

The parameter names `config` and `runtime` are **reserved** and cannot be used as tool arguments — using them causes runtime errors. To access runtime information, use the `ToolRuntime` parameter instead of naming your own arguments `config` or `runtime`. (If you use older injection patterns — `InjectedState`, `InjectedStore`, `get_runtime()`, `InjectedToolCallId` — see the page's migration note.)

Source: [LangChain tools](https://docs.langchain.com/oss/python/langchain/tools) retrieved 2026-06-30, content hash `a40a0dad`.
