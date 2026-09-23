---
title: "API examples: deploy a user Worker with static assets (three-step upload)"
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
notes: "Living vendor docs (developers.cloudflare.com). Idempotency anchor is source_content_sha256 over the page's `.md` rendering (append `index.md`). Section 2 of 3 from the platform-examples (API examples) page. This is the worked-code companion to the conceptual three-step upload in cloudflare-w4p--configuration-static-assets--deploy-via-api."
---

Abstract: The **worked API/SDK example for deploying a user Worker that serves static files** (HTML, CSS, JS, images): the code companion to the static-assets configuration page's three-step upload flow. The three steps: **(1)** POST a `manifest` of `{ path: { hash, size } }` to `.../scripts/$SCRIPT/assets-upload-session` and receive a `jwt` plus a `buckets` array naming which files still need uploading; **(2)** POST the missing files to `.../workers/assets/upload?base64=true` under the step-1 JWT (each returned `jwt` chains into the next bucket's auth and becomes the completion token); **(3)** `PUT` the Worker with `metadata.assets.jwt` set to the completion token and an `assets` binding. The TypeScript example includes the manifest-hash helper (SHA-256, **first 16 bytes / 32 hex chars** per the API) and the bucket-by-bucket upload loop that threads the JWT forward.

## Deploy a Worker with static assets

Deploy a Worker that serves static files. This is a three-step process: create an upload session with a manifest of files, upload the asset files, then deploy the Worker with the assets binding. (For configuration detail see [Deploy static assets to user Workers: the three-step upload API](cloudflare-w4p--configuration-static-assets--deploy-via-api.md).)

**Step 1: Create upload session.** The response includes a `jwt` token and a `buckets` array indicating which files need uploading.

```bash
curl -X POST "https://api.cloudflare.com/client/v4/accounts/$ACCOUNT_ID/workers/dispatch/namespaces/$NAMESPACE_NAME/scripts/$SCRIPT_NAME/assets-upload-session" \
  -H "Authorization: Bearer $API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "manifest": {
      "/index.html": { "hash": "<sha256-hash-first-16-bytes-hex>", "size": 1234 },
      "/styles.css": { "hash": "<sha256-hash-first-16-bytes-hex>", "size": 567 }
    }
  }'
```

**Step 2: Upload assets** (under the JWT from step 1, base64-encoded):

```bash
curl -X POST "https://api.cloudflare.com/client/v4/accounts/$ACCOUNT_ID/workers/assets/upload?base64=true" \
  -H "Authorization: Bearer $JWT_FROM_STEP_1" \
  -F '<hash1>=<base64-encoded-content>' \
  -F '<hash2>=<base64-encoded-content>'
```

**Step 3: Deploy Worker with assets** (the completion token goes in `metadata.assets.jwt`, plus an `assets` binding):

```bash
curl -X PUT "https://api.cloudflare.com/client/v4/accounts/$ACCOUNT_ID/workers/dispatch/namespaces/$NAMESPACE_NAME/scripts/$SCRIPT_NAME" \
  -H "Authorization: Bearer $API_TOKEN" \
  -F 'metadata={"main_module": "worker.mjs", "assets": {"jwt": "<completion-token>"}, "bindings": [{"type": "assets", "name": "ASSETS"}]};type=application/json' \
  -F 'worker.mjs=export default { async fetch(request, env) { return env.ASSETS.fetch(request); } };type=application/javascript+module'
```

TypeScript SDK (the manifest hash helper uses the **first 16 bytes / 32 hex chars** of the SHA-256 per the API requirement, and the upload loop threads the JWT forward across buckets):

```typescript
async function hashContent(base64Content: string): Promise<string> {
  const binaryString = atob(base64Content);
  const bytes = new Uint8Array(binaryString.length);
  for (let i = 0; i < binaryString.length; i++) bytes[i] = binaryString.charCodeAt(i);
  const hashBuffer = await crypto.subtle.digest("SHA-256", bytes);
  const hashArray = Array.from(new Uint8Array(hashBuffer));
  // Use first 16 bytes (32 hex chars) per API requirement
  return hashArray.slice(0, 16).map((b) => b.toString(16).padStart(2, "0")).join("");
}

// 1. build manifest { path: { hash, size } }; 2. POST assets-upload-session -> { jwt, buckets };
// 3. for each bucket, POST /assets/upload?base64=true under the current token, chaining the returned jwt;
// 4. PUT the script with metadata.assets.jwt = completionToken and bindings [{ type: "assets", name: "ASSETS" }].
```

Source: [API examples](https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/reference/platform-examples/) retrieved 2026-07-02, content hash `4d02e83c`.
