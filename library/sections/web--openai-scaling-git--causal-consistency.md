---
title: Rethinking constraints: causal consistency and the three-way comparison
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

Abstract: Pando's core trade. It drops two assumptions most Git systems treat as requirements: **repository-wide consistency** (a point-in-time snapshot of all refs, which forces every ref update through one coordination point) and **unique packfiles per client** (costly per-client pack generation that resists caching). Instead each push is stored as an immutable pack blob, and each branch move records a **ref version** (new tip, the pack that supplied it, and the earlier ref versions that pack depends on) in a horizontally scalable metadata store. Fetching replays the chain of ref versions (packs) a writer produced, so a reader observes the writer's causal history: updates to a single ref are serializable, clients conflict only when pushing the same ref at once, and two refs read in one clone may come from different moments (one client may see `foo@1, bar@2`, another `foo@2, bar@1`). OpenAI's simulation of 1,000 writers on distinct branches shows 3PC write latency and WAL read latency rising as disks saturate, while Pando, which streams packs to blob storage without unpacking and only negotiates and selects packs, scales to the limits of clients, network, and blob store on commodity hardware.

### Rethinking constraints

OpenAI had a hunch it could meet its requirements without compromising on Git, but it did need to compromise on two things most Git systems assume to be requirements:

- **Repository-wide consistency.** A consistent, point-in-time snapshot of all refs requires coordination across the repository. In a system that orders all ref updates together, pushes to unrelated branches contend on a single coordination point.
- **Unique packfiles for every client.** If two clients with different local histories fetch the same branch, the server may need to generate a different pack for each to avoid sending objects they already have. Creating these responses costs CPU and disk I/O, making high reader volumes hard to scale.

Pando instead provides a relaxed consistency model (**causal consistency**) to scale writes, and **reuses packfiles** to scale reads.

### Causal consistency (CC)

When a client pushes to a branch, Pando stores the incoming packfile as an immutable blob in a blob store. Each time the branch moves, Pando records a **ref version** containing the new tip, the pack that supplied it, and any earlier ref versions the pack depends on, in a metadata store. Both stores are horizontally scalable.

Fetching a commit or reference from Pando means replaying a set of ref versions (packfiles) to the client, reconstructing the state of the client that created the ref version being fetched. This gives weaker consistency across the whole repository while providing **serializability for updates to individual refs**. Clients only conflict when pushing to the same ref simultaneously. A client reading several branches cannot assume those reads describe one point in time.

A push to trunk adds an incremental pack containing one or more commits. Each push to a side branch includes the topic's earlier commits again, so a client holding the advertised trunk version can fetch the topic in one pack.

This is a form of causal consistency: to fetch a reference, the reader observes the history of the writer that produced it. During a push, Pando controls what shared history client and server agree on, so clients produce more easily shared packfiles.

As a consequence, Pando provides neither a point-in-time state of all references during Git operations nor an ordering of ref updates within a clone or fetch. If branches `foo` and `bar` are both updated during a full clone's negotiation, one client may observe `foo` at version 1 and `bar` at version 2 while another observes `foo` at version 2 and `bar` at version 1. In practice, users and agents do not depend on the global ordering of ref updates, only on the order of updates to a single reference.

### Comparing approaches

The post embeds an interactive simulation of the three models: 1,000 clients each select a distinct branch and repeatedly push unique commits, measuring total wall-clock time and **push-to-fetch latency** (the round trip for users and agents to collaborate, or for systems that rely on version control), across commodity-to-premium VMs and blob stores, with repository-wide consistency relaxed for 3PC. These are labeled synthetic teaching models, not production benchmarks.

The modeled 3PC system shows significantly greater **write** latency under load as disks saturate; the WAL system shows significantly greater **read** latency for the same reason, as servers struggle to keep up reading the journal. In both real-world testing on the monorepo and the simulation, Pando supports many thousands of clients pushing concurrently without degrading under load.

On a push, Pando validates the incoming packfile while streaming it to blob storage, **without unpacking it into a local repository**. On a fetch, Pando selects the stored packs the reader needs and the reader downloads them. No server applies packfiles to a local repository or performs costly unpack-and-repack operations; servers mostly negotiate and select packs, so they run on commodity hardware. Pando thus scales to the limits of the clients, the network between clients and Pando, and the blob store; to serve more clients, add Pando servers and scale the metadata and blob stores alongside them.

Source: [Scaling Git at OpenAI](https://openai.com/index/scaling-git-at-openai/#causal-consistency-cc) by OpenAI, 2026-11-02. Captured via the Internet Archive (`source_fetched_via=wayback`, the canonical host returned HTTP 403); content SHA-256 `f93cf33c`.
