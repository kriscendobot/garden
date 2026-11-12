---
title: Compaction and time to first byte: LSM-style packfile covers
source_kind: web
source_url: https://openai.com/index/scaling-git-at-openai/
source_snapshot: http://web.archive.org/web/20261110004756id_/https://openai.com/index/scaling-git-at-openai/
source_content_sha256: f93cf33cc74d4badf1d49db844bf99ef616bba6e2d3cf0f59a11ef638a1cb48e
source_authors: [Aaron Friel, Taylor Blau, Ted Nyman]
source_date: 2026-11-02
retrieved: 2026-11-12
ingested: 2026-11-12
ingested_by: scholar
topics: [source-control-architecture, content-addressed-storage, data-structures]
status: current
---

Abstract: Pando's replacement for repack and garbage collection. Sending one `packfile-uri` per push since a client's last fetch is infeasible in a fast-moving monorepo (tens of thousands of packs a day to catch up trunk), so background workers combine packs in a design modeled on **log-structured merge-tree compaction**: each push yields an **L0** pack (the smallest transmittable unit), and workers group packs into **covers** spanning sequences of ref versions that scale geometrically per level (the monorepo uses up to L4). A full cover is claimed by a compaction worker and rewritten as a single pack for better compression, and the cover index also acts as a **skip list over ref versions**, letting fetch planning scan all levels at once and choose packs in logarithmic time. Unlike most Git servers, Pando keeps packs at **every** level and never garbage-collects them; all levels serve fetches, and API readers of single objects prefer less-compressed L0 packs. Compaction cuts transfer size and makes pack planning sub-linear in how far behind a client is.

For most Git servers, **repacking and garbage collection** are necessary to keep a growing repository performant. Both reclaim space, but they are compute- and I/O-intensive.

In a fast-moving repository like OpenAI's monorepo, sending an individual packfile URI for every push since the last fetch is infeasible: each day a client would need tens of thousands of packfiles to catch up its trunk.

Instead, Pando combines packs in the background, adopting a design similar to **compaction in log-structured merge-trees**. Each push produces what Pando calls an **"L0" packfile**, the smallest unit of data Pando can transmit. Over time, background workers collect these into **covers** spanning a sequence of ref versions, scaling geometrically from L0. The monorepo today uses up to **L4** covers.

Covers serve two purposes. After a cover is sufficiently full, a compaction worker claims it and produces a single packfile, improving the compression ratio by reorganizing the objects inside. The covers also speed fetch negotiation by acting as a **skip list over ref versions**: scanning the indexes at every level simultaneously, Pando selects the set of packs to send in logarithmic time. Covers, repacked or not, make fetch planning more efficient and reduce Pando's throughput and latency requirements.

Unlike many Git servers, packfiles are **kept at every level and not discarded or garbage collected**. Packs at every level serve clients continuously, chosen by the haves and wants of each fetch. For clients using Pando as an API, reading an arbitrary object tends to need less data from an L0 than an L4 pack, because the L0 is less likely to be heavily compressed.

Compaction significantly reduces the total transfer size sent to clients and lets pack planning scale sub-linearly in how far behind the client is, which matters especially for large, quickly changing repositories, which OpenAI expects to become the new normal.

Source: [Scaling Git at OpenAI](https://openai.com/index/scaling-git-at-openai/#compaction-and-time-to-first-byte) by OpenAI, 2026-11-02. Captured via the Internet Archive (`source_fetched_via=wayback`, the canonical host returned HTTP 403); content SHA-256 `f93cf33c`.
