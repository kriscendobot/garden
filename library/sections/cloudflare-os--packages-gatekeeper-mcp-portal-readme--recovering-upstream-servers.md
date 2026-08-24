---
title: Recovering upstream servers from tool-name prefixes
source: packages/gatekeeper-mcp-portal/README.md
source_repo: cloudflare/cloudflare-os
source_commit: 4fd43ffe37435637e818357035a50054bacba297
source_date: 2026-08-18
source_authors: [Dan Carter, Maximo Guk]
ingested: 2026-08-24
ingested_by: scholar
topics: [capability-mediated-integrations]
status: current
---

A portal flattens every upstream server's tools into one `tools/list`, so the connector recovers the per-server seam from the portal's documented contract — a `{server_id}_{original_name}` prefix on every tool and a `portal_list_servers` tool — treating membership as a pure string test that cannot fail open.

Two facts carry the recovery. Every tool is named `{server_id}_{original_name}`, split on the first underscore only, with an alias replacing the tool name but never the server-id prefix, so membership is a string test needing no network call and a server scope cannot fail open on a transient error. And `portal_list_servers` is available in every portal session, returning each upstream server's id, name, and enabled state. Detection is a capability probe — does the endpoint offer `portal_list_servers`? — not a hostname match, so it works for a custom portal hostname and any other aggregator adopting the convention. A truncated listing counts as a portal whether or not the probe tool falls within it, because `tools/list` is unordered and concluding "not a portal" from evidence past the cut would fail open on the `portal_*` exclusion; truncation is reported by the client rather than inferred from tool count, since either the requested count or the 96 KiB UTF-8 budget can stop a listing.

For a portal too large for one catalog, the configurator normally gets names directly from `portal_list_servers`; if that is unavailable it falls back to a name-only tool index of up to 1,000 entries carrying no descriptions or schemas, and a truncated fallback blocks the form rather than presenting a partial list as complete. After a server is selected, a separate filtered scan returns up to 200 compact summaries from that server, each classified through the shared `tools.ts` trust boundary, with the filter applied before result budgets so unrelated servers cannot crowd the selected one out; index entries are typed separately (`IndexedTool`) to distinguish name-only survey results from full definitions. The server list is advisory — it supplies display names and ordering while tool-name prefixes remain the authority on membership — and failing to reach the portal blocks the grant rather than falling back to the bare endpoint. `portal_*` tools are excluded from every grant at every scope as a capability-boundary rule, because `portal_toggle_servers` and friends would let a Gadget widen its own authority.

Source: [packages/gatekeeper-mcp-portal/README.md](https://github.com/cloudflare/cloudflare-os/blob/4fd43ffe37435637e818357035a50054bacba297/packages/gatekeeper-mcp-portal/README.md) at commit `4fd43ffe`.
