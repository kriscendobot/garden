---
title: Product scope, repository unit, and durability
source_kind: web
source_url: https://developers.cloudflare.com/artifacts/llms-full.txt
source_content_sha256: d81d8779a3e3a3b645c62b871ca8c06e35acfc66ccfde4986186904f06cb9996
source_authors: ["Cloudflare, Inc."]
source_date: 2026-08-25
ingested: 2026-09-10
ingested_by: gardener
topics: [agent-workspaces, cloudflare-workers-agent-hosting, content-addressed-storage]
status: current
---

Cloudflare Artifacts stores versioned file trees as isolated Git repositories. A namespace and repository name form a stable address, while each repository owns its history, refs, remote URL, credentials, and lifecycle. Forking produces an independent repository that begins with another repository's history. Cloudflare recommends using a repository, rather than merely a branch, as the isolation unit when agent sessions do not share a lifecycle.

The service is in closed beta. Its durability claim is stronger than a single Worker or Durable Object: repository data is synchronously replicated across multiple data centers and asynchronously copied to object storage and snapshots. Repositories persist until explicitly deleted.

Supporting pages: [Artifacts](https://developers.cloudflare.com/artifacts/), [How Artifacts works](https://developers.cloudflare.com/artifacts/concepts/how-artifacts-works/), and [Repositories](https://developers.cloudflare.com/artifacts/concepts/repositories/).

Source: [Cloudflare Artifacts complete documentation](https://developers.cloudflare.com/artifacts/llms-full.txt), retrieved 2026-09-10.
