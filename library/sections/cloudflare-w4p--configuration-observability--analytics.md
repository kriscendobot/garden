---
title: "Observability: analytics via Analytics Engine and the GraphQL API"
source_kind: web
source_url: https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/configuration/observability/
source_content_sha256: 94ab78174b444e18ff6a3573f4ba3cbf38dee4b52b57057828461d4140355848
source_authors: [Cloudflare Docs]
source_date: 2026-04-21
retrieved: 2026-07-01
ingested: 2026-07-01
ingested_by: scholar
topics: [multi-tenant-platform]
status: current
notes: "Living vendor docs (developers.cloudflare.com). Idempotency anchor is source_content_sha256 over the page's `.md` rendering (append `index.md`)."
---

Abstract: Two ways to review Workers-for-Platforms analytics — the data a platform can surface back to its end users. **Workers Analytics Engine** exposes Worker-invocation events or custom user-defined events; a platform can write and query events **by script tag** to build per-customer usage aggregates. The **GraphQL Analytics API** provides metrics per dispatch namespace: query the `workersInvocationsAdaptive` node with the `dispatchNamespaceName` dimension to get usage by namespace. Together they are the metering/usage substrate behind per-customer dashboards and billing.

## Analytics

There are two ways for you to review your Workers for Platforms analytics.

### Workers Analytics Engine

[Workers Analytics Engine](https://developers.cloudflare.com/analytics/analytics-engine/) can be used with Workers for Platforms to provide analytics to end users. It can be used to expose events relating to a Worker's invocation or custom user-defined events. Platforms can write/query events by script tag to get aggregates over a user's usage.

### GraphQL Analytics API

Use Cloudflare's [GraphQL Analytics API](https://developers.cloudflare.com/analytics/graphql-api) to get metrics relating to your dispatch namespaces. Use the `dispatchNamespaceName` dimension in the `workersInvocationsAdaptive` node to query usage by namespace.

Source: [Observability](https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/configuration/observability/) retrieved 2026-07-01, content hash `94ab7817`.
