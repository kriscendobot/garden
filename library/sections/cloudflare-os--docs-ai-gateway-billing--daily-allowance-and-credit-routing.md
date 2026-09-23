---
title: Daily allowance and credit routing
source: docs/ai-gateway-billing.md
source_repo: cloudflare/cloudflare-os
source_commit: 8b9fd811d016b58ac5cbe1c28761f1d13dfe7138
source_date: 2026-08-18
source_authors: [Dan Carter, Kenton Varda, Maximo Guk, "Yo'av Moshe"]
ingested: 2026-08-24
ingested_by: scholar
topics: [ai-usage-billing, agent-workspaces, capability-mediated-integrations]
status: current
---

Cloudflare OS gives each user a daily platform-funded call allowance, but routes funded users through their own Cloudflare AI Gateway credits without consuming that allowance.

Before each user-initiated agent turn, the overseer checks both quota and a live, briefly cached credit balance. A connected balance at or above the minimum routes through the user's account. Otherwise the platform serves calls while daily quota remains, then blocks with a connect-or-top-up prompt. The platform never holds user money; top-ups occur in Cloudflare's dashboard.

Source: [docs/ai-gateway-billing.md](https://github.com/cloudflare/cloudflare-os/blob/8b9fd811d016b58ac5cbe1c28761f1d13dfe7138/docs/ai-gateway-billing.md) at commit `8b9fd811`.
