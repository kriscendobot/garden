---
source_kind: web
source_url: https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/reference/worker-isolation/
source_content_sha256: 10fe5de6c7ffd3ed50c275561810526aeb796ee00f226dbb37be06411399d6d4
source_authors: [Cloudflare Docs]
source_date: 2026-04-21
retrieved: 2026-07-01
ingested: 2026-07-01
ingested_by: scholar
section_count: 1
status: current
notes: "Living vendor docs (developers.cloudflare.com). Idempotency anchor is source_content_sha256 over the page's `.md` rendering (append `index.md`), not a git SHA."
---

The worker-isolation reference page: the two isolation modes of a dispatch namespace that define the tenant security boundary — untrusted mode (the default; strongest isolation, no `request.cf`, per-Worker isolated cache, `caches.default` disabled, no cross-tenant data access) versus trusted mode (for operator-controlled code; `request.cf` available, shared cache space) — plus how to switch and how to keep cache isolation while getting `request.cf`.

| Section | Topics | Status |
|---------|--------|--------|
| [Worker isolation: untrusted (default) versus trusted mode](../sections/cloudflare-w4p--worker-isolation--modes.md) | multi-tenant-platform | current |
