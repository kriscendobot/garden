---
title: Worker-side mutation with isomorphic-git
source_kind: web
source_url: https://developers.cloudflare.com/artifacts/llms-full.txt
source_content_sha256: d81d8779a3e3a3b645c62b871ca8c06e35acfc66ccfde4986186904f06cb9996
source_authors: ["Cloudflare, Inc."]
source_date: 2026-08-25
ingested: 2026-09-10
ingested_by: gardener
topics: [cloudflare-workers-agent-hosting, agent-workspaces, content-addressed-storage]
status: current
---

A Cloudflare Worker cannot use a local Git executable or ordinary local disk, and the Artifacts binding cannot edit repository files. Cloudflare's documented write path therefore combines the binding with isomorphic-git and an in-memory filesystem adapter. The Worker creates or finds a repository, obtains a short-lived write token, edits a temporary working tree, stages and commits changes through isomorphic-git, and pushes over HTTPS.

This means Artifacts durably stores committed Git state, not every mutable filesystem operation. A service that promises durable uncommitted edits needs a separate working-tree store or an explicit transaction model that commits before acknowledging durability. The example in-memory filesystem is process-local working state and should not be mistaken for the repository's durable data plane.

Supporting page: [isomorphic-git example](https://developers.cloudflare.com/artifacts/examples/isomorphic-git/).

Source: [Cloudflare Artifacts complete documentation](https://developers.cloudflare.com/artifacts/llms-full.txt), retrieved 2026-09-10.
