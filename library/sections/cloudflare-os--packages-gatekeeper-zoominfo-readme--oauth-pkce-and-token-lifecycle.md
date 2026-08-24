---
title: ZoomInfo OAuth PKCE and token lifecycle
source: packages/gatekeeper-zoominfo/README.md
source_repo: cloudflare/cloudflare-os
source_commit: 657aa96504f23fda775df46a5a6a95eaf135ec6d
source_date: 2026-08-17
source_authors: [Maximo Guk, Yo'av Moshe]
ingested: 2026-08-24
ingested_by: scholar
topics: [oauth-credentials, cloudflare-workers-agent-hosting]
status: current
---

ZoomInfo's connector uses Authorization Code with PKCE, HTTP Basic client authentication at token exchange, and refresh-token rotation to sustain a long-lived account session.

The callback is `${BASE_URL}/gatekeeper/zoominfo/oauth`, locally `http://localhost:8787/gatekeeper/zoominfo/oauth`. The app enables the eight recognized company, contact, intent, news, scoops, recommendations, account-summary, and insights scopes; lookup data comes with the data scopes and has no separate `lookup` scope. Local development supplies `ZOOMINFO_CLIENT_ID` and `ZOOMINFO_CLIENT_SECRET`; the Worker can override its public base and the GTM API base. Missing refresh tokens are fatal because the session must survive access-token expiry.

Source: [packages/gatekeeper-zoominfo/README.md](https://github.com/cloudflare/cloudflare-os/blob/657aa96504f23fda775df46a5a6a95eaf135ec6d/packages/gatekeeper-zoominfo/README.md) at commit `657aa965`.
