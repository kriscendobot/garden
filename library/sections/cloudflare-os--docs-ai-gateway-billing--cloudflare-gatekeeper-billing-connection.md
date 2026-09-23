---
title: Cloudflare Gatekeeper billing connection
source: docs/ai-gateway-billing.md
source_repo: cloudflare/cloudflare-os
source_commit: 8b9fd811d016b58ac5cbe1c28761f1d13dfe7138
source_date: 2026-08-18
source_authors: [Dan Carter, Kenton Varda, Maximo Guk, "Yo'av Moshe"]
ingested: 2026-08-24
ingested_by: scholar
topics: [ai-usage-billing, authentication-gatekeepers, capability-mediated-integrations]
status: current
---

AI billing obtains OAuth authority from the user's connected Cloudflare Gatekeeper and stores only a selected account ID and cached balance in the Workshop user object.

The Gatekeeper owns and refreshes tokens and exposes a usable access token to the billing service. One discovered account is selected automatically; multiple accounts require user choice. Billing targets the account's default Unified Billing AI Gateway. Signing in with Cloudflare alone does not persist the full-scope connection, so a user may still need the explicit connect flow.

Source: [docs/ai-gateway-billing.md](https://github.com/cloudflare/cloudflare-os/blob/8b9fd811d016b58ac5cbe1c28761f1d13dfe7138/docs/ai-gateway-billing.md) at commit `8b9fd811`.
