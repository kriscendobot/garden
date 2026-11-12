---
title: Scaling pushes: advertising only trunk, and an O(1) ref-version write
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

Abstract: How Pando takes a push. A conventional Git server advertises every ref so the pushing client can exclude as many objects as possible; with millions of branches that advertisement alone can exceed 100 MiB, and a pack thinned against arbitrary refs is hard to reuse because another reader may lack the excluded objects. Pando instead advertises **only a designated trunk branch** as the base for a new feature branch, so each pushed pack depends only on what the server explicitly allowed the client to exclude, and Pando can serve that exact pack to any later reader that already holds that trunk version. The cost: repeated pushes to one branch, or stacked branches, resend everything outside trunk (median pack still under 20 KiB, p99 under 3 MiB in the monorepo). The accepted push becomes one multi-key transaction (new ref version with tip, negotiated dependencies, and pack link, plus a compare-and-swap-like update of the ref pointer) giving read-your-own-write consistency with **O(1) metadata reads and writes** regardless of push size; compaction and, for huge pushes, most per-commit indexing run asynchronously from work queued in the same transaction. The ref pointer is the only contended key, so pushes to unrelated refs proceed independently.

**The write path at a glance.** An agent commits locally and runs `git push`, which creates a packfile of the changes to update a branch. Pando receives the pack and streams it to blob storage. After validating the push with a single-pass decode, Pando uses a **multi-key transaction** to record a ref version in its metadata store and atomically update the ref pointer, providing "read-your-own-write" consistency. The whole write needs O(1) metadata reads and writes. Pando's architecture rests on three central services: pushes, fetches, and compaction.

**Advertisement.** When a client pushes, a conventional Git server is like a poker player showing all of its cards, revealing every branch it has. The client then gathers the commits, trees, and blobs for a packfile that excludes objects it knows the server already has.

Advertising more refs can make the push smaller. It can also make the pack harder to reuse, because another client may be missing objects the writer left out. Pando instead advertises only a select set of branches, for two reasons:

- **Cost.** Providing a consistent view of every ref is expensive. With millions of branches, the ref advertisement alone can exceed 100 MiB, and serving it requires each server either to maintain a current mapping (significant coordination overhead) or to run a database query that scales with the number of refs.
- **Reusability.** With only a subset of refs advertised, the client generates a pack that depends only on what the server explicitly allowed it to exclude. Tracking those dependencies lets Pando reuse the packfile a client generated in one push as the response to a later fetch.

The more refs a server advertises, the more sources the client can exclude objects from and the smaller the pack, but reusing that pack requires the server to prove each fetching client has every dependency, or the pack may omit objects the client needs. If the server advertised nothing, the client would send the repository's full history: usable by anyone, but making every branch fetch effectively a full clone. Most of the size reduction comes from advertising just one ref.

By default, when a client pushes a new feature branch, Pando **advertises only a designated trunk branch** as the base. The advertisement stays the same size as the repository gains branches. The tradeoff: when an engineer pushes to one branch many times, or stacks one feature branch on another, the client resends everything outside trunk, so successive pushes grow and carry potentially redundant objects. In the monorepo the median packfile produced this way was under 20 KiB and the 99th percentile under 3 MiB, a sensible trade because a reader with the advertised trunk history can fetch the branch with that one pack.

**Metadata update.** After choosing the advertised refs, Pando accepts the push and splits the metadata update into synchronous and asynchronous parts. The **synchronous** part makes the new commit immediately fetchable: it writes a new ref version (the new tip, the dependencies used to negotiate the pack, and a link to the pushed pack) and updates the ref-pointer mapping to it. **Asynchronous** work, such as scheduling compaction, is recorded in the same transaction. For very large pushes only a subset of commits is written synchronously, which keeps the metadata cost constant regardless of push size.

Pando servers accept pushes to unrelated refs independently. The only contended key is the ref pointer, guarded by an atomic compare-and-swap-like operation. Write throughput scales by adding Pando servers, metadata-store scaling units, or blob stores.

Source: [Scaling Git at OpenAI](https://openai.com/index/scaling-git-at-openai/#scaling-pushes) by OpenAI, 2026-11-02. Captured via the Internet Archive (`source_fetched_via=wayback`, the canonical host returned HTTP 403); content SHA-256 `f93cf33c`.
