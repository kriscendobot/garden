---
source_kind: web
source_url: https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/configuration/hostname-routing/
source_content_sha256: 48eaef15584da67bf4ed5c23dfe4a5099cc764bd295349ee4e2e2cada1973631
source_authors: [Cloudflare Docs]
source_date: 2026-04-21
retrieved: 2026-07-01
ingested: 2026-07-01
ingested_by: scholar
section_count: 2
status: current
notes: "Living vendor docs (developers.cloudflare.com). Idempotency anchor is source_content_sha256 over the page's `.md` rendering (append `index.md`), not a git SHA."
---

The hostname-routing configuration page: how a dynamic dispatch Worker routes millions of vanity domains and subdomains without hitting Workers route limits. Covers the recommended wildcard `*/*` route (route in code, support subdomains and custom hostnames together, exclude hostnames via no-Worker routes or a dedicated domain) with its Cloudflare-for-SaaS setup, and the narrower `*.saas.com/*` subdomain route plus the Orange-to-Orange (O2O) proxy-mode invocation caveat that motivates preferring the wildcard.

| Section | Topics | Status |
|---------|--------|--------|
| [Hostname routing: the recommended wildcard route with a dispatch Worker](../sections/cloudflare-w4p--configuration-hostname-routing--wildcard-route.md) | multi-tenant-platform | current |
| [Subdomain routing and Orange-to-Orange (O2O) invocation behavior](../sections/cloudflare-w4p--configuration-hostname-routing--subdomain-routing-and-o2o.md) | multi-tenant-platform | current |
