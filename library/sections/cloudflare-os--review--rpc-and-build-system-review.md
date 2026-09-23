---
title: RPC and build-system review
source: REVIEW.md
source_repo: cloudflare/cloudflare-os
source_commit: da895450d81e674c03e62bd6c940acf57bc0224c
source_date: 2026-08-18
source_authors: [Maximo Guk, Nathan Disidore]
ingested: 2026-08-24
ingested_by: scholar
topics: [repository-governance, testing, eventual-send, node-packaging]
status: current
---

Review preserves intentional Cap'n Web promise pipelining and stub lifecycle while treating Vite+ task caching, environment declarations, generated outputs, and workerd execution as high-risk silent-failure surfaces.

Unawaited RPC promises are not floating-promise defects. Stubs must be disposed and wrapped before entering React state. Build tasks that read environment variables declare them, tasks exclude paths they write, and path-valued external inputs disable caching. Reviewers reject reintroduced recursive root scripts, TypeScript incremental state, removed workerd assertions, stale release-manifest goldens, and default credential inputs on Gatekeepers that need no third-party OAuth app.

Source: [REVIEW.md](https://github.com/cloudflare/cloudflare-os/blob/da895450d81e674c03e62bd6c940acf57bc0224c/REVIEW.md) at commit `da895450`.
