---
title: "Custom limits: per-customer CPU-time and subrequest caps"
source_kind: web
source_url: https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/configuration/custom-limits/
source_content_sha256: c666c0cc74970908a40884e9200fa61b10d6005b7d88ab09ec5800808f72579b
source_authors: [Cloudflare Docs]
source_date: 2026-04-21
retrieved: 2026-07-01
ingested: 2026-07-01
ingested_by: scholar
topics: [multi-tenant-platform]
status: current
notes: "Living vendor docs (developers.cloudflare.com). Idempotency anchor is source_content_sha256 over the page's `.md` rendering."
---

Abstract: **Custom limits** let a platform programmatically cap each customer Worker's resource usage: the maximum **CPU time** (`cpuMs`) and the maximum number of **subrequests** (`subRequests`), enforced **per invocation**. If a user Worker hits either limit, it immediately throws an exception. Limits are set in the dynamic dispatch Worker as the third argument to `env.dispatcher.get(name, {}, { limits: { cpuMs, subRequests } })`, so the operator can choose different caps per request (for example, by customer plan type). This is the platform's mechanism for bounding a tenant's blast radius on shared infrastructure without trusting the tenant's own code to self-limit.

## Custom limits

Custom limits allow you to programmatically enforce limits on your customers' Workers' resource usage. You can set limits for the maximum CPU time and number of subrequests per invocation. If a user Worker hits either of these limits, the user Worker will immediately throw an exception.

## Set custom limits

Custom limits can be set in the dynamic dispatch Worker:

```js
export default {
  async fetch(request, env) {
    try {
      // parse the URL, read the subdomain
      let workerName = new URL(request.url).host.split(".")[0];
      let userWorker = env.dispatcher.get(
        workerName,
        {},
        {
          // set limits
          limits: { cpuMs: 10, subRequests: 5 },
        },
      );
      return await userWorker.fetch(request);
    } catch (e) {
      if (e.message.startsWith("Worker not found")) {
        // we tried to get a worker that doesn't exist in our dispatch namespace
        return new Response("", { status: 404 });
      }
      return new Response(e.message, { status: 500 });
    }
  },
};
```

Source: [Custom limits](https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/configuration/custom-limits/) retrieved 2026-07-01, content hash `c666c0cc`.
