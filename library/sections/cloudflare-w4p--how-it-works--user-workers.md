---
title: "User Workers: customer code deployed into the namespace"
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

Abstract: **User Workers** contain the code written by a platform's customers. The customer sends their code to the platform, and the platform makes an API request to deploy a user Worker on the customer's behalf into a dispatch namespace. User Workers are invoked by the dynamic dispatch Worker (never routed to directly), and the platform can grant them **bindings** to access KV, D1, R2, and other Cloudflare resources — the mechanism by which the operator extends Cloudflare's developer platform to its customers under the operator's control. The deploy-and-invoke split (customer authors code, operator uploads it, dispatcher routes to it) is the tenant-code boundary: the operator, not the customer, holds the deployment credentials and decides which resources each user Worker can reach.

## User Workers

User Workers contain code written by your customers. Your customer sends their code to your platform, and then you make an API request to deploy a user Worker on their behalf. User Workers are deployed to a dispatch namespace and invoked by your dynamic dispatch Worker. You can provide user Workers with [bindings](https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/configuration/bindings/) to access KV, D1, R2, and other Cloudflare resources.

## Workers for Platforms versus Service bindings

Both Workers for Platforms and Service bindings enable Worker-to-Worker communication. Use Service bindings when you know exactly which Workers need to communicate. Use Workers for Platforms when user Workers are uploaded dynamically by your customers. You can use both simultaneously: your dynamic dispatch Worker can use Service bindings to call internal services while also dispatching to user Workers in a namespace.

Source: [How Workers for Platforms works](https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/how-workers-for-platforms-works/) retrieved 2026-07-01, content hash `46b14522`.
