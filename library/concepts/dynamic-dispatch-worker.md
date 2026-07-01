---
id: dynamic-dispatch-worker
aliases: [dynamic dispatch Worker, dispatch Worker, dynamic dispatcher, DISPATCHER.get, dispatcher.get]
topics: [multi-tenant-platform]
---

# dynamic-dispatch-worker

In Cloudflare Workers for Platforms, the **dynamic dispatch Worker** is the entry point for all requests to a platform: a specialized routing Worker that programmatically directs each incoming request to the appropriate user Worker in a dispatch namespace (via `env.DISPATCHER.get(name).fetch(request)`), instead of static Workers Routes. Besides routing (by hostname, path, headers, KV lookup, or custom-hostname metadata), it runs platform logic before customer code (authentication, rate limiting, validation), sets per-customer custom limits (CPU time, subrequests) as the third argument to `get()`, and can sanitize responses. It requires a dispatch namespace binding to reach the namespace.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [Dynamic dispatch Worker: the platform's request entry point](../sections/cloudflare-w4p--how-it-works--dynamic-dispatch-worker.md) | Its four responsibilities and the `env.DISPATCHER.get()` invocation. |
| [Dynamic dispatch Worker: why, and the dispatch namespace binding](../sections/cloudflare-w4p--dynamic-dispatch--binding-and-configuration.md) | Why programmable dispatch, and the Wrangler binding. |
| [Dispatch routing patterns and enforcing custom limits](../sections/cloudflare-w4p--dynamic-dispatch--routing-patterns.md) | KV/subdomain/path routing patterns and enforcing limits. |

## See also

- [[dispatch-namespace]] — what the dispatcher routes into.
- [[outbound-worker]] — the egress counterpart configured on the same binding.
- [[workers-for-platforms]] — the product.
