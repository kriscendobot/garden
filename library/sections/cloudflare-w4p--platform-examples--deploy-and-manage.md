---
title: "API examples: deploy a user Worker, and deploy with bindings and tags"
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
notes: "Living vendor docs (developers.cloudflare.com). Idempotency anchor is source_content_sha256 over the page's `.md` rendering (append `index.md`). Section 1 of 3 from the platform-examples (API examples) page; siblings are cloudflare-w4p--platform-examples--static-assets and cloudflare-w4p--platform-examples--list-and-delete. Concept detail lives in cloudflare-w4p--configuration-bindings--* and cloudflare-w4p--tags--overview."
---

Abstract: The primary programmatic operation of a Workers-for-Platforms operator (**uploading, that is deploying, a user Worker** into a dispatch namespace) via Cloudflare's REST API and the `cloudflare` TypeScript SDK, plus the variant that attaches **per-Worker bindings and tags** in the same upload. Prerequisites: an Account ID, a dispatch namespace, and an API token with Workers permissions (`npm install cloudflare` for the SDK). The REST upload is a `PUT` to `.../dispatch/namespaces/$NS/scripts/$SCRIPT` sent as **multipart form** (required for ES modules): a `metadata` part (`{"main_module": "..."}`) plus the module file. The SDK equivalent is `client.workersForPlatforms.dispatch.namespaces.scripts.update(namespace, scriptName, { account_id, metadata, files })`. To give each tenant its own resources and make the fleet bulk-manageable, extend `metadata` with a `bindings` array (for example a `kv_namespace` binding) and a `tags` array (for example `["customer-123","production","pro-plan"]`).

## Prerequisites

- **Account ID**: found in the Cloudflare dashboard URL or API settings.
- **Dispatch namespace**: created via the dashboard.
- **API token** with Workers permissions.

For SDK examples, install the Cloudflare SDK: `npm install cloudflare`.

## Deploy a user Worker

Upload a Worker script to your dispatch namespace. This is the primary operation your platform performs when customers deploy code.

REST API (multipart form is **required for ES modules**):

```bash
# First, create the worker script file
cat > worker.mjs << 'EOF'
export default {
  async fetch(request, env, ctx) {
    return new Response("Hello from user Worker!");
  },
};
EOF

# Deploy using multipart form (required for ES modules)
curl -X PUT "https://api.cloudflare.com/client/v4/accounts/$ACCOUNT_ID/workers/dispatch/namespaces/$NAMESPACE_NAME/scripts/$SCRIPT_NAME" \
  -H "Authorization: Bearer $API_TOKEN" \
  -F 'metadata={"main_module": "worker.mjs"};type=application/json' \
  -F 'worker.mjs=@worker.mjs;type=application/javascript+module'
```

TypeScript SDK:

```typescript
import Cloudflare from "cloudflare";

const client = new Cloudflare({ apiToken: process.env.API_TOKEN });

async function deployUserWorker(accountId, namespace, scriptName, scriptContent) {
  const scriptFile = new File([scriptContent], `${scriptName}.mjs`, {
    type: "application/javascript+module",
  });

  return client.workersForPlatforms.dispatch.namespaces.scripts.update(
    namespace,
    scriptName,
    {
      account_id: accountId,
      metadata: { main_module: `${scriptName}.mjs` },
      files: [scriptFile],
    },
  );
}
```

## Deploy with bindings and tags

Use [bindings](cloudflare-w4p--configuration-bindings--overview.md) to give each user Worker its own resources (a KV store or a database) and [tags](cloudflare-w4p--tags--overview.md) to organize Workers by customer ID, project ID, or plan type for bulk operations. Both ride along in the upload's `metadata`.

REST API:

```bash
curl -X PUT "https://api.cloudflare.com/client/v4/accounts/$ACCOUNT_ID/workers/dispatch/namespaces/$NAMESPACE_NAME/scripts/$SCRIPT_NAME" \
  -H "Authorization: Bearer $API_TOKEN" \
  -F 'metadata={"main_module": "worker.mjs", "bindings": [{"type": "kv_namespace", "name": "MY_KV", "namespace_id": "your-kv-namespace-id"}], "tags": ["customer-123", "production", "pro-plan"], "compatibility_date": "2024-01-01"};type=application/json' \
  -F 'worker.mjs=@worker.mjs;type=application/javascript+module'
```

TypeScript SDK (`metadata` carries `bindings` and `tags`):

```typescript
await client.workersForPlatforms.dispatch.namespaces.scripts.update(
  namespace,
  scriptName,
  {
    account_id: accountId,
    metadata: {
      main_module: `${scriptName}.mjs`,
      compatibility_date: "2024-01-01",
      bindings: [{ type: "kv_namespace", name: "MY_KV", namespace_id: kvNamespaceId }],
      tags: tags, // e.g., ["customer-123", "production", "pro-plan"]
    },
    files: [scriptFile],
  },
);
```

Source: [API examples](https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/reference/platform-examples/) retrieved 2026-07-02, content hash `4d02e83c`.
