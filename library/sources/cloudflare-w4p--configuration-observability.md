---
source_kind: web
source_url: https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/configuration/observability/
source_content_sha256: 94ab78174b444e18ff6a3573f4ba3cbf38dee4b52b57057828461d4140355848
source_authors: [Cloudflare Docs]
source_date: 2026-04-21
retrieved: 2026-07-01
ingested: 2026-07-01
ingested_by: scholar
section_count: 2
status: current
notes: "Living vendor docs (developers.cloudflare.com). Idempotency anchor is source_content_sha256 over the page's `.md` rendering (append `index.md`), not a git SHA."
---

The observability configuration page: how a platform collects logs and analytics across all user Workers in a dispatch namespace. Logs come via Workers Trace Events Logpush (raw execution logs, namespace-wide when enabled on the dispatch Worker) or Tail Workers (real-time / programmable, diagnostics-channel events); analytics come via Workers Analytics Engine (per-script-tag usage aggregates for end users) or the GraphQL Analytics API (`workersInvocationsAdaptive` with the `dispatchNamespaceName` dimension).

| Section | Topics | Status |
|---------|--------|--------|
| [Observability: namespace-wide logs via Logpush and Tail Workers](../sections/cloudflare-w4p--configuration-observability--logs.md) | multi-tenant-platform | current |
| [Observability: analytics via Analytics Engine and the GraphQL API](../sections/cloudflare-w4p--configuration-observability--analytics.md) | multi-tenant-platform | current |
