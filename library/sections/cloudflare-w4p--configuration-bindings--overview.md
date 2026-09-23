---
title: "Bindings: give each user Worker its own resources"
source_kind: web
source_url: https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/configuration/bindings/
source_content_sha256: 3635e8fea0b23b4a8cdf0d722fc4af83129bf3fd76b04f10e353681021144709
source_authors: [Cloudflare Docs]
source_date: 2026-04-21
retrieved: 2026-07-01
ingested: 2026-07-01
ingested_by: scholar
topics: [multi-tenant-platform]
status: current
notes: "Living vendor docs (developers.cloudflare.com). Idempotency anchor is source_content_sha256 over the page's `.md` rendering (append `index.md`)."
---

Abstract: A platform can attach **bindings** to the user Workers it deploys, giving each customer's Worker access to Cloudflare resources — a **KV namespace**, **D1 database**, **R2 bucket**, **Analytics Engine** dataset, **Durable Objects** class, and more — so end customers build richer applications without the platform building the infrastructure itself. The security property is **resource isolation**: a user Worker can access *only* the bindings explicitly attached to it, and for complete isolation the platform creates and attaches a *unique* resource (a distinct D1 database or KV namespace) per user Worker. This is the per-tenant data-plane counterpart to the dispatch namespace's code isolation.

## Bindings

When you deploy User Workers through Workers for Platforms, you can attach [bindings](https://developers.cloudflare.com/workers/runtime-apis/bindings/) to give them access to resources like KV namespaces, D1 databases, R2 buckets, and more. This enables your end customers to build more powerful applications without you having to build the infrastructure components yourself.

With bindings, each of your users can have their own:

- **KV namespace** to store and retrieve data.
- **R2 bucket** to store files and assets.
- **Analytics Engine** dataset to collect observability data.
- **Durable Objects** class for stateful coordination.

## Resource isolation

Each User Worker can only access the bindings that are explicitly attached to it. For complete isolation, you can create and attach a unique resource (like a D1 database or KV namespace) to every User Worker.

Source: [Bindings](https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/configuration/bindings/) retrieved 2026-07-01, content hash `3635e8fe`.
