---
title: "Outbound Workers: egress interception and control"
source_kind: web
source_url: https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/configuration/outbound-workers/
source_content_sha256: 65ffd3ad75ecf9da706667ed5ed65d2b7904acdaf62688a3c86a66f360f7171e
source_authors: [Cloudflare Docs]
source_date: 2026-04-21
retrieved: 2026-07-01
ingested: 2026-07-01
ingested_by: scholar
topics: [multi-tenant-platform]
status: current
notes: "Living vendor docs (developers.cloudflare.com). Idempotency anchor is source_content_sha256 over the page's `.md` rendering."
---

Abstract: An **outbound Worker** sits between a customer's user Workers and the public Internet, giving the platform visibility into and control over every outgoing `fetch()` request from user Workers (the egress-control boundary). Use cases: log all subrequests to identify malicious domains or usage patterns; maintain allow/block lists for hostnames user Workers may request; and inject authentication to the platform's own APIs behind the scenes so end developers never handle credentials. It is configured as an optional `outbound` parameter on the `dispatch_namespaces` binding in Wrangler (naming a `service` and optional `parameters` to pass context from the dispatcher), and the dispatcher passes per-request context through `dispatcher.get(name, {}, { outbound: { ... } })`; the outbound Worker reads that context from `env`. Two important boundaries: enabling an outbound Worker **disables the `connect()` TCP-socket API** in customer Workers (so all outbound traffic must go through the outbound Worker's `fetch`), and outbound Workers do **not** intercept fetches made from Durable Objects or mTLS certificate bindings.

## Outbound Workers

Outbound Workers sit between your customer's Workers and the public Internet. They give you visibility into all outgoing `fetch()` requests from user Workers.

### General use cases

- Log all subrequests to identify malicious domains or usage patterns.
- Create allow or block lists for hostnames requested by user Workers.
- Configure authentication to your APIs behind the scenes (without end developers needing to set credentials).

When an outbound Worker is enabled, your customer's Worker will no longer be able to use the `connect()` API to create outbound TCP sockets. This ensures all outbound communication goes through the outbound Worker's `fetch` method.

## Use outbound Workers

1. Create a Worker intended to serve as your outbound Worker.
2. Specify the outbound Worker as an optional parameter in the `dispatch_namespaces` binding in the project's Wrangler configuration file. Optionally, to pass data from the dynamic dispatch Worker to the outbound Worker, name the variables under `parameters`. (Requires `wrangler@3.3.0` or later.)

```jsonc
// wrangler.jsonc
{
  "dispatch_namespaces": [
    {
      "binding": "dispatcher",
      "namespace": "<NAMESPACE_NAME>",
      "outbound": {
        "service": "<SERVICE_NAME>",
        "parameters": ["params_object"]
      }
    }
  ]
}
```

3. Edit the dynamic dispatch Worker to call the outbound Worker and declare variables to pass on `dispatcher.get()`:

```js
let context_from_dispatcher = { customer_name: workerName, url: request.url };
let userWorker = env.dispatcher.get(
  workerName,
  {},
  {
    // outbound arguments; object name must match parameters in the binding
    outbound: { params_object: context_from_dispatcher },
  },
);
return await userWorker.fetch(request);
```

4. The outbound Worker is now invoked on any `fetch()` request from a user Worker (the user Worker triggers a `FetchEvent` on the outbound Worker). The variables declared in the binding are read through `env.<VAR_NAME>`. A typical outbound Worker logs the request and can, for example, mint a JWT and attach an `Authorization` header when the request targets the platform's own API host before forwarding it.

Outbound Workers do not intercept fetch requests made from Durable Objects or mTLS certificate bindings.

Source: [Outbound Workers](https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/configuration/outbound-workers/) retrieved 2026-07-01, content hash `65ffd3ad`.
