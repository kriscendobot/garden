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
| [Get started: deploy a Workers for Platforms starter kit](../sections/cloudflare-w4p--get-started--overview.md) | The template creates a dispatch namespace automatically; the dispatch Worker routes into it by name. |
| [Observability: namespace-wide logs via Logpush and Tail Workers](../sections/cloudflare-w4p--configuration-observability--logs.md) | Logpush/Tail Workers enabled on the dispatch Worker collect logs for every user Worker in the namespace. |
| [Local development: test the dispatch Worker locally against a remote namespace](../sections/cloudflare-w4p--local-development--overview.md) | Point the local dispatch Worker at a remote namespace's deployed user Workers with remote = true. |
| [API examples: deploy a user Worker, and deploy with bindings and tags](../sections/cloudflare-w4p--platform-examples--deploy-and-manage.md) | Uploading a user Worker into the namespace via the REST API / SDK, with optional bindings and tags. |
| [API examples: list Workers in a namespace, delete by tag, and delete a single Worker](../sections/cloudflare-w4p--platform-examples--list-and-delete.md) | Enumerating and removing the namespace's user Workers, including tag-scoped bulk delete. |

## See also

- [[dynamic-dispatch-worker]] — invokes user Workers in the namespace via the binding.
- [[workers-for-platforms]] — the product the namespace belongs to.
