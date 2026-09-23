---
title: ZoomInfo account search and enrichment capability
source: packages/gatekeeper-zoominfo/README.md
source_repo: cloudflare/cloudflare-os
source_commit: 657aa96504f23fda775df46a5a6a95eaf135ec6d
source_date: 2026-08-17
source_authors: [Maximo Guk, Yo'av Moshe]
ingested: 2026-08-24
ingested_by: scholar
topics: [capability-mediated-integrations]
status: current
---

The ZoomInfo Gatekeeper exposes one whole-account GTM capability covering lookup, free search, credit-bearing enrichment, Copilot insights, and usage counters, limited by the connected user's package entitlements.

Lookup resolves controlled filter values and available enrichment fields. Search covers companies, contacts, intent signals, scoops, and news. Enrichment expands matched records into full company, contact, hierarchy, hashtag, intent, scoop, or news detail. Copilot adds lookalikes, recommendations, account summaries, questions, and curated signals. `getCreditUsage()` reports the account's limits. The connector does not provide sign-in identity because `getAuthenticatedEmail()` returns `null`.

Source: [packages/gatekeeper-zoominfo/README.md](https://github.com/cloudflare/cloudflare-os/blob/657aa96504f23fda775df46a5a6a95eaf135ec6d/packages/gatekeeper-zoominfo/README.md) at commit `657aa965`.
