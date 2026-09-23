---
title: "Adding a KV namespace to a user Worker (worked API example)"
source_kind: web
source_url: https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/configuration/bindings/
source_content_sha256: 3635e8fea0b23b4a8cdf0d722fc4af83129bf3fd76b04f10e353681021144709
source_authors: [Cloudflare Docs]
source_date: 2026-04-21
retrieved: 2026-07-01
ingested: 2026-07-01
ingested_by: scholar
topics: [multi-tenant-platform]
status: current
notes: "Living vendor docs (developers.cloudflare.com). Idempotency anchor is source_content_sha256 over the page's `.md` rendering (append `index.md`)."
---

Abstract: The concrete two-step recipe for attaching a binding to a user Worker: (1) create the resource (here a **KV namespace**) via the Cloudflare API, and (2) attach it via the **Upload User Worker API** (`PUT .../dispatch/namespaces/<ns>/scripts/<script>`), either at first upload or on update. The key constraint: when uploading scripts by API, bindings must be declared in the multipart request's **`metadata`** object (a `bindings: [{ type, name, ... }]` array) — you cannot upload a Wrangler config file to configure them. Adding new bindings without dropping existing ones requires the **`keep_bindings`** parameter naming the binding *types* to preserve. The same shape works for R2, D1, and other binding types.

## Adding a KV namespace to a user Worker

This example walks through how to create a KV namespace and attach it to a User Worker. The same process can be used to attach other bindings.

### 1. Create a KV namespace

Create a KV namespace using the Cloudflare API.

### 2. Attach the KV namespace to the User Worker

Use the Upload User Worker API to attach the KV namespace binding to the Worker. You can do this when first uploading the Worker script or when updating an existing Worker.

> **Note.** When using the API to upload scripts, bindings must be specified in the `metadata` object of your multipart upload request. You cannot upload the Wrangler configuration file as a module to configure the bindings. For more details, see [Multipart upload metadata](https://developers.cloudflare.com/workers/configuration/multipart-upload-metadata/).

#### Example API request

```bash
curl -X PUT \
  "https://api.cloudflare.com/client/v4/accounts/<account-id>/workers/dispatch/namespaces/<your-namespace>/scripts/<script-name>" \
  -H "Content-Type: multipart/form-data" \
  -H "Authorization: Bearer <api-token>" \
  -F 'metadata={
    "main_module": "worker.js",
    "bindings": [
      {
        "type": "kv_namespace",
        "name": "USER_KV",
        "namespace_id": "<your-namespace-id>"
      }
    ]
  }' \
  -F 'worker.js=@/path/to/worker.js'
```

Now the User Worker can access the `USER_KV` binding through the `env` argument using `env.USER_KV.get()`, `env.USER_KV.put()`, and other KV methods.

If you plan to add new bindings to the Worker, use the `keep_bindings` parameter to ensure existing bindings are preserved while adding new ones:

```bash
curl -X PUT \
  "https://api.cloudflare.com/client/v4/accounts/<account-id>/workers/dispatch/namespaces/<your-namespace>/scripts/<script-name>" \
  -H "Content-Type: multipart/form-data" \
  -H "Authorization: Bearer <api-token>" \
  -F 'metadata={
    "bindings": [
      {
        "type": "r2_bucket",
        "name": "STORAGE",
        "bucket_name": "<your-bucket-name>"
      }
    ],
    "keep_bindings": ["kv_namespace"]
  }'
```

Source: [Bindings](https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/configuration/bindings/) retrieved 2026-07-01, content hash `3635e8fe`.
