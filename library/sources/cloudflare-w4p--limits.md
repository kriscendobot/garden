---
source_kind: web
source_url: https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/reference/limits/
source_content_sha256: bad44569fe583dbb154c062a9b76def9f3a4fcde20f942a6fdc2457770740fb5
source_authors: [Cloudflare Docs]
source_date: 2026-04-21
retrieved: 2026-07-02
ingested: 2026-07-02
ingested_by: scholar
section_count: 1
status: current
notes: "Living vendor docs (developers.cloudflare.com). Idempotency anchor is source_content_sha256 over the page's `.md` rendering (append `index.md`), not a git SHA."
---

The limits reference page: the platform-wide limits and isolation-driven object restrictions for Workers for Platforms. Unlimited scripts and Durable Object namespaces; `request.cf` inaccessible in user Workers by default (trusted mode required); `caches.default` disabled for namespaced scripts; a max of eight tags per script; Gradual Deployments unsupported for user Workers (all-at-once 100% deploys); and the Cloudflare API rate limits (1200/5min per user token, 200/s per IP, GraphQL max 320/5min, 50 user-token and 500 account-token quotas).

| Section | Topics | Status |
|---------|--------|--------|
| [Workers for Platforms limits: scripts, cf object, cache, tags, deployments, and API rate limits](../sections/cloudflare-w4p--limits--overview.md) | multi-tenant-platform | current |
