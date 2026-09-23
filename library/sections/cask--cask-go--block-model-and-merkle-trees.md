---
title: The 1KB block model and Merkle-tree foundation
source: cask.go
source_kind: comment-fragment
source_repo: kriskowal/cask
source_path: cask.go
source_line_range: "1-51"
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
comment_subject: The package-header design rationale — 1KB blocks of links+bytes+height form Merkle trees; blobs, directories, and arbitrary block types; why 1KB
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-25
ingested_by: scholar
topics: [content-addressed-storage, data-structures]
status: current
---

> Abstract: The `package cask` doc-comment is the canonical statement of CASK's block model in the code that defines it. Every block is **1KB** and holds a combination of **links** (SHA-256 hashes of other blocks) and **byte content**, plus a **height**. Content spanning multiple blocks forms a **Merkle (hash) tree** addressed through links: **blobs** are Merkle trees whose leaves hold data without links; **directories** are Merkle trees whose leaves hold name-ordered entries packed as densely as each leaf fits. CASK imposes only the basic `(height, links, data)` structure on all block types, so semantics, storage, and transport evolve independently. The 1KB size is chosen so a block fits the typical Ethernet MTU (UDP-friendly), so a round number of blocks fills a filesystem block, so order-independent peer-to-peer transfer works well, and so large immutable structures evolve cheaply — adding a link to an ordered set creates new blocks proportional to the *logarithm* of the set size, and append-only sets can be merged to a deterministic consistent root hash (expensive but possible).

The `cask` package defines the types for a **1KB blockwise content-address store**.

Every block is 1KB and contains a combination of **links** to other blocks (32-byte SHA-256 hashes) and **byte content**. Each block also has a **height**. Content that spans multiple blocks forms a **Merkle tree** (hash tree), using links to address child blocks.

- **Blobs** are a Merkle tree where leaf blocks contain data without links.
- **Directories** are a Merkle tree where leaf blocks contain entries, using both links and data to capture the hash, type, and name of each child, ordered by name, and divided among leaf blocks such that each leaf contains as many entries as can fit.

CASK supports **arbitrary block types** beyond blobs and directories and only imposes the basic block structure of height, links, and data on all types. This is what allows the project to **independently evolve semantics, storage, and transport**.

Why 1KB:

- Blocks are 1 Kilobyte to fit in the typical **Ethernet MTU**, which makes blocks particularly well-suited for **UDP transport**, and also so a round number of blocks will fit in a typical **filesystem block**.
- 1KB-block Merkle trees are well-suited for **order-independent peer-to-peer file transfer**.
- 1KB-block CAS Merkle trees can efficiently represent **evolution of large immutable data structures**. For example, adding a link to a Merkle tree representing an ordered set of links involves the creation of new blocks proportional to the **logarithm** of the size of the set. Merging append-only sets to deterministically arrive at a consistent root hash is expensive but possible.

This header is the implementation-side companion to the design-doc framing in `cask--readme--*` and `cask--architecture--*`: those describe the model in prose; this comment is what the type definitions actually commit to.

Source: [cask.go](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/cask.go#L1-L51) at commit `cdb975d8`.
