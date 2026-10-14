---
title: Principles for agent-scale source control
source_kind: web
source_url: https://www.anthropic.com/engineering/redesigning-source-control
source_content_sha256: b3d054963c3f39d437e21031240970f89ddca379738402fa31c6e6c9f3562a44
source_authors: [Nick G., S.G., R.K., Dan C., Garrett H., Ben L., Colin M., Joe P.]
source_date: 2026-10-13
ingested: 2026-10-14
ingested_by: scholar
topics: [source-control-architecture, agentic-sdlc]
status: current
---

Abstract: Scion assumes always-online clients, concentrates expensive history and mutation operations on horizontally scalable servers, exposes repository questions as APIs, makes commits incremental and largely refless, and treats sparse or virtualized working copies as optional consumers rather than the center of source control.

Anthropic states six design principles:

1. **Clients are always online.** They fetch repository data from a reachable server as needed instead of maintaining a complete offline copy.
2. **Clients and servers are asymmetric.** Servers answer history and blame queries and perform commits, merges, and rebases. Clients maintain bounded caches, materialize files, observe filesystem changes, and present the user interface.
3. **Source control is a service.** CI and tools can ask repository questions through the same APIs as the client, often without a local checkout.
4. **Every component scales horizontally.** Repository data is distributed; no server holds a full materialized repository and no packfile maintenance is required.
5. **Commits are cheap, incremental, and lock-free.** Work scales with the size of a change, and global refs are discouraged except for main and release lines.
6. **The working copy is optional and sparse by design.** Read and write workloads may remain API-only; when files are needed, sparse and virtualized checkouts materialize only requested content.

The source credits Google Piper and Meta Sapling as prior art, while emphasizing the always-online agent workload as the condition that permits this particular tradeoff.

Source: [Redesigning source control at Anthropic](https://www.anthropic.com/engineering/redesigning-source-control#principles-for-agent-scale-source-control), retrieved 2026-10-14; content SHA-256 `b3d05496`.
