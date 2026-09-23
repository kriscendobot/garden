---
title: "Worker isolation: untrusted (default) versus trusted mode"
source_kind: web
source_url: https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/reference/worker-isolation/
source_content_sha256: 10fe5de6c7ffd3ed50c275561810526aeb796ee00f226dbb37be06411399d6d4
source_authors: [Cloudflare Docs]
source_date: 2026-04-21
retrieved: 2026-07-01
ingested: 2026-07-01
ingested_by: scholar
topics: [multi-tenant-platform]
status: current
notes: "Living vendor docs (developers.cloudflare.com). Idempotency anchor is source_content_sha256 over the page's `.md` rendering."
---

Abstract: A dispatch namespace has two isolation modes that set the security boundary between tenant Workers. **Untrusted mode (the default)** provides the strongest isolation and is meant for when customers control the deployed code: the `request.cf` object is unavailable, each Worker has an isolated cache (via the Cache API or `fetch()` subrequests egressing through Cloudflare's cache), and `caches.default` is disabled for all Workers in the namespace — ensuring complete isolation and preventing cross-tenant data access. **Trusted mode** relaxes isolation for internal platforms where the operator controls all Worker code: `request.cf` becomes available and all Workers in the namespace share the same cache space, meaning a Worker can potentially read another Worker's cached responses. Trusted mode is set per namespace via the API (`trusted_workers: true` on the namespace); already-deployed Workers must be redeployed for `request.cf` to appear. To keep cache isolation while still getting `request.cf`, use customer-specific cache keys or the Cache API with isolated keys.

## Untrusted mode (default)

By default, Workers inside a dispatch namespace are considered "untrusted." This provides the strongest isolation between Workers and is best when your customers control the code being deployed. In untrusted mode:

- The `request.cf` object is not available in Workers.
- Each Worker has an isolated cache, when using the Cache API or when making subrequests using `fetch()` that egress via Cloudflare's cache.
- `caches.default` is disabled for all Workers in the namespace.

This mode ensures complete isolation between customer Workers, preventing any potential cross-tenant data access.

## Trusted mode

If you control the Worker code and want to disable isolation mode, configure the namespace as "trusted." This is useful when building internal platforms where your company controls all Worker code. In trusted mode:

- The `request.cf` object becomes available, providing access to request metadata.
- All Workers in the namespace share the same cache space when using the Cache API.

In trusted mode, Workers can potentially access cached responses from other Workers in the namespace. Only enable this if you control all Worker code or have appropriate cache-key isolation strategies. Convert a namespace to trusted via the API:

```bash
curl -X PUT "https://api.cloudflare.com/client/v4/accounts/{account_id}/workers/dispatch/namespaces/{namespace_name}" \
  -H "Authorization: Bearer {api_token}" \
  -H "Content-Type: application/json" \
  -d '{ "name": "{namespace_name}", "trusted_workers": true }'
```

If you enable trusted mode for a namespace that already has deployed Workers, you must redeploy those Workers for the `request.cf` object to become available. Any Workers deployed after enabling trusted mode automatically have access to it.

## Maintaining cache isolation in trusted mode

If you need access to `request.cf` but want to maintain cache isolation between customers, use customer-specific cache keys or the Cache API with isolated keys.

Source: [Worker Isolation](https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/reference/worker-isolation/) retrieved 2026-07-01, content hash `10fe5de6`.
