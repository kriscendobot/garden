---
title: "LangChain structured output: response_format and the provider/tool strategies"
source_kind: web
source_url: https://docs.langchain.com/oss/python/langchain/structured-output
source_content_sha256: de77c57a14a983fe045f403b1320e28a8ef1c5ae5c3f3c14ba22a2583f40dd6f
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
topics: [llm-agent-frameworks, agent-conventions]
status: current
notes: "Living vendor docs (docs.langchain.com, Mintlify). Idempotency anchor is source_content_sha256 over the page's `.md` rendering, not a git SHA. Part of the LangChain/LangGraph remainder-ingest batch 2 (2026-06-30)."
---

Abstract: Structured output makes an agent return data in a specific, predictable format — a JSON object, Pydantic model, dataclass, or TypedDict your application uses directly — instead of natural-language text you must parse. `create_agent` handles it automatically through the `response_format` parameter: you supply the desired schema, and when the model generates the structured data it is captured, validated, and returned in the `structured_response` key of the agent's final state. There are two strategies. `ProviderStrategy` uses a provider's **native** structured-output API (OpenAI, Anthropic, xAI, Gemini) — the most reliable method when available, because the provider enforces the schema. `ToolStrategy` uses **tool calling** to achieve the same result and works with any tool-calling model. Passing a bare schema type lets LangChain auto-select: `ProviderStrategy` if the model supports native structured output (read from its profile data on `langchain>=1.1`), else `ToolStrategy`.

## Response format

`response_format` accepts a `ToolStrategy[T]`, a `ProviderStrategy[T]`, a bare schema `type[T]` (auto-select), or `None` (not requested). When a bare schema type is passed, LangChain chooses `ProviderStrategy` for models with native support and `ToolStrategy` otherwise. The result is returned in `structured_response`.

## Provider strategy

Some providers support structured output natively through their APIs; this is the most reliable method. Configure a `ProviderStrategy(schema, strict=None)`:

- **`schema`** (required) — Pydantic model (returns a validated instance), dataclass / TypedDict / JSON Schema (returns a dict).
- **`strict`** (requires `langchain>=1.2`) — enable strict schema adherence where the provider supports it (e.g. OpenAI, xAI). Defaults to `None`.

LangChain auto-uses `ProviderStrategy` when a schema type is passed directly and the model supports it — so `response_format=ContactInfo` is functionally equivalent to `response_format=ProviderStrategy(ContactInfo)`, and either falls back to a tool-calling strategy if native support is absent.

```python
class ContactInfo(BaseModel):
    name: str = Field(description="The name of the person")
    email: str = Field(description="The email address of the person")

agent = create_agent(model="gpt-5.5", response_format=ContactInfo)  # auto-selects ProviderStrategy
result = agent.invoke({"messages": [{"role": "user", "content": "Extract: John Doe, john@example.com"}]})
result["structured_response"]  # ContactInfo(name='John Doe', email='john@example.com')
```

If native support is read dynamically and data are unavailable, you can force it via a custom model profile (`init_chat_model("...", profile={"structured_output": True, ...})`). When tools are also specified, the model must support simultaneous tool use and structured output.

## Tool calling strategy

For models without native structured output, LangChain uses tool calling. Configure a `ToolStrategy(schema, tool_message_content=None, handle_errors=True)`:

- **`schema`** (required) — as above, plus **`Union` types** (multiple schema options; the model picks the most appropriate based on context).
- **`tool_message_content`** — custom content for the tool message recorded when structured output is generated (defaults to a message showing the response data).
- **`handle_errors`** — the retry/error-handling strategy (covered in the companion section).

```python
agent = create_agent(model="gpt-5.5", tools=tools,
                     response_format=ToolStrategy(Union[ProductReview, CustomerComplaint]))
```

Source: [LangChain structured output](https://docs.langchain.com/oss/python/langchain/structured-output) retrieved 2026-06-30, content hash `de77c57a`.
