---
title: Gatekeepers and deferred human approval
source: README.md
source_repo: cloudflare/cloudflare-os
source_commit: 1ef6020a42fbabb6d27dd1063db3a075ba95c974
source_date: 2026-08-21
source_authors: [Kenton Varda, "Yo'av Moshe", Nathan Disidore, Phillip Jones, Dan Carter]
ingested: 2026-08-24
ingested_by: scholar
topics: [capability-mediated-integrations, capability-security, agent-workspaces]
status: current
---

Gatekeepers wrap external services with narrow capability APIs, authorization, audit logs, and simulated outcomes that let an agent continue before a person approves side effects.

Introducing an agent or gadget to an external resource creates a service-specific Gatekeeper. It exposes a Cap'n Web API, handles authorization such as OAuth, limits access to the intended resource, and logs actions for review.

For side effects, a Gatekeeper can simulate an outcome locally so the agent continues and may read simulated results. The user later approves or rejects queued actions individually or in bulk. This separates agent progress from synchronous approval without granting ambient or automatic approval.

Source: [README.md](https://github.com/cloudflare/cloudflare-os/blob/1ef6020a42fbabb6d27dd1063db3a075ba95c974/README.md) at commit `1ef6020a`.
