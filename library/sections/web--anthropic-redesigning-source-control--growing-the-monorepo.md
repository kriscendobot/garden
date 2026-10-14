---
title: Growing the monorepo beyond Git's operating assumptions
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

Abstract: Anthropic's workload exceeded the practical limits of distributing a complete Git repository to every client: nearly 100 GB of main-branch history, working copies over 25 GB compressed, and roughly 25 million daily CI checkouts would imply more than 600 PB of daily traffic if fetched naively.

Git's complete local repository is valuable for distributed, offline work, but Anthropic's clients are overwhelmingly online agents and jobs. Shallow clones, sparse checkouts, promisor remotes, blob-store seeds, and several hundred internal mirrors postponed the bottleneck without removing it. As merge velocity rose, seeds fell further behind main, while history-dependent operations such as diff and blame became harder to preserve on partial clones.

Anthropic observed that it already operated Git as a centralized system with one authoritative copy. Because agent and job clients are online by definition, preserving every offline-client property imposed costs that did not serve the dominant workload. That mismatch motivated a server-oriented system designed around online clients rather than complete local replicas.

Source: [Redesigning source control at Anthropic](https://www.anthropic.com/engineering/redesigning-source-control#growing-our-monorepo), retrieved 2026-10-14; content SHA-256 `b3d05496`.
