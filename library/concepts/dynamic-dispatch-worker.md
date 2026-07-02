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
| [Get started: deploy a Workers for Platforms starter kit](../sections/cloudflare-w4p--get-started--overview.md) | The template's dispatch Worker routes by URL path via `env.DISPATCHER.get(workerName)`. |
| [Hostname routing: the recommended wildcard route with a dispatch Worker](../sections/cloudflare-w4p--configuration-hostname-routing--wildcard-route.md) | A single wildcard `*/*` route sends all traffic to the dispatch Worker, which routes millions of hostnames in code. |
| [Subdomain routing and Orange-to-Orange (O2O) invocation behavior](../sections/cloudflare-w4p--configuration-hostname-routing--subdomain-routing-and-o2o.md) | The `*.saas.com/*` subdomain route to the dispatch Worker and the O2O proxy-mode invocation caveat. |
| [Local development: test the dispatch Worker locally against a remote namespace](../sections/cloudflare-w4p--local-development--overview.md) | Iterate on the dispatch Worker under wrangler dev while it invokes already-deployed user Workers. |

## See also

- [[dispatch-namespace]] — what the dispatcher routes into.
- [[outbound-worker]] — the egress counterpart configured on the same binding.
- [[workers-for-platforms]] — the product.
