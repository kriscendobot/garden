---
title: "Dispatch routing patterns and enforcing custom limits"
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

Abstract: Three common routing patterns run inside the dynamic dispatch Worker, all resolving a request to a user-Worker name and then invoking `env.DISPATCHER.get(name).fetch(request)`. **KV-based routing** stores hostname/path-to-Worker mappings in Workers KV so routing logic changes without redeploying the dispatcher. **Subdomain-based routing** maps `my-customer.example.com` to the Worker named `my-customer`. **Path-based routing** maps `example.com/customer-1` to the Worker named `customer-1`. Error handling checks for a `"Worker not found"` message (return 404 for an unknown Worker) and otherwise surfaces the exception. The same dispatcher also **enforces custom limits**: `env.DISPATCHER.get(name, {}, { limits })` sets per-invocation `cpuMs` and `subRequests` caps, which can be chosen by customer plan type; a `"CPU time limit"` exception can be caught to record a violation (for example via Workers Analytics Engine) and return 429.

## Routing examples

### KV-based routing

Store the routing mappings in Workers KV so you can modify routing logic without redeploying the dynamic dispatch Worker.

```js
export default {
  async fetch(request, env) {
    try {
      const url = new URL(request.url);
      // Use hostname, path, or any combination as the routing key
      const routingKey = url.hostname;
      // Lookup user Worker name from KV store
      const userWorkerName = await env.USER_ROUTING.get(routingKey);
      if (!userWorkerName) {
        return new Response("Route not configured", { status: 404 });
      }
      const userWorker = env.DISPATCHER.get(userWorkerName);
      return await userWorker.fetch(request);
    } catch (e) {
      if (e.message.startsWith("Worker not found")) {
        return new Response("", { status: 404 });
      }
      return new Response(e.message, { status: 500 });
    }
  },
};
```

### Subdomain-based routing

Route subdomains to the corresponding Worker. `my-customer.example.com` routes to the Worker named `my-customer`.

```js
const url = new URL(request.url);
const userWorkerName = url.hostname.split(".")[0];
const userWorker = env.DISPATCHER.get(userWorkerName);
return await userWorker.fetch(request);
```

### Path-based routing

Route URL paths to the corresponding Worker. `example.com/customer-1` routes to the Worker named `customer-1`.

```js
const url = new URL(request.url);
const pathParts = url.pathname.split("/").filter(Boolean);
if (pathParts.length === 0) {
  return new Response("Invalid path", { status: 400 });
}
const userWorkerName = pathParts[0];
const userWorker = env.DISPATCHER.get(userWorkerName);
return await userWorker.fetch(request);
```

## Enforce custom limits

Use [custom limits](cloudflare-w4p--custom-limits--overview.md) to control how much CPU time a given user Worker can use, or how many subrequests it can make. Set different limits based on customer plan type or other criteria.

```js
// Look up customer plan from your database or KV, then:
const plans = {
  enterprise: { cpuMs: 50, subRequests: 50 },
  pro: { cpuMs: 20, subRequests: 20 },
  free: { cpuMs: 10, subRequests: 5 },
};
const limits = plans[customerPlan] || plans.free;
const userWorker = env.DISPATCHER.get(userWorkerName, {}, { limits });
return await userWorker.fetch(request);
// Catch e.message.includes("CPU time limit") to record a violation and return 429.
```

To track limit violations and other metrics across user Workers, use Workers Analytics Engine; for detailed logging and debugging, configure a Tail Worker to capture events from your dispatch Worker.

Source: [Dynamic dispatch Worker](https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/configuration/dynamic-dispatch/) retrieved 2026-07-01, content hash `4bee0daa`.
