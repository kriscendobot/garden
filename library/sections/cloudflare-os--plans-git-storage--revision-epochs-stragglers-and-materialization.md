---
title: Revision epochs, stragglers, and materialization
source: plans/git-storage.md
source_repo: cloudflare/cloudflare-os
source_commit: 1ef6020a42fbabb6d27dd1063db3a075ba95c974
source_date: 2026-08-21
source_authors: [Kenton Varda]
ingested: 2026-08-24
ingested_by: scholar
topics: [collaborative-workspace-sharing, persistence, cloudflare-workers-agent-hosting]
status: current
---

The OT protocol treats each chat generation as a revision epoch, retains a contiguous change window, and periodically composes old rows into a materialized base without invalidating clients still inside the window.

Accept records the old generation's final revision and boundary commits, allowing eligible in-flight changes to bridge across a merge by transforming against the exact committed boundary rather than current head. Destructive operations such as revert, draft discard, or turn abort remain reject-shaped and bump generation. Per-client dedupe records outlive row retirement so delayed retries receive their prior acknowledgement. Pin declarations for bridged changes come from the recorded boundary map, preserving the content base against which the change was transformed.

Source: [plans/git-storage.md](https://github.com/cloudflare/cloudflare-os/blob/1ef6020a42fbabb6d27dd1063db3a075ba95c974/plans/git-storage.md) at commit `1ef6020a`.
