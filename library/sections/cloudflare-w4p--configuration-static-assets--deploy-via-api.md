---
title: "Deploy static assets to user Workers: the three-step upload API"
source_kind: web
source_url: https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/configuration/static-assets/
source_content_sha256: c1d57e6cddc723968bdd9e8b246ab8219ed22c84a1c1080d579f1ec9156deeb5
source_authors: [Cloudflare Docs]
source_date: 2026-04-21
retrieved: 2026-07-01
ingested: 2026-07-01
ingested_by: scholar
topics: [multi-tenant-platform]
status: current
notes: "Living vendor docs (developers.cloudflare.com). Idempotency anchor is source_content_sha256 over the page's `.md` rendering (append `index.md`). Carries the asset-isolation security caveat: assets are namespace-scoped and shared by hash across user Workers unless the platform salts the hash."
---

Abstract: The API a platform uses to upload static assets on behalf of its end users, in three steps. **(1) Create an upload session**: POST a **manifest** (each file's path, a 32-hex-char content hash, and byte size) to the `assets-upload-session` endpoint; the response returns a short-lived **JWT** (1 hour) and `buckets` (hash groups still needing upload — files Cloudflare already stored are omitted, giving content-addressed dedup). **(2) Upload file contents**: for any hashes in `buckets`, POST the raw bytes base64-encoded as multipart form-data (field name = the file hash) to the Workers Assets Upload API, authenticated with the step-1 JWT (not the account API token); on completion you get a final **completion token** (1 hour). **(3) Deploy the user Worker**: PUT the Worker with `metadata.assets.jwt = <completion-token>` (plus optional `assets.config`, for example `html_handling`) to link the assets. **Critical isolation caveat:** assets are associated with the *namespace*, not individual user Workers, so identical hashes are shared across user Workers — JWTs must stay with trusted platform services and never reach end-users, and strict per-tenant isolation requires salting the hash (for example `hash = slice(sha256(accountID + fileContents), 32)`).

## Deploy static assets to user Workers

It is common that, as the platform, you will be responsible for uploading static assets on behalf of your end users: your user uploads files (HTML, CSS, images) through your interface, and your platform interacts with the Workers for Platforms APIs to attach the static assets to the user Worker script. Once you receive the static files (for a new or updated site), complete three steps: create an upload session, upload file contents, then deploy/update the Worker.

### 1. Create an upload session

Before sending any file data, tell Cloudflare which files you intend to upload. That list is called a **manifest**. Each item includes a file path (for example `"/index.html"`), a hash (32-hex characters) representing the file contents, and the file size in bytes.

> **Asset isolation considerations.** Static assets uploaded to Workers for Platforms are associated with the *namespace* rather than with an individual user Worker. If multiple user Workers exist under the same namespace, assets with identical hashes may be shared across them. **JWTs should therefore only be shared with trusted platform services and should never be distributed to end-users.** If strict isolation of assets is required, either salt with a random value each time, or incorporate an end-user identifier (for example account ID or Worker script ID) within the hashing process to ensure uniqueness — for example `hash = slice(sha256(accountID + fileContents), 32)`.

Example manifest:

```json
{
  "/index.html": { "hash": "08f1dfda4574284ab3c21666d1ee8c7d4", "size": 1234 },
  "/styles.css": { "hash": "36b8be012ee77df5f269b11b975611d3", "size": 5678 }
}
```

Send a POST to the Create Assets Upload Session endpoint:

```bash
curl -X POST \
  "https://api.cloudflare.com/client/v4/accounts/$ACCOUNT_ID/workers/dispatch/namespaces/$NAMESPACE_NAME/scripts/$SCRIPT_NAME/assets-upload-session" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_TOKEN" \
  --data '{ "manifest": { "/index.html": { "hash": "08f1dfda4574284ab3c21666d1ee8c7d4", "size": 1234 }, "/styles.css": { "hash": "36b8be012ee77df5f269b11b975611d3", "size": 5678 } } }'
```

Generate the hash by computing a SHA-256 digest of the file contents, then truncating or otherwise representing it consistently as a 32-hex-character string (do it the same way each time so Cloudflare can match files across uploads). The response returns:

- `jwt`: an upload token (valid 1 hour) used in step 2.
- `buckets`: an array of file-hash groups indicating which files to upload together. Recently-uploaded files do not appear in `buckets` (Cloudflare already has them). If all files are already stored, the response returns only the JWT.

This step alone does not store files; you must upload the actual data next.

### 2. Upload file contents

If the session response returned `buckets`, you have new or changed files to upload. Use the Workers Assets Upload API to transmit the raw file bytes in base64-encoded format.

Authentication differs from most Cloudflare API calls: use the short-lived JWT from the `jwt` field (valid 1 hour), not the account-wide API token:

```
Authorization: Bearer <upload-session-token>
```

Send files as `multipart/form-data`: field name = the file hash, field value = a base64-encoded string of the file's raw bytes. If a bucket lists two hashes, upload both in one request:

```bash
curl -X POST \
  "https://api.cloudflare.com/client/v4/accounts/$ACCOUNT_ID/workers/assets/upload?base64=true" \
  -H "Authorization: Bearer <upload-session-token>" \
  -F "08f1dfda4574284ab3c21666d1ee8c7d4=<BASE64_OF_INDEX_HTML>" \
  -F "36b8be012ee77df5f269b11b975611d3=<BASE64_OF_STYLES_CSS>"
```

If you have multiple buckets, repeat per bucket group. Once every manifest file is uploaded, a `201` returns with a final **completion token** in the `jwt` field (valid 1 hour), used in step 3.

### 3. Deploy the user Worker with static assets

Attach the uploaded files by PUTting the user Worker with the completion token in `metadata.assets.jwt`. Optional settings under `assets.config` customize serving (for example `html_handling`):

```bash
curl -X PUT \
  "https://api.cloudflare.com/client/v4/accounts/$ACCOUNT_ID/workers/dispatch/namespaces/$NAMESPACE_NAME/scripts/$SCRIPT_NAME" \
  -H "Content-Type: multipart/form-data" \
  -H "Authorization: Bearer $API_TOKEN" \
  -F 'metadata={
    "main_module": "index.js",
    "assets": { "jwt": "<completion-token>", "config": { "html_handling": "auto-trailing-slash" } },
    "compatibility_date": "2025-01-24"
  };type=application/json' \
  -F 'index.js=@/path/to/index.js;type=application/javascript'
```

The `jwt` links the newly uploaded files to the Worker. If the user's Worker code has not changed, you can omit the code file or re-upload the same `index.js`. Once this PUT succeeds, requests routed to that Worker serve the new or updated static assets.

Source: [Static assets](https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/configuration/static-assets/) retrieved 2026-07-01, content hash `c1d57e6c`.
