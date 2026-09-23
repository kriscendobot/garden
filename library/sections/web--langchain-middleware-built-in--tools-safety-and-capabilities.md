---
title: "Built-in middleware: tool shaping, safety, and agent capabilities"
source_kind: web
source_url: https://docs.langchain.com/oss/python/langchain/middleware/built-in
source_content_sha256: 1009bcd409a8e5ec4993d8a8e934427d9c9f456a4dc482f5a8e29aaa4de33937
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
topics: [llm-agent-frameworks, human-in-the-loop, agent-conventions]
status: current
notes: "Living vendor docs (docs.langchain.com, Mintlify). Idempotency anchor is source_content_sha256 over the page's `.md` rendering. Second of two consolidated sections over the built-in-middleware catalog; per-middleware H3 anchors preserved inline for grep. Sibling: web--langchain-middleware-built-in--context-cost-and-resilience. Part of the LangChain/LangGraph remainder-ingest batch 3 (2026-06-30)."
---

Abstract: The second half of the prebuilt-middleware catalog: middleware that **shapes the toolset, enforces safety/oversight, and grants agents new capabilities** (several from Deep Agents). Tool-shaping: `LLMToolSelectorMiddleware` uses a (usually cheaper) LLM to pick the relevant tools before the main model call (`max_tools`, `always_include`), good when an agent has 10+ tools; `ProviderToolSearchMiddleware` defers selected tools behind a provider's server-side tool search so the model discovers them on demand (Anthropic Claude 4-class / OpenAI gpt-5.5+ only); `LLMToolEmulator` replaces real tool execution with LLM-generated responses for testing. Safety/oversight: `HumanInTheLoopMiddleware` pauses for human approve/edit/reject of named tool calls (requires a checkpointer); `PIIMiddleware` detects and handles PII (`block`/`redact`/`mask`/`hash`) on input, output, and tool results, with built-in types (`email`, `credit_card`, `ip`, `mac_address`, `url`) or custom regex/function detectors. Capabilities (mostly Deep Agents): `TodoListMiddleware` adds a `write_todos` planning tool; `ShellToolMiddleware` exposes a persistent shell under a host/Docker/Codex execution policy; `FilesystemFileSearchMiddleware` adds Glob+Grep tools; `FilesystemMiddleware` adds `ls`/`read_file`/`write_file`/`edit_file` over short-term (state) or long-term (store-backed `/memories/`) storage; `SubAgentMiddleware` lets the agent spawn subagents (plus an always-available `general-purpose` subagent) for context isolation. Provider-specific middleware (Anthropic, AWS, OpenAI) ships separately.

## Tool shaping

### LLM tool selector

`LLMToolSelectorMiddleware(model, max_tools, always_include)` asks an LLM (via structured output) which tools are relevant for the current query before the main model runs — useful at 10+ tools to cut tokens and improve focus. `max_tools` caps the selection; `always_include` tools are exempt from the cap; `model` defaults to the agent's main model.

### Provider tool search

`ProviderToolSearchMiddleware(searchable_tools=[...])` defers tools behind the provider's server-side tool search so the model receives them on demand instead of every schema up front. Requires server-side tool search support (Anthropic Claude Sonnet/Opus 4+/Haiku 4.5+, OpenAI gpt-5.5+); others raise `ValueError`. A tool can opt into deferral at construction with `extras={"defer_loading": True}` regardless of `searchable_tools`.

### LLM tool emulator

`LLMToolEmulator(tools=None, model=...)` emulates tool execution with LLM-generated responses for testing / prototyping. `tools=None` emulates all tools, `[]` none, or a named subset; `model` defaults to the agent's model.

## Safety and oversight

### Human-in-the-loop

`HumanInTheLoopMiddleware(interrupt_on={...})` pauses execution for human approval, editing, or rejection of tool calls before they run — for high-stakes operations, compliance, and feedback-guided runs. Each tool maps to `False` (no interrupt) or `{"allowed_decisions": ["approve", "edit", "reject"]}`. **Requires a checkpointer** to hold state across the interruption. Full patterns live in the human-in-the-loop docs.

### PII detection

`PIIMiddleware(pii_type, strategy, apply_to_input/output/tool_results)` detects and handles PII. `strategy`: `block` (raise), `redact` (`[REDACTED_{TYPE}]`), `mask` (`****-****-****-1234`), `hash` (deterministic). Built-in `pii_type`s: `email`, `credit_card`, `ip`, `mac_address`, `url`; custom types supply a `detector` as a regex string, a compiled regex, or a function returning `[{text, start, end}, ...]`. With `apply_to_output=True` and `langchain>=1.3.2`, it also redacts streamed wire output (text deltas, tool-call args, tool outputs, state snapshots) via a registered stream transformer.

## Agent capabilities (mostly Deep Agents)

### To-do list

`TodoListMiddleware()` equips the agent with a `write_todos` tool and guidance system prompt for planning multi-step tasks (`system_prompt`, `tool_description` overridable).

### Shell tool

`ShellToolMiddleware(workspace_root, execution_policy=...)` exposes a persistent shell session. Execution policies: `HostExecutionPolicy` (full host access, default), `DockerExecutionPolicy` (per-run container isolation), `CodexSandboxExecutionPolicy` (syscall/fs restrictions). Other options: `startup_commands`/`shutdown_commands`, `redaction_rules` (post-execution; do not prevent exfiltration under host policy), `shell_command` (default `/bin/bash`), `env`. Persistent shell sessions do not currently work with HITL interrupts.

### File search

`FilesystemFileSearchMiddleware(root_path, use_ripgrep=True, max_file_size_mb=10)` adds a **Glob** tool (pattern matching, e.g. `**/*.py`) and a **Grep** tool (regex content search with `files_with_matches`/`content`/`count` output modes; `include` filter). Falls back to Python regex if ripgrep is unavailable.

### Filesystem (Deep Agents)

`FilesystemMiddleware` provides `ls`/`read_file`/`write_file`/`edit_file`. By default writes to an in-state "filesystem" (short-term); configure a `CompositeBackend(default=StateBackend(), routes={"/memories/": StoreBackend()})` to route `/memories/`-prefixed files to persistent, cross-thread store storage. Included by default in `create_deep_agent`.

### Subagent (Deep Agents)

`SubAgentMiddleware(default_model, default_tools, subagents=[...])` lets the main (supervisor) agent hand off to subagents via a `task` tool, isolating context. A subagent is `{name, description, system_prompt, tools, model?, middleware?}`, or a prebuilt graph wrapped in `CompiledSubAgent`. A `general-purpose` subagent (same instructions and tools as the main agent) is always available for delegating complex tasks and getting a concise answer back without intermediate-tool bloat.

## Provider-specific middleware

Optimized middleware ships per provider: **Anthropic** (prompt caching, bash tool, text editor, memory, file search for Claude), **AWS** (prompt caching for Bedrock), **OpenAI** (content moderation).

Source: [Built-in middleware](https://docs.langchain.com/oss/python/langchain/middleware/built-in) retrieved 2026-06-30, content hash `1009bcd4`.
