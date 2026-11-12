---
title: Git object storage primer: objects, refs, packs, and replication
source_kind: web
source_url: https://openai.com/index/scaling-git-at-openai/
source_snapshot: http://web.archive.org/web/20261110004756id_/https://openai.com/index/scaling-git-at-openai/
source_content_sha256: f93cf33cc74d4badf1d49db844bf99ef616bba6e2d3cf0f59a11ef638a1cb48e
source_authors: [Aaron Friel, Taylor Blau, Ted Nyman]
source_date: 2026-11-02
retrieved: 2026-11-12
ingested: 2026-11-12
ingested_by: scholar
topics: [source-control-architecture, content-addressed-storage]
status: current
---

Abstract: The post's primer on what a Git server has to keep in sync. A repository is a content-addressed graph of immutable **objects** (blobs, trees, commits, tags, identified by a hash of type and contents) plus mutable **refs** pointing at commits. Objects are stored **loose** (one file each) or **packed** (delta-compressed together in a packfile). A fetch sends the objects reachable from the client's *wants* minus those reachable from its *haves*, as a packfile; a push sends a pack that may be **thin** against objects the server advertised, so the pack alone cannot reconstruct the history. A replicated service must therefore (1) never advertise a ref value until it can supply every object reachable from it, and (2) arbitrate competing updates to the same ref. Systems that impose a single order on all writes make pushes to unrelated branches wait on each other.

Git must keep two parts of a repository in sync: **objects** and **references**.

A Git repository records snapshots of files and the history connecting them as a graph of objects. An object is a blob, tree, commit, or tag. Blobs hold the content of an individual file; trees associate names with blobs or other trees to form a directory structure; commits point to a root tree and zero or more parent commits, forming the history.

Objects are identified by a hash of their type and contents. Objects are also immutable: recording a changed file creates a new blob, while unchanged files and directories can reuse existing objects. (The post's figure: `refs/heads/main` points to commit C2, whose parent is C1; C1's root tree T1 maps `parser.py` to blob B1, C2's root tree T2 maps it to blob B2, and both root trees share the same `docs/` tree T3.)

Branches and tags are references ("refs") that point to commits. Committing on a branch creates a new commit and updates the branch's ref to point to it.

Git stores objects either **loose** (individual files named by object ID) or **packed** (together in a packfile, where similar objects can be stored as deltas against one another).

An object is **reachable** from a commit if Git can find it by following links through parents, trees, and blobs. During a **fetch**, the client tells the server which commits it wants and which it already has. The server finds the objects reachable from the wanted commits, excludes those it knows the client already has, and sends the remainder as a packfile in the same format Git uses on disk. A full clone starts with no objects, so it needs everything reachable from the cloned history.

A **push** transfers objects the other way by asking the server to update one or more refs. The client uses the server's advertised refs to avoid sending objects the server already has, so the pack can depend on existing objects: receiving the pack alone is not enough to reconstruct the new history.

**Replication.** Replicating a Git repository means keeping both objects and references available across multiple servers. Before a replica can serve a reference's new value, it must be able to supply the objects reachable from that value. The service also needs to coordinate competing reference updates: pushes that try to move the same branch from the same old tip to different new commits. Systems that impose a single order on all writes to a repository can make pushes to unrelated branches wait on one another.

Source: [Scaling Git at OpenAI](https://openai.com/index/scaling-git-at-openai/#git-object-storage-primer) by OpenAI, 2026-11-02. Captured via the Internet Archive (`source_fetched_via=wayback`, the canonical host returned HTTP 403); content SHA-256 `f93cf33c`.
