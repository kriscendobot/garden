---
title: Portable gadget archive format
source: docs/blueprints.md
source_repo: cloudflare/cloudflare-os
source_commit: 69c39d5037609b7efe8e2ed7e704e86bb1ce7002
source_date: 2026-08-03
source_authors: [Phillip Jones, Kenton Varda]
ingested: 2026-08-24
ingested_by: scholar
topics: [reusable-app-blueprints, ai-generated-apps]
status: current
---

The `.gadget` format is a bounded, streamable container for moving Blueprint metadata and a compressed code snapshot between independent Cloudflare OS deployments.

The binary container holds an eight-byte magic number, format version, metadata length, content length, JSON `BlueprintMetadata`, and raw snapshot bytes. Metadata is capped at 64 KiB and content at 32 MiB before publication.

Ownership identifiers and screenshots are not transported. The server streams the existing gzip-compressed Yjs snapshot directly to and from R2. Import creates a new local Blueprint ID and local ownership while preserving the original author metadata.

Source: [docs/blueprints.md](https://github.com/cloudflare/cloudflare-os/blob/69c39d5037609b7efe8e2ed7e704e86bb1ce7002/docs/blueprints.md) at commit `69c39d50`.
