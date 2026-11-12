---
title: Line-rate fetch and clone: pack selection, packfile-uri, and the Express cache
source_kind: web
source_url: https://openai.com/index/scaling-git-at-openai/
source_snapshot: http://web.archive.org/web/20261110004756id_/https://openai.com/index/scaling-git-at-openai/
source_content_sha256: f93cf33cc74d4badf1d49db844bf99ef616bba6e2d3cf0f59a11ef638a1cb48e
source_authors: [Aaron Friel, Taylor Blau, Ted Nyman]
source_date: 2026-11-02
retrieved: 2026-11-12
ingested: 2026-11-12
ingested_by: scholar
topics: [source-control-architecture, networking]
status: current
---

Abstract: How Pando serves a fetch without computing a pack. A conventional server computes the object set difference between a client's *wants* and *haves*, compresses it, and sends it: expensive and resistant to caching. Pando instead maps haves and wants, through the commit mappings recorded at push time, to **ref versions**, each linked to a previously received packfile, and selects the set of stored packs that covers what the client lacks (wanting a side branch implies wanting its trunk dependencies) in **O(log Δ)** metadata reads, Δ being the ref-version distance between have and want. Because the Git protocol allows only one inline pack per response, Pando uses the under-appreciated **`packfile-uri`** protocol feature exclusively: it sends an empty inline pack plus URIs, and the client downloads the packs from **Express**, a regional pack-delivery cache over the blob store (consistent-hash routing, over 99% hit rate), with a separate metadata cache. OpenAI contributed `packfile-uri` improvements upstream and reports clones and fetches saturating 10 Gbps links on standard cloud VMs.

When another client fetches the branch, Pando selects a set of stored packs using the history the client already has. This needs O(log Δ) metadata reads, where Δ is the shortest distance in ref versions between what the client has and what it wants. The server returns packfile URIs, and the client downloads them through Express, a service that stores packfiles in regional caches.

**Haves and wants.** In a fetch the client gives the server two sets of commit IDs, its *haves* and *wants*. A conventional Git server computes the set difference between objects reachable from the wants and from the haves, compresses them, and sends the result. Open-source Git keeps a variety of local indexes to speed this up, but these packfiles can be expensive to compute and generally resist caching.

Pando instead uses the commit mappings recorded on pushes to look up the client's haves and wants, resolving them to the ref versions that contain those commits. Each ref version links to a packfile Pando previously received. The server solves for what the client needs by selecting the packfiles that cover the set of objects the client lacks. (The post's figure: Pando maps the haves and wants to a sequence of ref versions; wanting a side branch implies wanting its dependencies up the trunk.)

**`packfile-uri`.** The Git protocol allows only a single packfile in the HTTP response to a clone or fetch. An under-appreciated protocol feature, `packfile-uri`, lets a server return links from which the client downloads additional packs separately. Pando uses this **exclusively** and transmits an empty packfile inline. To support it, OpenAI contributed a number of `packfile-uri` improvements upstream.

**Regional caches.** OpenAI runs in many geographic regions, so it maintains Pando clusters with local caches in each. **Express**, a pack-delivery service, caches the blob store, and a separate service caches the metadata store. Together they let a cluster serve a request for a commit ID, or a special read of a ref, entirely from cached state. Requests for a packfile are routed to Express servers by consistent hashing, with cache hit rates above 99%.

The cache system is fast enough to saturate the network between clients and Pando: using packfile URIs and local caches on standard cloud-provider VMs, OpenAI validated clone and fetch operations saturating 10 Gbps links.

Source: [Scaling Git at OpenAI](https://openai.com/index/scaling-git-at-openai/#line-rate-fetch-and-clone-performance) by OpenAI, 2026-11-02. Captured via the Internet Archive (`source_fetched_via=wayback`, the canonical host returned HTTP 403); content SHA-256 `f93cf33c`.
