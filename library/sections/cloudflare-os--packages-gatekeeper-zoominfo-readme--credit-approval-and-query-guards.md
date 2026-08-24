---
title: ZoomInfo credit approval and query guards
source: packages/gatekeeper-zoominfo/README.md
source_repo: cloudflare/cloudflare-os
source_commit: 657aa96504f23fda775df46a5a6a95eaf135ec6d
source_date: 2026-08-17
source_authors: [Maximo Guk, Yo'av Moshe]
ingested: 2026-08-24
ingested_by: scholar
topics: [capability-mediated-integrations, capability-security]
status: current
---

ZoomInfo enrichment spends credits only after approval and suspends the agent turn until the decision, while runtime guards reject provider combinations that would silently broaden a query.

Search, lookup, recommendations, insights, and summaries are free; enrichment generally consumes credits. Each `enrich*` call enters the approval queue, then results are collected by ticket. Enrichment is not simulated and carries `awaitDecision`. `getCreditUsage()` is authoritative because per-record charge flags can overstate use.

Intent and scoop search accept firmographic filters but no company identity, so a known company must use `enrichIntent` or `enrichScoops`. `state` and `country` are mutually exclusive because ZoomInfo silently ignores `state` when both are present; the Gatekeeper rejects the pair rather than returning unexpectedly broad results. Entitlements further constrain fields and datasets.

Source: [packages/gatekeeper-zoominfo/README.md](https://github.com/cloudflare/cloudflare-os/blob/657aa96504f23fda775df46a5a6a95eaf135ec6d/packages/gatekeeper-zoominfo/README.md) at commit `657aa965`.
