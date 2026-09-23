---
title: "API examples: list Workers in a namespace, delete by tag, and delete a single Worker"
source_kind: web
source_url: https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/reference/platform-examples/
source_content_sha256: 4d02e83c7337a7fa806617a85586e50cb066948fff2d1da2dc3d085178e54f4c
source_authors: [Cloudflare Docs]
source_date: 2026-05-05
retrieved: 2026-07-02
ingested: 2026-07-02
ingested_by: scholar
topics: [multi-tenant-platform]
status: current
notes: "Living vendor docs (developers.cloudflare.com). Idempotency anchor is source_content_sha256 over the page's `.md` rendering (append `index.md`). Section 3 of 3 from the platform-examples (API examples) page. The tag-scoped bulk delete is the lifecycle payoff of tagging in cloudflare-w4p--tags--overview."
---

Abstract: The **fleet-management API examples** for a Workers-for-Platforms operator: enumerate and remove user Workers. **List** all Workers in a namespace with `GET .../dispatch/namespaces/$NS/scripts` (the SDK/REST result carries each script's `id` and `tags`). **Delete by tag** (`DELETE .../scripts?tags=customer-123:yes`) removes every Worker matching a tag filter in one call, the payoff of tagging when a customer offboards and you need to drop their whole fleet at once. **Delete a single Worker** with `DELETE .../scripts/$SCRIPT` (SDK: `client.workersForPlatforms.dispatch.namespaces.scripts.delete(namespace, scriptName, { account_id })`). Together with the deploy examples these are the CRUD surface a platform wraps around its customers' save/delete actions.

## List Workers in a namespace

Retrieve all user Workers deployed to a namespace.

```bash
curl "https://api.cloudflare.com/client/v4/accounts/$ACCOUNT_ID/workers/dispatch/namespaces/$NAMESPACE_NAME/scripts" \
  -H "Authorization: Bearer $API_TOKEN"
```

```typescript
async function listWorkers(accountId, namespace) {
  const response = await fetch(
    `https://api.cloudflare.com/client/v4/accounts/${accountId}/workers/dispatch/namespaces/${namespace}/scripts`,
    { headers: { Authorization: `Bearer ${process.env.API_TOKEN}` } },
  );
  const data = await response.json(); // { success, result: Array<{ id, tags? }> }
  return data.result;
}
```

## Delete Workers by tag

Delete all Workers matching a tag filter. This is useful when a customer deletes their account and you need to remove all their Workers at once. Delete all Workers tagged `customer-123`:

```bash
curl -X DELETE "https://api.cloudflare.com/client/v4/accounts/$ACCOUNT_ID/workers/dispatch/namespaces/$NAMESPACE_NAME/scripts?tags=customer-123:yes" \
  -H "Authorization: Bearer $API_TOKEN"
```

```typescript
async function deleteWorkersByTag(accountId, namespace, tag) {
  const response = await fetch(
    `https://api.cloudflare.com/client/v4/accounts/${accountId}/workers/dispatch/namespaces/${namespace}/scripts?tags=${tag}:yes`,
    { method: "DELETE", headers: { Authorization: `Bearer ${process.env.API_TOKEN}` } },
  );
  return response.json();
}
```

## Delete a single Worker

Delete a specific Worker by name.

```bash
curl -X DELETE "https://api.cloudflare.com/client/v4/accounts/$ACCOUNT_ID/workers/dispatch/namespaces/$NAMESPACE_NAME/scripts/$SCRIPT_NAME" \
  -H "Authorization: Bearer $API_TOKEN"
```

```typescript
import Cloudflare from "cloudflare";
const client = new Cloudflare({ apiToken: process.env.API_TOKEN });

async function deleteWorker(accountId, namespace, scriptName) {
  return client.workersForPlatforms.dispatch.namespaces.scripts.delete(
    namespace,
    scriptName,
    { account_id: accountId },
  );
}
```

Source: [API examples](https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/reference/platform-examples/) retrieved 2026-07-02, content hash `4d02e83c`.
