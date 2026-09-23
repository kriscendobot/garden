---
source_kind: web
source_url: https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/reference/local-development/
source_content_sha256: b3cfa35a38ae4ad16e084b6ab905886541d13e80b53a6b2c4d38866e3abdef88
source_authors: [Cloudflare Docs]
source_date: 2026-06-25
retrieved: 2026-07-02
ingested: 2026-07-02
ingested_by: scholar
section_count: 1
status: current
notes: "Living vendor docs (developers.cloudflare.com). Idempotency anchor is source_content_sha256 over the page's `.md` rendering (append `index.md`), not a git SHA."
---

The local-development reference page: how to iterate on a dynamic dispatch Worker locally under `wrangler dev` while invoking user Workers already deployed to Cloudflare, by setting `remote = true` on the dispatch-namespace binding (a remote binding) to point at a remote (recommended: staging) namespace. Useful for testing routing changes, adding dispatcher middleware, and debugging production-impacting dispatch issues.

| Section | Topics | Status |
|---------|--------|--------|
| [Local development: test the dispatch Worker locally against a remote namespace](../sections/cloudflare-w4p--local-development--overview.md) | multi-tenant-platform | current |
