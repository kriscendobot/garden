---
source_kind: web
source_url: https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/configuration/custom-limits/
source_content_sha256: c666c0cc74970908a40884e9200fa61b10d6005b7d88ab09ec5800808f72579b
source_authors: [Cloudflare Docs]
source_date: 2026-04-21
retrieved: 2026-07-01
ingested: 2026-07-01
ingested_by: scholar
section_count: 1
status: current
notes: "Living vendor docs (developers.cloudflare.com). Idempotency anchor is source_content_sha256 over the page's `.md` rendering (append `index.md`), not a git SHA."
---

The custom-limits configuration page: how a platform caps each customer Worker's CPU time (`cpuMs`) and subrequest count (`subRequests`) per invocation, set as the third argument to `env.dispatcher.get()` in the dynamic dispatch Worker; a Worker that hits either limit immediately throws.

| Section | Topics | Status |
|---------|--------|--------|
| [Custom limits: per-customer CPU-time and subrequest caps](../sections/cloudflare-w4p--custom-limits--overview.md) | multi-tenant-platform | current |
