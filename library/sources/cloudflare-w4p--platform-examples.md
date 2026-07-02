---
source_kind: web
source_url: https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/reference/platform-examples/
source_content_sha256: 4d02e83c7337a7fa806617a85586e50cb066948fff2d1da2dc3d085178e54f4c
source_authors: [Cloudflare Docs]
source_date: 2026-05-05
retrieved: 2026-07-02
ingested: 2026-07-02
ingested_by: scholar
section_count: 3
status: current
notes: "Living vendor docs (developers.cloudflare.com). Page title is 'API examples'. Idempotency anchor is source_content_sha256 over the page's `.md` rendering (append `index.md`), not a git SHA. Split into three sections (deploy-and-manage, static-assets, list-and-delete) because the page is a ~16KB catalogue of independent REST + TypeScript-SDK recipes."
---

The platform-examples ("API examples") reference page: REST-API and TypeScript-SDK recipes for programmatically deploying and managing user Workers (the operator-side CRUD a platform wraps around its customers' actions). Split into three sections: (1) prerequisites plus deploy a user Worker plus deploy with bindings and tags; (2) deploy a Worker with static assets (the three-step manifest, upload, then deploy flow, with the SHA-256 first-16-bytes hash helper); (3) list Workers in a namespace, delete by tag (bulk offboarding), and delete a single Worker.

| Section | Topics | Status |
|---------|--------|--------|
| [API examples: deploy a user Worker, and deploy with bindings and tags](../sections/cloudflare-w4p--platform-examples--deploy-and-manage.md) | multi-tenant-platform | current |
| [API examples: deploy a user Worker with static assets (three-step upload)](../sections/cloudflare-w4p--platform-examples--static-assets.md) | multi-tenant-platform | current |
| [API examples: list Workers in a namespace, delete by tag, and delete a single Worker](../sections/cloudflare-w4p--platform-examples--list-and-delete.md) | multi-tenant-platform | current |
