---
title: "Dynamic dispatch Worker: why, and the dispatch namespace binding"
source_kind: web
source_url: https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/configuration/dynamic-dispatch/
source_content_sha256: 4bee0daaca0f986e09b0aa6648f333f63ab79ba296a2f1d777ae72e4ebee6582
source_authors: [Cloudflare Docs]
source_date: 2026-04-21
retrieved: 2026-07-01
ingested: 2026-07-01
ingested_by: scholar
topics: [multi-tenant-platform]
status: current
notes: "Living vendor docs (developers.cloudflare.com). Idempotency anchor is source_content_sha256 over the page's `.md` rendering."
---

Abstract: The dynamic dispatch Worker is a specialized routing Worker that directs incoming requests to the appropriate user Workers in a dispatch namespace; instead of static Workers Routes, it lets the platform control routing programmatically through code. It exists for scale (route requests to millions of hostnames to different Workers without per-hostname route configuration), custom routing logic (store hostname-to-Worker mappings in Workers KV and look them up dynamically; route on subdomain, path, headers, or custom-hostname metadata), and platform functionality at the routing layer (authentication checks before requests reach user Workers, header/metadata rewriting, attaching context like user IDs, request/response transformation). To route into a namespace it needs a **dispatch namespace binding** declared in the Wrangler configuration (`dispatch_namespaces` with a `binding` name such as `DISPATCHER` and the target `namespace`); once configured, the Worker calls `env.dispatcher.get()` (or `env.DISPATCHER.get()`) to invoke any Worker in that namespace.

## Why use a dynamic dispatch Worker?

- **Scale** — route requests to millions of hostnames to different Workers, without defining Workers Routes configuration for each one.
- **Custom routing logic** — write code to determine exactly how requests should be routed. For example: store hostname-to-Worker mappings in Workers KV and look them up dynamically; route requests based on subdomain, path, headers, or other request properties; use custom metadata attached to custom hostnames for routing decisions.
- **Add platform functionality** — build additional features at the routing layer: run authentication checks before requests reach user Workers; remove or add headers or metadata from incoming requests; attach useful context like user IDs or account information; transform requests or responses as needed.

You can also create a dispatch Worker from the Cloudflare dashboard (**Workers for Platforms** → select namespace → **Create** → **Dispatch Worker**), which provides templates for path-based and subdomain-based routing.

## Configure the dispatch namespace binding

To allow your dynamic dispatch Worker to dynamically route requests to Workers in a namespace, configure a dispatch namespace binding. This binding enables the Worker to call any user Worker within that namespace using `env.dispatcher.get()`.

```jsonc
// wrangler.jsonc
{
  "dispatch_namespaces": [
    {
      "binding": "DISPATCHER",
      "namespace": "my-dispatch-namespace"
    }
  ]
}
```

```toml
# wrangler.toml
[[dispatch_namespaces]]
binding = "DISPATCHER"
namespace = "my-dispatch-namespace"
```

Once the binding is configured, your dynamic dispatch Worker can route requests to any Worker in the namespace.

Source: [Dynamic dispatch Worker](https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/configuration/dynamic-dispatch/) retrieved 2026-07-01, content hash `4bee0daa`.
