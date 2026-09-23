---
title: Overview — a git-like interface for structured data
source: rust/dialog-repository/README.md
source_repo: dialog-db/dialog-db
source_commit: a898b5de44a29e5be30a1faa99f11ef7a5332d69
source_date: 2026-06-04
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [local-first-sync, capability-security]
status: current
---

> Abstract: `dialog-repository` is dialog-db's git-like interface — repositories with branches, remotes, push/pull, and merge, but over *structured data* rather than files. It is the top-of-stack crate that composes the lower dialog crates (`dialog-capability`, `dialog-operator`, `dialog-storage`, `dialog-query`) into the familiar version-control vocabulary. Each repository has its own identity (an Ed25519 keypair), named branches with revision history, and remotes for replication. Information is stored as **claims** — `{ the, of, is, cause }` facts where `the` is the relation, `of` is the entity, `is` is the value, and `cause` is the provenance — and queried either with typed concepts (`#[derive(Concept)]`) or with deductive rules. The defining determinism property: **the same name under the same profile always yields the same repository identity**, so a repository is addressable by human-readable name without a registry.

## Overview

`dialog-repository` provides a git-like interface for Dialog-DB: repositories with branches, remotes, push/pull, and merge, but for structured data instead of files.

- Each repository has its own **identity** (a keypair), **named branches** with revision history, and **remotes** for replication.
- Information is stored as **claims**: `{ the, of, is, cause }` facts where `the` is the relation, `of` is the entity, `is` is the value, and `cause` is the provenance.
- Claims can be queried with **typed concepts** or **deductive rules**.
- **Same name under the same profile always yields the same repository identity** — a repository is deterministically derived from `(profile, name)`, not registered.

This is the crate that turns dialog-db's fact store, capability authorization, and content-addressed storage into the branch/remote/push/pull surface an application programs against; the design-level counterpart is `notes/repository.md`.

Source: [rust/dialog-repository/README.md](https://github.com/dialog-db/dialog-db/blob/a898b5de44a29e5be30a1faa99f11ef7a5332d69/rust/dialog-repository/README.md) at commit `a898b5de`.
