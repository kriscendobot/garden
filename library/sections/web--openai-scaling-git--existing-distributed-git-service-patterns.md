---
title: Existing distributed Git service patterns: three-phase commit and write-ahead log
source_kind: web
source_url: https://openai.com/index/scaling-git-at-openai/
source_snapshot: http://web.archive.org/web/20261110004756id_/https://openai.com/index/scaling-git-at-openai/
source_content_sha256: f93cf33cc74d4badf1d49db844bf99ef616bba6e2d3cf0f59a11ef638a1cb48e
source_authors: [Aaron Friel, Taylor Blau, Ted Nyman]
source_date: 2026-11-02
retrieved: 2026-11-12
ingested: 2026-11-12
ingested_by: scholar
topics: [source-control-architecture]
status: current
---

Abstract: The two conventional replicated-Git designs OpenAI modeled before building Pando, and where each bottlenecks. **Three-phase commit (3PC):** every replica holds a complete repository; an incoming pack is copied to all replicas in parallel, and a coordinator drives lock-and-check, pre-commit, and commit rounds until a majority accepts the ref update. Reads are local and every replica gives a consistent view of all refs, but refs update one at a time, each push pays several quorum round trips, and replica disk and network latency sit on the push path. **Write-ahead log (WAL):** writers upload packs to a blob store in parallel and publish by **compare-and-swap on one shared manifest** (on conflict, read the intervening entries, re-check the ref update, retry with the already-uploaded pack). Even pushes to unrelated branches contend on that one manifest, so CAS round-trip time caps the publish rate (batching trades latency for throughput), and replicas that must read and index every pack before serving fall behind under write load, raising fetch latency.

While designing Pando, OpenAI evaluated two conventional approaches: one coordinating ref updates across repository replicas with **three-phase commit** (3PC, a protocol for coordinating a commit across multiple nodes), and one ordering updates through a shared **write-ahead log** (WAL, a record of changes written before they are applied) in blob storage.

### Three-phase commit (3PC)

In the modeled 3PC design, the Git service keeps a complete copy of the repository on several replicas. When any server receives a push, the incoming packfile is copied and sent to all replicas in parallel. To publish the push, a majority of replicas must accept the ref update. The server managing this is the coordinator, and it needs multiple rounds of communication with each other replica.

To accept a reference update, each replica locks its copy of the ref and checks that it still points to the commit the client expects. The coordinator then sends a pre-commit message to the replicas that accept. Once a majority acknowledges the pre-commit, the coordinator tells them to perform the update. Any up-to-date replica can then advertise the new branch tip from its local copy.

Complete replicas make it possible to serve reads locally, and guarantee clients a consistent view of all references whichever replica they pick. As a consequence, references are updated one at a time, and each push requires multiple round trips to coordinate the update among replicas.

Waiting for a quorum puts replica disk performance and communication latency on the push path. As write volume grows, the replicas must keep up with incoming packs as well as read traffic.

### Write-ahead log (WAL)

In the modeled WAL design, the Git service uses a **shared manifest in blob storage** to order updates across the repository. When a server receives a push, it uploads the incoming packfile to a blob store and prepares the ref update in its local copy of the repository. To publish, it adds an entry to the shared manifest that records the ref update and points to the packfile, and updates the manifest with a **compare-and-swap**, which atomically replaces the manifest or rejects the change. If another writer updated it in the meantime, the server reads the intervening entries, checks that its ref update is still valid, and retries with the packfile it already uploaded.

Writers can upload packfiles in parallel, but even pushes to unrelated branches must update the same manifest. The round-trip time of a successful compare-and-swap limits how often the repository can publish a new manifest. A low-latency blob store makes that step fast. Batching lets one manifest update cover several refs, at the cost of queueing and added latency.

Increasing the blob store's capacity alone does not resolve the bottleneck. Each replica still needs to read and index packs from the blob store before it can serve them locally; if incoming writes outpace that work, replicas fall behind and clients wait longer to fetch newly pushed commits.

> Garden note: the WAL design is structurally the garden's own `journal2` coordination model. Every producer CAS-pushes to one shared ref (`origin/journal2`), retrying on a lost race after re-reading the intervening commits (see concept [journal-ref-rmw-cas](../concepts/journal-ref-rmw-cas.md)), and every reader must fetch and index the whole branch. The post's diagnosis (one contended manifest regardless of how unrelated the writes are; readers falling behind under write load) is the same pressure behind the garden's journal contention watch and the `journal3` split proposal.

Source: [Scaling Git at OpenAI](https://openai.com/index/scaling-git-at-openai/#existing-distributed-git-service-patterns) by OpenAI, 2026-11-02. Captured via the Internet Archive (`source_fetched_via=wayback`, the canonical host returned HTTP 403); content SHA-256 `f93cf33c`.
