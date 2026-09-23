---
title: "Deploying static assets with Wrangler"
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
notes: "Living vendor docs (developers.cloudflare.com). Idempotency anchor is source_content_sha256 over the page's `.md` rendering (append `index.md`). The CLI alternative to the three-step upload API in cloudflare-w4p--configuration-static-assets--deploy-via-api."
---

Abstract: The CLI alternative to the three-step upload API: when the platform allows direct publishing, **Wrangler** bundles and uploads a user Worker's code and its static assets together in one step. Declare an `assets` block in the Wrangler config (`directory` = the local static-file folder, `binding` = the name the Worker code uses to reference the assets, for example `ASSETS`); optionally serve assets from Worker code via `env.ASSETS.fetch(request)`. Deploy into a dispatch namespace with `npx wrangler deploy --name <USER_WORKER_NAME> --dispatch-namespace <NAMESPACE_NAME>`, and Wrangler detects, bundles, and uploads the files alongside the Worker code.

## Deploying static assets with Wrangler

If you prefer a CLI-based approach and your platform setup allows direct publishing, use Wrangler to deploy both your Worker code and static assets. Wrangler bundles and uploads static assets (from a specified directory) along with your Worker script.

Create or update your Wrangler configuration file to specify where Wrangler should look for static files:

```jsonc
{
  "$schema": "./node_modules/wrangler/config-schema.json",
  "name": "my-static-site",
  "main": "./src/index.js",
  // Set this to today's date
  "compatibility_date": "2026-07-01",
  "assets": {
    "directory": "./public",
    "binding": "ASSETS"
  }
}
```

- `directory`: the local folder containing your static files (for example `./public`).
- `binding`: the binding name used to reference these assets within your Worker code.

### 1. Organize your files

Place your static files (HTML, CSS, images, etc.) in the specified directory (in this example `./public`). Wrangler will detect and bundle these files when you publish your Worker. To reference these files in your Worker script to serve them dynamically, use the `ASSETS` binding:

```js
export default {
  async fetch(request, env, ctx) {
    return env.ASSETS.fetch(request);
  },
};
```

### 2. Deploy the user Worker with the static assets

Run Wrangler to publish both your Worker code and the static assets:

```bash
npx wrangler deploy --name <USER_WORKER_NAME> --dispatch-namespace <NAMESPACE_NAME>
```

Wrangler will automatically detect your static files, bundle them, and upload them to Cloudflare along with your Worker code.

Source: [Static assets](https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/configuration/static-assets/) retrieved 2026-07-01, content hash `c1d57e6c`.
