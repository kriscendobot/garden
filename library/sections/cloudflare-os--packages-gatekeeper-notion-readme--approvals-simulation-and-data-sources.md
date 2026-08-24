---
title: Notion approvals, write simulation, and the data-source split
source: packages/gatekeeper-notion/README.md
source_repo: cloudflare/cloudflare-os
source_commit: 657aa96504f23fda775df46a5a6a95eaf135ec6d
source_date: 2026-08-17
source_authors: [Maximo Guk]
ingested: 2026-08-24
ingested_by: scholar
topics: [capability-mediated-integrations, cloudflare-workers-agent-hosting]
status: current
---

Notion reads authorize immediately while writes are staged for deferred approval, and reads simulate a Gadget's own pending unapproved writes — including provisional IDs for created pages — so it sees its own changes before a person approves them.

Every read calls `authorizeObservation()`; every write is staged via `submitAction()` and only performed in `applyAction()`. Reads simulate pending (unapproved) writes so a Gadget sees its own changes immediately, including provisional IDs for created pages, and page, database, data-source, and user responses are cached in Durable Object storage with short TTLs.

Notion's newer model splits a database into one or more data sources, and the connector hides that split from the Session API by pinning API versions per operation. Database `query`, `getSchema`, and row creation resolve the database's primary data source under Notion-Version `2025-09-03`, while pages, blocks, comments, and search use `2022-06-28` so user-facing IDs and URLs stay consistent. The result is that the agent-facing surface never mentions data sources even though the underlying calls straddle two API versions.

Source: [packages/gatekeeper-notion/README.md](https://github.com/cloudflare/cloudflare-os/blob/657aa96504f23fda775df46a5a6a95eaf135ec6d/packages/gatekeeper-notion/README.md) at commit `657aa965`.
