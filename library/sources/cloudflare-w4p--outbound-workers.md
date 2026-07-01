---
source_kind: web
source_url: https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/configuration/outbound-workers/
source_content_sha256: 65ffd3ad75ecf9da706667ed5ed65d2b7904acdaf62688a3c86a66f360f7171e
source_authors: [Cloudflare Docs]
source_date: 2026-04-21
retrieved: 2026-07-01
ingested: 2026-07-01
ingested_by: scholar
section_count: 1
status: current
notes: "Living vendor docs (developers.cloudflare.com). Idempotency anchor is source_content_sha256 over the page's `.md` rendering (append `index.md`), not a git SHA."
---

The outbound-Workers configuration page: how a platform intercepts and controls all outgoing `fetch()` requests from user Workers (egress control, logging, allow/block lists, behind-the-scenes API auth), how to wire the outbound Worker into the `dispatch_namespaces` binding and pass per-request context, and the two boundaries (it disables the `connect()` TCP-socket API in customer Workers, and does not intercept Durable Object or mTLS-binding fetches).

| Section | Topics | Status |
|---------|--------|--------|
| [Outbound Workers: egress interception and control](../sections/cloudflare-w4p--outbound-workers--overview.md) | multi-tenant-platform | current |
