---
title: Deferred actions and simulation
source: packages/gatekeeper-confluence/README.md
source_repo: cloudflare/cloudflare-os
source_commit: 657aa96504f23fda775df46a5a6a95eaf135ec6d
source_date: 2026-08-17
source_authors: [Maximo Guk]
ingested: 2026-08-24
ingested_by: scholar
topics: [capability-mediated-integrations, agent-workspaces, capability-security]
status: current
---

Confluence reads authorize observation immediately, while every side effect becomes a pending action whose simulated result is visible to the agent before a human approves provider execution.

Create, edit, comment, label, attachment, trash, and restore operations are recorded and submitted without reaching Atlassian until an Overseer applies them. Provisional IDs and overlays for content, titles, labels, comments, and trashed state let later reasoning observe the pending world. Rejection or reversion removes that simulated state. Short-lived Durable Object caches are invalidated on writes so approved and provisional views do not drift indefinitely.

Source: [packages/gatekeeper-confluence/README.md](https://github.com/cloudflare/cloudflare-os/blob/657aa96504f23fda775df46a5a6a95eaf135ec6d/packages/gatekeeper-confluence/README.md) at commit `657aa965`.
