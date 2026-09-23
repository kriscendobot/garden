---
title: "Hostname routing: the recommended wildcard route with a dispatch Worker"
source_kind: web
source_url: https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/configuration/hostname-routing/
source_content_sha256: 48eaef15584da67bf4ed5c23dfe4a5099cc764bd295349ee4e2e2cada1973631
source_authors: [Cloudflare Docs]
source_date: 2026-04-21
retrieved: 2026-07-01
ingested: 2026-07-01
ingested_by: scholar
topics: [multi-tenant-platform]
status: current
notes: "Living vendor docs (developers.cloudflare.com). Idempotency anchor is source_content_sha256 over the page's `.md` rendering (append `index.md`)."
---

Abstract: How a platform routes **millions of vanity domains or subdomains** to user Workers without hitting Workers' traditional route limits: configure a single **wildcard `*/*` route** on the SaaS domain pointing at the dynamic dispatch Worker, and do all per-hostname routing **in code** rather than as individual routes. The recommended pattern because one route handles both platform subdomains (`customer1.myplatform.com`) and end-customer custom hostnames (`shop.customer.com`) with the same logic, avoids route limits, and lets the dispatcher route on hostname, path, KV lookups, or custom-hostname metadata. Setup ties together Cloudflare for SaaS custom hostnames, a fallback origin (a dummy DNS record when the Worker is the origin), CNAME DNS, the `*/*` route, and dispatch logic. Because `*/*` sends *all* inbound traffic to the dispatcher, exclude hostnames by adding no-Worker routes or using a dedicated domain.

## (Recommended) Wildcard route with a dispatch Worker

Configure a wildcard [Route](https://developers.cloudflare.com/workers/configuration/routing/routes/) (`*/*`) on your SaaS domain (the domain where you configure custom hostnames) to point to your dynamic dispatch Worker. This allows you to:

- **Support both subdomains and vanity domains**: handle `customer1.myplatform.com` (subdomain) and `shop.customer.com` (custom hostname) with the same routing logic.
- **Avoid route limits**: instead of creating individual routes for every domain (which can cause you to hit Routes limits), handle the routing logic in code and proxy millions of domains to individual Workers.
- **Programmatically control routing logic**: write custom code to route requests based on hostname, custom metadata, path, or any other properties.

> **Note.** This will route all traffic inbound to the domain to the dispatch Worker. To exclude certain hostnames, either add routes without a Worker specification (to opt certain hostnames or paths out of the dispatcher Worker, for example `saas.com`, `api.saas.com`), or use a dedicated domain (for example `customers.saas.com`) for custom-hostname and dispatch-Worker management to keep the rest of that domain's traffic separate.

### Setup

1. **Configure custom hostnames**: set up your domain and custom hostnames using Cloudflare for SaaS.
2. **Set the fallback origin**: set up a fallback origin server (where all custom hostnames route). Requests route through the Worker before reaching the origin. If the Worker is the origin, place a dummy DNS record for the fallback origin (for example, `A 192.0.2.0`).
3. **Configure DNS**: point DNS records (subdomains or custom hostname) via CNAME to the SaaS domain. If customers must proxy their apex hostname and cannot use CNAME records, use Apex Proxying.
4. **Create wildcard route**: add a `*/*` route on your platform domain (for example `saas.com`) and associate it with your dispatch Worker.
5. **Implement dispatch logic**: add logic to route based on hostname, look up mappings stored in Workers KV, or use custom metadata attached to custom hostnames.

> **Note.** If you plan to route based on custom metadata, create subdomains (for example `customer1.saas.com`) as custom hostnames — DNS records do not support custom metadata.

#### Example dispatch Worker

```js
export default {
  async fetch(request, env) {
    const hostname = new URL(request.url).hostname;

    // Get custom hostname metadata for routing decisions
    const hostnameData = await env.KV.get(`hostname:${hostname}`, {
      type: "json",
    });

    if (!hostnameData?.workerName) {
      return new Response("Hostname not configured", { status: 404 });
    }

    // Route to the appropriate user Worker
    const userWorker = env.DISPATCHER.get(hostnameData.workerName);
    return await userWorker.fetch(request);
  },
};
```

Source: [Hostname routing](https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/configuration/hostname-routing/) retrieved 2026-07-01, content hash `48eaef15`.
