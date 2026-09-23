---
title: "Tags: organize, search, filter, and bulk-manage user Workers"
source_kind: web
source_url: https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/configuration/tags/
source_content_sha256: a6a7fbfd8a8c48be9b7bd939786cdd97918af0c130f67cc2f49d908ca96cb6b6
source_authors: [Cloudflare Docs]
source_date: 2026-04-21
retrieved: 2026-07-01
ingested: 2026-07-01
ingested_by: scholar
topics: [multi-tenant-platform]
status: current
notes: "Living vendor docs (developers.cloudflare.com). Idempotency anchor is source_content_sha256 over the page's `.md` rendering."
---

Abstract: **Tags** organize, search, and filter user Workers at scale. A Worker script can be tagged by customer ID, plan type, project ID, or environment (a maximum of **eight tags per script**; avoid special characters like `,` and `&`). Once tagged, the operator can filter Workers in the namespace view and perform **bulk operations** — most importantly, deleting all Workers matching a tag when a customer leaves the platform. Tags are managed through the Cloudflare dashboard (**Workers for Platforms** → namespace → user Worker → **Settings** → **Tags**) or through the Workers-for-Platforms API: get script tags, set (replace-all) script tags, add a single tag, delete a single tag, list scripts filtered by a `tag:yes`/`tag:no` predicate, and delete scripts matching a tag filter. The filter/bulk-delete-by-tag pair is the multi-tenant lifecycle primitive: a whole customer's fleet of user Workers is addressable as one tag.

## Tags

Use tags to organize, search, and filter user Workers at scale. Tag Workers based on customer ID, plan type, project ID, or environment. After you tag user Workers, you can perform bulk operations like deleting all Workers for a specific customer. You can set a maximum of eight tags per script; avoid special characters like `,` and `&` when naming your tag.

## Add tags via dashboard

Go to **Workers for Platforms** in the Cloudflare dashboard, select your namespace, select a user Worker, go to **Settings** → **Tags**, add your tags (for example, `customer-123`, `pro-plan`, `production`), and select **Save**. You can also search and filter Workers by tags in the namespace view.

## Tags API operations

The Workers-for-Platforms API exposes tag operations under the namespace's scripts subresource:

- **Get script tags** — fetch all tags for a Worker script (`GET .../scripts/$SCRIPT_NAME/tags`).
- **Set script tags** — replace all tags on a script; existing tags not in the request are removed (`PUT .../scripts/$SCRIPT_NAME/tags`).
- **Add a single tag** — add one tag without affecting existing tags (`PUT .../scripts/$SCRIPT_NAME/tags/$TAG`).
- **Delete a single tag** — remove one tag (`DELETE .../scripts/$SCRIPT_NAME/tags/$TAG`).
- **Filter Workers by tag** — list all Workers matching a tag filter using `tag:yes` to include or `tag:no` to exclude (`GET .../scripts?tags=production%3Ayes`).
- **Delete Workers by tag** — bulk-delete all Workers matching a tag filter, for example when a customer leaves your platform (`DELETE .../scripts?tags=customer-123%3Ayes`).

Token permissions: read operations accept `Workers Tail Read`, `Workers Scripts Write`, or `Workers Scripts Read`; write and bulk-delete operations require `Workers Scripts Write`.

Source: [Tags](https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/configuration/tags/) retrieved 2026-07-01, content hash `a6a7fbfd`.
