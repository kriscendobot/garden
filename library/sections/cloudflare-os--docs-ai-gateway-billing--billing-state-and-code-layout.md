---
title: Billing state and code layout
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

Daily quota, selected account, and cached balance live with each user; OAuth tokens remain confined to the Cloudflare Gatekeeper connection.

Backend code separates feature and threshold configuration, calendar-day quota checks, account and balance REST access, and Gatekeeper-backed connection and routing logic. Client billing components render usage, exhausted-credit, and account-selection states.

Source: [docs/ai-gateway-billing.md](https://github.com/cloudflare/cloudflare-os/blob/8b9fd811d016b58ac5cbe1c28761f1d13dfe7138/docs/ai-gateway-billing.md) at commit `8b9fd811`.
