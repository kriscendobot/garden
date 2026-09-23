---
title: "Workers for Platforms limits: scripts, cf object, cache, tags, deployments, and API rate limits"
source_kind: web
source_url: https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/reference/limits/
source_content_sha256: bad44569fe583dbb154c062a9b76def9f3a4fcde20f942a6fdc2457770740fb5
source_authors: [Cloudflare Docs]
source_date: 2026-04-21
retrieved: 2026-07-02
ingested: 2026-07-02
ingested_by: scholar
topics: [multi-tenant-platform]
status: current
notes: "Living vendor docs (developers.cloudflare.com). Idempotency anchor is source_content_sha256 over the page's `.md` rendering (append `index.md`). Several caps are cross-references into the isolation and tags sections (cloudflare-w4p--worker-isolation--modes, cloudflare-w4p--tags--overview)."
---

Abstract: The platform-wide **limits** for Workers for Platforms and the isolation-driven restrictions on Cloudflare request objects. Scripts and Durable Object namespaces are **unlimited**. For tenant isolation, the `request.cf` object is **inaccessible in user Workers by default** (some fields such as `cacheKey`, `resolveOverride`, `scrapeShield` can manipulate Cloudflare features), reachable only by enabling **trusted mode** on the namespace; and `caches.default` is **disabled for namespaced scripts**. Each script may carry **at most eight tags** (avoid `,` and `&`). **Gradual Deployments are not yet supported** for user Workers (every change deploys all-at-once to 100% of traffic). Finally, the Cloudflare **API rate limits**: 1,200 client-API requests / 5 min per user/account token (cumulative across dashboard, API key, and token; a `429` blocks all calls for the next five minutes), 200/second per IP, GraphQL capped by query cost (max 320 / 5 min), a 50 user-API-token quota, and a 500 account-API-token quota. Increases go through the Limit Increase Request Form; Enterprise customers can contact Support.

## Script limits

Cloudflare provides an unlimited number of scripts for Workers for Platforms customers.

## `cf` object

The `cf` object contains Cloudflare-specific properties of a request. This field is **not accessible in user Workers by default** because some fields are sensitive and can be used to manipulate Cloudflare features (for example, `cacheKey`, `resolveOverride`, `scrapeShield`).

To access the `cf` object, enable **trusted mode** for your namespace. Only enable this if you control all Worker code in the namespace. (See [Worker isolation: untrusted (default) versus trusted mode](cloudflare-w4p--worker-isolation--modes.md).)

## Durable Object namespace limits

Workers for Platforms do not have a limit for the number of Durable Object namespaces.

## Cache API

For isolation, `caches.default` is **disabled for namespaced scripts**.

## Tags

You can set a maximum of **eight tags per script**. Avoid special characters like `,` and `&` when naming a tag. (See [Tags: organize, search, filter, and bulk-manage user Workers](cloudflare-w4p--tags--overview.md).)

To request an adjustment to a limit, complete the Limit Increase Request Form. If the limit can be increased, Cloudflare will contact you with next steps.

## Gradual Deployments

Gradual Deployments are **not supported yet** for user Workers. Changes made to user Workers create a new version that is deployed all-at-once to 100% of traffic.

## API Rate Limits

| Type                              | Limit                               |
| --------------------------------- | ----------------------------------- |
| Client API per user/account token | 1200 / 5 minutes                    |
| Client API per IP                 | 200 / second                        |
| GraphQL                           | Varies by query cost. Max 320 / 5 min |
| User API token quota              | 50                                  |
| Account API token quota           | 500                                 |

The global rate limit for the Cloudflare API is **1,200 requests per five-minute period per user**, and applies cumulatively regardless of whether the request is made via the dashboard, API key, or API token. If you exceed this limit, all API calls for the next five minutes are blocked with `HTTP 429 - Too Many Requests`.

Some specific API calls have their own separately-documented limits (Cache Purge, GraphQL, Rulesets, Lists, Gateway Lists). Enterprise customers can contact Cloudflare Support to raise the Client API per user, GraphQL, or API token limits.

Source: [Limits](https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/reference/limits/) retrieved 2026-07-02, content hash `bad44569`.
