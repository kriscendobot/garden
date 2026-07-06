---
title: Overview — local-first database with built-in identity
source: rust/dialog-repository/Guide.md
source_repo: dialog-db/dialog-db
source_commit: 18c640a06797b62eb3c57f3aeedb016634a5da19
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [local-first-sync]
status: current
---

> Abstract: The one-line framing that opens `dialog-repository`'s Guide: **Dialog is a local-first database with built-in identity, replication, and delegated access control.** These three built-ins are what distinguish it from a plain embedded store — identity (per-device profiles and derived operators, each a `did:key`), replication (branches with remotes, push/pull), and delegated access control (UCAN chains shared through delegation). The Guide is the task-oriented companion to the crate README's reference walkthrough: it partitions the same surface into Identity, Setup, Repository, Writing, Querying, Syncing, and Collaboration.

## Dialog

Dialog is a local-first database with built-in identity, replication, and delegated access control.

The three built-ins frame everything the Guide covers:

- **Identity** — per-device profiles and derived operators, each a `did:key`, with an optional account for cross-device recovery.
- **Replication** — branches with revision history and remotes; `push`/`pull` synchronize a branch against its upstream.
- **Delegated access control** — authority is shared through UCAN delegation chains, so a collaborator acts on a repository without holding its keys.

This section is the guide-shape overview; the reference-shape counterpart is `rust/dialog-repository/README.md`'s `overview`, and the design-level rationale is in `notes/repository.md`.

Source: [rust/dialog-repository/Guide.md](https://github.com/dialog-db/dialog-db/blob/18c640a06797b62eb3c57f3aeedb016634a5da19/rust/dialog-repository/Guide.md) at commit `18c640a0`.
