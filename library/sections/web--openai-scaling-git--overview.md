---
title: Scaling Git at OpenAI: overview
source_kind: web
source_url: https://openai.com/index/scaling-git-at-openai/
source_snapshot: http://web.archive.org/web/20261110004756id_/https://openai.com/index/scaling-git-at-openai/
source_content_sha256: f93cf33cc74d4badf1d49db844bf99ef616bba6e2d3cf0f59a11ef638a1cb48e
source_authors: [Aaron Friel, Taylor Blau, Ted Nyman]
source_date: 2026-11-02
retrieved: 2026-11-12
ingested: 2026-11-12
ingested_by: scholar
topics: [source-control-architecture, agentic-sdlc]
status: current
---

Abstract: OpenAI's *Scaling Git at OpenAI* (Aaron Friel, Taylor Blau, Ted Nyman; 2026-11-02) introduces **Pando**, a new server backend for Git repositories that now powers all development in OpenAI's monorepo without changing the Git client, protocol, or workflow. Pando has two goals: horizontally scalable writes, tuned for concurrent pushes to many branches, and read throughput high enough that clients saturate their network bandwidth. It gets there by giving up repository-wide ref consistency (it offers per-ref serializability and **causal consistency** instead) and per-client pack generation (it **reuses pushed packfiles** and serves them by `packfile-uri` from regional caches). OpenAI reports median push latency cut by nearly 5x and close to a petabyte of Git data served per day. The post compares Pando with three-phase-commit and write-ahead-log replica designs, describes its push, fetch, and LSM-style compaction services, says it was built with Codex in 10 weeks, and lists the client improvements contributed back to upstream Git.

We built Pando, a new backend for Git repositories, without interrupting any engineering work or changing how our team uses Git. Pando now powers all development in OpenAI's monorepo. Pando is designed to meet two ambitious goals: first, horizontally scalable writes, optimized for concurrent pushes to many branches. And second, maximize read throughput, so clients can download data fast enough to fully saturate their available network bandwidth.

We met these goals while retaining compatibility with the Git protocol and client, enabling both our engineers and agents to seamlessly adopt Pando into their existing workflows. In production, Pando cut median push latency by nearly 5x. It now delivers nearly a petabyte of Git data per day.

The post covers the motivations for building a new source-control system and for retaining Git compatibility, compares Pando with common approaches to scaling Git, and describes what comes next, including continued upstream contributions to Git for agent-scale work.

> Library cross-reference: this is the second agent-scale source-control account in the library, after Anthropic's Scion ([overview](web--anthropic-redesigning-source-control--overview.md)). The two diverge at the first fork in the road: Scion abandons Git's client and packfile negotiation for an always-online object-RPC service, while Pando keeps the Git wire protocol and client and rebuilds only the server around reusable packs. Performance and adoption figures are OpenAI's own.

Source: [Scaling Git at OpenAI](https://openai.com/index/scaling-git-at-openai/) by OpenAI, 2026-11-02. Captured via the Internet Archive (`source_fetched_via=wayback`, the canonical host returned HTTP 403); content SHA-256 `f93cf33c`.
