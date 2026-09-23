---
title: "Request lifecycle and the optional outbound Worker"
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

Abstract: The end-to-end request lifecycle ties the four Workers-for-Platforms components together. A request arrives at the dynamic dispatch Worker (for example `customer-a.example.com/api`); the dispatcher decides which user Worker should handle it and calls `env.DISPATCHER.get("customer-a")` to obtain the stub; the user Worker executes; if it makes external `fetch()` calls and an **outbound Worker** is configured, those requests pass through the outbound Worker first (the platform's egress-control interception point); the user Worker returns a response; and the dynamic dispatch Worker can optionally modify that response before returning it. The outbound Worker is optional and sits on the egress path only — it lets the platform block or allow external API calls, log what external services customers call, and add authentication headers or transform requests before they leave the platform.

## Outbound Worker (optional)

An [outbound Worker](cloudflare-w4p--outbound-workers--overview.md) intercepts `fetch()` requests made by user Workers. Use it to:

- **Control egress** — block or allow external API calls from customer code.
- **Log requests** — track what external services customers are calling.
- **Modify requests** — add authentication headers or transform requests before they leave your platform.

## Request lifecycle

1. A request arrives at your dynamic dispatch Worker (for example, `customer-a.example.com/api`).
2. Your dynamic dispatch Worker determines which user Worker should handle the request.
3. The dynamic dispatch Worker calls `env.DISPATCHER.get("customer-a")` to get the user Worker.
4. The user Worker executes. If it makes external `fetch()` calls and an outbound Worker is configured, those requests pass through the outbound Worker first.
5. The user Worker returns a response.
6. Your dynamic dispatch Worker can optionally modify the response before returning it.

Source: [How Workers for Platforms works](https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/how-workers-for-platforms-works/) retrieved 2026-07-01, content hash `46b14522`.
