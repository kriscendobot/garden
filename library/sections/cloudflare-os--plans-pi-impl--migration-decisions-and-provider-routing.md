---
title: Migration decisions and provider routing
source: plans/pi-impl.md
source_repo: cloudflare/cloudflare-os
source_commit: bdb6dc75560e8fa3833e99c9399cae90446d12e1
source_date: 2026-08-03
source_authors: [Kenton Varda]
ingested: 2026-08-24
ingested_by: scholar
topics: [llm-agent-frameworks, cloudflare-workers-agent-hosting, agent-workspaces]
status: current
---

The implementation playbook replaces the Vercel AI SDK with exact-pinned `pi-ai` and `pi-agent-core` while preserving Cloudflare OS chat storage, frontend protocol, replay semantics, and cost accounting.

The low-level awaited `runAgentLoopContinue` is chosen over the stateful agent class. Inference moves to token-authenticated HTTPS because pi has no Workers-binding transport: Cloudflare AI Gateway, Workers AI, BYOK unified routing, OpenAI Responses, Anthropic, and Ollama each map to explicit pi model and endpoint shapes. Suggested-model metadata remains authoritative for context and output limits. Text and images are supported initially; existing unsupported attachments replay as markers, with PDF and binding-backed transport deferred.

Source: [plans/pi-impl.md](https://github.com/cloudflare/cloudflare-os/blob/bdb6dc75560e8fa3833e99c9399cae90446d12e1/plans/pi-impl.md) at commit `bdb6dc75`.
