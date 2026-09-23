---
title: "Local development: test the dispatch Worker locally against a remote namespace"
source_kind: web
source_url: https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/reference/local-development/
source_content_sha256: b3cfa35a38ae4ad16e084b6ab905886541d13e80b53a6b2c4d38866e3abdef88
source_authors: [Cloudflare Docs]
source_date: 2026-06-25
retrieved: 2026-07-02
ingested: 2026-07-02
ingested_by: scholar
topics: [multi-tenant-platform]
status: current
notes: "Living vendor docs (developers.cloudflare.com). Idempotency anchor is source_content_sha256 over the page's `.md` rendering (append `index.md`). Complements the dispatch-Worker configuration in cloudflare-w4p--dynamic-dispatch--binding-and-configuration."
---

Abstract: How to iterate on a **dynamic dispatch Worker locally** while it invokes **user Workers that are already deployed to Cloudflare**. You run the dispatch Worker under `wrangler dev` on your machine, but point its dispatch-namespace binding at a **remote** namespace by adding `remote = true` (a [remote binding](https://developers.cloudflare.com/workers/local-development/#remote-bindings)) to the `dispatch_namespaces` binding in the Wrangler config; `wrangler dev` then routes requests to the real deployed user Workers in that namespace. This is the safe way to test routing changes, add middleware (auth, rate limiting, logging) to the dispatcher, and debug production-impacting dispatch issues. Cloudflare recommends pointing at a **staging namespace** rather than production while testing.

## Local development

Test changes to your dynamic dispatch Worker by running the dispatch Worker locally but connecting it to user Workers that have been deployed to Cloudflare. Consider using a **staging namespace** to test changes safely before deploying to production.

This is helpful when:

- **Testing routing changes** and validating that updates continue to work with deployed user Workers.
- **Adding new middleware** (authentication, rate limiting, or logging) to the dynamic dispatch Worker.
- **Debugging issues** in the dynamic dispatcher that may be impacting deployed user Workers.

## How to use remote dispatch namespaces

In the dynamic dispatch Worker's Wrangler file, configure the dispatch-namespace binding to connect to the remote namespace by setting `remote = true`:

```jsonc
// wrangler.jsonc
{
  "dispatch_namespaces": [
    {
      "binding": "DISPATCH_NAMESPACE",
      "namespace": "production",
      "remote": true
    }
  ]
}
```

```toml
# wrangler.toml
[[dispatch_namespaces]]
binding = "DISPATCH_NAMESPACE"
namespace = "production"
remote = true
```

This tells the dispatch Worker running locally to connect to the remote `production` namespace. When you run `wrangler dev`, your dispatch Worker routes requests to the user Workers deployed in that namespace.

Source: [Local development](https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/reference/local-development/) retrieved 2026-07-02, content hash `b3cfa35a`.
