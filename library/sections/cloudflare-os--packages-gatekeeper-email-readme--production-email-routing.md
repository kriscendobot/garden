---
title: Production email routing
source: packages/gatekeeper-email/README.md
source_repo: cloudflare/cloudflare-os
source_commit: 9a2c8509089653eba0727a8d73124ea50361ef5c
source_date: 2026-05-18
source_authors: [Kenton Varda, Phillip Jones]
ingested: 2026-08-24
ingested_by: scholar
topics: [cloudflare-workers-agent-hosting, capability-mediated-integrations]
status: current
---

Production delivery composes Cloudflare Email Routing with a deployed Gatekeeper base URL and an Email Worker route, while preserving the same per-local-part Durable Object dispatch used in development.

`BASE_URL` names the Gatekeeper fetch handler, either at its own Worker origin or under a shared application path. The operator enables the domain's MX and SPF routing, then maps a catch-all or selected address pattern to the deployed worker. The Worker parses the recipient, dispatches to the Durable Object named for that mailbox, and the object invokes its persisted gadget hook.

Source: [packages/gatekeeper-email/README.md](https://github.com/cloudflare/cloudflare-os/blob/9a2c8509089653eba0727a8d73124ea50361ef5c/packages/gatekeeper-email/README.md) at commit `9a2c8509`.
