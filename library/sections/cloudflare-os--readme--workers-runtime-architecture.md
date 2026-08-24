---
title: Workers runtime architecture
source: README.md
source_repo: cloudflare/cloudflare-os
source_commit: 1ef6020a42fbabb6d27dd1063db3a075ba95c974
source_date: 2026-08-21
source_authors: [Kenton Varda, "Yo'av Moshe", Nathan Disidore, Phillip Jones, Dan Carter]
ingested: 2026-08-24
ingested_by: scholar
topics: [cloudflare-workers-agent-hosting, agent-workspaces, sandbox-platforms]
status: current
---

Cloudflare OS maps its kernel, processes, drivers, and user sessions onto Workers primitives: Durable Objects hold workspaces, Dynamic Worker Facets run gadgets, and Gatekeeper facets mediate remote services.

The `workshop-backend` package acts as the kernel, connecting users to gadgets and Gatekeepers while enforcing sandboxing and access control. The frontend is the shell, gadgets are processes, blueprints are executables, and shared permissions are access-control entries.

Every workspace is a Durable Object. Every gadget runs in a Dynamic Worker Facet, and Gatekeepers install facets into the workspace. The same architecture can run on the open-source `workerd` runtime rather than only on Cloudflare's hosted platform.

Source: [README.md](https://github.com/cloudflare/cloudflare-os/blob/1ef6020a42fbabb6d27dd1063db3a075ba95c974/README.md) at commit `1ef6020a`.
