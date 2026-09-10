---
title: Lazy mounts, limits, and lifecycle economics
source_kind: web
source_url: https://developers.cloudflare.com/artifacts/llms-full.txt
source_content_sha256: d81d8779a3e3a3b645c62b871ca8c06e35acfc66ccfde4986186904f06cb9996
source_authors: ["Cloudflare, Inc."]
source_date: 2026-08-25
ingested: 2026-09-10
ingested_by: gardener
topics: [cloudflare-workers-agent-hosting, agent-workspaces]
status: current
---

ArtifactFS serves a different environment from the Worker binding. On a host with FUSE, it starts from a blobless clone, mounts a working tree, and hydrates file contents on demand into a local blob cache. Cloudflare recommends a regular clone for smaller repositories and ArtifactFS when large-repository startup latency justifies the added mount machinery. This path applies to sandboxes, containers, and virtual machines, not to a Worker isolate itself.

The published beta limits are 10 GB per repository, 1 TB per account by default, 2,000 control-plane requests per 10 seconds per namespace, and 2,000 Git requests per 10 seconds per repository. Repository and namespace counts are described as unlimited. Paid pricing meters repository operations and aggregate gigabyte-month storage; retained replicas do not multiply the storage charge.

Supporting pages: [ArtifactFS](https://developers.cloudflare.com/artifacts/guides/artifact-fs/), [Limits](https://developers.cloudflare.com/artifacts/platform/limits/), and [Pricing](https://developers.cloudflare.com/artifacts/platform/pricing/).

Source: [Cloudflare Artifacts complete documentation](https://developers.cloudflare.com/artifacts/llms-full.txt), retrieved 2026-09-10.
