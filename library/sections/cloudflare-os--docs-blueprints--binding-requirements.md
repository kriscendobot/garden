---
title: Binding requirements and annotations
source: docs/blueprints.md
source_repo: cloudflare/cloudflare-os
source_commit: 69c39d5037609b7efe8e2ed7e704e86bb1ce7002
source_date: 2026-08-03
source_authors: [Phillip Jones, Kenton Varda]
ingested: 2026-08-24
ingested_by: scholar
topics: [reusable-app-blueprints, capability-mediated-integrations]
status: current
---

Blueprint bindings preserve the shape of an application's dependencies while requiring each consumer to supply their own concrete resources and credentials.

Annotations add a friendly name, explanatory text, and an optional suggested value to a named binding. Suggestions help consumers reproduce the author's intended setup but do not become requirements.

Three binding kinds are recorded: Gatekeeper connections to external resources, AI model selections, and agent spawner configurations. Gatekeeper consumers select an account and compatible resource, model consumers choose from their configured models, and spawner consumers choose a model while inheriting prompt and environment restrictions.

Source: [docs/blueprints.md](https://github.com/cloudflare/cloudflare-os/blob/69c39d5037609b7efe8e2ed7e704e86bb1ce7002/docs/blueprints.md) at commit `69c39d50`.
