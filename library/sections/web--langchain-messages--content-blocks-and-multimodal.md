---
title: "LangChain messages: content blocks and multimodal content"
source_kind: web
source_url: https://docs.langchain.com/oss/python/langchain/messages
source_content_sha256: 1bf3eebc16fcec85a2677fbb2bd4e1972ce0b4218fa19d33bc12fc9a6f59c9b9
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
topics: [llm-agent-frameworks, agent-conventions]
status: current
notes: "Living vendor docs (docs.langchain.com, Mintlify). Idempotency anchor is source_content_sha256 over the page's `.md` rendering, not a git SHA. Part of the LangChain/LangGraph remainder-ingest batch 2 (2026-06-30)."
---

Abstract: A message's `content` is the loosely-typed payload sent to the model — it may be a plain string, a list of provider-native content objects, or a list of LangChain's **standard content blocks**. Standard content blocks are LangChain v1's cross-provider representation: a message exposes a `content_blocks` property that **lazily parses** the raw `content` into a typed, normalized list (so an Anthropic `thinking` block and an OpenAI `reasoning` block both parse into a consistent `ReasoningContentBlock`). Content blocks do not replace `content`; they are an additive, type-safe view, with backward compatibility preserved. Setting `content_blocks` at construction still populates `content`. **Multimodality** — text, images, audio, video, files — is expressed through these blocks, each accepting a `url`, `base64` data (with `mime_type`), or a provider-managed `file_id`.

## Message content

`content` may contain one of three things:

1. A string.
2. A list of content blocks in a **provider-native** format (e.g. OpenAI's `{"type": "image_url", ...}`).
3. A list of **LangChain standard content blocks**.

Specifying `content_blocks` at construction populates `content` while giving a type-safe interface:

```python
human_message = HumanMessage(content_blocks=[
    {"type": "text", "text": "Hello, how are you?"},
    {"type": "image", "url": "https://example.com/image.jpg"},
])
```

### Standard content blocks

The `content_blocks` property lazily parses `content` into a standard, type-safe representation that works across providers. Provider-specific shapes (Anthropic `thinking` with a `signature`; OpenAI `reasoning` with a `summary`) parse into a uniform `ReasoningContentBlock`. To **serialize** standard content into `content` for use outside LangChain, set `LC_OUTPUT_VERSION=v1` or `init_chat_model(..., output_version="v1")`.

### Multimodal

Multimodal data is supplied as content blocks with one of three sources: `url`, `base64` (requires `mime_type`), or a provider-managed `file_id`. Block types: `image`, `file` (PDF and similar), `audio`, `video`. Not all models support all file types, and some providers have extra requirements (OpenAI requires a filename for PDFs); extra keys go top-level or under `"extras": {...}`.

### Content block reference

Each block is a typed dict whose `type` field discriminates it. The catalog:

- **Core:** `TextContentBlock` (`text`, optional `annotations`), `ReasoningContentBlock` (`reasoning`, plus provider `extras` such as a `signature`).
- **Multimodal:** `ImageContentBlock`, `AudioContentBlock`, `VideoContentBlock`, `FileContentBlock` (each with `url` / `base64` / `id` / `mime_type`), and `PlainTextContentBlock` (`type: "text-plain"`, for `.txt` / `.md` document text).
- **Tool calling:** `ToolCall` (`name`, `args`, `id`), `ToolCallChunk` (streaming fragments with an `index` and possibly-incomplete JSON `args`), `InvalidToolCall` (malformed calls, carrying an `error`).
- **Server-side tool execution:** `ServerToolCall`, `ServerToolCallChunk`, `ServerToolResult` (a `status` of `success`/`error` and an `output`).
- **Provider-specific:** `NonStandardContentBlock` (`type: "non_standard"`, a `value` escape hatch for experimental or provider-unique features).

Content blocks were introduced in LangChain v1 to standardize formats across providers while staying backward-compatible with existing `content`-based code.

Source: [LangChain messages](https://docs.langchain.com/oss/python/langchain/messages) retrieved 2026-06-30, content hash `1bf3eebc`.
