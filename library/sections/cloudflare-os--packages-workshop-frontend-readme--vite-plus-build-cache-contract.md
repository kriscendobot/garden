---
title: Workshop Vite+ build cache contract
source: packages/workshop-frontend/README.md
source_repo: cloudflare/cloudflare-os
source_commit: 046bcd7b76404934e2e87bb490b5a6ffb8fc226d
source_date: 2026-08-17
source_authors: [Brayden Wilmoth, Kenton Varda, Maximo Guk]
ingested: 2026-08-24
ingested_by: scholar
topics: [cloudflare-workers-agent-hosting, node-packaging]
status: current
---

The Workshop frontend's production build is a Vite+ task whose cache fingerprint explicitly includes build-time `VITE_*` flags and whose output cleanup prevents stale artifacts from surviving across restored cache entries.

`pnpm exec vp run build` type-checks and builds the React, Kumo, and Vite single-page app. The build is a Vite+ task rather than a package script because cached task execution uses a clean environment: undeclared ambient variables disappear, and unfingerprinted flags could replay an old bundle after configuration changes. The task always produces a production bundle regardless of shell `NODE_ENV` and deletes `dist/` before execution so old source maps do not linger when cache behavior changes.

Source: [packages/workshop-frontend/README.md](https://github.com/cloudflare/cloudflare-os/blob/046bcd7b76404934e2e87bb490b5a6ffb8fc226d/packages/workshop-frontend/README.md) at commit `046bcd7b`.
