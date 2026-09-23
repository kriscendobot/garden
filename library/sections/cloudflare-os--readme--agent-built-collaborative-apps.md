---
title: Agent-built collaborative applications
source: README.md
source_repo: cloudflare/cloudflare-os
source_commit: 1ef6020a42fbabb6d27dd1063db3a075ba95c974
source_date: 2026-08-21
source_authors: [Kenton Varda, "Yo'av Moshe", Nathan Disidore, Phillip Jones, Dan Carter]
ingested: 2026-08-24
ingested_by: scholar
topics: [ai-generated-apps, collaborative-workspace-sharing, agent-workspaces]
status: current
---

Gadgets are designed to be generated, debugged, invoked, and collaboratively edited by agents without requiring a separate application-specific agent integration.

The built-in coding agent writes and tests gadget code. Gadget clients and servers communicate through Cap'n Web RPC, which gives the application an explicit API that Code Mode agents can call directly. Each gadget is backed by a Durable Object, so real-time multiplayer state synchronization is part of the default hosting model.

Users may share a running gadget for collaboration or publish its code as a Blueprint so others can create independent copies.

Source: [README.md](https://github.com/cloudflare/cloudflare-os/blob/1ef6020a42fbabb6d27dd1063db3a075ba95c974/README.md) at commit `1ef6020a`.
