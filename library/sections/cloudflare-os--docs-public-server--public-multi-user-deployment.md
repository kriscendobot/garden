---
title: Public multi-user deployment
source: docs/public-server.md
source_repo: cloudflare/cloudflare-os
source_commit: 8b9fd811d016b58ac5cbe1c28761f1d13dfe7138
source_date: 2026-08-18
source_authors: [Kenton Varda, Maximo Guk]
ingested: 2026-08-24
ingested_by: scholar
topics: [agent-workspaces, authentication-gatekeepers, ai-usage-billing, cloudflare-workers-agent-hosting]
status: current
notes: Overview-shaped companion to the detailed OAuth sign-in and AI Gateway billing sources.
---

The public-server recipe composes independently enabled Gatekeeper sign-in, password hiding, daily platform quota, and user-funded Cloudflare credits into a multi-user Cloudflare OS deployment.

Verified email unifies accounts across Google, GitHub, and Cloudflare login. Local development loads Gatekeeper OAuth credentials and Gateway configuration from `.dev.vars`. Gateway traffic prefers the Workers AI binding for an in-account Gateway and falls back to token-authenticated HTTPS for cross-account routing, while retaining the binding for document-to-Markdown conversion. Each Gatekeeper OAuth app uses its own callback path under the public base URL.

This source is a deployment overview. The detailed authentication lifecycle, billing decisions, storage ownership, and configuration edge cases live in the OAuth sign-in and AI Gateway billing sources.

Source: [docs/public-server.md](https://github.com/cloudflare/cloudflare-os/blob/8b9fd811d016b58ac5cbe1c28761f1d13dfe7138/docs/public-server.md) at commit `8b9fd811`.
