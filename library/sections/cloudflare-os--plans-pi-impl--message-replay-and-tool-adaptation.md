---
title: Message replay and tool adaptation
source: plans/pi-impl.md
source_repo: cloudflare/cloudflare-os
source_commit: bdb6dc75560e8fa3833e99c9399cae90446d12e1
source_date: 2026-08-03
source_authors: [Kenton Varda]
ingested: 2026-08-24
ingested_by: scholar
topics: [llm-agent-frameworks, agent-workspaces, agent-conventions]
status: current
---

Existing chat records replay into pi's typed user, assistant, tool-call, and tool-result messages without changing the persisted Cloudflare OS API or the replay decisions that reconstruct provisional state.

The two system-prompt slots concatenate into one stable prompt prefix. Attachments convert to text or base64 image content, assistant tool calls carry typed arguments, and live and replayed tool results share one text serialization helper. Agent tools replace Zod schemas with TypeBox and return model-visible content plus persistence details. Error paths retain side metadata because pi converts thrown tool errors into error results but drops tool details.

Source: [plans/pi-impl.md](https://github.com/cloudflare/cloudflare-os/blob/bdb6dc75560e8fa3833e99c9399cae90446d12e1/plans/pi-impl.md) at commit `bdb6dc75`.
