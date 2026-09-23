---
title: "Dispatch namespace: the container for customer Workers"
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

Abstract: A **dispatch namespace** is the container that holds all of a platform's customers' Workers. The platform takes the code its customers write and makes an API request to deploy that code as a **user Worker** into a namespace (for example `staging` or `production`). Compared to plain Workers, a namespace provides three things: an **unlimited number of Workers** (no per-account script limits apply inside a namespace), **isolation by default** (each user Worker runs in untrusted mode, never shares a cache even on the same Cloudflare zone, and cannot access the `request.cf` object), and **dynamic invocation** (the dynamic dispatch Worker can call any Worker in the namespace by name with `env.DISPATCHER.get("worker-name")`). Best practice is one namespace for all customers (for example `production`), not a namespace per customer; create a separate `staging` namespace only to test changes safely.

## Dispatch namespace

A dispatch namespace is a container that holds all of your customers' Workers. Your platform takes the code your customers write, and then makes an API request to deploy that code as a user Worker to a namespace — for example `staging` or `production`. Compared to Workers, this provides:

- **Unlimited number of Workers** — no per-account script limits apply to Workers in a namespace.
- **Isolation by default** — each user Worker in a namespace runs in [untrusted mode](cloudflare-w4p--worker-isolation--modes.md) — user Workers never share a cache even when running on the same Cloudflare zone, and cannot access the `request.cf` object.
- **Dynamic invocation** — your dynamic dispatch Worker can call any Worker in the namespace using `env.DISPATCHER.get("worker-name")`.

### Best practice

All your customers' Workers should live in a single namespace (for example, `production`). Do not create a namespace per customer. If you need to test changes safely, create a separate `staging` namespace.

Source: [How Workers for Platforms works](https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/how-workers-for-platforms-works/) retrieved 2026-07-01, content hash `46b14522`.
