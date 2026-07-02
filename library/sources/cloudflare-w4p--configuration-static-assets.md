---
source_kind: web
source_url: https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/configuration/static-assets/
source_content_sha256: c1d57e6cddc723968bdd9e8b246ab8219ed22c84a1c1080d579f1ec9156deeb5
source_authors: [Cloudflare Docs]
source_date: 2026-04-21
retrieved: 2026-07-01
ingested: 2026-07-01
ingested_by: scholar
section_count: 3
status: current
notes: "Living vendor docs (developers.cloudflare.com). Idempotency anchor is source_content_sha256 over the page's `.md` rendering (append `index.md`), not a git SHA."
---

The static-assets configuration page: hosting static assets (HTML/CSS/JS/media) on Cloudflare's global network attached to user Workers, for static sites and full-stack customer apps. Covers what you can build and the caching/scaling/unified-deployment benefits, the three-step upload API (create upload session with a hashed manifest → base64-upload missing buckets under a short-lived JWT → deploy the Worker with the completion token), including the namespace-scoped asset-sharing isolation caveat, and the Wrangler CLI alternative.

| Section | Topics | Status |
|---------|--------|--------|
| [Static assets: what you can build and the benefits](../sections/cloudflare-w4p--configuration-static-assets--overview.md) | multi-tenant-platform | current |
| [Deploy static assets to user Workers: the three-step upload API](../sections/cloudflare-w4p--configuration-static-assets--deploy-via-api.md) | multi-tenant-platform | current |
| [Deploying static assets with Wrangler](../sections/cloudflare-w4p--configuration-static-assets--deploy-with-wrangler.md) | multi-tenant-platform | current |
