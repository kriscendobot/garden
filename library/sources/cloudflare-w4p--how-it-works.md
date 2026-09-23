---
source_kind: web
source_url: https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/how-workers-for-platforms-works/
source_content_sha256: 46b14522867d0b338a4ba7c8cfa9708c0f21b754aa9dd44cf1e8f050197ea2d9
source_authors: [Cloudflare Docs]
source_date: 2026-04-21
retrieved: 2026-07-01
ingested: 2026-07-01
ingested_by: scholar
section_count: 4
status: current
notes: "Living vendor docs (developers.cloudflare.com). Idempotency anchor is source_content_sha256 over the page's `.md` rendering (append `index.md`), not a git SHA."
---

The architecture page: the four key components Workers for Platforms adds over plain Workers — dispatch namespaces (the container of customer Workers), dynamic dispatch Workers (the platform's request entry point / router), user Workers (the deployed customer code), and the optional outbound Worker (egress interception) — plus the end-to-end request lifecycle and how Workers for Platforms compares to Service bindings.

| Section | Topics | Status |
|---------|--------|--------|
| [Dispatch namespace: the container for customer Workers](../sections/cloudflare-w4p--how-it-works--dispatch-namespace.md) | multi-tenant-platform | current |
| [Dynamic dispatch Worker: the platform's request entry point](../sections/cloudflare-w4p--how-it-works--dynamic-dispatch-worker.md) | multi-tenant-platform | current |
| [User Workers: customer code deployed into the namespace](../sections/cloudflare-w4p--how-it-works--user-workers.md) | multi-tenant-platform | current |
| [Request lifecycle and the optional outbound Worker](../sections/cloudflare-w4p--how-it-works--request-lifecycle.md) | multi-tenant-platform | current |
