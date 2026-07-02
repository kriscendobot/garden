---
source_kind: web
source_url: https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/configuration/bindings/
source_content_sha256: 3635e8fea0b23b4a8cdf0d722fc4af83129bf3fd76b04f10e353681021144709
source_authors: [Cloudflare Docs]
source_date: 2026-04-21
retrieved: 2026-07-01
ingested: 2026-07-01
ingested_by: scholar
section_count: 2
status: current
notes: "Living vendor docs (developers.cloudflare.com). Idempotency anchor is source_content_sha256 over the page's `.md` rendering (append `index.md`), not a git SHA."
---

The bindings configuration page: how a platform attaches Cloudflare resource bindings (KV, D1, R2, Analytics Engine, Durable Objects) to the user Workers it deploys, the resource-isolation property (a user Worker sees only the bindings explicitly attached, and a unique per-Worker resource gives full isolation), and a worked API example creating a KV namespace and attaching it via the Upload User Worker API (`metadata.bindings`, `keep_bindings`).

| Section | Topics | Status |
|---------|--------|--------|
| [Bindings: give each user Worker its own resources](../sections/cloudflare-w4p--configuration-bindings--overview.md) | multi-tenant-platform | current |
| [Adding a KV namespace to a user Worker (worked API example)](../sections/cloudflare-w4p--configuration-bindings--adding-a-kv-namespace.md) | multi-tenant-platform | current |
