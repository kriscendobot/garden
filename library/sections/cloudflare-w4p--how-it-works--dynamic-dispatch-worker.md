---
title: "Dynamic dispatch Worker: the platform's request entry point"
source_kind: web
source_url: https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/how-workers-for-platforms-works/
source_content_sha256: 46b14522867d0b338a4ba7c8cfa9708c0f21b754aa9dd44cf1e8f050197ea2d9
source_authors: [Cloudflare Docs]
source_date: 2026-04-21
retrieved: 2026-07-01
ingested: 2026-07-01
ingested_by: scholar
topics: [multi-tenant-platform]
status: current
notes: "Living vendor docs (developers.cloudflare.com). Idempotency anchor is source_content_sha256 over the page's `.md` rendering."
---

Abstract: A **dynamic dispatch Worker** is the entry point for all requests to the platform. It is a specialized routing Worker that determines which customer Worker should handle each request (based on hostname, path, headers, or any other criteria), runs platform logic before customer code runs (authentication, rate limiting, request validation), sets per-customer custom limits on CPU time and subrequests based on plan type, and sanitizes responses (modifies or filters responses coming back from customer Workers). It invokes a user Worker through a **dispatch namespace binding**: `env.DISPATCHER.get(name)` returns a stub whose `.fetch(request)` runs the named customer Worker. This is what makes routing programmable code rather than static route configuration.

## Dynamic dispatch Worker

A dynamic dispatch Worker is the entry point for all requests to your platform. Your dynamic dispatch Worker:

- **Routes requests** — determines which customer Worker should handle each request based on hostname, path, headers, or any other criteria.
- **Runs platform logic** — executes authentication, rate limiting, or request validation before customer code runs.
- **Sets per-customer limits** — enforces [custom limits](cloudflare-w4p--custom-limits--overview.md) on CPU time and subrequests based on plan type.
- **Sanitizes responses** — modifies or filters responses from customer Workers.

The dynamic dispatch Worker uses a [dispatch namespace binding](cloudflare-w4p--dynamic-dispatch--binding-and-configuration.md) to invoke user Workers:

```js
export default {
  async fetch(request, env) {
    // Determine which customer Worker to call
    const customerName = new URL(request.url).hostname.split(".")[0];

    // Get and invoke the customer's Worker
    const userWorker = env.DISPATCHER.get(customerName);
    return userWorker.fetch(request);
  },
};
```

Source: [How Workers for Platforms works](https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/how-workers-for-platforms-works/) retrieved 2026-07-01, content hash `46b14522`.
