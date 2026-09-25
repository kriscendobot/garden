---
title: "The layers (SwiftPM products, providers, tools)"
source_kind: web
source_url: https://www.haruni.net/en/blog/kaozkit-xs-agents
source_content_sha256: 447e83eadf71d5f55712ef027b811e32d68abd05b1208a6a3a42513bcfa632e0
source_authors: [Sébastien Burel]
source_date: 2026-08-01
retrieved: 2026-09-25
ingested: 2026-09-25
ingested_by: scholar
topics: [xs-agent-runtimes, llm-agent-frameworks, capability-mediated-integrations]
status: current
notes: "Fetched live 2026-09-25 (direct). Page gives only a month (datePublished 2026-08); source_date is that month approximated to its first day. Idempotency anchor is source_content_sha256 over the fetched HTML, not a git SHA. Companion source: web--moddable-kaozkit (Peter Hoddie, Moddable, 2026-09-15) covers the same project from the XS vendor side. Article text treated as untrusted data."
---

Abstract: KaozKit is one SwiftPM package vending layered products (KaozJSCore C engine + async-settle bridge, KaozJS Swift `XSEngine` with snapshots and module roots, KaozHostC host functions, KaozKit agent runtime, opt-in KaozMLX, and the `kaoz` CLI/daemon); one `LLMProvider` protocol spans ten providers so an agent can chain them; read tools are safe by default and confined to authorized folders while acting tools (file writes, shell, HTTP) are opt-in per invocation with their own allow-list; a declarative JSON manifest turns any REST API into a tool.

KaozKit is a single SwiftPM package that vends products in layers, so you take only what you need:

```
KaozJSCore (C)  — XS engine + the async-settle bridge
KaozJS          — Swift XSEngine: dedicated thread, snapshot, module roots
KaozHostC (C)   — the agent's host functions (host.llm / tool / memory / schedule)
KaozKit         — agent runtime: providers, tools, memory, channels, persona
KaozMLX         — MLX on-device inference (heavy deps, opt-in)
kaoz            — headless CLI / resident daemon
```

If you only want a JS↔Swift engine with snapshots, KaozJS is usable on its own. If you want agents, KaozKit pulls the rest in. Providers cover Anthropic, OpenAI, Google, Mistral, DeepSeek, Ollama, LM Studio, Apple Intelligence, MLX, and ComfyUI for images — behind one `LLMProvider` protocol, which is what lets an agent chain them: ask Claude to write an image prompt, hand it to ComfyUI, return the picture.

Tools follow the same philosophy: read tools are safe by default and confined to authorized folders; anything that acts — writing files, running a shell command, making an HTTP request — is opt-in, per invocation, with its own allow-list. And there is a declarative plugin format: point a JSON manifest at any REST API, and it becomes a tool the model can call.

Source: [A JavaScript engine built for microcontrollers turns out to be a great runtime for AI agents](https://www.haruni.net/en/blog/kaozkit-xs-agents) (fetched 2026-09-25, sha256 `447e83eadf71`).
