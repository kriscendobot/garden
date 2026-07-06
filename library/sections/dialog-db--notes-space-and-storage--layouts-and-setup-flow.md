---
title: On-disk and on-web layouts, and the setup flow
source: notes/space-and-storage.md
source_repo: dialog-db/dialog-db
source_commit: 18c640a06797b62eb3c57f3aeedb016634a5da19
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [ucan-authorization, content-addressed-storage]
status: current
---

> Abstract: The concrete backend layouts a `Location` resolves to. On the FileSystem (native), a `Location { Profile, "alice" }` becomes a directory `~/Library/.../dialog/alice/` holding `credentials/self`, `archive/` (index + blob), `memory/`, and `certificates/`. On IndexedDB (web), the same space is a database named `"alice"` with object stores `credentials`, `archive`, `memory`, and `certificates`. The setup flow assembles a `Storage::default()`, opens a `Profile` (triggering `storage::Load` internally), derives an `Operator` capability with `.allow(Subject::any())`, and opens a `Repository` (which triggers `storage::Load` for the repo's space); the `Operator` holds the assembled `Storage` and routes all subsequent effects through it.

## On-Disk Layout (FileSystem)

```
~/Library/.../dialog/alice/        <-- Location { Profile, "alice" }
  credentials/self                 <-- credential provider
  archive/                         <-- archive provider (index + blob)
  memory/                          <-- memory provider
  certificates/                    <-- certificate store
```

## On-Web Layout (IndexedDB)

```
Database: "alice"
Object stores:
  "credentials"                    <-- credential provider
  "archive"                        <-- archive provider
  "memory"                         <-- memory provider
  "certificates"                   <-- certificate store
```

## Setup Flow

```rust
let storage = Storage::default();

let profile = Profile::open("alice")
    .perform(&storage)
    .await?;

let operator = profile
    .derive(b"my-app")
    .allow(Subject::any())
    .build(storage)
    .await?;

let repo = profile.repository("contacts")
    .open()
    .perform(&operator)
    .await?;
```

`Profile::open` triggers `storage::Load` internally. `Repository::open` does the same for the repo's space. The `Operator` holds the assembled `Storage` and routes all subsequent effects through it.

Source: [notes/space-and-storage.md](https://github.com/dialog-db/dialog-db/blob/18c640a06797b62eb3c57f3aeedb016634a5da19/notes/space-and-storage.md) at commit `18c640a0`.
