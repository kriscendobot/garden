---
title: Blueprint instantiation by users and agents
source: docs/blueprints.md
source_repo: cloudflare/cloudflare-os
source_commit: 69c39d5037609b7efe8e2ed7e704e86bb1ce7002
source_date: 2026-08-03
source_authors: [Phillip Jones, Kenton Varda]
ingested: 2026-08-24
ingested_by: scholar
topics: [reusable-app-blueprints, ai-generated-apps, capability-mediated-integrations]
status: current
---

Instantiation copies Blueprint code into a new independent gadget and resolves every required binding against the creating user's resources; agents can perform the same operation inside an existing workspace.

The public landing page displays metadata without authentication, then asks an authenticated user to assign Gatekeeper resources, AI models, and agent spawners. The backend reads metadata from KV and code from R2, creates an Overseer DO, initializes the snapshot, and creates the assigned Gatekeepers.

An agent may list available Blueprints and pass a `blueprintId` to `createGadget`. The copied files and provisional gadget creation participate in the chat's normal accept-or-revert changes. Bindings are not assigned automatically: the agent must wire them under the expected names or ask the user to add model and spawner connections.

Source: [docs/blueprints.md](https://github.com/cloudflare/cloudflare-os/blob/69c39d5037609b7efe8e2ed7e704e86bb1ce7002/docs/blueprints.md) at commit `69c39d50`.
