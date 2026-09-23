---
title: "Get started: deploy a Workers for Platforms starter kit"
source_kind: web
source_url: https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/get-started/
source_content_sha256: 41d7aa1d5e66bf94ad3219fa95a60e08b30e407dc72810f5fd2481ac267286c8
source_authors: [Cloudflare Docs]
source_date: 2026-04-21
retrieved: 2026-07-01
ingested: 2026-07-01
ingested_by: scholar
topics: [multi-tenant-platform]
status: current
notes: "Living vendor docs (developers.cloudflare.com). Idempotency anchor is source_content_sha256 over the page's `.md` rendering (append `index.md`). Tutorial-shape restatement of the four components; soft-flag cross-ref to the how-it-works sections (cloudflare-w4p--how-it-works--*), which carry the canonical detail."
---

Abstract: The **getting-started** path for Workers for Platforms: deploy the one-click **Platform Starter Kit** template (`worker-publisher-template`) to your account, which provisions a complete setup (dispatch namespace + dispatch Worker + user-Worker deployment) automatically; then deploy code snippets through the resulting Worker UI and reach each at `/<script-name>`. The page recaps the three components the template wires together (dispatch namespace as the container of user Workers, dispatch Worker as the path-based router calling `env.DISPATCHER.get(workerName)`, user Workers as the isolated customer code) and points at the customization surfaces (dynamic dispatch, hostname routing, bindings, outbound Workers, custom limits, API examples). It also links **VibeSDK**, Cloudflare's open-source AI vibe-coding-platform template, as a second one-click starting point.

## Get started

Get started with Workers for Platforms by deploying a starter kit to your account.

## Deploy a platform

Deploy the Platform Starter Kit (`cloudflare/templates/worker-publisher-template`) to your Cloudflare account. This creates a complete Workers for Platforms setup with one click. After deployment completes, open your Worker URL. You now have a platform where you can deploy code snippets.

### Try it out

1. Enter a script name, for example `my-worker`.
2. Write or paste Worker code in the editor.
3. Click **Deploy Worker**.

Once deployed, visit `/<script-name>` on your Worker URL to run your code. For example, if you named your script `my-worker`, go to `https://<your-worker>.<subdomain>.workers.dev/my-worker`.

Each script you deploy becomes its own isolated Worker. The platform calls the Cloudflare API to create the Worker and the dispatch Worker routes requests to it based on the URL path.

## Understand how it works

The template you deployed contains three components that work together.

**Dispatch namespace** — a collection of user Workers; a container that holds all the Workers your platform deploys on behalf of your customers. The template creates one automatically; view it in the dashboard under **Workers for Platforms**.

**Dispatch Worker** — receives incoming requests and routes them to the correct user Worker, using a [binding](https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/configuration/bindings/) to access the dispatch namespace:

```js
export default {
  async fetch(request, env) {
    // Get the user Worker name from the URL path
    const url = new URL(request.url);
    const workerName = url.pathname.split("/")[1];

    // Fetch the user Worker from the dispatch namespace
    const userWorker = env.DISPATCHER.get(workerName);

    // Forward the request to the user Worker
    return userWorker.fetch(request);
  },
};
```

The `env.DISPATCHER.get()` method retrieves a user Worker by name from the dispatch namespace.

**User Workers** — contain the code your customers write and deploy; they run in isolated environments with no access to other customers' data or code. In the template, user Workers are deployed programmatically through the API; in production, your platform would call the Cloudflare API or SDK to deploy user Workers when your customers save their code.

## Build your platform

Customize the template for your use case:

- **Dynamic dispatch** — route requests by subdomain or hostname.
- **Hostname routing** — let customers use custom domains with their applications.
- **Bindings** — give each customer access to their own database, key-value store, or object storage.
- **Outbound Workers** — configure egress policies on outgoing requests from customer code.
- **Custom limits** — set CPU time and subrequest limits per customer.
- **API examples** — examples for deploying and managing customer code programmatically.

## Build an AI vibe coding platform

Build an AI vibe coding platform where users describe what they want and AI generates and deploys applications. With **VibeSDK** (`cloudflare/vibesdk`), Cloudflare's open-source vibe-coding platform, you can start from an example that handles AI code generation, code execution in secure sandboxes, live previews, and deployment at scale.

Source: [Get started](https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/get-started/) retrieved 2026-07-01, content hash `41d7aa1d`.
