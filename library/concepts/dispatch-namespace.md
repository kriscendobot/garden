---
id: dispatch-namespace
aliases: [dispatch namespace, dispatch namespaces, dispatch_namespaces, DISPATCHER binding, dispatch namespace binding, env.DISPATCHER.get]
topics: [multi-tenant-platform]
---

# dispatch-namespace

In Cloudflare Workers for Platforms, the **dispatch namespace** is the container that holds all of a platform's customers' Workers. The platform deploys each customer's code as a **user Worker** into a namespace (for example `production` or `staging`) via an API request. A namespace gives an unlimited number of Workers (no per-account script limits), isolation by default (each user Worker runs in untrusted mode, never shares a cache, and cannot read `request.cf`), and dynamic invocation: a dynamic dispatch Worker with a **dispatch namespace binding** (`dispatch_namespaces` in Wrangler, conventionally bound as `DISPATCHER`) calls any Worker in the namespace by name with `env.DISPATCHER.get("worker-name")`. Best practice is one namespace for all customers, not one per customer.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [Dispatch namespace: the container for customer Workers](../sections/cloudflare-w4p--how-it-works--dispatch-namespace.md) | The container's three properties: unlimited Workers, isolation by default, dynamic invocation. |
| [Dynamic dispatch Worker: why, and the dispatch namespace binding](../sections/cloudflare-w4p--dynamic-dispatch--binding-and-configuration.md) | Declaring the `dispatch_namespaces` binding in Wrangler. |
| [Worker isolation: untrusted (default) versus trusted mode](../sections/cloudflare-w4p--worker-isolation--modes.md) | The namespace's untrusted/trusted isolation modes. |

## See also

- [[dynamic-dispatch-worker]] — invokes user Workers in the namespace via the binding.
- [[workers-for-platforms]] — the product the namespace belongs to.
