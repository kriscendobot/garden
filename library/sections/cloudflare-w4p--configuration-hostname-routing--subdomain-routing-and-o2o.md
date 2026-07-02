---
title: "Subdomain routing and Orange-to-Orange (O2O) invocation behavior"
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

Abstract: The narrower subdomain-only routing pattern and the **Orange-to-Orange (O2O)** invocation caveat. When a platform only needs to route subdomain records (`customer1.saas.com`), a more specific `*.saas.com/*` route to the dispatch Worker suffices, backed by an orange-clouded wildcard DNS record. The O2O subtlety: when a customer is *also* on Cloudflare and CNAMEs their custom domain to the SaaS domain, whether the Worker is invoked depends on which side's DNS is proxied (orange cloud) versus DNS-only (grey cloud) — routing on the CNAME target requires the custom hostname be orange-clouded, routing on the custom hostname requires it be grey-clouded. Because the platform rarely controls the customer's proxy setting, the `*/*` wildcard route (previous section) is recommended: it invokes the Worker in every proxy-mode combination, where the two specific-route patterns each miss one.

## Subdomain routing

If you're only looking to route subdomain records (for example `customer1.saas.com`), you can use a more specific route (`*.saas.com/*`) to route requests to your dispatch Worker.

### Setup

1. Create an orange-clouded wildcard DNS record `*.saas.com` that points to the origin. If the Worker is the origin, use a dummy DNS value (for example `A 192.0.2.0`).
2. Set a wildcard route `*.saas.com/*` pointing to your dispatch Worker.
3. Add logic to the dispatch Worker to route subdomain requests to the right Worker.

#### Example subdomain dispatch Worker

```js
export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    const subdomain = url.hostname.split(".")[0];

    // Route based on subdomain
    if (subdomain && subdomain !== "saas") {
      const userWorker = env.DISPATCHER.get(subdomain);
      return await userWorker.fetch(request);
    }

    return new Response("Invalid subdomain", { status: 400 });
  },
};
```

### O2O behavior

When your customers are also using Cloudflare and point their custom domain to your SaaS domain via CNAME (for example `mystore.com` → `saas.com`), Worker routing behavior depends on whether the customer's DNS record is proxied (orange cloud) or DNS-only (grey cloud). This can cause inconsistent behavior when using specific hostname routes:

- If you're routing based on the CNAME target (`saas.com`), the custom hostname's DNS record must be orange-clouded for the Worker to be invoked.
- If you're routing based on the custom hostname (`mystore.com`), the customer's record must be grey-clouded for the Worker to be invoked.

Since you may not have control over your customer's DNS proxy settings, Cloudflare recommends the `*/*` wildcard route to ensure routing logic always works regardless of how DNS is configured.

#### Worker invocation across route configurations and proxy modes

| Route Pattern         | Custom Hostname (Orange Cloud) | Custom Hostname (Grey Cloud) |
| --------------------- | ------------------------------ | ---------------------------- |
| `*/*` (Recommended)   | ✅                              | ✅                            |
| Target hostname route | ✅                              | ❌                            |
| Custom hostname route | ❌                              | ✅                            |

Source: [Hostname routing](https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/configuration/hostname-routing/) retrieved 2026-07-01, content hash `48eaef15`.
