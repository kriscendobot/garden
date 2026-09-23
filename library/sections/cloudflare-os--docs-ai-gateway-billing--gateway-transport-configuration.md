---
title: AI Gateway transport configuration
source: docs/ai-gateway-billing.md
source_repo: cloudflare/cloudflare-os
source_commit: 8b9fd811d016b58ac5cbe1c28761f1d13dfe7138
source_date: 2026-08-18
source_authors: [Dan Carter, Kenton Varda, Maximo Guk, "Yo'av Moshe"]
ingested: 2026-08-24
ingested_by: scholar
topics: [ai-usage-billing, cloudflare-workers-agent-hosting]
status: current
---

Gateway mode requires an account ID plus either an in-account Workers AI binding or an HTTPS token with run and read permissions, with an explicit binding opt-out for cross-account gateways.

Binding requests are preauthenticated and can also read cost logs, but cannot reach a Gateway in another Cloudflare account. `CF_AI_GATEWAY_USE_BINDING=false` selects HTTPS without removing the Workers AI binding needed by the separate document-to-Markdown tool. Google-provider traffic still requires the API token. Every configured model provider, including Workers AI, routes through the Gateway.

Source: [docs/ai-gateway-billing.md](https://github.com/cloudflare/cloudflare-os/blob/8b9fd811d016b58ac5cbe1c28761f1d13dfe7138/docs/ai-gateway-billing.md) at commit `8b9fd811`.
