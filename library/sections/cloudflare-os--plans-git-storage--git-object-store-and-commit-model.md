---
title: Git object store and commit model
source: plans/git-storage.md
source_repo: cloudflare/cloudflare-os
source_commit: 1ef6020a42fbabb6d27dd1063db3a075ba95c974
source_date: 2026-08-21
source_authors: [Kenton Varda]
ingested: 2026-08-24
ingested_by: scholar
topics: [persistence, ai-generated-apps, cloudflare-workers-agent-hosting]
status: current
---

The plan replaces the workspace-wide Yjs mainline with real Git commits stored as loose objects in each Overseer Durable Object, while retaining chat-local editing as the only path to uncommitted changes.

The object store is keyed by SHA-1 object ID and exposed to `isomorphic-git` through a deliberately narrow filesystem shim. Gadget records, blueprint records, and chat pins act as refs, so the store needs no branches, tags, `HEAD`, index, or config. All gadget histories share one content-addressed store per workspace, allowing unchanged blobs and trees to deduplicate. The initial design accepts whole-object zlib storage, a 2 MB object limit, and no garbage collection or delta compression, while keeping chunking, R2 spill, GitHub interchange, and protocol support as later shim-local work.

Source: [plans/git-storage.md](https://github.com/cloudflare/cloudflare-os/blob/1ef6020a42fbabb6d27dd1063db3a075ba95c974/plans/git-storage.md) at commit `1ef6020a`.
