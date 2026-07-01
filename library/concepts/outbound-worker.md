---
id: outbound-worker
aliases: [outbound Worker, outbound Workers, egress control, egress interception, outbound binding]
topics: [multi-tenant-platform]
---

# outbound-worker

In Cloudflare Workers for Platforms, an **outbound Worker** is an optional Worker that sits between a customer's user Workers and the public Internet, intercepting every outgoing `fetch()` request they make. It is the platform's egress-control point: log all subrequests (spotting malicious domains or usage patterns), enforce allow/block lists of hostnames, and inject authentication to the platform's own APIs so end developers never handle credentials. It is wired in as an optional `outbound` parameter on the `dispatch_namespaces` binding (naming a `service` and optional `parameters`), and the dispatcher passes per-request context via `dispatcher.get(name, {}, { outbound: {...} })`. Enabling it disables the `connect()` TCP-socket API in customer Workers (forcing all egress through the outbound Worker's `fetch`); it does not intercept Durable Object or mTLS-binding fetches.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [Outbound Workers: egress interception and control](../sections/cloudflare-w4p--outbound-workers--overview.md) | Use cases, wiring, per-request context, and the two boundaries. |
| [Request lifecycle and the optional outbound Worker](../sections/cloudflare-w4p--how-it-works--request-lifecycle.md) | Where the outbound Worker sits on the egress path in the request flow. |

## See also

- [[dynamic-dispatch-worker]] — configures the outbound Worker on the dispatch binding.
- [[workers-for-platforms]] — the product.
